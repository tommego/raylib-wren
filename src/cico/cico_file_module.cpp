#include "cico_file_module.h"

#include <stdio.h>
#include <string.h>

// Exit codes used by the wren binaries, following the BSD standard
//
// The interpreter was used with an incorrect number of arguments
#define WREN_EX_USAGE 64

// Compilation error
#define WREN_EX_DATAERR 65

// Runtime error
#define WREN_EX_SOFTWARE 70

// Cannot open input file
#define WREN_EX_NOINPUT 66

// I/O Error
#define WREN_EX_IOERR 74

// The maximum number of components in a path. We can't normalize a path that
// contains more than this number of parts. The number here assumes a max path
// length of 4096, which is common on Linux, and then assumes each component is
// at least two characters, "/", and a single-letter directory name.
#define MAX_COMPONENTS 2048

namespace cico
{

typedef struct {
  const char* start;
  const char* end;
} Slice;

// Categorizes what form a path is.
typedef enum
{
  // An absolute path, starting with "/" on POSIX systems, a drive letter on
  // Windows, etc.
  PATH_TYPE_ABSOLUTE,

  // An explicitly relative path, starting with "./" or "../".
  PATH_TYPE_RELATIVE,

  // A path that has no leading prefix, like "foo/bar".
  PATH_TYPE_SIMPLE,
} PathType;


typedef struct
{
  // Dynamically allocated array of characters.
  char* chars;

  // The number of characters currently in use in [chars], not including the
  // null terminator.
  size_t length;

  // Size of the allocated [chars] buffer.
  size_t capacity;
} Path;

//path helpers
  void ensureCapacity(Path* path, size_t capacity);
  void appendSlice(Path* path, Slice slice);
  void pathAppendString(Path* path, const char* string);
  void pathFree(Path* path);
  void pathDirName(Path* path);
  void pathRemoveExtension(Path* path);
  void pathAppendChar(Path* path, char c);
  void pathJoin(Path* path, const char* string);
  void pathNormalize(Path* path);
  char* pathToString(Path* path);
  PathType pathType(const char* path);
//file helpers
  char* readFile(const char* path);
  WrenLoadModuleResult readModule(WrenVM* vm, const char* module);
//vm helpers
  void vm_write(WrenVM* vm, const char* text);
  void reportError(WrenVM* vm, WrenErrorType type, const char* module, int line, const char* message);

//path helpers

  void ensureCapacity(Path* path, size_t capacity)
  {
    // Capacity always needs to be one greater than the actual length to have
    // room for the null byte, which is stored in the buffer, but not counted in
    // the length. A zero-character path still needs a one-character array to
    // store the '\0'.
    capacity++;

    if (path->capacity >= capacity) return;

    // Grow by doubling in size.
    size_t newCapacity = 16;
    while (newCapacity < capacity) newCapacity *= 2;

    path->chars = (char*)realloc(path->chars, newCapacity);
    path->capacity = newCapacity;
  }

  void appendSlice(Path* path, Slice slice)
  {
    size_t length = slice.end - slice.start;
    ensureCapacity(path, path->length + length);
    memcpy(path->chars + path->length, slice.start, length);
    path->length += length;
    path->chars[path->length] = '\0';
  }

  void pathAppendString(Path* path, const char* string)
  {
    Slice slice;
    slice.start = string;
    slice.end = string + strlen(string);
    appendSlice(path, slice);
  }

  inline static bool isSeparator(char c)
  {
    // Slash is a separator on POSIX and Windows.
    if (c == '/') return true;

    // Backslash is only a separator on Windows.
    #ifdef _WIN32
      if (c == '\\') return true;
    #endif

    return false;
  }

  #ifdef _WIN32
  inline static bool isDriveLetter(char c)
  {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
  }
  #endif

  // Gets the length of the prefix of [path] that defines its absolute root.
  //
  // Returns 1 the leading "/". On Windows, also handles drive letters ("C:" or
  // "C:\").
  //
  // If the path is not absolute, returns 0.
  inline static size_t absolutePrefixLength(const char* path)
  {
    #ifdef _WIN32
      // Drive letter.
      if (isDriveLetter(path[0]) && path[1] == ':')
      {
        if (isSeparator(path[2]))
        {
          // Fully absolute path.
          return 3;
        } else {
          // "Half-absolute" path like "C:", which is relative to the current
          // working directory on drive. It's absolute for our purposes.
          return 2;
        }
      }

      // TODO: UNC paths.

    #endif

    // POSIX-style absolute path or absolute path in the current drive on Windows.
    if (isSeparator(path[0])) return 1;

    // Not absolute.
    return 0;
  }

  PathType pathType(const char* path)
  {
    if (absolutePrefixLength(path) > 0) return PATH_TYPE_ABSOLUTE;

    // See if it must be relative.
    if ((path[0] == '.' && isSeparator(path[1])) ||
        (path[0] == '.' && path[1] == '.' && isSeparator(path[2])))
    {
      return PATH_TYPE_RELATIVE;
    }

    // Otherwise, we don't know.
    return PATH_TYPE_SIMPLE;
  }


  Path* pathNew(const char* string)
  {
    Path* path = (Path*)malloc(sizeof(Path));
    path->chars = (char*)malloc(1);
    path->chars[0] = '\0';
    path->length = 0;
    path->capacity = 0;

    pathAppendString(path, string);

    return path;
  }

  void pathFree(Path* path)
  {
    if (path->chars) free(path->chars);
    free(path);
  }

  void pathDirName(Path* path)
  {
    // Find the last path separator.
    for (size_t i = path->length - 1; i < path->length; i--)
    {
      if (isSeparator(path->chars[i]))
      {
        path->length = i;
        path->chars[i] = '\0';
        return;
      }
    }

    // If we got here, there was no separator so it must be a single component.
    path->length = 0;
    path->chars[0] = '\0';
  }

  void pathRemoveExtension(Path* path)
  {
    for (size_t i = path->length - 1; i < path->length; i--)
    {
      // If we hit a path separator before finding the extension, then the last
      // component doesn't have one.
      if (isSeparator(path->chars[i])) return;

      if (path->chars[i] == '.')
      {
        path->length = i;
        path->chars[path->length] = '\0';
      }
    }
  }

  void pathAppendChar(Path* path, char c)
  {
    ensureCapacity(path, path->length + 1);
    path->chars[path->length++] = c;
    path->chars[path->length] = '\0';
  }

  void pathJoin(Path* path, const char* string)
  {
    if (path->length > 0 && !isSeparator(path->chars[path->length - 1]))
    {
      pathAppendChar(path, '/');
    }

    pathAppendString(path, string);
  }

  void pathNormalize(Path* path)
  {
    // Split the path into components.
    Slice components[MAX_COMPONENTS];
    int numComponents = 0;

    char* start = path->chars;
    char* end = path->chars;

    // Split into parts and handle "." and "..".
    int leadingDoubles = 0;
    for (;;)
    {
      if (*end == '\0' || isSeparator(*end))
      {
        // Add the current component.
        if (start != end)
        {
          size_t length = end - start;
          if (length == 1 && start[0] == '.')
          {
            // Skip "." components.
          }
          else if (length == 2 && start[0] == '.' && start[1] == '.')
          {
            // Walk out of directories on "..".
            if (numComponents > 0)
            {
              // Discard the previous component.
              numComponents--;
            }
            else
            {
              // Can't back out any further, so preserve the "..".
              leadingDoubles++;
            }
          }
          else
          {
            if (numComponents >= MAX_COMPONENTS)
            {
              fprintf(stderr, "Path cannot have more than %d path components.\n",
                MAX_COMPONENTS);
              exit(1);
            }

            components[numComponents].start = start;
            components[numComponents].end = end;
            numComponents++;
          }
        }

        // Skip over separators.
        while (*end != '\0' && isSeparator(*end)) end++;

        start = end;
        if (*end == '\0') break;
      }

      end++;
    }

    // Preserve the path type. We don't want to turn, say, "./foo" into "foo"
    // because that changes the semantics of how that path is handled when used
    // as an import string.
    bool needsSeparator = false;

    Path* result = pathNew("");
    size_t prefixLength = absolutePrefixLength(path->chars);
    if (prefixLength > 0)
    {
      // It's an absolute path, so preserve the absolute prefix.
      Slice slice;
      slice.start = path->chars;
      slice.end = path->chars + prefixLength;
      appendSlice(result, slice);
    }
    else if (leadingDoubles > 0)
    {
      // Add any leading "..".
      for (int i = 0; i < leadingDoubles; i++)
      {
        if (needsSeparator) pathAppendChar(result, '/');
        pathAppendString(result, "..");
        needsSeparator = true;
      }
    }
    else if (path->chars[0] == '.' && isSeparator(path->chars[1]))
    {
      // Preserve a leading "./", since we use that to distinguish relative from
      // logical imports.
      pathAppendChar(result, '.');
      needsSeparator = true;
    }

    for (int i = 0; i < numComponents; i++)
    {
      if (needsSeparator) pathAppendChar(result, '/');
      appendSlice(result, components[i]);
      needsSeparator = true;
    }

    if (result->length == 0) pathAppendChar(result, '.');

    // Copy back into the original path.
    free(path->chars);
    path->capacity = result->capacity;
    path->chars = result->chars;
    path->length = result->length;

    free(result);
  }

  char* pathToString(Path* path)
  {
    char* string = (char*)malloc(path->length + 1);
    memcpy(string, path->chars, path->length);
    string[path->length] = '\0';
    return string;
  }

//file helpers

  // Reads the contents of the file at [path] and returns it as a heap allocated
  // string.
  //
  // Returns `NULL` if the path could not be found. Exits if it was found but
  // could not be read.
  char* readFile(const char* path)
  {
    FILE* file = fopen(path, "rb");
    if (file == NULL) return NULL;

    // Find out how big the file is.
    fseek(file, 0L, SEEK_END);
    size_t fileSize = ftell(file);
    rewind(file);

    // Allocate a buffer for it.
    char* buffer = (char*)malloc(fileSize + 1);
    if (buffer == NULL)
    {
      fprintf(stderr, "Could not read file \"%s\".\n", path);
      exit(WREN_EX_IOERR);
    }

    // Read the entire file.
    size_t bytesRead = fread(buffer, 1, fileSize, file);
    if (bytesRead < fileSize)
    {
      fprintf(stderr, "Could not read file \"%s\".\n", path);
      exit(WREN_EX_IOERR);
    }

    // Terminate the string.
    buffer[bytesRead] = '\0';

    fclose(file);
    return buffer;
  }

//VM bindings

  void vm_write(WrenVM* vm, const char* text)
  {
    printf("%s", text);
  }

  void reportError(WrenVM* vm, WrenErrorType type, 
    const char* module, int line, const char* message)
  {
    switch (type)
    {
      case WREN_ERROR_COMPILE:
        fprintf(stderr, "[%s line %d] %s\n", module, line, message);
        break;

      case WREN_ERROR_RUNTIME:
        fprintf(stderr, "%s\n", message);
        break;

      case WREN_ERROR_STACK_TRACE:
        fprintf(stderr, "[%s line %d] in %s\n", module, line, message);
        break;
    }
  }

  void readModuleComplete(WrenVM* vm, const char* module, WrenLoadModuleResult result)
  {
    if (result.source) {
      free((void*)result.source);
      result.source = NULL;
    }
  }

  WrenLoadModuleResult readModule(WrenVM* vm, const char* module) 
  {
    //source may or may not be null
    WrenLoadModuleResult result = {0};

    #ifdef WREN_TRY
      return result;
    #endif

    Path* filePath = pathNew(module);

    // Add a ".wren" file extension.
    pathAppendString(filePath, ".wren");

    char* source = readFile(filePath->chars);
    pathFree(filePath);

      result.source = source;
      result.onComplete = readModuleComplete;
    return result;

  }

const char* cicoResolveFileModule(WrenVM* vm, const char* importer, const char* module)
{
    // Logical import strings are used as-is and need no resolution.
    if (pathType(module) == PATH_TYPE_SIMPLE) return module;

    // Get the directory containing the importing module.
    Path* path = pathNew(importer);
    pathDirName(path);

    // Add the relative import path.
    pathJoin(path, module);

    pathNormalize(path);
    char* resolved = pathToString(path);

    pathFree(path);
    return resolved;
}
} // namespace cico
