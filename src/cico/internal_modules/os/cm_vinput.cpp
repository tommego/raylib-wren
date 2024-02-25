#include "cm_vinput.h"
#include "cico_def.h"

#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <map>
#include <linux/uinput.h>
extern "C" {
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <dirent.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/inotify.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/inotify.h>
//#include <sys/limits.h>
#include <sys/poll.h>
#include <errno.h>
#include <unistd.h>
#include <time.h>
}

namespace cico
{
#define KEYMAP(key) {#key, key}
static std::map<const char*, int> gKey= {
   KEYMAP(KEY_RESERVED),
   KEYMAP(KEY_ESC),
   KEYMAP(KEY_1),
   KEYMAP(KEY_2),
   KEYMAP(KEY_3),
   KEYMAP(KEY_4),
   KEYMAP(KEY_5),
   KEYMAP(KEY_6),
   KEYMAP(KEY_7),
   KEYMAP(KEY_8),
   KEYMAP(KEY_9),
   KEYMAP(KEY_0),
   KEYMAP(KEY_MINUS),
   KEYMAP(KEY_EQUAL),
   KEYMAP(KEY_BACKSPACE),
   KEYMAP(KEY_TAB),
   KEYMAP(KEY_Q),
   KEYMAP(KEY_W),
   KEYMAP(KEY_E),
   KEYMAP(KEY_R),
   KEYMAP(KEY_T),
   KEYMAP(KEY_Y),
   KEYMAP(KEY_U),
   KEYMAP(KEY_I),
   KEYMAP(KEY_O),
   KEYMAP(KEY_P),
   KEYMAP(KEY_LEFTBRACE),
   KEYMAP(KEY_RIGHTBRACE),
   KEYMAP(KEY_ENTER),
   KEYMAP(KEY_LEFTCTRL),
   KEYMAP(KEY_A),
   KEYMAP(KEY_S),
   KEYMAP(KEY_D),
   KEYMAP(KEY_F),
   KEYMAP(KEY_G),
   KEYMAP(KEY_H),
   KEYMAP(KEY_J),
   KEYMAP(KEY_K),
   KEYMAP(KEY_L),
   KEYMAP(KEY_SEMICOLON),
   KEYMAP(KEY_APOSTROPHE),
   KEYMAP(KEY_GRAVE),
   KEYMAP(KEY_LEFTSHIFT),
   KEYMAP(KEY_BACKSLASH),
   KEYMAP(KEY_Z),
   KEYMAP(KEY_X),
   KEYMAP(KEY_C),
   KEYMAP(KEY_V),
   KEYMAP(KEY_B),
   KEYMAP(KEY_N),
   KEYMAP(KEY_M),
   KEYMAP(KEY_COMMA),
   KEYMAP(KEY_DOT),
   KEYMAP(KEY_SLASH),
   KEYMAP(KEY_RIGHTSHIFT),
   KEYMAP(KEY_KPASTERISK),
   KEYMAP(KEY_LEFTALT),
   KEYMAP(KEY_SPACE),
   KEYMAP(KEY_CAPSLOCK),
   KEYMAP(KEY_F1),
   KEYMAP(KEY_F2),
   KEYMAP(KEY_F3),
   KEYMAP(KEY_F4),
   KEYMAP(KEY_F5),
   KEYMAP(KEY_F6),
   KEYMAP(KEY_F7),
   KEYMAP(KEY_F8),
   KEYMAP(KEY_F9),
   KEYMAP(KEY_F10),
   KEYMAP(KEY_NUMLOCK),
   KEYMAP(KEY_SCROLLLOCK),
   KEYMAP(KEY_F11),
   KEYMAP(KEY_F12),
   KEYMAP(KEY_RO),
   KEYMAP(KEY_RIGHTCTRL),
   KEYMAP(KEY_HOME),
   KEYMAP(KEY_UP),
   KEYMAP(KEY_PAGEUP),
   KEYMAP(KEY_LEFT),
   KEYMAP(KEY_RIGHT),
   KEYMAP(KEY_END),
   KEYMAP(KEY_DOWN),
   KEYMAP(KEY_PAGEDOWN),
   KEYMAP(KEY_INSERT),
   KEYMAP(KEY_DELETE),
   KEYMAP(KEY_VOLUMEDOWN),
   KEYMAP(KEY_VOLUMEUP),
   KEYMAP(KEY_POWER),
   KEYMAP(KEY_PAUSE)
};

struct VKeyboard {
    int fd;
    char gbuff[255];
};

CICO_CLS_ALLOCATOR(VKeyboard)

struct VMouse {

};
CICO_CLS_ALLOCATOR(VMouse)

void register_device_atom_mode(int fd)
{
   struct uinput_user_dev iudev;
   memset(&iudev, 0, sizeof(struct uinput_user_dev));
   snprintf(iudev.name, UINPUT_MAX_NAME_SIZE, "jvinput");
   iudev.id.bustype = BUS_USB;
   iudev.id.vendor = 0x1234;
   iudev.id.product = 0xfedf;
   iudev.id.version = 1;
   write(fd, &iudev, sizeof(struct uinput_user_dev));
   printf("[VInput] register_device_atom_mode %d \n", fd);
}

void register_device_legacy_mode(int fd) {

#if defined(__aarch64__) // only support fore aarch64
   struct uinput_setup u_setup;
   memset(&u_setup, 0, sizeof(struct uinput_setup));
   u_setup.id.bustype = BUS_USB;
   u_setup.id.vendor = 0x1122; 
   u_setup.id.product = 0x3313;
   strcpy(u_setup.name, "jvinput");
   ioctl(fd, UI_DEV_SETUP, &u_setup);
#endif
}

void emit(int fd, int type, int code, int val)
{
   int *a;
   struct input_event ie;
   ie.type = type;
   ie.code = code;
   ie.value = val;
   ie.time.tv_sec = 0;
   ie.time.tv_usec = 0;
   write(fd, &ie, sizeof(ie));
}

void trigger_key(int fd, int key)
{
   emit(fd, EV_KEY, key, 1);
   emit(fd, EV_SYN, SYN_REPORT, 0);
   usleep(50 * 1000);
   emit(fd, EV_KEY, key, 0);
   emit(fd, EV_SYN, SYN_REPORT, 0);
}

void vkeyboardInit(WrenVM* vm) {
    auto kb = WSCls(0, VKeyboard);
    kb->fd = open("/dev/uinput", O_WRONLY | O_NONBLOCK);
    ioctl(kb->fd, UI_SET_EVBIT, EV_SYN);
    ioctl(kb->fd, UI_SET_EVBIT, EV_KEY);
    for(auto item: gKey) { ioctl(kb->fd, UI_SET_KEYBIT, item.second); }

    if(int(WSDouble(1)) == 0) {
        register_device_legacy_mode(kb->fd);
    } else {
        register_device_atom_mode(kb->fd);
    }
   ioctl(kb->fd, UI_DEV_CREATE);
   usleep(1 * 1000);
}

void vkeyboardTriggerKey(WrenVM* vm) { trigger_key(WSCls(0, VKeyboard)->fd, WSDouble(1)); }
void vkeyboardTriggerKeyEx(WrenVM* vm) { 
    auto keyStr = WSString(1);
    for(const auto& item : gKey) {
        if(strcmp(item.first, keyStr) == 0) { trigger_key(WSCls(0, VKeyboard)->fd, item.second); }
    }
}
static char* g_vinputModuleSource = nullptr;
const char* cicoVinputSource() {
    if(!g_vinputModuleSource) {g_vinputModuleSource = loadModuleSource("cico_native/os/vinput.wren"); }
    return g_vinputModuleSource;
}

WrenForeignMethodFn wrenVinputBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature) 
{
    WrenForeignMethodFn fn = nullptr;
     if(strcmp(className, "VKeyboard") == 0) {
        do {
            if(strcmp(signature, "init(_)") == 0) { fn = vkeyboardInit; break; }
            if(strcmp(signature, "triggerKey(_)") == 0) { fn = vkeyboardTriggerKey; break; }
            if(strcmp(signature, "triggerKeyEx(_)") == 0) { fn = vkeyboardTriggerKeyEx; break; }
        } while(false);
     }
     return fn;
}

WrenForeignClassMethods wrenVinputBinForeignClass(WrenVM* vm, const char* className)
{
    WrenForeignClassMethods method;
    method.allocate = nullptr;
    method.finalize = nullptr;

    do {
        if(strcmp(className, "VKeyboard") == 0) { method.allocate = VKeyboardMalloc; break; }
        if(strcmp(className, "VMouse") == 0) { method.allocate = VMouseMalloc; break; }
    } while(false);

    return method;
}
} // namespace cico
