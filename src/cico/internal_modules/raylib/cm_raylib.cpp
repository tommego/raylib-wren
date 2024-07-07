#include "cm_raylib.h"
#include "cico_def.h"

extern "C" {
    #include "raylib.h"
    #include "config.h"
    #include "raymath.h"
    #include "external/stb_rect_pack.h"
}

namespace cico
{

CICO_CLS_ALLOCATOR(Vector2)
CICO_CLS_ALLOCATOR(Vector3)
CICO_CLS_ALLOCATOR(Vector4)
CICO_CLS_ALLOCATOR(Quaternion)
CICO_CLS_ALLOCATOR(Matrix)
CICO_CLS_ALLOCATOR(float3)
CICO_CLS_ALLOCATOR(float16)
CICO_CLS_ALLOCATOR(Color)
CICO_CLS_ALLOCATOR(Rectangle)
CICO_CLS_ALLOCATOR(Image)
CICO_CLS_ALLOCATOR(Texture)
CICO_CLS_ALLOCATOR(RenderTexture)
CICO_CLS_ALLOCATOR(NPatchInfo)
CICO_CLS_ALLOCATOR(GlyphInfo)
CICO_CLS_ALLOCATOR(Font)
CICO_CLS_ALLOCATOR(Camera3D)
CICO_CLS_ALLOCATOR(Camera2D)
CICO_CLS_ALLOCATOR(Mesh)
CICO_CLS_ALLOCATOR(Shader)
CICO_CLS_ALLOCATOR(MaterialMap)
CICO_CLS_ALLOCATOR(Material)
CICO_CLS_ALLOCATOR(Transform)
CICO_CLS_ALLOCATOR(BoneInfo)
CICO_CLS_ALLOCATOR(Model)
CICO_CLS_ALLOCATOR(ModelAnimation)
CICO_CLS_ALLOCATOR(Ray)
CICO_CLS_ALLOCATOR(RayCollision)
CICO_CLS_ALLOCATOR(BoundingBox)
CICO_CLS_ALLOCATOR(Wave)
CICO_CLS_ALLOCATOR(AudioStream)
CICO_CLS_ALLOCATOR(Sound)
CICO_CLS_ALLOCATOR(Music)
CICO_CLS_ALLOCATOR(VrDeviceInfo)
CICO_CLS_ALLOCATOR(VrStereoConfig)
CICO_CLS_ALLOCATOR(FilePathList)
CICO_CLS_ALLOCATOR(AutomationEvent)
CICO_CLS_ALLOCATOR(AutomationEventList)
CICO_CLS_ALLOCATOR(ValueList)
CICO_CLS_ALLOCATOR(Value)

static char* g_raylibModuleSource = nullptr;

const char* cicoRaylibSource()
{
    if(!g_raylibModuleSource) { g_raylibModuleSource = loadModuleSource("cico_native/raylib/raylib.wren"); }
    return g_raylibModuleSource;
}

void raymathClamp(WrenVM* vm) 
{
    wrenSetSlotDouble(vm, 0, double(Clamp(WSDouble(1), WSDouble(2), WSDouble(3))));
}

void raymathLerp(WrenVM* vm) 
{
    wrenSetSlotDouble(vm, 0, double(Lerp(WSDouble(1), WSDouble(2), WSDouble(3))));
}

void raymathNormalize(WrenVM* vm) 
{
    wrenSetSlotDouble(vm, 0, double(Normalize(WSDouble(1), WSDouble(2), WSDouble(3))));
}

void raymathRemap(WrenVM* vm) 
{
    wrenSetSlotDouble(vm, 0, double(Remap(WSDouble(1), WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5))));
}

void raymathWrap(WrenVM* vm) 
{
    wrenSetSlotDouble(vm, 0, double(Wrap(WSDouble(1), WSDouble(2), WSDouble(3))));
}

void raymathFloatEquals(WrenVM* vm) 
{
    wrenSetSlotDouble(vm, 0, double(FloatEquals(WSDouble(1), WSDouble(2))));
}

void raymathVector2Zero(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Zero();
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2One(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2One();
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Add(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Add(*WSCls(1, Vector2), *WSCls(2, Vector2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2AddValue(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2AddValue(*WSCls(1, Vector2), WSDouble(2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Subtract(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Subtract(*WSCls(1, Vector2), *WSCls(2, Vector2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2SubtractValue(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2SubtractValue(*WSCls(1, Vector2), WSDouble(2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Length(WrenVM* vm) 
{
    auto v = Vector2Length(*WSCls(1, Vector2));
    wrenSetSlotDouble(vm, 0, v);
}

void raymathVector2LengthSqr(WrenVM* vm) 
{
    auto v = Vector2LengthSqr(*WSCls(1, Vector2));
    wrenSetSlotDouble(vm, 0, v);
}

void raymathVector2DotProduct(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2DotProduct(*WSCls(1, Vector2), *WSCls(2, Vector2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Distance(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Distance(*WSCls(1, Vector2), *WSCls(2, Vector2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2DistanceSqr(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2DistanceSqr(*WSCls(1, Vector2), *WSCls(2, Vector2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Angle(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Angle(*WSCls(1, Vector2), *WSCls(2, Vector2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2LineAngle(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2LineAngle(*WSCls(1, Vector2), *WSCls(2, Vector2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Scale(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Scale(*WSCls(1, Vector2), WSDouble(2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Multiply(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Multiply(*WSCls(1, Vector2), *WSCls(2, Vector2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Negate(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Negate(*WSCls(1, Vector2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Divide(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Divide(*WSCls(1, Vector2), *WSCls(2, Vector2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Normalize(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Normalize(*WSCls(1, Vector2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Transform(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Transform(*WSCls(1, Vector2), *WSCls(2, Matrix));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Lerp(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Lerp(*WSCls(1, Vector2), *WSCls(2, Vector2), WSDouble(3));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Reflect(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Reflect(*WSCls(1, Vector2), *WSCls(2, Vector2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Rotate(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Rotate(*WSCls(1, Vector2), WSDouble(2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2MoveTowards(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2MoveTowards(*WSCls(1, Vector2), *WSCls(2, Vector2), WSDouble(3));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Invert(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Invert(*WSCls(1, Vector2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Clamp(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2Clamp(*WSCls(1, Vector2), *WSCls(2, Vector2), *WSCls(3, Vector2));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2ClampValue(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 0, sizeof(Vector2));
    auto v = Vector2ClampValue(*WSCls(1, Vector2), WSDouble(2), WSDouble(3));
    memcpy(WSCls(0, Vector2), &v, sizeof(Vector2));
}

void raymathVector2Equals(WrenVM* vm) 
{
    auto v = Vector2Equals(*WSCls(1, Vector2), *WSCls(2, Vector2));
    wrenSetSlotDouble(vm, 0, v);
}

void raymathVector3Zero(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Zero();
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3One(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3One();
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Add(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Add(*WSCls(1, Vector3), *WSCls(2, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3AddValue(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3AddValue(*WSCls(1, Vector3), WSDouble(2));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Subtract(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Subtract(*WSCls(1, Vector3), *WSCls(2, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3SubtractValue(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3SubtractValue(*WSCls(1, Vector3), WSDouble(2));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Scale(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Scale(*WSCls(1, Vector3), WSDouble(2));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Multiply(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Multiply(*WSCls(1, Vector3), *WSCls(2, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Perpendicular(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Perpendicular(*WSCls(1, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3CrossProduct(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3CrossProduct(*WSCls(1, Vector3), *WSCls(2, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Length(WrenVM* vm) 
{
    auto v = Vector3Length(*WSCls(1, Vector3));
    wrenSetSlotDouble(vm, 0, v);
}

void raymathVector3LengthSqr(WrenVM* vm) 
{
    auto v = Vector3LengthSqr(*WSCls(1, Vector3));
    wrenSetSlotDouble(vm, 0, v);
}

void raymathVector3DotProduct(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3DotProduct(*WSCls(1, Vector3), *WSCls(2, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Distance(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Distance(*WSCls(1, Vector3), *WSCls(2, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3DistanceSqr(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3DistanceSqr(*WSCls(1, Vector3), *WSCls(2, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Angle(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Angle(*WSCls(1, Vector3), *WSCls(2, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Negate(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Negate(*WSCls(1, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Divide(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Divide(*WSCls(1, Vector3), *WSCls(2, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Normalize(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Normalize(*WSCls(1, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Project(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Project(*WSCls(1, Vector3), *WSCls(2, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Reject(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Reject(*WSCls(1, Vector3), *WSCls(2, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3OrthoNormalize(WrenVM* vm) 
{
    Vector3OrthoNormalize(WSCls(1, Vector3), WSCls(2, Vector3));
}

void raymathVector3Transform(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Transform(*WSCls(1, Vector3), *WSCls(2, Matrix));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3RotateByQuaternion(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3RotateByQuaternion(*WSCls(1, Vector3), *WSCls(2, Quaternion));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3RotateByAxisAngle(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3RotateByAxisAngle(*WSCls(1, Vector3), *WSCls(2, Vector3), WSDouble(3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Lerp(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Lerp(*WSCls(1, Vector3), *WSCls(2, Vector3), WSDouble(3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Reflect(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Reflect(*WSCls(1, Vector3), *WSCls(2, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Min(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Min(*WSCls(1, Vector3), *WSCls(2, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Max(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Max(*WSCls(1, Vector3), *WSCls(2, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Barycenter(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Barycenter(*WSCls(1, Vector3), *WSCls(2, Vector3), *WSCls(3, Vector3), *WSCls(4, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Unproject(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Unproject(*WSCls(1, Vector3), *WSCls(2, Matrix), *WSCls(3, Matrix));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3ToFloatV(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 6, sizeof(float3));
    auto v = Vector3ToFloatV(*WSCls(1, Vector3));
    memcpy(WSCls(0, float3), &v, sizeof(float3));
}

void raymathVector3Invert(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Invert(*WSCls(1, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Clamp(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Clamp(*WSCls(1, Vector3), *WSCls(2, Vector3), *WSCls(3, Vector3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3ClampValue(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3ClampValue(*WSCls(1, Vector3), WSDouble(2), WSDouble(3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathVector3Equals(WrenVM* vm) 
{
    auto v = Vector3Equals(*WSCls(1, Vector3), *WSCls(2, Vector3));
    wrenSetSlotDouble(vm, 0, v);
}

void raymathVector3Refract(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = Vector3Refract(*WSCls(1, Vector3), *WSCls(2, Vector3), WSDouble(3));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathMatrixDeterminant(WrenVM* vm) 
{
    auto v = MatrixDeterminant(*WSCls(1, Matrix));
    wrenSetSlotDouble(vm, 0, v);
}

void raymathMatrixTrace(WrenVM* vm) 
{
    auto v = MatrixTrace(*WSCls(1, Matrix));
    wrenSetSlotDouble(vm, 0, v);
}

void raymathMatrixTranspose(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixTranspose(*WSCls(1, Matrix));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixInvert(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixInvert(*WSCls(1, Matrix));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixIdentity(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixIdentity();
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixAdd(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixAdd(*WSCls(1, Matrix), *WSCls(2, Matrix));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixSubtract(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixSubtract(*WSCls(1, Matrix), *WSCls(2, Matrix));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixMultiply(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixMultiply(*WSCls(1, Matrix), *WSCls(2, Matrix));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixTranslate(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixTranslate(WSDouble(1), WSDouble(2), WSDouble(3));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixRotate(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixRotate(*WSCls(1, Vector3), WSDouble(2));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixRotateX(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixRotateX(WSDouble(1));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixRotateY(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixRotateY(WSDouble(1));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixRotateZ(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixRotateZ(WSDouble(1));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixRotateXYZ(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixRotateXYZ(*WSCls(1, Vector3));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixRotateZYX(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixRotateZYX(*WSCls(1, Vector3));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixScale(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixScale(WSDouble(1), WSDouble(2), WSDouble(3));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixFrustum(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixFrustum(WSDouble(1), WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5), WSDouble(6));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixPerspective(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixPerspective(WSDouble(1), WSDouble(2), WSDouble(3), WSDouble(4));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixOrtho(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixOrtho(WSDouble(1), WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5), WSDouble(6));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixLookAt(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = MatrixLookAt(*WSCls(1, Vector3), *WSCls(2, Vector3), *WSCls(3, Vector3));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathMatrixToFloatV(WrenVM* vm) 
{
    wrenSetSlotNewForeign(vm, 0, 7, sizeof(float16));
    auto v = MatrixToFloatV(*WSCls(1, Matrix));
    memcpy(WSCls(0, float16), &v, sizeof(float16));
}

void raymathQuaternionAdd(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionAdd(*WSCls(1, Quaternion), *WSCls(2, Quaternion));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionAddValue(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionAddValue(*WSCls(1, Quaternion), WSDouble(2));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionSubtract(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionSubtract(*WSCls(1, Quaternion), *WSCls(2, Quaternion));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionSubtractValue(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionSubtractValue(*WSCls(1, Quaternion), WSDouble(2));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionIdentity(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionIdentity();
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionLength(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionLength(*WSCls(1, Quaternion));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionNormalize(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionNormalize(*WSCls(1, Quaternion));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionInvert(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionInvert(*WSCls(1, Quaternion));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionMultiply(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionMultiply(*WSCls(1, Quaternion), *WSCls(2, Quaternion));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionScale(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionScale(*WSCls(1, Quaternion), WSDouble(2));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionDivide(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionDivide(*WSCls(1, Quaternion), *WSCls(2, Quaternion));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionLerp(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionLerp(*WSCls(1, Quaternion), *WSCls(2, Quaternion), WSDouble(3));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionNlerp(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionNlerp(*WSCls(1, Quaternion), *WSCls(2, Quaternion), WSDouble(3));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionSlerp(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionSlerp(*WSCls(1, Quaternion), *WSCls(2, Quaternion), WSDouble(3));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionFromVector3ToVector3(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionFromVector3ToVector3(*WSCls(1, Vector3), *WSCls(2, Vector3));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionFromMatrix(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionFromMatrix(*WSCls(1, Matrix));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionToMatrix(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 5, sizeof(Matrix));
    auto v = QuaternionToMatrix(*WSCls(1, Quaternion));
    memcpy(WSCls(0, Matrix), &v, sizeof(Matrix));
}

void raymathQuaternionFromAxisAngle(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionFromAxisAngle(*WSCls(1, Vector3), WSDouble(2));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionToAxisAngle(WrenVM* vm)
{
    // QuaternionToAxisAngle(*WSCls(1, Quaternion), WSCls(2, Vector3), &WSDouble(3));
}

void raymathQuaternionFromEuler(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionFromEuler(WSDouble(1), WSDouble(2), WSDouble(3));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionToEuler(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 2, sizeof(Vector3));
    auto v = QuaternionToEuler(*WSCls(1, Quaternion));
    memcpy(WSCls(0, Vector3), &v, sizeof(Vector3));
}

void raymathQuaternionTransform(WrenVM* vm)
{
    wrenSetSlotNewForeign(vm, 0, 4, sizeof(Quaternion));
    auto v = QuaternionTransform(*WSCls(1, Quaternion), *WSCls(2, Matrix));
    memcpy(WSCls(0, Quaternion), &v, sizeof(Quaternion));
}

void raymathQuaternionEquals(WrenVM* vm)
{
    auto v = QuaternionEquals(*WSCls(1, Quaternion), *WSCls(2, Quaternion));
    wrenSetSlotDouble(vm, 0, v);
}

void raymathVector2GetX(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Vector2)->x); }
void raymathVector2SetX(WrenVM* vm) { WSCls(0, Vector2)->x = WSDouble(1); }
void raymathVector2GetY(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Vector2)->y); }
void raymathVector2SetY(WrenVM* vm) { WSCls(0, Vector2)->y = WSDouble(1); }

void raymathVector3GetX(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Vector3)->x); }
void raymathVector3SetX(WrenVM* vm) { WSCls(0, Vector3)->x = WSDouble(1); }
void raymathVector3GetY(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Vector3)->y); }
void raymathVector3SetY(WrenVM* vm) { WSCls(0, Vector3)->y = WSDouble(1); }
void raymathVector3GetZ(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Vector3)->z); }
void raymathVector3SetZ(WrenVM* vm) { WSCls(0, Vector3)->z = WSDouble(1); }

void raymathVector4GetX(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Vector4)->x); }
void raymathVector4SetX(WrenVM* vm) { WSCls(0, Vector4)->x = WSDouble(1); }
void raymathVector4GetY(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Vector4)->y); }
void raymathVector4SetY(WrenVM* vm) { WSCls(0, Vector4)->y = WSDouble(1); }
void raymathVector4GetZ(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Vector4)->z); }
void raymathVector4SetZ(WrenVM* vm) { WSCls(0, Vector4)->z = WSDouble(1); }
void raymathVector4GetW(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Vector4)->w); }
void raymathVector4SetW(WrenVM* vm) { WSCls(0, Vector4)->w = WSDouble(1); }

void raymathQuaternionGetX(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Quaternion)->x); }
void raymathQuaternionSetX(WrenVM* vm) { WSCls(0, Quaternion)->x = WSDouble(1); }
void raymathQuaternionGetY(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Quaternion)->y); }
void raymathQuaternionSetY(WrenVM* vm) { WSCls(0, Quaternion)->y = WSDouble(1); }
void raymathQuaternionGetZ(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Quaternion)->z); }
void raymathQuaternionSetZ(WrenVM* vm) { WSCls(0, Quaternion)->z = WSDouble(1); }
void raymathQuaternionGetW(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Quaternion)->w); }
void raymathQuaternionSetW(WrenVM* vm) { WSCls(0, Quaternion)->w = WSDouble(1); }

void raymathMatrixGetValue(WrenVM* vm) { wrenSetSlotDouble(vm, 0, ((float*)WSCls(0, Matrix))[int(WSDouble(1))]); }
void raymathMatrixSetValue(WrenVM* vm) { ((float*)WSCls(0, Matrix))[int(WSDouble(1))] = WSDouble(2); }

void raymathFloat3GetValue(WrenVM* vm) { wrenSetSlotDouble(vm, 0, ((float*)WSCls(0, float3))[int(WSDouble(1))]); }
void raymathFloat3SetValue(WrenVM* vm) { ((float*)WSCls(0, float3))[int(WSDouble(1))] = WSDouble(2); }

void raymathFloat16GetValue(WrenVM* vm) { wrenSetSlotDouble(vm, 0, ((float*)WSCls(0, float16))[int(WSDouble(1))]); }
void raymathFloat16SetValue(WrenVM* vm) { ((float*)WSCls(0, float16))[int(WSDouble(1))] = WSDouble(2); }

void raymathColorGetR(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Color)->r); }
void raymathColorSetR(WrenVM* vm) { WSCls(0, Color)->r = WSDouble(1); }
void raymathColorGetG(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Color)->g); }
void raymathColorSetG(WrenVM* vm) { WSCls(0, Color)->g = WSDouble(1); }
void raymathColorGetB(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Color)->b); }
void raymathColorSetB(WrenVM* vm) { WSCls(0, Color)->b = WSDouble(1); }
void raymathColorGetA(WrenVM* vm) { wrenSetSlotDouble(vm, 0, WSCls(0, Color)->a); }
void raymathColorSetA(WrenVM* vm) { WSCls(0, Color)->a = WSDouble(1); }

WRENPROPERTY_RW(Color, r, Double)
WRENPROPERTY_RW(Color, g, Double)
WRENPROPERTY_RW(Color, b, Double)
WRENPROPERTY_RW(Color, a, Double)

WRENPROPERTY_RW(Rectangle, x, Double)
WRENPROPERTY_RW(Rectangle, y, Double)
WRENPROPERTY_RW(Rectangle, width, Double)
WRENPROPERTY_RW(Rectangle, height, Double)

// WRENPROPERTYBYTESDEF(Image, data)
WRENPROPERTY_RW(Image, width, Double)
WRENPROPERTY_RW(Image, height, Double)
WRENPROPERTY_RW(Image, mipmaps, Double)
WRENPROPERTY_RW(Image, format, Double)

WRENPROPERTY_RW(Texture, id, Double)
WRENPROPERTY_RW(Texture, width, Double)
WRENPROPERTY_RW(Texture, height, Double)
WRENPROPERTY_RW(Texture, mipmaps, Double)
WRENPROPERTY_RW(Texture, format, Double)

WRENPROPERTY_RW(RenderTexture, id, Double)
WRENFOREIGNPROPERTY_WO(RenderTexture, texture, Texture)
WRENFOREIGNPROPERTY_WO(RenderTexture, depth, Texture)
void renderTextureGetTexture(WrenVM* vm) { *WSCls(1, Texture2D) = WSCls(0, RenderTexture)->texture; }
void renderTextureGetDepthTexture(WrenVM* vm) { *WSCls(1, Texture2D) = WSCls(0, RenderTexture)->depth; }

WRENPROPERTY_RW(NPatchInfo, left, Double)
WRENPROPERTY_RW(NPatchInfo, top, Double)
WRENPROPERTY_RW(NPatchInfo, right, Double)
WRENPROPERTY_RW(NPatchInfo, bottom, Double)
WRENPROPERTY_RW(NPatchInfo, layout, Double)
WRENFOREIGNPROPERTY_WO(NPatchInfo, source, Rectangle)

WRENPROPERTY_RW(GlyphInfo, value, Double)
WRENPROPERTY_RW(GlyphInfo, offsetX, Double)
WRENPROPERTY_RW(GlyphInfo, offsetY, Double)
WRENPROPERTY_RW(GlyphInfo, advanceX, Double)
WRENFOREIGNPROPERTY_WO(GlyphInfo, image, Image)

WRENPROPERTY_RW(Font, baseSize, Double)
WRENPROPERTY_RW(Font, glyphCount, Double)
WRENPROPERTY_RW(Font, glyphPadding, Double)
WRENFOREIGNPROPERTY_WO(Font, texture, Texture)

WRENFOREIGNPROPERTY_WO(Camera3D, position, Vector3)
WRENFOREIGNPROPERTY_WO(Camera3D, target, Vector3)
WRENFOREIGNPROPERTY_WO(Camera3D, up, Vector3)
WRENPROPERTY_RW(Camera3D, fovy, Double)
WRENPROPERTY_RW(Camera3D, projection, Double)

WRENFOREIGNPROPERTY_WO(Camera2D, offset, Vector2)
WRENFOREIGNPROPERTY_WO(Camera2D, target, Vector2)
WRENPROPERTY_RW(Camera2D, rotation, Double)
WRENPROPERTY_RW(Camera2D, zoom, Double)

WRENFOREIGNPROPERTY_WO(MaterialMap, texture, Texture2D)
WRENFOREIGNPROPERTY_WO(MaterialMap, color, Color)
WRENPROPERTY_RW(MaterialMap, value, Double)

WRENFOREIGNPROPERTY_WO(Material, shader, Shader)
void materialGetMaps(WrenVM* vm) {
    auto vlist = WSCls(1, ValueList);
    auto material = WSCls(0, Material);
    vlist->count = MAX_MATERIAL_MAPS;
    vlist->valueType = 12;
    vlist->data = material->maps;
}

WRENFOREIGNPROPERTY_WO(Transform, translation, Vector3)
WRENFOREIGNPROPERTY_WO(Transform, rotation, Quaternion)
WRENFOREIGNPROPERTY_WO(Transform, scale, Vector3)

// WRENPROPERTY_RW(BoneInfo, name, String)
WRENPROPERTY_RW(BoneInfo, parent, Double)

WRENFOREIGNPROPERTY_WO(Model, transform, Matrix)
WRENPROPERTY_RW(Model, meshCount, Double)
WRENPROPERTY_RW(Model, materialCount, Double)
WRENPROPERTY_RW(Model, boneCount, Double)
void modelGetMaterial(WrenVM* vm) { *WSCls(1, Material) = WSCls(0, Model)->materials[int(WSDouble(2))]; WSCls(1, Material)->maps = WSCls(0, Model)->materials[int(WSDouble(2))].maps; }
void modelGetMaterials(WrenVM* vm) {
    auto vlist = WSCls(1, ValueList);
    auto model = WSCls(0, Model);
    vlist->count = model->materialCount;
    vlist->valueType = 13;
    vlist->data = model->materials;
}
void modelSetMaterial(WrenVM* vm) { WSCls(0, Model)->materials[int(WSDouble(1))] = *WSCls(2, Material); WSCls(0, Model)->materials[int(WSDouble(1))].maps = WSCls(2, Material)->maps;}
void modelSetMaterialShader(WrenVM* vm) { WSCls(0, Model)->materials[int(WSDouble(1))].shader = *WSCls(2, Shader); }

WRENPROPERTY_RW(ModelAnimation, boneCount, Double)
WRENPROPERTY_RW(ModelAnimation, frameCount, Double)

WRENFOREIGNPROPERTY_WO(Ray, position, Vector3)
WRENFOREIGNPROPERTY_WO(Ray, direction, Vector3)

WRENPROPERTY_RW(RayCollision, hit, Bool)
WRENPROPERTY_RW(RayCollision, distance, Double)
WRENFOREIGNPROPERTY_WO(RayCollision, point, Vector3)
WRENFOREIGNPROPERTY_WO(RayCollision, normal, Vector3)

WRENFOREIGNPROPERTY_WO(BoundingBox, min, Vector3)
WRENFOREIGNPROPERTY_WO(BoundingBox, max, Vector3)

WRENPROPERTY_RW(ValueList, count, Double)
WRENPROPERTY_RW(ValueList, valueType, Double)

// FilePathList
WRENFOREIGNPROPERTY_RO(FilePathList, count, Double)
WRENFOREIGNPROPERTY_RO(FilePathList, capacity, Double)
void WRENGETTERFN(FilePathList, paths)(WrenVM* vm) {
    auto d = WSCls(0, FilePathList);
    wrenSetSlotNewList(vm, 0);
    wrenEnsureSlots(vm, 3);
    for(int i = 0 ; i < d->count; i++) {
        wrenSetSlotString(vm, 2, d->paths[i]);
        wrenInsertInList(vm, 0, i, 2);
    }
}

void valueListGet(WrenVM* vm) {
    auto d = WSCls(0, ValueList);
    switch (d->valueType)
    {
    case 0: { *WSCls(1, Color) = ((Color*)d->data)[int(WSDouble(2))]; break; }
    case 1: { *WSCls(1, Rectangle) = ((Rectangle*)d->data)[int(WSDouble(2))]; break; }
    case 2: { *WSCls(1, Image) = ((Image*)d->data)[int(WSDouble(2))]; break; }
    case 3: { *WSCls(1, Texture2D) = ((Texture2D*)d->data)[int(WSDouble(2))]; break; }
    case 4: { *WSCls(1, RenderTexture2D) = ((RenderTexture2D*)d->data)[int(WSDouble(2))]; break; }
    case 5: { *WSCls(1, NPatchInfo) = ((NPatchInfo*)d->data)[int(WSDouble(2))]; break; }
    case 6: { *WSCls(1, GlyphInfo) = ((GlyphInfo*)d->data)[int(WSDouble(2))]; break; }
    case 7: { *WSCls(1, Font) = ((Font*)d->data)[int(WSDouble(2))]; break; }
    case 8: { *WSCls(1, Camera3D) = ((Camera3D*)d->data)[int(WSDouble(2))]; break; }
    case 9: { *WSCls(1, Camera2D) = ((Camera2D*)d->data)[int(WSDouble(2))]; break; }
    case 10: { *WSCls(1, Mesh) = ((Mesh*)d->data)[int(WSDouble(2))]; break; }
    case 11: { *WSCls(1, Shader) = ((Shader*)d->data)[int(WSDouble(2))]; break; }
    case 12: { *WSCls(1, MaterialMap) = ((MaterialMap*)d->data)[int(WSDouble(2))]; break; }
    case 13: { *WSCls(1, Material) = ((Material*)d->data)[int(WSDouble(2))]; break; }
    case 14: { *WSCls(1, Transform) = ((Transform*)d->data)[int(WSDouble(2))]; break; }
    case 15: { *WSCls(1, BoneInfo) = ((BoneInfo*)d->data)[int(WSDouble(2))]; break; }
    case 16: { *WSCls(1, Model) = ((Model*)d->data)[int(WSDouble(2))]; break; }
    case 17: { *WSCls(1, ModelAnimation) = ((ModelAnimation*)d->data)[int(WSDouble(2))]; break; }
    case 18: { *WSCls(1, Ray) = ((Ray*)d->data)[int(WSDouble(2))]; break; }
    case 19: { *WSCls(1, RayCollision) = ((RayCollision*)d->data)[int(WSDouble(2))]; break; }
    case 20: { *WSCls(1, BoundingBox) = ((BoundingBox*)d->data)[int(WSDouble(2))]; break; }
    case 21: { *WSCls(1, Vector2) = ((Vector2*)d->data)[int(WSDouble(2))]; break; }
    case 22: { *WSCls(1, Vector3) = ((Vector3*)d->data)[int(WSDouble(2))]; break; }
    case 23: { *WSCls(1, Vector4) = ((Vector4*)d->data)[int(WSDouble(2))]; break; }
    case 24: { *WSCls(1, Matrix) = ((Matrix*)d->data)[int(WSDouble(2))]; break; }
    case 25: { *WSCls(1, float3) = ((float3*)d->data)[int(WSDouble(2))]; break; }
    case 26: { *WSCls(1, float16) = ((float16*)d->data)[int(WSDouble(2))]; break; }
    case 27: { wrenSetSlotDouble(vm, 0, ((float*)d->data)[int(WSDouble(2))]); break; }
    case 28: { wrenSetSlotDouble(vm, 0, ((int*)d->data)[int(WSDouble(2))]); break; }
    case 29: { wrenSetSlotDouble(vm, 0, ((unsigned char*)d->data)[int(WSDouble(2))]); break; }
    case 30: { wrenSetSlotBool(vm, 0, ((bool*)d->data)[int(WSDouble(2))]); break; }
    case 31: { wrenSetSlotString(vm, 0, (const char*)((char**)d->data)[int(WSDouble(2))]); break; }
    default: break;
    }
}
void valueListSet(WrenVM* vm) {
    auto d = WSCls(0, ValueList);
    auto idx = int(WSDouble(1));
    if(idx < 0 || idx >= d->count) {
        LOG_F(WARNING, "[valueListSet] index out of range (0 - %d), value: %d \n", d->count, idx);
        return;
    }
    switch (d->valueType)
    {
    case 0: {((Color*)d->data)[idx] = *WSCls(2, Color); break; }
    case 1: { ((Rectangle*)d->data)[idx] = *WSCls(2, Rectangle); break; }
    case 2: { ((Image*)d->data)[idx] = *WSCls(2, Image); break; }
    case 3: { ((Texture2D*)d->data)[idx] = *WSCls(2, Texture2D); break; }
    case 4: { ((RenderTexture2D*)d->data)[idx] = *WSCls(2, RenderTexture2D); break; }
    case 5: { ((NPatchInfo*)d->data)[idx] = *WSCls(2, NPatchInfo); break; }
    case 6: { ((GlyphInfo*)d->data)[idx] = *WSCls(2, GlyphInfo); break; }
    case 7: { ((Font*)d->data)[idx] = *WSCls(2, Font); break; }
    case 8: { ((Camera3D*)d->data)[idx] = *WSCls(2, Camera3D); break; }
    case 9: { ((Camera2D*)d->data)[idx] = *WSCls(2, Camera2D); break; }
    case 10: { ((Mesh*)d->data)[idx] = *WSCls(2, Mesh); break; }
    case 11: { ((Shader*)d->data)[idx] = *WSCls(2, Shader); break; }
    case 12: { ((MaterialMap*)d->data)[idx] = *WSCls(2, MaterialMap); break; }
    case 13: { ((Material*)d->data)[idx] = *WSCls(2, Material); break; }
    case 14: { ((Transform*)d->data)[idx] = *WSCls(2, Transform); break; }
    case 15: { ((BoneInfo*)d->data)[idx] = *WSCls(2, BoneInfo); break; }
    case 16: { ((Model*)d->data)[idx] = *WSCls(2, Model); break; }
    case 17: { ((ModelAnimation*)d->data)[idx] = *WSCls(2, ModelAnimation); break; }
    case 18: { ((Ray*)d->data)[idx] = *WSCls(2, Ray); break; }
    case 19: { ((RayCollision*)d->data)[idx] = *WSCls(2, RayCollision); break; }
    case 20: { ((BoundingBox*)d->data)[idx] = *WSCls(2, BoundingBox); break; }
    case 21: { ((Vector2*)d->data)[idx] = *WSCls(2, Vector2); break; }
    case 22: { ((Vector3*)d->data)[idx] = *WSCls(2, Vector3); break; }
    case 23: { ((Vector4*)d->data)[idx] = *WSCls(2, Vector4); break; }
    case 24: { ((Matrix*)d->data)[idx] = *WSCls(2, Matrix); break; }
    case 25: { ((float3*)d->data)[idx] = *WSCls(2, float3); break; }
    case 26: { ((float16*)d->data)[idx] = *WSCls(2, float16); break; }
    case 27: { ((float*)d->data)[idx] = WSDouble(2); break; }
    case 28: { ((int*)d->data)[idx] = WSDouble(2);break; }
    case 29: { ((unsigned char*)d->data)[idx] = WSDouble(2); break; }
    case 30: { ((bool*)d->data)[idx] = WSBool(2); break; }
    case 31: { 
        auto v = (char*)WSString(2);
        auto slen = strlen(v);
        if(!((char**)d->data)[idx]){ 
            ((char**)d->data)[idx] = (char*)malloc(sizeof(char) * (slen + 1));
        }
        else 
        {
            ((char**)d->data)[idx] = (char*)realloc(((char**)d->data)[idx], sizeof(char) * (slen + 1));
        }
        memcpy(((char**)d->data)[idx], v, sizeof(char) * (slen + 1));
        ((char**)d->data)[idx][slen] = '\0';
    }
    default: break;   
    }
}

void valueListCreate(WrenVM* vm) {
    auto d = WSCls(0, ValueList);
    auto cnt = int(WSDouble(2));
    if(cnt <= 0) {  
        LOG_F(WARNING, "[valueListCreate] could not create items with count: %d\n", cnt);
    }
    d->valueType = WSDouble(1);
    d->count = cnt;
    switch (d->valueType)
    {
    case 0: { d->data = malloc(cnt * sizeof(Color)); break; }
    case 1: { d->data = malloc(cnt * sizeof(Rectangle)); break; }
    case 2: { d->data = malloc(cnt * sizeof(Image)); break; }
    case 3: { d->data = malloc(cnt * sizeof(Texture2D)); break; }
    case 4: { d->data = malloc(cnt * sizeof(RenderTexture2D)); break; }
    case 5: { d->data = malloc(cnt * sizeof(NPatchInfo)); break; }
    case 6: { d->data = malloc(cnt * sizeof(GlyphInfo)); break; }
    case 7: { d->data = malloc(cnt * sizeof(Font)); break; }
    case 8: { d->data = malloc(cnt * sizeof(Camera3D)); break; }
    case 9: { d->data = malloc(cnt * sizeof(Camera2D)); break; }
    case 10: { d->data = malloc(cnt * sizeof(Mesh)); break; }
    case 11: { d->data = malloc(cnt * sizeof(Shader)); break; }
    case 12: { d->data = malloc(cnt * sizeof(MaterialMap)); break; }
    case 13: { d->data = malloc(cnt * sizeof(Material)); break; }
    case 14: { d->data = malloc(cnt * sizeof(Transform)); break; }
    case 15: { d->data = malloc(cnt * sizeof(BoneInfo)); break; }
    case 16: { d->data = malloc(cnt * sizeof(Model)); break; }
    case 17: { d->data = malloc(cnt * sizeof(ModelAnimation)); break; }
    case 18: { d->data = malloc(cnt * sizeof(Ray)); break; }
    case 19: { d->data = malloc(cnt * sizeof(RayCollision)); break; }
    case 20: { d->data = malloc(cnt * sizeof(BoundingBox)); break; }
    case 21: { d->data = malloc(cnt * sizeof(Vector2)); break; }
    case 22: { d->data = malloc(cnt * sizeof(Vector3)); break; }
    case 23: { d->data = malloc(cnt * sizeof(Vector4)); break; }
    case 24: { d->data = malloc(cnt * sizeof(Matrix)); break; }
    case 25: { d->data = malloc(cnt * sizeof(float3)); break; }
    case 26: { d->data = malloc(cnt * sizeof(float16)); break; }
    case 27: { d->data = malloc(cnt * sizeof(float)); break; }
    case 28: { d->data = malloc(cnt * sizeof(int)); break; }
    case 29: { d->data = malloc(cnt * sizeof(unsigned char)); break; }
    case 30: { d->data = malloc(cnt * sizeof(bool)); break; }
    case 31: { d->data = malloc(cnt * sizeof(char*)); memset(d->data, 0, cnt * sizeof(char*)); break; }
    default: break;   
    }
}

void valueGet(WrenVM* vm) {
    auto d = WSCls(0, Value);
    switch (d->valueType)
    {
    case 0: { *WSCls(1, Color) = *((Color*)d->data); break; }
    case 1: { *WSCls(1, Rectangle) = *((Rectangle*)d->data); break; }
    case 2: { *WSCls(1, Image) = *((Image*)d->data); break; }
    case 3: { *WSCls(1, Texture2D) = *((Texture2D*)d->data); break; }
    case 4: { *WSCls(1, RenderTexture2D) = *((RenderTexture2D*)d->data); break; }
    case 5: { *WSCls(1, NPatchInfo) = *((NPatchInfo*)d->data); break; }
    case 6: { *WSCls(1, GlyphInfo) = *((GlyphInfo*)d->data); break; }
    case 7: { *WSCls(1, Font) = *((Font*)d->data); break; }
    case 8: { *WSCls(1, Camera3D) = *((Camera3D*)d->data); break; }
    case 9: { *WSCls(1, Camera2D) = *((Camera2D*)d->data); break; }
    case 10: { *WSCls(1, Mesh) = *((Mesh*)d->data); break; }
    case 11: { *WSCls(1, Shader) = *((Shader*)d->data); break; }
    case 12: { *WSCls(1, MaterialMap) = *((MaterialMap*)d->data); break; }
    case 13: { *WSCls(1, Material) = *((Material*)d->data); break; }
    case 14: { *WSCls(1, Transform) = *((Transform*)d->data); break; }
    case 15: { *WSCls(1, BoneInfo) = *((BoneInfo*)d->data); break; }
    case 16: { *WSCls(1, Model) = *((Model*)d->data); break; }
    case 17: { *WSCls(1, ModelAnimation) = *((ModelAnimation*)d->data); break; }
    case 18: { *WSCls(1, Ray) = *((Ray*)d->data); break; }
    case 19: { *WSCls(1, RayCollision) = *((RayCollision*)d->data); break; }
    case 20: { *WSCls(1, BoundingBox) = *((BoundingBox*)d->data); break; }
    case 21: { *WSCls(1, Vector2) = *((Vector2*)d->data); break; }
    case 22: { *WSCls(1, Vector3) = *((Vector3*)d->data); break; }
    case 23: { *WSCls(1, Vector4) = *((Vector4*)d->data); break; }
    case 24: { *WSCls(1, Matrix) = *((Matrix*)d->data); break; }
    case 25: { *WSCls(1, float3) = *((float3*)d->data); break; }
    case 26: { *WSCls(1, float16) = *((float16*)d->data); break; }
    case 27: { wrenSetSlotDouble(vm, 0, *((float*)d->data)); break; }
    case 28: { wrenSetSlotDouble(vm, 0, *((int*)d->data)); break; }
    case 29: { wrenSetSlotDouble(vm, 0, *((unsigned char*)d->data)); break; }
    case 30: { wrenSetSlotBool(vm, 0, *((bool*)d->data)); break; }
    case 31: { wrenSetSlotString(vm, 0, (const char*)d->data); break; }
    default: break;
    }
}
void valueSet(WrenVM* vm) {
    auto d = WSCls(0, Value);
    switch (d->valueType)
    {
    case 0: { *((Color*)d->data) = *WSCls(2, Color); break; }
    case 1: { *((Rectangle*)d->data) = *WSCls(2, Rectangle); break; }
    case 2: { *((Image*)d->data) = *WSCls(2, Image); break; }
    case 3: { *((Texture2D*)d->data) = *WSCls(2, Texture2D); break; }
    case 4: { *((RenderTexture2D*)d->data) = *WSCls(2, RenderTexture2D); break; }
    case 5: { *((NPatchInfo*)d->data) = *WSCls(2, NPatchInfo); break; }
    case 6: { *((GlyphInfo*)d->data) = *WSCls(2, GlyphInfo); break; }
    case 7: { *((Font*)d->data) = *WSCls(2, Font); break; }
    case 8: { *((Camera3D*)d->data) = *WSCls(2, Camera3D); break; }
    case 9: { *((Camera2D*)d->data) = *WSCls(2, Camera2D); break; }
    case 10: { *((Mesh*)d->data) = *WSCls(2, Mesh); break; }
    case 11: { *((Shader*)d->data) = *WSCls(2, Shader); break; }
    case 12: { *((MaterialMap*)d->data) = *WSCls(2, MaterialMap); break; }
    case 13: { *((Material*)d->data) = *WSCls(2, Material); break; }
    case 14: { *((Transform*)d->data) = *WSCls(2, Transform); break; }
    case 15: { *((BoneInfo*)d->data) = *WSCls(2, BoneInfo); break; }
    case 16: { *((Model*)d->data) = *WSCls(2, Model); break; }
    case 17: { *((ModelAnimation*)d->data) = *WSCls(2, ModelAnimation); break; }
    case 18: { *((Ray*)d->data) = *WSCls(2, Ray); break; }
    case 19: { *((RayCollision*)d->data) = *WSCls(2, RayCollision); break; }
    case 20: { *((BoundingBox*)d->data) = *WSCls(2, BoundingBox); break; }
    case 21: { *((Vector2*)d->data) = *WSCls(2, Vector2); break; }
    case 22: { *((Vector3*)d->data) = *WSCls(2, Vector3); break; }
    case 23: { *((Vector4*)d->data) = *WSCls(2, Vector4); break; }
    case 24: { *((Matrix*)d->data) = *WSCls(2, Matrix); break; }
    case 25: { *((float3*)d->data) = *WSCls(2, float3); break; }
    case 26: { *((float16*)d->data) = *WSCls(2, float16); break; }
    case 27: { *((float*)d->data) = WSDouble(1); break; }
    case 28: { *((int*)d->data) = WSDouble(1);break; }
    case 29: { *((unsigned char*)d->data) = WSDouble(1); break; }
    case 30: { *((bool*)d->data) = WSBool(1); break; }
    case 31: {
        auto len = strlen(WSString(1));
        if(!d->data) {
            d->data = malloc((len + 1) * sizeof(char));
        }
        else {
            d->data = realloc(d->data, (len + 1) * sizeof(char));
        }
            ((char*)d->data)[len] = '\0';
            memcpy(d->data, WSString(1), len * sizeof(char));
        break;
     }
    default: break;   
    }
}

void valueCreate(WrenVM* vm) {
    auto valueType = int(WSDouble(1));
    auto d = WSCls(0, Value);
    d->valueType = valueType;
    switch (valueType)
    {
    case 0: { d->data = malloc(sizeof(Color)); *((Color*)d->data) = *WSCls(2, Color); break; }
    case 1: { d->data = malloc(sizeof(Rectangle)); *((Rectangle*)d->data) = *WSCls(2, Rectangle);  break; }
    case 2: { d->data = malloc(sizeof(Image)); *((Image*)d->data) = *WSCls(2, Image); break; }
    case 3: { d->data = malloc(sizeof(Texture2D)); *((Texture2D*)d->data) = *WSCls(2, Texture2D); break; }
    case 4: { d->data = malloc(sizeof(RenderTexture2D)); *((RenderTexture2D*)d->data) = *WSCls(2, RenderTexture2D); break; }
    case 5: { d->data = malloc(sizeof(NPatchInfo)); *((NPatchInfo*)d->data) = *WSCls(2, NPatchInfo); break; }
    case 6: { d->data = malloc(sizeof(GlyphInfo)); *((GlyphInfo*)d->data) = *WSCls(2, GlyphInfo); break; }
    case 7: { d->data = malloc(sizeof(Font)); *((Font*)d->data) = *WSCls(2, Font); break; }
    case 8: { d->data = malloc(sizeof(Camera3D)); *((Camera3D*)d->data) = *WSCls(2, Camera3D); break; }
    case 9: { d->data = malloc(sizeof(Camera2D)); *((Camera2D*)d->data) = *WSCls(2, Camera2D); break; }
    case 10: { d->data = malloc(sizeof(Mesh)); *((Mesh*)d->data) = *WSCls(2, Mesh); break; }
    case 11: { d->data = malloc(sizeof(Shader)); *((Shader*)d->data) = *WSCls(2, Shader); break; }
    case 12: { d->data = malloc(sizeof(MaterialMap)); *((MaterialMap*)d->data) = *WSCls(2, MaterialMap); break; }
    case 13: { d->data = malloc(sizeof(Material)); *((Material*)d->data) = *WSCls(2, Material); break; }
    case 14: { d->data = malloc(sizeof(Transform)); *((Transform*)d->data) = *WSCls(2, Transform); break; }
    case 15: { d->data = malloc(sizeof(BoneInfo)); *((BoneInfo*)d->data) = *WSCls(2, BoneInfo); break; }
    case 16: { d->data = malloc(sizeof(Model)); *((Model*)d->data) = *WSCls(2, Model); break; }
    case 17: { d->data = malloc(sizeof(ModelAnimation)); *((ModelAnimation*)d->data) = *WSCls(2, ModelAnimation); break; }
    case 18: { d->data = malloc(sizeof(Ray)); *((Ray*)d->data) = *WSCls(2, Ray); break; }
    case 19: { d->data = malloc(sizeof(RayCollision)); *((RayCollision*)d->data) = *WSCls(2, RayCollision); break; }
    case 20: { d->data = malloc(sizeof(BoundingBox)); *((BoundingBox*)d->data) = *WSCls(2, BoundingBox); break; }
    case 21: { d->data = malloc(sizeof(Vector2)); *((Vector2*)d->data) = *WSCls(2, Vector2); break; }
    case 22: { d->data = malloc(sizeof(Vector3)); *((Vector3*)d->data) = *WSCls(2, Vector3); break; }
    case 23: { d->data = malloc(sizeof(Vector4)); *((Vector4*)d->data) = *WSCls(2, Vector4); break; }
    case 24: { d->data = malloc(sizeof(Matrix)); *((Matrix*)d->data) = *WSCls(2, Matrix); break; }
    case 25: { d->data = malloc(sizeof(float3)); *((float3*)d->data) = *WSCls(2, float3); break; }
    case 26: { d->data = malloc(sizeof(float16)); *((float16*)d->data) = *WSCls(2, float16); break; }
    case 27: { d->data = malloc(sizeof(float)); *((float*)d->data) = WSDouble(2); break; }
    case 28: { d->data = malloc(sizeof(int)); *((int*)d->data) = WSDouble(2); break; }
    case 29: { d->data = malloc(sizeof(unsigned char)); *((unsigned char*)d->data) = WSDouble(2); break; }
    case 30: { d->data = malloc(sizeof(bool)); *((bool*)d->data) = WSBool(2); break; }
    default: break;   
    }
}

void RAYLIBFN(InitWindow)(WrenVM* vm) { InitWindow(WSDouble(1), WSDouble(2), WSString(3)); }
void RAYLIBFN(CloseWindow)(WrenVM* vm) { CloseWindow(); }
void RAYLIBFN(WindowShouldClose)(WrenVM* vm) { wrenSetSlotBool(vm, 0, WindowShouldClose()); }
void RAYLIBFN(IsWindowReady)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsWindowReady()); }
void RAYLIBFN(IsWindowFullscreen)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsWindowFullscreen()); }
void RAYLIBFN(IsWindowHidden)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsWindowHidden()); }
void RAYLIBFN(IsWindowMinimized)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsWindowMinimized()); }
void RAYLIBFN(IsWindowMaximized)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsWindowMaximized()); }
void RAYLIBFN(IsWindowFocused)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsWindowFocused()); }
void RAYLIBFN(IsWindowResized)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsWindowResized()); }
void RAYLIBFN(IsWindowState)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsWindowState(WSDouble(1))); }
void RAYLIBFN(SetWindowState)(WrenVM* vm) { SetWindowState(WSDouble(1)); }
void RAYLIBFN(ClearWindowState)(WrenVM* vm) { ClearWindowState(WSDouble(1)); }
void RAYLIBFN(ToggleFullscreen)(WrenVM* vm) { ToggleFullscreen(); }
void RAYLIBFN(ToggleBorderlessWindowed)(WrenVM* vm) { ToggleBorderlessWindowed(); }
void RAYLIBFN(MaximizeWindow)(WrenVM* vm) { MaximizeWindow(); }
void RAYLIBFN(MinimizeWindow)(WrenVM* vm) { MinimizeWindow(); }
void RAYLIBFN(RestoreWindow)(WrenVM* vm) { RestoreWindow(); }
void RAYLIBFN(SetWindowIcon)(WrenVM* vm) { SetWindowIcon(*WSCls(1, Image)); }
void RAYLIBFN(SetWindowIcons)(WrenVM* vm) {  } // TODO
void RAYLIBFN(SetWindowTitle)(WrenVM* vm) { SetWindowTitle(WSString(1)); }
void RAYLIBFN(SetWindowPosition)(WrenVM* vm) { SetWindowPosition(WSDouble(1), WSDouble(2)); }
void RAYLIBFN(SetWindowMonitor)(WrenVM* vm) { SetWindowMonitor(WSDouble(1)); }
void RAYLIBFN(SetWindowMinSize)(WrenVM* vm) { SetWindowMinSize(WSDouble(1), WSDouble(2)); }
void RAYLIBFN(SetWindowMaxSize)(WrenVM* vm) { SetWindowMaxSize(WSDouble(1), WSDouble(2)); }
void RAYLIBFN(SetWindowSize)(WrenVM* vm) { SetWindowSize(WSDouble(1), WSDouble(2)); }
void RAYLIBFN(SetWindowOpacity)(WrenVM* vm) { SetWindowOpacity(WSDouble(1)); }
void RAYLIBFN(SetWindowFocused)(WrenVM* vm) { SetWindowFocused(); }
void RAYLIBFN(GetScreenWidth)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetScreenWidth()); }
void RAYLIBFN(GetScreenHeight)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetScreenHeight()); }
void RAYLIBFN(GetRenderWidth)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetRenderWidth()); }
void RAYLIBFN(GetRenderHeight)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetRenderHeight()); }
void RAYLIBFN(GetMonitorCount)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetMonitorCount()); }
void RAYLIBFN(GetCurrentMonitor)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetCurrentMonitor()); }
void RAYLIBFN(GetMonitorPosition)(WrenVM* vm) {  
    auto inv2 = WSCls(1, Vector2);
    auto out = GetMonitorPosition(WSDouble(2));
    memcpy(inv2, &out, sizeof(Vector2));
}
void RAYLIBFN(GetMonitorWidth)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetMonitorWidth(WSDouble(1))); }
void RAYLIBFN(GetMonitorHeight)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetMonitorHeight(WSDouble(1))); }
void RAYLIBFN(GetMonitorPhysicalWidth)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetMonitorPhysicalWidth(WSDouble(1))); }
void RAYLIBFN(GetMonitorPhysicalHeight)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetMonitorPhysicalHeight(WSDouble(1))); }
void RAYLIBFN(GetMonitorRefreshRate)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetMonitorRefreshRate(WSDouble(1))); }
void RAYLIBFN(GetWindowPosition)(WrenVM* vm) { 
    auto inv2 = WSCls(1, Vector2);
    auto out = GetWindowPosition();
    memcpy(inv2, &out, sizeof(Vector2));
}
void RAYLIBFN(GetWindowScaleDPI)(WrenVM* vm) {  
    auto inv2 = WSCls(1, Vector2);
    auto out = GetWindowScaleDPI();
    memcpy(inv2, &out, sizeof(Vector2));
}
void RAYLIBFN(GetMonitorName)(WrenVM* vm) { wrenSetSlotString(vm, 0, GetMonitorName(WSDouble(1))); }
void RAYLIBFN(SetClipboardText)(WrenVM* vm) { SetClipboardText(WSString(1)); }
void RAYLIBFN(GetClipboardText)(WrenVM* vm) { wrenSetSlotString(vm, 0, GetClipboardText()); }
void RAYLIBFN(EnableEventWaiting)(WrenVM* vm) { EnableEventWaiting(); }
void RAYLIBFN(DisableEventWaiting)(WrenVM* vm) { DisableEventWaiting(); }

void RAYLIBFN(ShowCursor)(WrenVM* vm) { ShowCursor(); }
void RAYLIBFN(HideCursor)(WrenVM* vm) { HideCursor(); }
void RAYLIBFN(IsCursorHidden)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsCursorHidden()); }
void RAYLIBFN(EnableCursor)(WrenVM* vm) { EnableCursor(); }
void RAYLIBFN(DisableCursor)(WrenVM* vm) { DisableCursor(); }
void RAYLIBFN(IsCursorOnScreen)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsCursorOnScreen()); }

void RAYLIBFN(ClearBackground)(WrenVM* vm) { ClearBackground(*WSCls(1, Color)); }
void RAYLIBFN(BeginDrawing)(WrenVM* vm) { BeginDrawing(); }
void RAYLIBFN(EndDrawing)(WrenVM* vm) { EndDrawing(); }
void RAYLIBFN(BeginMode2D)(WrenVM* vm) { BeginMode2D(*WSCls(1, Camera2D)); }
void RAYLIBFN(EndMode2D)(WrenVM* vm) { EndMode2D(); }
void RAYLIBFN(BeginMode3D)(WrenVM* vm) { BeginMode3D(*WSCls(1, Camera3D)); }
void RAYLIBFN(EndMode3D)(WrenVM* vm) { EndMode3D(); }
void RAYLIBFN(BeginTextureMode)(WrenVM* vm) { BeginTextureMode(*WSCls(1, RenderTexture2D)); }
void RAYLIBFN(EndTextureMode)(WrenVM* vm) { EndTextureMode(); }
void RAYLIBFN(BeginShaderMode)(WrenVM* vm) { BeginShaderMode(*WSCls(1, Shader)); }
void RAYLIBFN(EndShaderMode)(WrenVM* vm) { EndShaderMode(); }
void RAYLIBFN(EndBlendMode)(WrenVM* vm) { EndBlendMode(); }
void RAYLIBFN(BeginBlendMode)(WrenVM* vm) { BeginBlendMode(WSDouble(1)); }
void RAYLIBFN(BeginScissorMode)(WrenVM* vm) { BeginScissorMode(WSDouble(1), WSDouble(2), WSDouble(3), WSDouble(4)); }
void RAYLIBFN(EndScissorMode)(WrenVM* vm) { EndScissorMode(); }
void RAYLIBFN(BeginVrStereoMode)(WrenVM* vm) { BeginVrStereoMode(*WSCls(1, VrStereoConfig)); }
void RAYLIBFN(EndVrStereoMode)(WrenVM* vm) { EndVrStereoMode(); }

void RAYLIBFN(LoadVrStereoConfig)(WrenVM* vm) {  } // TODO 
void RAYLIBFN(UnloadVrStereoConfig)(WrenVM* vm) { } // TODO

void RAYLIBFN(LoadShader)(WrenVM* vm) { 
    auto shader = LoadShader(WSString(2), WSString(3));
    memcpy(WSCls(1, Shader), &shader, sizeof(Shader));
}
void RAYLIBFN(LoadShaderFromMemory)(WrenVM* vm) { 
    auto shader = LoadShaderFromMemory(WSString(2), WSString(3));
    memcpy(WSCls(1, Shader), &shader, sizeof(Shader));
}
void RAYLIBFN(IsShaderReady)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsShaderReady(*WSCls(1, Shader))); }
void RAYLIBFN(GetShaderLocation)(WrenVM* vm) { 
    wrenSetSlotDouble(vm, 0, GetShaderLocation(*WSCls(1, Shader), WSString(2)));
}
void RAYLIBFN(GetShaderLocationAttrib)(WrenVM* vm) {
    wrenSetSlotDouble(vm, 0, GetShaderLocationAttrib(*WSCls(1, Shader), WSString(2)));
}
void RAYLIBFN(SetShaderValue)(WrenVM* vm) { 
    auto shader = WSCls(1, Shader);
    int loc = WSDouble(2);
    int utype = WSDouble(4);
    switch(utype) {
        case SHADER_UNIFORM_FLOAT: {
            float v = WSDouble(3);
            SetShaderValue(*shader, loc, &v, utype);
            break;
        }
        case SHADER_UNIFORM_VEC2: {
            SetShaderValue(*shader, loc, WSCls(3, Vector2), utype);
            break;
        }
        case SHADER_UNIFORM_VEC3: {
            SetShaderValue(*shader, loc, WSCls(3, Vector3), utype);
            break;
        }
        case SHADER_UNIFORM_VEC4: {
            SetShaderValue(*shader, loc, (void*)WSCls(3, Vector4), utype);
            break;
        }
        case SHADER_UNIFORM_INT: {
            int v = WSDouble(3);
            SetShaderValue(*shader, loc, &v, utype);
            break;
        }
        default: {
            break;
        }
    }
    
}
void RAYLIBFN(SetShaderValueV)(WrenVM* vm) { }
void RAYLIBFN(SetShaderValueMatrix)(WrenVM* vm) {
    SetShaderValueMatrix(*WSCls(1, Shader), int(WSDouble(1)), *WSCls(2, Matrix));
}
void RAYLIBFN(SetShaderValueTexture)(WrenVM* vm) { 
    SetShaderValueTexture(*WSCls(1, Shader), int(WSDouble(1)), *WSCls(2, Texture2D));
}
void RAYLIBFN(UnloadShader)(WrenVM* vm) { 
    UnloadShader(*WSCls(1, Shader));
}

void RAYLIBFN(GetMouseRay)(WrenVM* vm) {
    auto inray = WSCls(1, Ray);
    auto out = GetMouseRay(*WSCls(2, Vector2), *WSCls(3, Camera));
    memcpy(inray, &out, sizeof(Ray));
}
void RAYLIBFN(GetCameraMatrix)(WrenVM* vm) {
    auto inmat = WSCls(1, Matrix);
    auto out = GetCameraMatrix(*WSCls(2, Camera));
    memcpy(inmat, &out, sizeof(Matrix));
}
void RAYLIBFN(GetCameraMatrix2D)(WrenVM* vm) { 
    auto inmat = WSCls(1, Matrix);
    auto out = GetCameraMatrix2D(*WSCls(2, Camera2D));
    memcpy(inmat, &out, sizeof(Matrix));
}
void RAYLIBFN(GetWorldToScreen)(WrenVM* vm) { 
    auto inv2 = WSCls(1, Vector2);
    auto out = GetWorldToScreen(*WSCls(2, Vector3), *WSCls(3, Camera));
    memcpy(inv2, &out, sizeof(Vector2));
}

void RAYLIBFN(GetScreenToWorld2D)(WrenVM* vm) { 
    auto inv2 = WSCls(1, Vector2);
    auto out = GetScreenToWorld2D(*WSCls(2, Vector2), *WSCls(3, Camera2D));
    memcpy(inv2, &out, sizeof(Vector2));
}
void RAYLIBFN(GetWorldToScreenEx)(WrenVM* vm) { 
    auto inv2 = WSCls(1, Vector2);
    auto out = GetWorldToScreenEx(*WSCls(2, Vector3), *WSCls(3, Camera), WSDouble(4), WSDouble(5));
    memcpy(inv2, &out, sizeof(Vector2));
}
void RAYLIBFN(GetWorldToScreen2D)(WrenVM* vm) { 
    auto inv2 = WSCls(1, Vector2);
    auto out = GetWorldToScreen2D(*WSCls(2, Vector2), *WSCls(3, Camera2D));
    memcpy(inv2, &out, sizeof(Vector2));
}

void RAYLIBFN(SetTargetFPS)(WrenVM* vm) { SetTargetFPS(WSDouble(1)); }
void RAYLIBFN(GetFrameTime)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetFrameTime()); }
void RAYLIBFN(GetTime)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetTime()); }
void RAYLIBFN(GetFPS)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetFPS()); }

void RAYLIBFN(SwapScreenBuffer)(WrenVM* vm) { SwapScreenBuffer(); }
void RAYLIBFN(PollInputEvents)(WrenVM* vm) { PollInputEvents(); }
void RAYLIBFN(WaitTime)(WrenVM* vm) { WaitTime(WSDouble(1)); }

void RAYLIBFN(SetRandomSeed)(WrenVM* vm) {  SetRandomSeed(WSDouble(1)); }
void RAYLIBFN(GetRandomValue)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetRandomValue(WSDouble(1), WSDouble(2))); }
void RAYLIBFN(LoadRandomSequence)(WrenVM* vm) { 
    auto vlist = WSCls(1, ValueList);
    auto data = LoadRandomSequence(WSDouble(2), WSDouble(3), WSDouble(4));
    vlist->data = data;
    vlist->count = WSDouble(2);
    vlist->valueType = 28;
}
void RAYLIBFN(UnloadRandomSequence)(WrenVM* vm) {
    auto vlist = WSCls(1, ValueList);
    UnloadRandomSequence((int*)vlist->data);
    vlist->count = 0;
    vlist->data = nullptr;
}

void RAYLIBFN(TakeScreenshot)(WrenVM* vm) { TakeScreenshot(WSString(1)); }
void RAYLIBFN(SetConfigFlags)(WrenVM* vm) { SetConfigFlags(WSDouble(1)); }
void RAYLIBFN(OpenURL)(WrenVM* vm) { OpenURL(WSString(1)); }

void RAYLIBFN(LoadFileData)(WrenVM* vm) { 
    unsigned char* data = nullptr; 
    int dataSize;
    data = LoadFileData(WSString(1), &dataSize);
    wrenSetSlotString(vm, 0, (const char*)data);
    wrenSetSlotDouble(vm, 2, dataSize);
}
void RAYLIBFN(UnloadFileData)(WrenVM* vm) {  UnloadFileData((unsigned char*)WSString(1)); }
void RAYLIBFN(SaveFileData)(WrenVM* vm) { SaveFileData(WSString(1), (void*)WSString(2), WSDouble(3)); }
void RAYLIBFN(ExportDataAsCode)(WrenVM* vm) { ExportDataAsCode((const unsigned char*)WSString(1), WSDouble(2), WSString(3)); }
void RAYLIBFN(LoadFileText)(WrenVM* vm) { wrenSetSlotString(vm, 0, LoadFileText(WSString(1))); }
void RAYLIBFN(UnloadFileText)(WrenVM* vm) { UnloadFileText((char*)WSString(1)); }
void RAYLIBFN(SaveFileText)(WrenVM* vm) { SaveFileText(WSString(1), (char*)WSString(2)); }

void RAYLIBFN(FileExists)(WrenVM* vm) { wrenSetSlotBool(vm, 0, FileExists(WSString(1))); }
void RAYLIBFN(DirectoryExists)(WrenVM* vm) { wrenSetSlotBool(vm, 0, DirectoryExists(WSString(1))); }
void RAYLIBFN(IsFileExtension)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsFileExtension(WSString(1), WSString(2)));  }
void RAYLIBFN(GetFileLength)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetFileLength(WSString(1))); }
void RAYLIBFN(GetFileExtension)(WrenVM* vm) { wrenSetSlotString(vm, 0, GetFileExtension(WSString(1))); }
void RAYLIBFN(GetFileName)(WrenVM* vm) { wrenSetSlotString(vm, 0, GetFileName(WSString(1))); }
void RAYLIBFN(GetFileNameWithoutExt)(WrenVM* vm) { wrenSetSlotString(vm, 0, GetFileNameWithoutExt(WSString(1))); }
void RAYLIBFN(GetDirectoryPath)(WrenVM* vm) { wrenSetSlotString(vm, 0, GetDirectoryPath(WSString(1))); }
void RAYLIBFN(GetPrevDirectoryPath)(WrenVM* vm) { wrenSetSlotString(vm, 0, GetPrevDirectoryPath(WSString(1))); }
void RAYLIBFN(GetWorkingDirectory)(WrenVM* vm) { wrenSetSlotString(vm, 0, GetWorkingDirectory()); }
void RAYLIBFN(GetApplicationDirectory)(WrenVM* vm) { wrenSetSlotString(vm, 0, GetApplicationDirectory()); }
void RAYLIBFN(ChangeDirectory)(WrenVM* vm) { wrenSetSlotBool(vm, 0, ChangeDirectory(WSString(1))); }
void RAYLIBFN(IsPathFile)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsPathFile(WSString(1))); }
void RAYLIBFN(LoadDirectoryFiles)(WrenVM* vm) { 
    auto input = WSCls(1, FilePathList);
    auto output = LoadDirectoryFiles(WSString(2));
    memcpy(input, &output, sizeof(FilePathList));
} 
void RAYLIBFN(LoadDirectoryFilesEx)(WrenVM* vm) { 
    auto input = WSCls(1, FilePathList);
    auto output = LoadDirectoryFilesEx(WSString(2), WSString(3), WSBool(4));
    memcpy(input, &output, sizeof(FilePathList));
}
void RAYLIBFN(UnloadDirectoryFiles)(WrenVM* vm) { 
    UnloadDirectoryFiles(*WSCls(1, FilePathList));
}
void RAYLIBFN(IsFileDropped)(WrenVM* vm) { 
    wrenSetSlotBool(vm, 0, IsFileDropped());
}
void RAYLIBFN(LoadDroppedFiles)(WrenVM* vm) { 
    auto input = WSCls(1, FilePathList);
    auto output = LoadDroppedFiles();
    memcpy(input, &output, sizeof(FilePathList));
}
void RAYLIBFN(UnloadDroppedFiles)(WrenVM* vm) { 
    auto input = WSCls(1, FilePathList);
    UnloadDroppedFiles(*input);
    input->count = 0;
}
void RAYLIBFN(GetFileModTime)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetFileModTime(WSString(1))); }

void RAYLIBFN(CompressData)(WrenVM* vm) { wrenSetSlotString(vm, 0, (const char*)CompressData((const unsigned char*)WSString(1), WSDouble(2), (int*)WSCls(3, Value)->data)); }
void RAYLIBFN(DecompressData)(WrenVM* vm) { wrenSetSlotString(vm, 0, (const char*)DecompressData((const unsigned char*)WSString(1), WSDouble(2), (int*)WSCls(3, Value)->data)); } 
void RAYLIBFN(EncodeDataBase64)(WrenVM* vm) { wrenSetSlotString(vm, 0, (const char*)EncodeDataBase64((const unsigned char*)WSString(1), WSDouble(2), (int*)WSCls(3, Value)->data)); } 
void RAYLIBFN(DecodeDataBase64)(WrenVM* vm) { wrenSetSlotString(vm, 0, (const char*)DecodeDataBase64((const unsigned char*)WSString(1), (int*)WSCls(2, Value)->data)); } 

void RAYLIBFN(LoadAutomationEventList)(WrenVM* vm) { } // TODO 
void RAYLIBFN(UnloadAutomationEventList)(WrenVM* vm) { } // TODO 
void RAYLIBFN(ExportAutomationEventList)(WrenVM* vm) { } // TODO 
void RAYLIBFN(SetAutomationEventList)(WrenVM* vm) { } // TODO 
void RAYLIBFN(SetAutomationEventBaseFrame)(WrenVM* vm) { } // TODO 
void RAYLIBFN(StartAutomationEventRecording)(WrenVM* vm) { } // TODO 
void RAYLIBFN(StopAutomationEventRecording)(WrenVM* vm) { } // TODO 
void RAYLIBFN(PlayAutomationEvent)(WrenVM* vm) { }

void RAYLIBFN(IsKeyPressed)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsKeyPressed(WSDouble(1))); }
void RAYLIBFN(IsKeyPressedRepeat)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsKeyPressedRepeat(WSDouble(1))); }
void RAYLIBFN(IsKeyDown)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsKeyDown(WSDouble(1))); }
void RAYLIBFN(IsKeyReleased)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsKeyReleased(WSDouble(1))); }
void RAYLIBFN(IsKeyUp)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsKeyUp(WSDouble(1))); }
void RAYLIBFN(GetKeyPressed)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetKeyPressed()); }
void RAYLIBFN(GetCharPressed)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetCharPressed()); }
void RAYLIBFN(SetExitKey)(WrenVM* vm) { SetExitKey(WSDouble(1)); }

void RAYLIBFN(IsGamepadAvailable)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsGamepadAvailable(WSDouble(1))); }
void RAYLIBFN(GetGamepadName)(WrenVM* vm) { wrenSetSlotString(vm, 0, GetGamepadName(WSDouble(1))); }
void RAYLIBFN(IsGamepadButtonPressed)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsGamepadButtonPressed(WSDouble(1), WSDouble(2))); }
void RAYLIBFN(IsGamepadButtonDown)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsGamepadButtonDown(WSDouble(1), WSDouble(2))); }
void RAYLIBFN(IsGamepadButtonReleased)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsGamepadButtonReleased(WSDouble(1), WSDouble(2))); }
void RAYLIBFN(IsGamepadButtonUp)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsGamepadButtonUp(WSDouble(1), WSDouble(2))); }
void RAYLIBFN(GetGamepadButtonPressed)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetGamepadButtonPressed()); } 
void RAYLIBFN(GetGamepadAxisCount)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetGamepadAxisCount(WSDouble(1))); } 
void RAYLIBFN(GetGamepadAxisMovement)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetGamepadAxisMovement(WSDouble(1), WSDouble(2))); }
void RAYLIBFN(SetGamepadMappings)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, SetGamepadMappings(WSString(1))); }

void RAYLIBFN(IsMouseButtonPressed)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsMouseButtonPressed(WSDouble(1))); }
void RAYLIBFN(IsMouseButtonDown)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsMouseButtonDown(WSDouble(1))); }
void RAYLIBFN(IsMouseButtonReleased)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsMouseButtonReleased(WSDouble(1))); }
void RAYLIBFN(IsMouseButtonUp)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsMouseButtonUp(WSDouble(1))); }
void RAYLIBFN(GetMouseX)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetMouseX()); }
void RAYLIBFN(GetMouseY)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetMouseY()); }
void RAYLIBFN(GetMousePosition)(WrenVM* vm) { 
    auto inv2 = WSCls(1, Vector2);
    auto out = GetMousePosition();
    memcpy(inv2, &out, sizeof(Vector2));
}
void RAYLIBFN(GetMouseDelta)(WrenVM* vm) { 
    auto inv2 = WSCls(1, Vector2);
    auto out = GetMouseDelta();
    memcpy(inv2, &out, sizeof(Vector2));
}
void RAYLIBFN(SetMousePosition)(WrenVM* vm) { SetMousePosition(WSDouble(1), WSDouble(2)); }
void RAYLIBFN(SetMouseOffset)(WrenVM* vm) { SetMouseOffset(WSDouble(1), WSDouble(2)); }
void RAYLIBFN(SetMouseScale)(WrenVM* vm) { SetMouseScale(WSDouble(1), WSDouble(2)); }
void RAYLIBFN(GetMouseWheelMove)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetMouseWheelMove()); }
void RAYLIBFN(GetMouseWheelMoveV)(WrenVM* vm) {  
    auto inv2 = WSCls(1, Vector2);
    auto out = GetMouseWheelMoveV();
    memcpy(inv2, &out, sizeof(Vector2));
}
void RAYLIBFN(SetMouseCursor)(WrenVM* vm) { SetMouseCursor(WSDouble(1)); }

void RAYLIBFN(GetTouchX)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetTouchX()); }
void RAYLIBFN(GetTouchY)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetTouchY()); }
void RAYLIBFN(GetTouchPosition)(WrenVM* vm) { 
    auto input = WSCls(1, Vector2);
    auto output = GetTouchPosition(WSDouble(2));
    memcpy(input, &output, sizeof(Vector2));
}
void RAYLIBFN(GetTouchPointId)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetTouchPointId(WSDouble(1))); }
void RAYLIBFN(GetTouchPointCount)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetTouchPointCount()); }

void RAYLIBFN(SetGesturesEnabled)(WrenVM* vm) { SetGesturesEnabled(WSDouble(1)); }
void RAYLIBFN(IsGestureDetected)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, IsGestureDetected(WSDouble(1))); }
void RAYLIBFN(GetGestureDetected)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetGestureDetected()); }
void RAYLIBFN(GetGestureHoldDuration)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetGestureHoldDuration()); }
void RAYLIBFN(GetGestureDragVector)(WrenVM* vm) { 
    auto input = WSCls(1, Vector2);
    auto output = GetGestureDragVector();
    memcpy(input, &output, sizeof(Vector2));
} 
void RAYLIBFN(GetGestureDragAngle)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetGestureDragAngle()); }
void RAYLIBFN(GetGesturePinchVector)(WrenVM* vm) { 
    auto input = WSCls(1, Vector2);
    auto output = GetGesturePinchVector();
    memcpy(input, &output, sizeof(Vector2));
}
void RAYLIBFN(GetGesturePinchAngle)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetGesturePinchAngle()); }

void RAYLIBFN(UpdateCamera)(WrenVM* vm) { UpdateCamera(WSCls(1, Camera), WSDouble(2)); }
void RAYLIBFN(UpdateCameraPro)(WrenVM* vm) { UpdateCameraPro(WSCls(1, Camera), *WSCls(2, Vector3), *WSCls(3, Vector3), WSDouble(4)); }

void RAYLIBFN(SetShapesTexture)(WrenVM* vm) { SetShapesTexture(*WSCls(1, Texture2D), *WSCls(2, Rectangle)); }

void RAYLIBFN(DrawPixel)(WrenVM* vm) { DrawPixel(WSDouble(1), WSDouble(2), *WSCls(3, Color)); }
void RAYLIBFN(DrawPixelV)(WrenVM* vm) { DrawPixelV(*WSCls(1, Vector2), *WSCls(2, Color)); }
void RAYLIBFN(DrawLine)(WrenVM* vm) { DrawLine(WSDouble(1), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawLineV)(WrenVM* vm) { DrawLineV(*WSCls(1, Vector2), *WSCls(2, Vector2), *WSCls(3, Color)); }
void RAYLIBFN(DrawLineEx)(WrenVM* vm) { DrawLineEx(*WSCls(1, Vector2), *WSCls(2, Vector2), WSDouble(3), *WSCls(4, Color)); }
void RAYLIBFN(DrawLineStrip)(WrenVM* vm) { DrawLineStrip((Vector2*)WSCls(1, ValueList)->data, WSDouble(2), *WSCls(3, Color)); } 
void RAYLIBFN(DrawLineBezier)(WrenVM* vm) { DrawLineBezier(*WSCls(1, Vector2), *WSCls(2, Vector2), WSDouble(3), *WSCls(4, Color)); }
void RAYLIBFN(DrawCircle)(WrenVM* vm) { DrawCircle(WSDouble(1), WSDouble(2), WSDouble(3), *WSCls(4, Color)); }
void RAYLIBFN(DrawCircleSector)(WrenVM* vm) { DrawCircleSector(*WSCls(1, Vector2), WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5), *WSCls(6, Color)); }
void RAYLIBFN(DrawCircleSectorLines)(WrenVM* vm) { DrawCircleSectorLines(*WSCls(1, Vector2), WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5), *WSCls(6, Color)); }
void RAYLIBFN(DrawCircleGradient)(WrenVM* vm) { DrawCircleGradient(WSDouble(1), WSDouble(2), WSDouble(3), *WSCls(4, Color), *WSCls(5, Color)); }
void RAYLIBFN(DrawCircleV)(WrenVM* vm) { DrawCircleV(*WSCls(1, Vector2), WSDouble(2), *WSCls(3, Color)); }
void RAYLIBFN(DrawCircleLines)(WrenVM* vm) { DrawCircleLines(WSDouble(1), WSDouble(2), WSDouble(3), *WSCls(4, Color)); }
void RAYLIBFN(DrawCircleLinesV)(WrenVM* vm) { DrawCircleLinesV(*WSCls(1, Vector2), WSDouble(2), *WSCls(3, Color)); }
void RAYLIBFN(DrawEllipse)(WrenVM* vm) { DrawEllipse(WSDouble(1), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawEllipseLines)(WrenVM* vm) { DrawEllipseLines(WSDouble(1), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawRing)(WrenVM* vm) { DrawRing(*WSCls(1, Vector2), WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5), WSDouble(6), *WSCls(7, Color)); }
void RAYLIBFN(DrawRingLines)(WrenVM* vm) { DrawRingLines(*WSCls(1, Vector2), WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5), WSDouble(6), *WSCls(7, Color)); }
void RAYLIBFN(DrawRectangle)(WrenVM* vm) { DrawRectangle(WSDouble(1), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawRectangleV)(WrenVM* vm) { DrawRectangleV(*WSCls(1, Vector2), *WSCls(2, Vector2), *WSCls(3, Color)); }
void RAYLIBFN(DrawRectangleRec)(WrenVM* vm) { DrawRectangleRec(*WSCls(1, Rectangle), *WSCls(2, Color)); }
void RAYLIBFN(DrawRectanglePro)(WrenVM* vm) { DrawRectanglePro(*WSCls(1, Rectangle), *WSCls(2, Vector2), WSDouble(3), *WSCls(4, Color)); }
void RAYLIBFN(DrawRectangleGradientV)(WrenVM* vm) { DrawRectangleGradientV(WSDouble(1), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color), *WSCls(6, Color)); }
void RAYLIBFN(DrawRectangleGradientH)(WrenVM* vm) { DrawRectangleGradientH(WSDouble(1), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color), *WSCls(6, Color)); }
void RAYLIBFN(DrawRectangleGradientEx)(WrenVM* vm) { DrawRectangleGradientEx(*WSCls(1, Rectangle), *WSCls(2, Color), *WSCls(3, Color), *WSCls(4, Color), *WSCls(5, Color)); }
void RAYLIBFN(DrawRectangleLines)(WrenVM* vm) { DrawRectangleLines(WSDouble(1), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawRectangleLinesEx)(WrenVM* vm) { DrawRectangleLinesEx(*WSCls(1, Rectangle), WSDouble(2), *WSCls(3, Color)); }
void RAYLIBFN(DrawRectangleRounded)(WrenVM* vm) { DrawRectangleRounded(*WSCls(1, Rectangle), WSDouble(2), WSDouble(3), *WSCls(4, Color)); }
void RAYLIBFN(DrawRectangleRoundedLines)(WrenVM* vm) { DrawRectangleRoundedLines(*WSCls(1, Rectangle), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawTriangle)(WrenVM* vm) { DrawTriangle(*WSCls(1, Vector2), *WSCls(2, Vector2), *WSCls(3, Vector2), *WSCls(4, Color)); }
void RAYLIBFN(DrawTriangleLines)(WrenVM* vm) { DrawTriangleLines(*WSCls(1, Vector2), *WSCls(2, Vector2), *WSCls(3, Vector2), *WSCls(4, Color)); } 
void RAYLIBFN(DrawTriangleFan)(WrenVM* vm) { DrawTriangleFan((Vector2*)WSCls(1, ValueList)->data, WSDouble(2), *WSCls(3, Color)); }
void RAYLIBFN(DrawTriangleStrip)(WrenVM* vm) { DrawTriangleStrip((Vector2*)WSCls(1, ValueList)->data, WSDouble(2), *WSCls(3, Color)); } 
void RAYLIBFN(DrawPoly)(WrenVM* vm) { DrawPoly(*WSCls(1, Vector2), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawPolyLines)(WrenVM* vm) { DrawPolyLines(*WSCls(1, Vector2), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawPolyLinesEx)(WrenVM* vm) { DrawPolyLinesEx(*WSCls(1, Vector2), WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5), *WSCls(6, Color)); }

void RAYLIBFN(DrawSplineLinear)(WrenVM* vm) { DrawSplineLinear((Vector2*)WSCls(1, ValueList)->data, WSDouble(2), WSDouble(3), *WSCls(4, Color)); } 
void RAYLIBFN(DrawSplineBasis)(WrenVM* vm) { DrawSplineBasis((Vector2*)WSCls(1, ValueList)->data, WSDouble(2), WSDouble(3), *WSCls(4, Color)); } 
void RAYLIBFN(DrawSplineCatmullRom)(WrenVM* vm) { DrawSplineCatmullRom((Vector2*)WSCls(1, ValueList)->data, WSDouble(2), WSDouble(3), *WSCls(4, Color)); } 
void RAYLIBFN(DrawSplineBezierQuadratic)(WrenVM* vm) { DrawSplineBezierQuadratic((Vector2*)WSCls(1, ValueList)->data, WSDouble(2), WSDouble(3), *WSCls(4, Color)); } 
void RAYLIBFN(DrawSplineBezierCubic)(WrenVM* vm) { DrawSplineBezierCubic((Vector2*)WSCls(1, ValueList)->data, WSDouble(2), WSDouble(3), *WSCls(4, Color)); } 
void RAYLIBFN(DrawSplineSegmentLinear)(WrenVM* vm) { DrawSplineSegmentLinear(*WSCls(1, Vector2), *WSCls(2, Vector2), WSDouble(3), *WSCls(4, Color)); }
void RAYLIBFN(DrawSplineSegmentBasis)(WrenVM* vm) { DrawSplineSegmentBasis(*WSCls(1, Vector2), *WSCls(2, Vector2), *WSCls(3, Vector2), *WSCls(4, Vector2), WSDouble(5), *WSCls(6, Color)); }
void RAYLIBFN(DrawSplineSegmentCatmullRom)(WrenVM* vm) { DrawSplineSegmentCatmullRom(*WSCls(1, Vector2), *WSCls(2, Vector2), *WSCls(3, Vector2), *WSCls(4, Vector2), WSDouble(5), *WSCls(6, Color)); }
void RAYLIBFN(DrawSplineSegmentBezierQuadratic)(WrenVM* vm) { DrawSplineSegmentBezierQuadratic(*WSCls(1, Vector2), *WSCls(2, Vector2), *WSCls(3, Vector2), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawSplineSegmentBezierCubic)(WrenVM* vm) { DrawSplineSegmentBezierCubic(*WSCls(1, Vector2), *WSCls(2, Vector2), *WSCls(3, Vector2), *WSCls(4, Vector2), WSDouble(5), *WSCls(6, Color)); }

void RAYLIBFN(GetSplinePointLinear)(WrenVM* vm) { *WSCls(1, Vector2) = GetSplinePointLinear(*WSCls(2, Vector2), *WSCls(3, Vector2), WSDouble(4)); } 
void RAYLIBFN(GetSplinePointBasis)(WrenVM* vm) { *WSCls(1, Vector2) = GetSplinePointBasis(*WSCls(2, Vector2), *WSCls(3, Vector2), *WSCls(4, Vector2), *WSCls(5, Vector2), WSDouble(6)); } 
void RAYLIBFN(GetSplinePointCatmullRom)(WrenVM* vm) { *WSCls(1, Vector2) = GetSplinePointCatmullRom(*WSCls(2, Vector2), *WSCls(3, Vector2), *WSCls(4, Vector2), *WSCls(5, Vector2), WSDouble(6)); }
void RAYLIBFN(GetSplinePointBezierQuad)(WrenVM* vm) { *WSCls(1, Vector2) = GetSplinePointBezierQuad(*WSCls(2, Vector2), *WSCls(3, Vector2), *WSCls(4, Vector2), WSDouble(5)); }
void RAYLIBFN(GetSplinePointBezierCubic)(WrenVM* vm) { *WSCls(1, Vector2) = GetSplinePointBezierCubic(*WSCls(2, Vector2), *WSCls(3, Vector2), *WSCls(4, Vector2), *WSCls(5, Vector2), WSDouble(6)); } 

void RAYLIBFN(CheckCollisionRecs)(WrenVM* vm) { wrenSetSlotBool(vm, 0, CheckCollisionRecs(*WSCls(1, Rectangle), *WSCls(2, Rectangle))); }
void RAYLIBFN(CheckCollisionCircles)(WrenVM* vm) { wrenSetSlotBool(vm, 0, CheckCollisionCircles(*WSCls(1, Vector2), WSDouble(2), *WSCls(3, Vector2), WSDouble(4))); } 
void RAYLIBFN(CheckCollisionCircleRec)(WrenVM* vm) { wrenSetSlotBool(vm, 0, CheckCollisionCircleRec(*WSCls(1, Vector2), WSDouble(2), *WSCls(3, Rectangle))); }
void RAYLIBFN(CheckCollisionPointRec)(WrenVM* vm) { wrenSetSlotBool(vm, 0, CheckCollisionPointRec(*WSCls(1, Vector2), *WSCls(2, Rectangle))); } 
void RAYLIBFN(CheckCollisionPointCircle)(WrenVM* vm) { wrenSetSlotBool(vm, 0, CheckCollisionPointCircle(*WSCls(1, Vector2), *WSCls(2, Vector2), WSDouble(3))); } 
void RAYLIBFN(CheckCollisionPointTriangle)(WrenVM* vm) { wrenSetSlotBool(vm, 0, CheckCollisionPointTriangle(*WSCls(1, Vector2), *WSCls(2, Vector2), *WSCls(3, Vector2), *WSCls(4, Vector2))); }
void RAYLIBFN(CheckCollisionPointPoly)(WrenVM* vm) { wrenSetSlotBool(vm, 0, CheckCollisionPointPoly(*WSCls(1, Vector2), (Vector2*)WSCls(2, ValueList)->data, WSDouble(3))); } 
void RAYLIBFN(CheckCollisionLines)(WrenVM* vm) { wrenSetSlotBool(vm, 0, CheckCollisionLines(*WSCls(1, Vector2), *WSCls(2, Vector2), *WSCls(3, Vector2), *WSCls(4, Vector2), (Vector2*)WSCls(5, Value)->data)); }
void RAYLIBFN(CheckCollisionPointLine)(WrenVM* vm) { wrenSetSlotBool(vm, 0, CheckCollisionPointLine(*WSCls(1, Vector2), *WSCls(2, Vector2), *WSCls(3, Vector2), WSDouble(4))); } 
void RAYLIBFN(GetCollisionRec)(WrenVM* vm) { *WSCls(1, Rectangle) = GetCollisionRec(*WSCls(2, Rectangle), *WSCls(3, Rectangle)); } 

void RAYLIBFN(LoadImage)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    auto output = LoadImage(WSString(2));
    LOG_F(INFO, "[raylib] loading image %s: <%d %d> ", WSString(2), output.width, output.height);
    input->data = output.data;
    memcpy(input, &output, sizeof(Image));
}
void RAYLIBFN(LoadImageRaw)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    auto output = LoadImageRaw(WSString(2), WSDouble(3), WSDouble(4), WSDouble(5), WSDouble(6));
    memcpy(input, &output, sizeof(Image));
}
void RAYLIBFN(LoadImageSvg)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    auto output = LoadImageSvg(WSString(2), WSDouble(3), WSDouble(4));
    memcpy(input, &output, sizeof(Image));
}
void RAYLIBFN(LoadImageAnim)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    int frames;
    auto output = LoadImageAnim(WSString(2), &frames);
    memcpy(input, &output, sizeof(Image));
    wrenSetSlotDouble(vm, 3, frames);
}
void RAYLIBFN(LoadImageFromMemory)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    auto output = LoadImageFromMemory(WSString(2), (const unsigned char*)WSString(3), WSDouble(4));
    memcpy(input, &output, sizeof(Image));
}
void RAYLIBFN(LoadImageFromTexture)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    auto output = LoadImageFromTexture(*WSCls(2, Texture2D));
    memcpy(input, &output, sizeof(Image));
}
void RAYLIBFN(LoadImageFromScreen)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    auto output = LoadImageFromScreen();
    memcpy(input, &output, sizeof(Image));
}
void RAYLIBFN(IsImageReady)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsImageReady(*WSCls(1, Image))); }
void RAYLIBFN(UnloadImage)(WrenVM* vm) { UnloadImage(*WSCls(1, Image)); }
void RAYLIBFN(ExportImage)(WrenVM* vm) { ExportImage(*WSCls(1, Image), WSString(2)); }
void RAYLIBFN(ExportImageToMemory)(WrenVM* vm) { 
    int fileSize;
    auto data = ExportImageToMemory(*WSCls(1, Image), WSString(2), &fileSize);
    wrenSetSlotString(vm, 0, (const char*)data);
    wrenSetSlotDouble(vm, 2, fileSize);
} 
void RAYLIBFN(ExportImageAsCode)(WrenVM* vm) { wrenSetSlotBool(vm, 0, ExportImageAsCode(*WSCls(1, Image), WSString(2))); } 

void RAYLIBFN(GenImageColor)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    *input = GenImageColor(WSDouble(2), WSDouble(3), *WSCls(4, Color));
}
void RAYLIBFN(GenImageGradientLinear)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    *input = GenImageGradientLinear(WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color), *WSCls(6, Color));
}
void RAYLIBFN(GenImageGradientRadial)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    *input = GenImageGradientRadial(WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color), *WSCls(6, Color));
}
void RAYLIBFN(GenImageGradientSquare)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    *input = GenImageGradientSquare(WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color), *WSCls(6, Color));
}
void RAYLIBFN(GenImageChecked)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    *input = GenImageChecked(WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5), *WSCls(6, Color), *WSCls(7, Color));
} 
void RAYLIBFN(GenImageWhiteNoise)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    *input = GenImageWhiteNoise(WSDouble(2), WSDouble(3), WSDouble(4));
}
void RAYLIBFN(GenImagePerlinNoise)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    *input = GenImagePerlinNoise(WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5), WSDouble(6));
}
void RAYLIBFN(GenImageCellular)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    *input = GenImageCellular(WSDouble(2), WSDouble(3), WSDouble(4));
}
void RAYLIBFN(GenImageText)(WrenVM* vm) {
    auto input = WSCls(1, Image);
    *input = GenImageText(WSDouble(2), WSDouble(3), WSString(4));
}

void RAYLIBFN(ImageCopy)(WrenVM* vm) { *WSCls(1, Image) = ImageCopy(*WSCls(2, Image)); } 
void RAYLIBFN(ImageFromImage)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageText)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageTextEx)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageFormat)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageToPOT)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageCrop)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageAlphaCrop)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageAlphaClear)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageAlphaMask)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageAlphaPremultiply)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageBlurGaussian)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageKernelConvolution)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageResize)(WrenVM* vm) {
    auto img = WSCls(1, Image);
    int w = WSDouble(2);
    int h = WSDouble(3);
    ImageResize(img, w, h);
} // TODO 
void RAYLIBFN(ImageResizeNN)(WrenVM* vm) {
    auto img = WSCls(1, Image);
    int w = WSDouble(2);
    int h = WSDouble(3);
    ImageResizeNN(img, w, h);
} // TODO 
void RAYLIBFN(ImageResizeCanvas)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageMipmaps)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageDither)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageFlipVertical)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageFlipHorizontal)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageRotate)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageRotateCW)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageRotateCCW)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageColorTint)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageColorInvert)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageColorGrayscale)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageColorContrast)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageColorBrightness)(WrenVM* vm) {} // TODO 
void RAYLIBFN(ImageColorReplace)(WrenVM* vm) {} // TODO 
void RAYLIBFN(LoadImageColors)(WrenVM* vm) {} // TODO 
void RAYLIBFN(LoadImagePalette)(WrenVM* vm) {} // TODO 
void RAYLIBFN(UnloadImageColors)(WrenVM* vm) {} // TODO 
void RAYLIBFN(UnloadImagePalette)(WrenVM* vm) {} // TODO 
void RAYLIBFN(GetImageAlphaBorder)(WrenVM* vm) {} // TODO 
void RAYLIBFN(GetImageColor)(WrenVM* vm) { 
    auto input = WSCls(1, Color);
    auto img = WSCls(2, Image);
    auto c = GetImageColor(*img, WSDouble(3), WSDouble(4));
    memcpy(input, &c, sizeof(Color));
} // TODO 

void RAYLIBFN(ImageClearBackground)(WrenVM* vm) { ImageClearBackground(WSCls(1, Image), *WSCls(2, Color)); }  
void RAYLIBFN(ImageDrawPixel)(WrenVM* vm) { ImageDrawPixel(WSCls(1, Image), WSDouble(2), WSDouble(3), *WSCls(4, Color)); } 
void RAYLIBFN(ImageDrawPixelV)(WrenVM* vm) { ImageDrawPixelV(WSCls(1, Image), *WSCls(2, Vector2), *WSCls(3, Color)); } 
void RAYLIBFN(ImageDrawLine)(WrenVM* vm) { ImageDrawLine(WSCls(1, Image), WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5), *WSCls(6, Color)); } 
void RAYLIBFN(ImageDrawLineV)(WrenVM* vm) { ImageDrawLineV(WSCls(1, Image), *WSCls(2, Vector2), *WSCls(3, Vector2), *WSCls(4, Color)); }
void RAYLIBFN(ImageDrawCircle)(WrenVM* vm) { ImageDrawCircle(WSCls(1, Image), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); } 
void RAYLIBFN(ImageDrawCircleV)(WrenVM* vm) { ImageDrawCircleV(WSCls(1, Image), *WSCls(2, Vector2), WSDouble(3), *WSCls(4, Color)); } 
void RAYLIBFN(ImageDrawCircleLines)(WrenVM* vm) { ImageDrawCircleLines(WSCls(1, Image), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); } 
void RAYLIBFN(ImageDrawCircleLinesV)(WrenVM* vm) { ImageDrawCircleLinesV(WSCls(1, Image), *WSCls(2, Vector2), WSDouble(3), *WSCls(4, Color)); } 
void RAYLIBFN(ImageDrawRectangle)(WrenVM* vm) { ImageDrawRectangle(WSCls(1, Image), WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5), *WSCls(6, Color)); } 
void RAYLIBFN(ImageDrawRectangleV)(WrenVM* vm) { ImageDrawRectangleV(WSCls(1, Image), *WSCls(2, Vector2), *WSCls(3, Vector2), *WSCls(4, Color)); }
void RAYLIBFN(ImageDrawRectangleRec)(WrenVM* vm) { ImageDrawRectangleRec(WSCls(1, Image), *WSCls(2, Rectangle), *WSCls(3, Color)); }
void RAYLIBFN(ImageDrawRectangleLines)(WrenVM* vm) { ImageDrawRectangleLines(WSCls(1, Image), *WSCls(2, Rectangle), WSDouble(3), *WSCls(4, Color)); } 
void RAYLIBFN(ImageDraw)(WrenVM* vm) { ImageDraw(WSCls(1, Image), *WSCls(2, Image), *WSCls(3, Rectangle), *WSCls(4, Rectangle), *WSCls(5, Color)); } 
void RAYLIBFN(ImageDrawText)(WrenVM* vm) { ImageDrawText(WSCls(1, Image), WSString(2), WSDouble(3), WSDouble(4), WSDouble(5), *WSCls(6, Color)); }  
void RAYLIBFN(ImageDrawTextEx)(WrenVM* vm) { ImageDrawTextEx(WSCls(1, Image), *WSCls(2, Font), WSString(3), *WSCls(4, Vector2), WSDouble(5), WSDouble(6), *WSCls(7, Color)); } 

void RAYLIBFN(LoadTexture)(WrenVM* vm) {
    auto input = WSCls(1, Texture2D);
    auto output = LoadTexture(WSString(2));
    memcpy(input, &output, sizeof(Texture2D));
}
void RAYLIBFN(LoadTextureFromImage)(WrenVM* vm) {
    auto input = WSCls(1, Texture2D);
    auto output = LoadTextureFromImage(*WSCls(2, Image));
    memcpy(input, &output, sizeof(Texture2D));
}
void RAYLIBFN(LoadTextureCubemap)(WrenVM* vm) {
    auto input = WSCls(1, TextureCubemap);
    auto output = LoadTextureCubemap(*WSCls(2, Image), WSDouble(3));
    memcpy(input, &output, sizeof(TextureCubemap));
}
void RAYLIBFN(LoadRenderTexture)(WrenVM* vm) {
    auto input = WSCls(1, RenderTexture2D);
    auto output = LoadRenderTexture(WSDouble(2), WSDouble(3));
    memcpy(input, &output, sizeof(RenderTexture2D));
}
void RAYLIBFN(IsTextureReady)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsTextureReady(*WSCls(1, Texture2D))); }
void RAYLIBFN(UnloadTexture)(WrenVM* vm) { UnloadTexture(*WSCls(1, Texture2D)); }
void RAYLIBFN(IsRenderTextureReady)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsRenderTextureReady(*WSCls(1, RenderTexture2D))); }
void RAYLIBFN(UnloadRenderTexture)(WrenVM* vm) { UnloadRenderTexture(*WSCls(1, RenderTexture2D)); }
void RAYLIBFN(UpdateTexture)(WrenVM* vm) {} // TODO 
void RAYLIBFN(UpdateTextureRec)(WrenVM* vm) {} // TODO 

void RAYLIBFN(GenTextureMipmaps)(WrenVM* vm) { GenTextureMipmaps(WSCls(1, Texture2D)); }
void RAYLIBFN(SetTextureFilter)(WrenVM* vm) { SetTextureFilter(*WSCls(1, Texture2D), WSDouble(2)); }
void RAYLIBFN(SetTextureWrap)(WrenVM* vm) { SetTextureWrap(*WSCls(1, Texture2D), WSDouble(2)); }

void RAYLIBFN(DrawTexture)(WrenVM* vm) { DrawTexture(*WSCls(1, Texture2D), WSDouble(2), WSDouble(3), *WSCls(4, Color)); }
void RAYLIBFN(DrawTextureV)(WrenVM* vm) { DrawTextureV(*WSCls(1, Texture2D), *WSCls(2, Vector2), *WSCls(3, Color)); }
void RAYLIBFN(DrawTextureEx)(WrenVM* vm) { DrawTextureEx(*WSCls(1, Texture2D), *WSCls(2, Vector2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawTextureRec)(WrenVM* vm) { DrawTextureRec(*WSCls(1, Texture2D), *WSCls(2, Rectangle), *WSCls(3, Vector2), *WSCls(4, Color)); }
void RAYLIBFN(DrawTexturePro)(WrenVM* vm) { DrawTexturePro(*WSCls(1, Texture2D), *WSCls(2, Rectangle), *WSCls(3, Rectangle), *WSCls(4, Vector2), WSDouble(5), *WSCls(6, Color)); }
void RAYLIBFN(DrawTextureNPatch)(WrenVM* vm) { DrawTextureNPatch(*WSCls(1, Texture2D), *WSCls(2, NPatchInfo), *WSCls(3, Rectangle), *WSCls(4, Vector2), WSDouble(5), *WSCls(6, Color)); }

void RAYLIBFN(Fade)(WrenVM* vm) { *WSCls(1, Color) = Fade(*WSCls(2, Color), WSDouble(3)); } 
void RAYLIBFN(ColorToInt)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, (ColorToInt(*WSCls(1, Color)))); }
void RAYLIBFN(ColorNormalize)(WrenVM* vm) { *WSCls(1, Vector4) = ColorNormalize(*WSCls(2, Color)); }
void RAYLIBFN(ColorFromNormalized)(WrenVM* vm) { *WSCls(1, Color) = ColorFromNormalized(*WSCls(2, Vector4)); }
void RAYLIBFN(ColorToHSV)(WrenVM* vm) { *WSCls(1, Vector3) = ColorToHSV(*WSCls(2, Color)); }
void RAYLIBFN(ColorFromHSV)(WrenVM* vm) { *WSCls(1, Color) = ColorFromHSV(WSDouble(2), WSDouble(3), WSDouble(4)); } 
void RAYLIBFN(ColorTint)(WrenVM* vm) { *WSCls(1, Color) = ColorTint(*WSCls(2, Color), *WSCls(3, Color)); } 
void RAYLIBFN(ColorBrightness)(WrenVM* vm) { *WSCls(1, Color) = ColorBrightness(*WSCls(2, Color),  WSDouble(3)); }  
void RAYLIBFN(ColorContrast)(WrenVM* vm) { *WSCls(1, Color) = ColorContrast(*WSCls(2, Color),  WSDouble(3)); }
void RAYLIBFN(ColorAlpha)(WrenVM* vm) { *WSCls(1, Color) = ColorAlpha(*WSCls(2, Color),  WSDouble(3)); } 
void RAYLIBFN(ColorAlphaBlend)(WrenVM* vm) { *WSCls(1, Color) = ColorAlphaBlend(*WSCls(2, Color),  *WSCls(3, Color), *WSCls(4, Color)); } 
void RAYLIBFN(GetColor)(WrenVM* vm) { *WSCls(1, Color) = GetColor(WSDouble(2)); } 
void RAYLIBFN(GetPixelColor)(WrenVM* vm) {} // TODO 
void RAYLIBFN(SetPixelColor)(WrenVM* vm) {} // TODO 
void RAYLIBFN(GetPixelDataSize)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetPixelDataSize(WSDouble(1), WSDouble(2), WSDouble(3))); } 


void RAYLIBFN(GetFontDefault)(WrenVM* vm) {
    auto input = WSCls(1, Font);
    auto output = GetFontDefault();
    memcpy(input, &output, sizeof(Font));
}
void RAYLIBFN(LoadFont)(WrenVM* vm) {
    auto input = WSCls(1, Font);
    std::vector<int> codepoints;
    // ascii
    for(int i = 0 ; i < 128; i++ ) {codepoints.push_back(i);}
    // 中文
    for(int i = 0x4e00; i < 0x9fa5; i++) { codepoints.push_back(i); }
    // 韩文
    for(int i = 0x3130; i < 0x318f; i++) { codepoints.push_back(i); }
    // 日文
    for(int i = 0x0800; i < 0x4e00; i++) { codepoints.push_back(i); } 

    // emoj
    for(int i = 0x231a; i < 0x3299; i++) { codepoints.push_back(i); } 
    for(int i = 0x1F004; i < 0x1F9E6; i++) { codepoints.push_back(i); } 

    auto output = LoadFontEx(WSString(2), 32, codepoints.data(), codepoints.size());
    memcpy(input, &output, sizeof(Font));
}
void RAYLIBFN(LoadFontEx)(WrenVM* vm) {
    auto cp = WSCls(4, ValueList);
    auto fnt = WSCls(1, Font);
    *fnt = LoadFontEx(WSString(2), WSDouble(3), (int*)cp->data, cp->count);
} // TODO
void RAYLIBFN(LoadFontFromImage)(WrenVM* vm) {} // TODO
void RAYLIBFN(LoadFontFromMemory)(WrenVM* vm) {} // TODO
void RAYLIBFN(IsFontReady)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsFontReady(*WSCls(1, Font))); }
void RAYLIBFN(LoadFontData)(WrenVM* vm) {} // TODO
void RAYLIBFN(GenImageFontAtlas)(WrenVM* vm) {} // TODO
void RAYLIBFN(UnloadFontData)(WrenVM* vm) {} // TODO
void RAYLIBFN(UnloadFont)(WrenVM* vm) { UnloadFont(*WSCls(1, Font)); }
void RAYLIBFN(ExportFontAsCode)(WrenVM* vm) {} // TODO

void RAYLIBFN(DrawFPS)(WrenVM* vm) { DrawFPS(WSDouble(1), WSDouble(2)); }
void RAYLIBFN(DrawText)(WrenVM* vm) { DrawText(WSString(1), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawTextEx)(WrenVM* vm) { DrawTextEx(*WSCls(1, Font), WSString(2), *WSCls(3, Vector2), WSDouble(4), WSDouble(5), *WSCls(6, Color)); } 
void RAYLIBFN(DrawTextPro)(WrenVM* vm) { DrawTextPro(*WSCls(1, Font), WSString(2), *WSCls(3, Vector2), *WSCls(4, Vector2), WSDouble(5), WSDouble(6), WSDouble(7), *WSCls(8, Color)); } 
void RAYLIBFN(DrawTextCodepoint)(WrenVM* vm) {} // TODO
void RAYLIBFN(DrawTextCodepoints)(WrenVM* vm) {} // TODO

void RAYLIBFN(SetTextLineSpacing)(WrenVM* vm) { SetTextLineSpacing(WSDouble(1)); }
void RAYLIBFN(MeasureText)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, MeasureText(WSString(1), WSDouble(2))); }
void RAYLIBFN(MeasureTextEx)(WrenVM* vm) { *WSCls(1, Vector2) = MeasureTextEx(*WSCls(2, Font), WSString(3), WSDouble(4), WSDouble(5)); }
void RAYLIBFN(GetGlyphIndex)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetGlyphIndex(*WSCls(1, Font), WSDouble(2))); }
void RAYLIBFN(GetGlyphInfo)(WrenVM* vm) { *WSCls(1, GlyphInfo) = GetGlyphInfo(*WSCls(2, Font), WSDouble(3)); }
void RAYLIBFN(GetGlyphAtlasRec)(WrenVM* vm) { *WSCls(1, Rectangle) = GetGlyphAtlasRec(*WSCls(2, Font), WSDouble(3)); } 

void RAYLIBFN(LoadUTF8)(WrenVM* vm) { wrenSetSlotString(vm, 0, LoadUTF8((int*)WSCls(1, ValueList)->data, WSDouble(2))); }
void RAYLIBFN(UnloadUTF8)(WrenVM* vm) { UnloadUTF8((char*)WSString(1)); } 
void RAYLIBFN(LoadCodepoints)(WrenVM* vm) { 
    auto vlist = WSCls(1, ValueList);
    vlist->valueType = 28;
    int cnt = 0;
    vlist->data = LoadCodepoints(WSString(2), &cnt);
    vlist->count = cnt;
}
void RAYLIBFN(UnloadCodepoints)(WrenVM* vm) { UnloadCodepoints((int*)WSCls(1, ValueList)->data); WSCls(1, ValueList)->count = 0; }
void RAYLIBFN(GetCodepointCount)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, GetCodepointCount(WSString(1))); }
void RAYLIBFN(GetCodepoint)(WrenVM* vm) {
    int cnt = 0;
    wrenSetSlotDouble(vm, 0, GetCodepoint(WSString(1), &cnt));
    wrenSetSlotDouble(vm, 2, cnt);
}
void RAYLIBFN(GetCodepointNext)(WrenVM* vm) {
    int cnt = 0;
    wrenSetSlotDouble(vm, 0, GetCodepointNext(WSString(1), &cnt));
    wrenSetSlotDouble(vm, 2, cnt);
}
void RAYLIBFN(GetCodepointPrevious)(WrenVM* vm) {
    int cnt = 0;
    wrenSetSlotDouble(vm, 0, GetCodepointPrevious(WSString(1), &cnt));
    wrenSetSlotDouble(vm, 2, cnt);
}
void RAYLIBFN(CodepointToUTF8)(WrenVM* vm) {
    int cnt = 0;
    wrenSetSlotString(vm, 0, CodepointToUTF8(WSDouble(1), &cnt));
    wrenSetSlotDouble(vm, 2, cnt);
}

void RAYLIBFN(TextCopy)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, TextCopy((char*)WSString(1), WSString(2))); }
void RAYLIBFN(TextIsEqual)(WrenVM* vm) { wrenSetSlotBool(vm, 0, TextIsEqual((char*)WSString(1), WSString(2))); }
void RAYLIBFN(TextLength)(WrenVM* vm) { wrenSetSlotDouble(vm, 0, TextLength(WSString(1))); } 
void RAYLIBFN(TextFormat)(WrenVM* vm) {} 
void RAYLIBFN(TextSubtext)(WrenVM* vm) {} 
void RAYLIBFN(TextReplace)(WrenVM* vm) {} 
void RAYLIBFN(TextInsert)(WrenVM* vm) {} 
void RAYLIBFN(TextJoin)(WrenVM* vm) {} 
void RAYLIBFN(TextSplit)(WrenVM* vm) {}
void RAYLIBFN(TextAppend)(WrenVM* vm) {} 
void RAYLIBFN(TextFindIndex)(WrenVM* vm) {} 
void RAYLIBFN(TextToUpper)(WrenVM* vm) {} 
void RAYLIBFN(TextToLower)(WrenVM* vm) {} 
void RAYLIBFN(TextToPascal)(WrenVM* vm) {} 
void RAYLIBFN(TextToInteger)(WrenVM* vm) {}

void RAYLIBFN(DrawLine3D)(WrenVM* vm) { DrawLine3D(*WSCls(1, Vector3), *WSCls(2, Vector3), *WSCls(3, Color)); }
void RAYLIBFN(DrawPoint3D)(WrenVM* vm) { DrawPoint3D(*WSCls(1, Vector3), *WSCls(2, Color)); }
void RAYLIBFN(DrawCircle3D)(WrenVM* vm) { DrawCircle3D(*WSCls(1, Vector3), WSDouble(2), *WSCls(3, Vector3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawTriangle3D)(WrenVM* vm) { DrawTriangle3D(*WSCls(1, Vector3), *WSCls(2, Vector3), *WSCls(3, Vector3), *WSCls(4, Color)); }
void RAYLIBFN(DrawTriangleStrip3D)(WrenVM* vm) { DrawTriangleStrip3D((Vector3*)WSCls(1, ValueList)->data, WSDouble(2), *WSCls(3, Color)); }
void RAYLIBFN(DrawCube)(WrenVM* vm) { DrawCube(*WSCls(1, Vector3), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawCubeV)(WrenVM* vm) { DrawCubeV(*WSCls(1, Vector3), *WSCls(2, Vector3), *WSCls(3, Color)); }
void RAYLIBFN(DrawCubeWires)(WrenVM* vm) { DrawCubeWires(*WSCls(1, Vector3), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawCubeWiresV)(WrenVM* vm) { DrawCubeWiresV(*WSCls(1, Vector3), *WSCls(2, Vector3), *WSCls(3, Color)); }
void RAYLIBFN(DrawSphere)(WrenVM* vm) { DrawSphere(*WSCls(1, Vector3), WSDouble(2), *WSCls(3, Color)); }
void RAYLIBFN(DrawSphereEx)(WrenVM* vm) { DrawSphereEx(*WSCls(1, Vector3), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawSphereWires)(WrenVM* vm) { DrawSphereWires(*WSCls(1, Vector3), WSDouble(2), WSDouble(3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawCylinder)(WrenVM* vm) { DrawCylinder(*WSCls(1, Vector3), WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5), *WSCls(6, Color)); }
void RAYLIBFN(DrawCylinderEx)(WrenVM* vm) { DrawCylinderEx(*WSCls(1, Vector3), *WSCls(2, Vector3), WSDouble(3), WSDouble(4), WSDouble(5), *WSCls(6, Color)); }
void RAYLIBFN(DrawCylinderWires)(WrenVM* vm) { DrawCylinderWires(*WSCls(1, Vector3), WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5), *WSCls(6, Color)); }
void RAYLIBFN(DrawCylinderWiresEx)(WrenVM* vm) { DrawCylinderWiresEx(*WSCls(1, Vector3), *WSCls(2, Vector3), WSDouble(3), WSDouble(4), WSDouble(5), *WSCls(6, Color)); }
void RAYLIBFN(DrawCapsule)(WrenVM* vm) { DrawCapsule(*WSCls(1, Vector3), *WSCls(2, Vector3), WSDouble(3), WSDouble(4), WSDouble(5), *WSCls(6, Color)); }
void RAYLIBFN(DrawCapsuleWires)(WrenVM* vm) { DrawCapsuleWires(*WSCls(1, Vector3), *WSCls(2, Vector3), WSDouble(3), WSDouble(4), WSDouble(5), *WSCls(6, Color)); }
void RAYLIBFN(DrawPlane)(WrenVM* vm) { DrawPlane(*WSCls(1, Vector3), *WSCls(2, Vector2), *WSCls(3, Color)); }
void RAYLIBFN(DrawRay)(WrenVM* vm) { DrawRay(*WSCls(1, Ray), *WSCls(2, Color)); }
void RAYLIBFN(DrawGrid)(WrenVM* vm) { DrawGrid(WSDouble(1), WSDouble(2)); }

void RAYLIBFN(LoadModel)(WrenVM* vm) {
    auto input = WSCls(1, Model);
    auto output = LoadModel(WSString(2));
    memcpy(input, &output, sizeof(Model));
}
void RAYLIBFN(LoadModelFromMesh)(WrenVM* vm) {
    auto input = WSCls(1, Model);
    auto output = LoadModelFromMesh(*WSCls(2, Mesh));
    memcpy(input, &output, sizeof(Model));
}
void RAYLIBFN(IsModelReady)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsModelReady(*WSCls(1, Model))); }
void RAYLIBFN(UnloadModel)(WrenVM* vm) { UnloadModel(*WSCls(1, Model)); }
void RAYLIBFN(GetModelBoundingBox)(WrenVM* vm) { *WSCls(1, BoundingBox) = GetModelBoundingBox(*WSCls(2, Model)); }

void RAYLIBFN(DrawModel)(WrenVM* vm) { DrawModel(*WSCls(1, Model), *WSCls(2, Vector3), WSDouble(3), *WSCls(4, Color)); }
void RAYLIBFN(DrawModelEx)(WrenVM* vm) { DrawModelEx(*WSCls(1, Model), *WSCls(2, Vector3), *WSCls(3, Vector3), WSDouble(4), *WSCls(5, Vector3), *WSCls(6, Color)); }
void RAYLIBFN(DrawModelWires)(WrenVM* vm) { DrawModelWires(*WSCls(1, Model), *WSCls(2, Vector3), WSDouble(3), *WSCls(4, Color)); }
void RAYLIBFN(DrawModelWiresEx)(WrenVM* vm) { DrawModelWiresEx(*WSCls(1, Model), *WSCls(2, Vector3), *WSCls(3, Vector3), WSDouble(4), *WSCls(5, Vector3), *WSCls(6, Color)); }
void RAYLIBFN(DrawBoundingBox)(WrenVM* vm) { DrawBoundingBox(*WSCls(1, BoundingBox), *WSCls(2, Color)); }
void RAYLIBFN(DrawBillboard)(WrenVM* vm) { DrawBillboard(*WSCls(1, Camera), *WSCls(2, Texture2D), *WSCls(3, Vector3), WSDouble(4), *WSCls(5, Color)); }
void RAYLIBFN(DrawBillboardRec)(WrenVM* vm) { DrawBillboardRec(*WSCls(1, Camera), *WSCls(2, Texture2D), *WSCls(3, Rectangle), *WSCls(4, Vector3), *WSCls(5, Vector2), *WSCls(6, Color)); } 
void RAYLIBFN(DrawBillboardPro)(WrenVM* vm) { DrawBillboardPro(*WSCls(1, Camera), *WSCls(2, Texture2D), *WSCls(3, Rectangle), *WSCls(4, Vector3), *WSCls(5, Vector3), *WSCls(6, Vector2), *WSCls(7, Vector2), WSDouble(8), *WSCls(9, Color)); } 

void RAYLIBFN(UploadMesh)(WrenVM* vm) { UploadMesh(WSCls(1, Mesh), WSBool(2)); }
void RAYLIBFN(UpdateMeshBuffer)(WrenVM* vm) {} // TODO 
void RAYLIBFN(UnloadMesh)(WrenVM* vm) { UnloadMesh(*WSCls(1, Mesh)); }
void RAYLIBFN(DrawMesh)(WrenVM* vm) { DrawMesh(*WSCls(1, Mesh), *WSCls(2, Material), *WSCls(3, Matrix)); }
void RAYLIBFN(DrawMeshInstanced)(WrenVM* vm) { DrawMeshInstanced(*WSCls(1, Mesh), *WSCls(2, Material), (Matrix*)WSCls(3, ValueList)->data, WSDouble(4)); }  
void RAYLIBFN(ExportMesh)(WrenVM* vm) { ExportMesh(*WSCls(1, Mesh), WSString(2)); }
void RAYLIBFN(GetMeshBoundingBox)(WrenVM* vm) { *WSCls(1, BoundingBox) = GetMeshBoundingBox(*WSCls(2, Mesh)); } 
void RAYLIBFN(GenMeshTangents)(WrenVM* vm) { GenMeshTangents(WSCls(1, Mesh)); } 

void RAYLIBFN(GenMeshPoly)(WrenVM* vm) { *WSCls(1, Mesh) = GenMeshPoly(WSDouble(2), WSDouble(3)); }
void RAYLIBFN(GenMeshPlane)(WrenVM* vm) { *WSCls(1, Mesh) = GenMeshPlane(WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5)); }
void RAYLIBFN(GenMeshCube)(WrenVM* vm) { *WSCls(1, Mesh) = GenMeshCube(WSDouble(2), WSDouble(3), WSDouble(4)); }
void RAYLIBFN(GenMeshSphere)(WrenVM* vm) { *WSCls(1, Mesh) = GenMeshSphere(WSDouble(2), WSDouble(3), WSDouble(4)); }
void RAYLIBFN(GenMeshHemiSphere)(WrenVM* vm) { *WSCls(1, Mesh) = GenMeshHemiSphere(WSDouble(2), WSDouble(3), WSDouble(4)); }
void RAYLIBFN(GenMeshCylinder)(WrenVM* vm) { *WSCls(1, Mesh) = GenMeshCylinder(WSDouble(2), WSDouble(3), WSDouble(4)); }
void RAYLIBFN(GenMeshCone)(WrenVM* vm) { *WSCls(1, Mesh) = GenMeshCone(WSDouble(2), WSDouble(3), WSDouble(4)); }
void RAYLIBFN(GenMeshTorus)(WrenVM* vm) { *WSCls(1, Mesh) = GenMeshTorus(WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5)); }
void RAYLIBFN(GenMeshKnot)(WrenVM* vm) { *WSCls(1, Mesh) = GenMeshKnot(WSDouble(2), WSDouble(3), WSDouble(4), WSDouble(5)); }
void RAYLIBFN(GenMeshHeightmap)(WrenVM* vm) { *WSCls(1, Mesh) = GenMeshHeightmap(*WSCls(2, Image), *WSCls(3, Vector3)); }
void RAYLIBFN(GenMeshCubicmap)(WrenVM* vm) { *WSCls(1, Mesh) = GenMeshCubicmap(*WSCls(2, Image), *WSCls(3, Vector3)); }

void RAYLIBFN(LoadMaterials)(WrenVM* vm) { 
    auto vlist = WSCls(1, ValueList);
    int cnt = 0;
    auto materials = LoadMaterials(WSString(2), &cnt);
    vlist->valueType = 13;
    vlist->count = cnt; 
    vlist->data = materials;
    wrenSetSlotDouble(vm, 3, cnt);
}
void RAYLIBFN(LoadMaterialDefault)(WrenVM* vm) {
    auto input = WSCls(1, Material);
    auto output = LoadMaterialDefault();
    memcpy(input, &output, sizeof(Material));
}
void RAYLIBFN(IsMaterialReady)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsMaterialReady(*WSCls(1, Material))); }
void RAYLIBFN(UnloadMaterial)(WrenVM* vm) { UnloadMaterial(*WSCls(1, Material)); }
void RAYLIBFN(SetMaterialTexture)(WrenVM* vm) { SetMaterialTexture(WSCls(1, Material), WSDouble(2), *WSCls(3, Texture2D)); }
void RAYLIBFN(SetModelMeshMaterial)(WrenVM* vm) { SetModelMeshMaterial(WSCls(1, Model), WSDouble(2), WSDouble(3)); }

void RAYLIBFN(LoadModelAnimations)(WrenVM* vm) {
    auto input = WSCls(1, ValueList);
    int aniCount;
    auto output = LoadModelAnimations(WSString(2), &aniCount);
    input->count = aniCount;
    input->data = output;
    input->valueType = 17;
} 
void RAYLIBFN(UpdateModelAnimation)(WrenVM* vm) { UpdateModelAnimation(*WSCls(1, Model), *WSCls(2, ModelAnimation), WSDouble(3)); }
void RAYLIBFN(UnloadModelAnimation)(WrenVM* vm) { UnloadModelAnimation(*WSCls(1, ModelAnimation)); }
void RAYLIBFN(UnloadModelAnimations)(WrenVM* vm) { 
    auto vlist = WSCls(1, ValueList);
    UnloadModelAnimations((ModelAnimation*)vlist->data, vlist->count);
}
void RAYLIBFN(IsModelAnimationValid)(WrenVM* vm) { wrenSetSlotBool(vm, 0, IsModelAnimationValid(*WSCls(1, Model), *WSCls(2, ModelAnimation))); } 

void RAYLIBFN(CheckCollisionSpheres)(WrenVM* vm) {}
void RAYLIBFN(CheckCollisionBoxes)(WrenVM* vm) {}
void RAYLIBFN(CheckCollisionBoxSphere)(WrenVM* vm) {}
void RAYLIBFN(GetRayCollisionSphere)(WrenVM* vm) {}
void RAYLIBFN(GetRayCollisionBox)(WrenVM* vm) {}
void RAYLIBFN(GetRayCollisionMesh)(WrenVM* vm) {}
void RAYLIBFN(GetRayCollisionTriangle)(WrenVM* vm) {}
void RAYLIBFN(GetRayCollisionQuad)(WrenVM* vm) {}

void RAYLIBFN(PackRectangles)(WrenVM* vm) {
    ValueList* vinput = WSCls(1, ValueList);
    ValueList* voutput = WSCls(2, ValueList);
    int w = int(WSDouble(3));
    int h = int(WSDouble(4));
    int math = int(WSDouble(5));
    int num_rects = vinput->count;
    int num_nodes = w;
    Rectangle* in_rects = nullptr;
    if(vinput->valueType == 1) { in_rects = (Rectangle*)vinput->data; }
    LOG_F(INFO, "[RectPacker] packing w:%d h:%d, rect count: %d, math: %d, num_nodes: %d, output_data: %p", w, h, vinput->count, math, num_nodes, voutput->data);
    if(in_rects) {
        stbrp_rect *brp_rects = (stbrp_rect*)malloc(num_rects * sizeof(stbrp_rect));
        stbrp_node *brp_nodes = (stbrp_node*)malloc(num_nodes * sizeof(stbrp_node));
        memset(brp_rects, 0, sizeof(stbrp_rect) * num_rects);
        memset(brp_nodes, 0, sizeof(stbrp_node) * num_nodes);
        stbrp_context ctx;
        ctx.init_mode = 1;
        voutput->valueType = 1;
        if(voutput->data) {
            voutput->data = realloc(voutput->data, num_rects * sizeof(Rectangle));
        } else {
            voutput->data = malloc(num_rects * sizeof(Rectangle));
        }
        voutput->count = num_rects;

        for(int i = 0; i < num_rects; i++) {
            brp_rects[i].w = in_rects[i].width;
            brp_rects[i].h = in_rects[i].height;
            brp_rects[i].id = i;
            brp_rects[i].was_packed = 1;
        }
        stbrp_init_target(&ctx, w, h, brp_nodes, num_nodes);
        stbrp_setup_allow_out_of_mem(&ctx, 1);
        stbrp_setup_heuristic(&ctx, math);
        stbrp_pack_rects(&ctx, brp_rects, num_rects);
        Rectangle* out_rects = (Rectangle*)voutput->data;
        for(int i = 0; i < num_rects; i++)
        { 
            out_rects[brp_rects[i].id] = Rectangle{ float(brp_rects[i].x), float(brp_rects[i].y), float(brp_rects[i].w), float(brp_rects[i].h) }; 
        }
        free(brp_nodes);
        free(brp_rects);
    }
    LOG_F(INFO, "[RectPacker] Packing finished.");
}

WrenForeignMethodFn wrenRaylibBindForeignMethod(WrenVM* vm, const char* className, bool isStatic, const char* signature)
{
    WrenForeignMethodFn fn = nullptr;
    if(strcmp(className, "RayMath") == 0)
    {
        do 
        {
            if(strcmp(signature, "Clamp(_,_,_)") == 0) { fn = RAYMATHFN(Clamp); break; }
            if(strcmp(signature, "Lerp(_,_,_)") == 0) { fn = RAYMATHFN(Lerp); break; }
            if(strcmp(signature, "Normalize(_,_,_)") == 0) { fn = RAYMATHFN(Normalize); break; }
            if(strcmp(signature, "Remap(_,_,_,_,_)") == 0) { fn = RAYMATHFN(Remap); break; }
            if(strcmp(signature, "Wrap(_,_,_)") == 0) { fn = RAYMATHFN(Wrap); break; }
            if(strcmp(signature, "FloatEquals(_,_)") == 0) { fn = RAYMATHFN(FloatEquals); break; }
        } while(false);
    }

    if(strcmp(className, "Vector2") == 0)
    {
        do 
        {
            if(strcmp(signature, "x") == 0) { fn = raymathVector2GetX; break; }
            if(strcmp(signature, "x=(_)") == 0) { fn = raymathVector2SetX; break; }
            if(strcmp(signature, "y") == 0) { fn = raymathVector2GetY; break; }
            if(strcmp(signature, "y=(_)") == 0) { fn = raymathVector2SetY; break; }
            if(strcmp(signature, "Vector2Zero()") == 0) { fn = RAYMATHFN(Vector2Zero); break; }
            if(strcmp(signature, "Vector2One()") == 0) { fn = RAYMATHFN(Vector2One); break; }
            if(strcmp(signature, "Vector2Add(_,_)") == 0) { fn = RAYMATHFN(Vector2Add); break; }
            if(strcmp(signature, "Vector2AddValue(_,_)") == 0) { fn = RAYMATHFN(Vector2AddValue); break; }
            if(strcmp(signature, "Vector2Subtract(_,_)") == 0) { fn = RAYMATHFN(Vector2Subtract); break; }
            if(strcmp(signature, "Vector2SubtractValue(_,_)") == 0) { fn = RAYMATHFN(Vector2SubtractValue); break; }
            if(strcmp(signature, "Vector2Length(_)") == 0) { fn = RAYMATHFN(Vector2Length); break; }
            if(strcmp(signature, "Vector2LengthSqr(_)") == 0) { fn = RAYMATHFN(Vector2LengthSqr); break; }
            if(strcmp(signature, "Vector2DotProduct(_,_)") == 0) { fn = RAYMATHFN(Vector2DotProduct); break; }
            if(strcmp(signature, "Vector2Distance(_,_)") == 0) { fn = RAYMATHFN(Vector2Distance); break; }
            if(strcmp(signature, "Vector2DistanceSqr(_,_)") == 0) { fn = RAYMATHFN(Vector2DistanceSqr); break; }
            if(strcmp(signature, "Vector2Angle(_,_)") == 0) { fn = RAYMATHFN(Vector2Angle); break; }
            if(strcmp(signature, "Vector2LineAngle(_,_)") == 0) { fn = RAYMATHFN(Vector2LineAngle); break; }
            if(strcmp(signature, "Vector2Scale(_,_)") == 0) { fn = RAYMATHFN(Vector2Scale); break; }
            if(strcmp(signature, "Vector2Multiply(_,_)") == 0) { fn = RAYMATHFN(Vector2Multiply); break; }
            if(strcmp(signature, "Vector2Negate(_)") == 0) { fn = RAYMATHFN(Vector2Negate); break; }
            if(strcmp(signature, "Vector2Divide(_,_)") == 0) { fn = RAYMATHFN(Vector2Divide); break; }
            if(strcmp(signature, "Vector2Normalize(_)") == 0) { fn = RAYMATHFN(Vector2Normalize); break; }
            if(strcmp(signature, "Vector2Transform(_,_)") == 0) { fn = RAYMATHFN(Vector2Transform); break; }
            if(strcmp(signature, "Vector2Lerp(_,_,_)") == 0) { fn = RAYMATHFN(Vector2Lerp); break; }
            if(strcmp(signature, "Vector2Reflect(_,_)") == 0) { fn = RAYMATHFN(Vector2Reflect); break; }
            if(strcmp(signature, "Vector2Rotate(_,_)") == 0) { fn = RAYMATHFN(Vector2Rotate); break; }
            if(strcmp(signature, "Vector2MoveTowards(_,_,_)") == 0) { fn = RAYMATHFN(Vector2MoveTowards); break; }
            if(strcmp(signature, "Vector2Invert(_)") == 0) { fn = RAYMATHFN(Vector2Invert); break; }
            if(strcmp(signature, "Vector2Clamp(_,_,_)") == 0) { fn = RAYMATHFN(Vector2Clamp); break; }
            if(strcmp(signature, "Vector2ClampValue(_,_,_)") == 0) { fn = RAYMATHFN(Vector2ClampValue); break; }
            if(strcmp(signature, "Vector2Equals(_,_)") == 0) { fn = RAYMATHFN(Vector2Equals); break; }
        } while(false);
    }

    if(strcmp(className, "Vector3") == 0) 
    {
        do 
        {
            if(strcmp(signature, "x") == 0) { fn = raymathVector3GetX; break; }
            if(strcmp(signature, "x=(_)") == 0) { fn = raymathVector3SetX; break; }
            if(strcmp(signature, "y") == 0) { fn = raymathVector3GetY; break; }
            if(strcmp(signature, "y=(_)") == 0) { fn = raymathVector3SetY; break; }
            if(strcmp(signature, "z") == 0) { fn = raymathVector3GetZ; break; }
            if(strcmp(signature, "z=(_)") == 0) { fn = raymathVector3SetZ; break; }
            if(strcmp(signature, "Vector3Zero()") == 0) { fn = RAYMATHFN(Vector3Zero); break; }
            if(strcmp(signature, "Vector3One()") == 0) { fn = RAYMATHFN(Vector3One); break; }
            if(strcmp(signature, "Vector3Add(_,_)") == 0) { fn = RAYMATHFN(Vector3Add); break; }
            if(strcmp(signature, "Vector3AddValue(_,_)") == 0) { fn = RAYMATHFN(Vector3AddValue); break; }
            if(strcmp(signature, "Vector3Subtract(_,_)") == 0) { fn = RAYMATHFN(Vector3Subtract); break; }
            if(strcmp(signature, "Vector3SubtractValue(_,_)") == 0) { fn = RAYMATHFN(Vector3SubtractValue); break; }
            if(strcmp(signature, "Vector3Scale(_,_)") == 0) { fn = RAYMATHFN(Vector3Scale); break; }
            if(strcmp(signature, "Vector3Multiply(_,_)") == 0) { fn = RAYMATHFN(Vector3Multiply); break; }
            if(strcmp(signature, "Vector3CrossProduct(_,_)") == 0) { fn = RAYMATHFN(Vector3CrossProduct); break; }
            if(strcmp(signature, "Vector3Perpendicular(_)") == 0) { fn = RAYMATHFN(Vector3Perpendicular); break; }
            if(strcmp(signature, "Vector3Length(_)") == 0) { fn = RAYMATHFN(Vector3Length); break; }
            if(strcmp(signature, "Vector3LengthSqr(_)") == 0) { fn = RAYMATHFN(Vector3LengthSqr); break; }
            if(strcmp(signature, "Vector3DotProduct(_,_)") == 0) { fn = RAYMATHFN(Vector3DotProduct); break; }
            if(strcmp(signature, "Vector3Distance(_,_)") == 0) { fn = RAYMATHFN(Vector3Distance); break; }
            if(strcmp(signature, "Vector3DistanceSqr(_,_)") == 0) { fn = RAYMATHFN(Vector3DistanceSqr); break; }
            if(strcmp(signature, "Vector3Angle(_,_)") == 0) { fn = RAYMATHFN(Vector3Angle); break; }
            if(strcmp(signature, "Vector3Negate(_)") == 0) { fn = RAYMATHFN(Vector3Negate); break; }
            if(strcmp(signature, "Vector3Divide(_,_)") == 0) { fn = RAYMATHFN(Vector3Divide); break; }
            if(strcmp(signature, "Vector3Normalize(_)") == 0) { fn = RAYMATHFN(Vector3Normalize); break; }
            if(strcmp(signature, "Vector3Project(_,_)") == 0) { fn = RAYMATHFN(Vector3Project); break; }
            if(strcmp(signature, "Vector3Reject(_,_)") == 0) { fn = RAYMATHFN(Vector3Reject); break; }
            if(strcmp(signature, "Vector3OrthoNormalize(_,_)") == 0) { fn = RAYMATHFN(Vector3OrthoNormalize); break; }
            if(strcmp(signature, "Vector3Transform(_,_)") == 0) { fn = RAYMATHFN(Vector3Transform); break; }
            if(strcmp(signature, "Vector3RotateByQuaternion(_,_)") == 0) { fn = RAYMATHFN(Vector3RotateByQuaternion); break; }
            if(strcmp(signature, "Vector3RotateByAxisAngle(_,_,_)") == 0) { fn = RAYMATHFN(Vector3RotateByAxisAngle); break; }
            if(strcmp(signature, "Vector3Lerp(_,_,_)") == 0) { fn = RAYMATHFN(Vector3Lerp); break; }
            if(strcmp(signature, "Vector3Reflect(_,_)") == 0) { fn = RAYMATHFN(Vector3Reflect); break; }
            if(strcmp(signature, "Vector3Min(_,_)") == 0) { fn = RAYMATHFN(Vector3Min); break; }
            if(strcmp(signature, "Vector3Max(_,_)") == 0) { fn = RAYMATHFN(Vector3Max); break; }
            if(strcmp(signature, "Vector3Barycenter(_,_,_,_)") == 0) { fn = RAYMATHFN(Vector3Barycenter); break; }
            if(strcmp(signature, "Vector3Unproject(_,_,_)") == 0) { fn = RAYMATHFN(Vector3Unproject); break; }
            if(strcmp(signature, "Vector3ToFloatV(_)") == 0) { fn = RAYMATHFN(Vector3ToFloatV); break; }
            if(strcmp(signature, "Vector3Invert(_)") == 0) { fn = RAYMATHFN(Vector3Invert); break; }
            if(strcmp(signature, "Vector3Clamp(_,_,_)") == 0) { fn = RAYMATHFN(Vector3Clamp); break; }
            if(strcmp(signature, "Vector3ClampValue(_,_,_)") == 0) { fn = RAYMATHFN(Vector3ClampValue); break; }
            if(strcmp(signature, "Vector3Equals(_,_)") == 0) { fn = RAYMATHFN(Vector3Equals); break; }
            if(strcmp(signature, "Vector3Refract(_,_,_)") == 0) { fn = RAYMATHFN(Vector3Refract); break; }
        } while(false);
    }

    if(strcmp(className, "Vector4") == 0) 
    {
        do 
        {
            if(strcmp(signature, "x") == 0) { fn = raymathVector4GetX; break; }
            if(strcmp(signature, "x=(_)") == 0) { fn = raymathVector4SetX; break; }
            if(strcmp(signature, "y") == 0) { fn = raymathVector4GetY; break; }
            if(strcmp(signature, "y=(_)") == 0) { fn = raymathVector4SetY; break; }
            if(strcmp(signature, "z") == 0) { fn = raymathVector4GetZ; break; }
            if(strcmp(signature, "z=(_)") == 0) { fn = raymathVector4SetZ; break; }
            if(strcmp(signature, "w") == 0) { fn = raymathVector4GetW; break; }
            if(strcmp(signature, "w=(_)") == 0) { fn = raymathVector4SetW; break; }
        } while(false);
    }

    if(strcmp(className, "Quaternion") == 0) 
    {
        do 
        {
            if(strcmp(signature, "x") == 0) { fn = raymathQuaternionGetX; break; }
            if(strcmp(signature, "x=(_)") == 0) { fn = raymathQuaternionSetX; break; }
            if(strcmp(signature, "y") == 0) { fn = raymathQuaternionGetY; break; }
            if(strcmp(signature, "y=(_)") == 0) { fn = raymathQuaternionSetY; break; }
            if(strcmp(signature, "z") == 0) { fn = raymathQuaternionGetZ; break; }
            if(strcmp(signature, "z=(_)") == 0) { fn = raymathQuaternionSetZ; break; }
            if(strcmp(signature, "w") == 0) { fn = raymathQuaternionGetW; break; }
            if(strcmp(signature, "w=(_)") == 0) { fn = raymathQuaternionSetW; break; }
            if(strcmp(signature, "QuaternionAdd(_,_)") == 0) { fn = RAYMATHFN(QuaternionAdd); break; }
            if(strcmp(signature, "QuaternionAddValue(_,_)") == 0) { fn = RAYMATHFN(QuaternionAddValue); break; }
            if(strcmp(signature, "QuaternionSubtract(_,_)") == 0) { fn = RAYMATHFN(QuaternionSubtract); break; }
            if(strcmp(signature, "QuaternionSubtractValue(_,_)") == 0) { fn = RAYMATHFN(QuaternionSubtractValue); break; }
            if(strcmp(signature, "QuaternionIdentity()") == 0) { fn = RAYMATHFN(QuaternionIdentity); break; }
            if(strcmp(signature, "QuaternionLength(_)") == 0) { fn = RAYMATHFN(QuaternionLength); break; }
            if(strcmp(signature, "QuaternionNormalize(_)") == 0) { fn = RAYMATHFN(QuaternionNormalize); break; }
            if(strcmp(signature, "QuaternionInvert(_)") == 0) { fn = RAYMATHFN(QuaternionInvert); break; }
            if(strcmp(signature, "QuaternionMultiply(_,_)") == 0) { fn = RAYMATHFN(QuaternionMultiply); break; }
            if(strcmp(signature, "QuaternionScale(_,_)") == 0) { fn = RAYMATHFN(QuaternionScale); break; }
            if(strcmp(signature, "QuaternionDivide(_,_)") == 0) { fn = RAYMATHFN(QuaternionDivide); break; }
            if(strcmp(signature, "QuaternionLerp(_,_,_)") == 0) { fn = RAYMATHFN(QuaternionLerp); break; }
            if(strcmp(signature, "QuaternionNlerp(_,_,_)") == 0) { fn = RAYMATHFN(QuaternionNlerp); break; }
            if(strcmp(signature, "QuaternionSlerp(_,_,_)") == 0) { fn = RAYMATHFN(QuaternionSlerp); break; }
            if(strcmp(signature, "QuaternionFromVector3ToVector3(_,_)") == 0) { fn = RAYMATHFN(QuaternionFromVector3ToVector3); break; }
            if(strcmp(signature, "QuaternionFromMatrix(_)") == 0) { fn = RAYMATHFN(QuaternionFromMatrix); break; }
            if(strcmp(signature, "QuaternionToMatrix(_)") == 0) { fn = RAYMATHFN(QuaternionToMatrix); break; }
            if(strcmp(signature, "QuaternionFromAxisAngle(_,_)") == 0) { fn = RAYMATHFN(QuaternionFromAxisAngle); break; }
            if(strcmp(signature, "QuaternionToAxisAngle(_,_,_)") == 0) { fn = RAYMATHFN(QuaternionToAxisAngle); break; }
            if(strcmp(signature, "QuaternionFromEuler(_,_,_)") == 0) { fn = RAYMATHFN(QuaternionFromEuler); break; }
            if(strcmp(signature, "QuaternionToEuler(_)") == 0) { fn = RAYMATHFN(QuaternionToEuler); break; }
            if(strcmp(signature, "QuaternionTransform(_,_)") == 0) { fn = RAYMATHFN(QuaternionTransform); break; }
            if(strcmp(signature, "QuaternionEquals(_,_)") == 0) { fn = RAYMATHFN(QuaternionEquals); break; }
        } while(false);
    }

    if(strcmp(className, "Matrix") == 0) 
    {
        do 
        {
            if(strcmp(signature, "[_]") == 0) { fn = raymathMatrixGetValue; break; }
            if(strcmp(signature, "[_]=(_)") == 0) { fn = raymathMatrixSetValue; break; }
            if(strcmp(signature, "MatrixDeterminant(_)") == 0) { fn = RAYMATHFN(MatrixDeterminant); break; }
            if(strcmp(signature, "MatrixTrace(_)") == 0) { fn = RAYMATHFN(MatrixTrace); break; }
            if(strcmp(signature, "MatrixTranspose(_)") == 0) { fn = RAYMATHFN(MatrixTranspose); break; }
            if(strcmp(signature, "MatrixInvert(_)") == 0) { fn = RAYMATHFN(MatrixInvert); break; }
            if(strcmp(signature, "MatrixIdentity()") == 0) { fn = RAYMATHFN(MatrixIdentity); break; }
            if(strcmp(signature, "MatrixAdd(_,_)") == 0) { fn = RAYMATHFN(MatrixAdd); break; }
            if(strcmp(signature, "MatrixSubtract(_,_)") == 0) { fn = RAYMATHFN(MatrixSubtract); break; }
            if(strcmp(signature, "MatrixMultiply(_,_)") == 0) { fn = RAYMATHFN(MatrixMultiply); break; }
            if(strcmp(signature, "MatrixTranslate(_,_,_)") == 0) { fn = RAYMATHFN(MatrixTranslate); break; }
            if(strcmp(signature, "MatrixRotate(_,_)") == 0) { fn = RAYMATHFN(MatrixRotate); break; }
            if(strcmp(signature, "MatrixRotateX(_)") == 0) { fn = RAYMATHFN(MatrixRotateX); break; }
            if(strcmp(signature, "MatrixRotateY(_)") == 0) { fn = RAYMATHFN(MatrixRotateY); break; }
            if(strcmp(signature, "MatrixRotateZ(_)") == 0) { fn = RAYMATHFN(MatrixRotateZ); break; }
            if(strcmp(signature, "MatrixRotateXYZ(_)") == 0) { fn = RAYMATHFN(MatrixRotateXYZ); break; }
            if(strcmp(signature, "MatrixRotateZYX(_)") == 0) { fn = RAYMATHFN(MatrixRotateZYX); break; }
            if(strcmp(signature, "MatrixScale(_,_,_)") == 0) { fn = RAYMATHFN(MatrixScale); break; }
            if(strcmp(signature, "MatrixFrustum(_,_,_,_,_,_)") == 0) { fn = RAYMATHFN(MatrixFrustum); break; }
            if(strcmp(signature, "MatrixPerspective(_,_,_,_)") == 0) { fn = RAYMATHFN(MatrixPerspective); break; }
            if(strcmp(signature, "MatrixOrtho(_,_,_,_,_,_)") == 0) { fn = RAYMATHFN(MatrixOrtho); break; }
            if(strcmp(signature, "MatrixLookAt(_,_,_)") == 0) { fn = RAYMATHFN(MatrixLookAt); break; }
            if(strcmp(signature, "MatrixToFloatV(_)") == 0) { fn = RAYMATHFN(MatrixToFloatV); break; }
        } while(false);
    }

    if(strcmp(className, "float3") == 0) 
    {
        do 
        {
            if(strcmp(signature, "[_]") == 0) { fn = raymathFloat3GetValue; break; }
            if(strcmp(signature, "[_]=(_)") == 0) { fn = raymathFloat3SetValue; break; }
        } while(false);
    }

    if(strcmp(className, "float16") == 0) 
    {
        do 
        {
            if(strcmp(signature, "[_]") == 0) { fn = raymathFloat16GetValue; break; }
            if(strcmp(signature, "[_]=(_)") == 0) { fn = raymathFloat16SetValue; break; }
        } while(false);
    }

    if(strcmp(className, "Color") == 0) 
    {
        do 
        {
            if(strcmp(signature, "r=(_)") == 0) { fn = WRENSETTERFN(Color, r); break; }
            if(strcmp(signature, "r") == 0) { fn = WRENGETTERFN(Color, r); break; }
            if(strcmp(signature, "g=(_)") == 0) { fn = WRENSETTERFN(Color, g); break; }
            if(strcmp(signature, "g") == 0) { fn = WRENGETTERFN(Color, g); break; }
            if(strcmp(signature, "b=(_)") == 0) { fn = WRENSETTERFN(Color, b); break; }
            if(strcmp(signature, "b") == 0) { fn = WRENGETTERFN(Color, b); break; }
            if(strcmp(signature, "a=(_)") == 0) { fn = WRENSETTERFN(Color, a); break; }
            if(strcmp(signature, "a") == 0) { fn = WRENGETTERFN(Color, a); break; }
        } while(false);
    }

    if(strcmp(className, "Rectangle") == 0) 
    {
        do 
        {
            if(strcmp(signature, "x=(_)") == 0) { fn = WRENSETTERFN(Rectangle, x); break; }
            if(strcmp(signature, "x") == 0) { fn = WRENGETTERFN(Rectangle, x); break; }
            if(strcmp(signature, "y=(_)") == 0) { fn = WRENSETTERFN(Rectangle, y); break; }
            if(strcmp(signature, "y") == 0) { fn = WRENGETTERFN(Rectangle, y); break; }
            if(strcmp(signature, "width=(_)") == 0) { fn = WRENSETTERFN(Rectangle, width); break; }
            if(strcmp(signature, "width") == 0) { fn = WRENGETTERFN(Rectangle, width); break; }
            if(strcmp(signature, "height=(_)") == 0) { fn = WRENSETTERFN(Rectangle, height); break; }
            if(strcmp(signature, "height") == 0) { fn = WRENGETTERFN(Rectangle, height); break; }
        } while(false);
    }

    if(strcmp(className, "Image") == 0) 
    {
        do 
        {
            if(strcmp(signature, "width=(_)") == 0) { fn = WRENSETTERFN(Image, width); break; }
            if(strcmp(signature, "width") == 0) { fn = WRENGETTERFN(Image, width); break; }
            if(strcmp(signature, "height=(_)") == 0) { fn = WRENSETTERFN(Image, height); break; }
            if(strcmp(signature, "height") == 0) { fn = WRENGETTERFN(Image, height); break; }
            if(strcmp(signature, "mipmaps=(_)") == 0) { fn = WRENSETTERFN(Image, mipmaps); break; }
            if(strcmp(signature, "mipmaps") == 0) { fn = WRENGETTERFN(Image, mipmaps); break; }
            if(strcmp(signature, "format=(_)") == 0) { fn = WRENSETTERFN(Image, format); break; }
            if(strcmp(signature, "format") == 0) { fn = WRENGETTERFN(Image, format); break; }
            
        } while(false);
    }

    if(strcmp(className, "Texture") == 0) 
    {
        do 
        {
            if(strcmp(signature, "id=(_)") == 0) { fn = WRENSETTERFN(Texture, id); break; }
            if(strcmp(signature, "id") == 0) { fn = WRENGETTERFN(Texture, id); break; }
            if(strcmp(signature, "width=(_)") == 0) { fn = WRENSETTERFN(Texture, width); break; }
            if(strcmp(signature, "width") == 0) { fn = WRENGETTERFN(Texture, width); break; }
            if(strcmp(signature, "height=(_)") == 0) { fn = WRENSETTERFN(Texture, height); break; }
            if(strcmp(signature, "height") == 0) { fn = WRENGETTERFN(Texture, height); break; }
            if(strcmp(signature, "mipmaps=(_)") == 0) { fn = WRENSETTERFN(Texture, mipmaps); break; }
            if(strcmp(signature, "mipmaps") == 0) { fn = WRENGETTERFN(Texture, mipmaps); break; }
            if(strcmp(signature, "format=(_)") == 0) { fn = WRENSETTERFN(Texture, format); break; }
            if(strcmp(signature, "format") == 0) { fn = WRENGETTERFN(Texture, format); break; }
        } while(false);
    }

    if(strcmp(className, "RenderTexture") == 0) 
    {
        do 
        {
            if(strcmp(signature, "id=(_)") == 0) { fn = WRENSETTERFN(RenderTexture, id); break; }
            if(strcmp(signature, "id") == 0) { fn = WRENGETTERFN(RenderTexture, id); break; }
            if(strcmp(signature, "texture=(_)") == 0) { fn = WRENSETTERFN(RenderTexture, texture); break; }
            if(strcmp(signature, "depth=(_)") == 0) { fn = WRENSETTERFN(RenderTexture, depth); break; }
            if(strcmp(signature, "getTexture(_)") == 0) { fn = renderTextureGetTexture; break; }
            if(strcmp(signature, "getDepthTexture(_)") == 0) { fn = renderTextureGetDepthTexture; break; }
        } while(false);
    }

    if(strcmp(className, "NPatchInfo") == 0) 
    {
        do 
        {
            if(strcmp(signature, "source=(_)") == 0) { fn = WRENSETTERFN(NPatchInfo, source); break; }
            if(strcmp(signature, "left=(_)") == 0) { fn = WRENSETTERFN(NPatchInfo, left); break; }
            if(strcmp(signature, "left") == 0) { fn = WRENGETTERFN(NPatchInfo, left); break; }
            if(strcmp(signature, "top=(_)") == 0) { fn = WRENSETTERFN(NPatchInfo, top); break; }
            if(strcmp(signature, "top") == 0) { fn = WRENGETTERFN(NPatchInfo, top); break; }
            if(strcmp(signature, "right=(_)") == 0) { fn = WRENSETTERFN(NPatchInfo, right); break; }
            if(strcmp(signature, "right") == 0) { fn = WRENGETTERFN(NPatchInfo, right); break; }
            if(strcmp(signature, "bottom=(_)") == 0) { fn = WRENSETTERFN(NPatchInfo, bottom); break; }
            if(strcmp(signature, "bottom") == 0) { fn = WRENGETTERFN(NPatchInfo, bottom); break; }
            if(strcmp(signature, "layout=(_)") == 0) { fn = WRENSETTERFN(NPatchInfo, layout); break; }
            if(strcmp(signature, "layout") == 0) { fn = WRENGETTERFN(NPatchInfo, layout); break; }
        } while(false);
    }

    if(strcmp(className, "GlyphInfo") == 0) 
    {
        do 
        {
            if(strcmp(signature, "value=(_)") == 0) { fn = WRENSETTERFN(GlyphInfo, value); break; }
            if(strcmp(signature, "value") == 0) { fn = WRENGETTERFN(GlyphInfo, value); break; }
            if(strcmp(signature, "offsetX=(_)") == 0) { fn = WRENSETTERFN(GlyphInfo, offsetX); break; }
            if(strcmp(signature, "offsetX") == 0) { fn = WRENGETTERFN(GlyphInfo, offsetX); break; }
            if(strcmp(signature, "offsetY=(_)") == 0) { fn = WRENSETTERFN(GlyphInfo, offsetY); break; }
            if(strcmp(signature, "offsetY") == 0) { fn = WRENGETTERFN(GlyphInfo, offsetY); break; }
            if(strcmp(signature, "advanceX=(_)") == 0) { fn = WRENSETTERFN(GlyphInfo, advanceX); break; }
            if(strcmp(signature, "advanceX") == 0) { fn = WRENGETTERFN(GlyphInfo, advanceX); break; }
            if(strcmp(signature, "image=(_)") == 0) { fn = WRENSETTERFN(GlyphInfo, image); break; }
        } while(false);
    }

    if(strcmp(className, "Font") == 0) 
    {
        do 
        {
            if(strcmp(signature, "baseSize=(_)") == 0) { fn = WRENSETTERFN(Font, baseSize); break; }
            if(strcmp(signature, "baseSize") == 0) { fn = WRENGETTERFN(Font, baseSize); break; }
            if(strcmp(signature, "glyphCount=(_)") == 0) { fn = WRENSETTERFN(Font, glyphCount); break; }
            if(strcmp(signature, "glyphCount") == 0) { fn = WRENGETTERFN(Font, glyphCount); break; }
            if(strcmp(signature, "glyphPadding=(_)") == 0) { fn = WRENSETTERFN(Font, glyphPadding); break; }
            if(strcmp(signature, "glyphPadding") == 0) { fn = WRENGETTERFN(Font, glyphPadding); break; }
            if(strcmp(signature, "texture=(_)") == 0) { fn = WRENSETTERFN(Font, texture); break; }
        } while(false);
    }

    if(strcmp(className, "Camera3D") == 0) 
    {
        do 
        {
            if(strcmp(signature, "position=(_)") == 0) { fn = WRENSETTERFN(Camera3D, position); break; }
            if(strcmp(signature, "target=(_)") == 0) { fn = WRENSETTERFN(Camera3D, target); break; }
            if(strcmp(signature, "up=(_)") == 0) { fn = WRENSETTERFN(Camera3D, up); break; }
            if(strcmp(signature, "fovy=(_)") == 0) { fn = WRENSETTERFN(Camera3D, fovy); break; }
            if(strcmp(signature, "fovy") == 0) { fn = WRENGETTERFN(Camera3D, fovy); break; }
            if(strcmp(signature, "projection=(_)") == 0) { fn = WRENSETTERFN(Camera3D, projection); break; }
            if(strcmp(signature, "projection") == 0) { fn = WRENGETTERFN(Camera3D, projection); break; }
        } while(false);
    }

    if(strcmp(className, "Camera2D") == 0) 
    {
        do 
        {
            if(strcmp(signature, "offset=(_)") == 0) { fn = WRENSETTERFN(Camera2D, offset); break; }
            if(strcmp(signature, "target=(_)") == 0) { fn = WRENSETTERFN(Camera2D, target); break; }
            if(strcmp(signature, "rotation=(_)") == 0) { fn = WRENSETTERFN(Camera2D, rotation); break; }
            if(strcmp(signature, "rotation") == 0) { fn = WRENGETTERFN(Camera2D, rotation); break; }
            if(strcmp(signature, "zoom=(_)") == 0) { fn = WRENSETTERFN(Camera2D, zoom); break; }
            if(strcmp(signature, "zoom") == 0) { fn = WRENGETTERFN(Camera2D, zoom); break; }
        } while(false);
    }

    if(strcmp(className, "Mesh") == 0) 
    {
        do 
        {
        } while(false);
    }

    if(strcmp(className, "Shader") == 0) 
    {
        do 
        {
        } while(false);
    }

    if(strcmp(className, "MaterialMap") == 0) 
    {
        do 
        {
            if(strcmp(signature, "texture=(_)") == 0) { fn = WRENSETTERFN(MaterialMap, texture); break; }
            if(strcmp(signature, "color=(_)") == 0) { fn = WRENSETTERFN(MaterialMap, color); break; }
            if(strcmp(signature, "value=(_)") == 0) { fn = WRENSETTERFN(MaterialMap, value); break; }
            if(strcmp(signature, "value") == 0) { fn = WRENGETTERFN(MaterialMap, value); break; }
        } while(false);
    }

    if(strcmp(className, "Material") == 0) 
    {
        do 
        {
            if(strcmp(signature, "shader=(_)") == 0) { fn = WRENSETTERFN(Material, shader); break; }
            if(strcmp(signature, "getMaps(_)") == 0) { fn = materialGetMaps; break; }
        } while(false);
    }

    if(strcmp(className, "Transform") == 0) 
    {
        do 
        {
            if(strcmp(signature, "translation=(_)") == 0) { fn = WRENSETTERFN(Transform, translation); break; }
            if(strcmp(signature, "rotation=(_)") == 0) { fn = WRENSETTERFN(Transform, rotation); break; }
            if(strcmp(signature, "scale=(_)") == 0) { fn = WRENSETTERFN(Transform, scale); break; }
        } while(false);
    }

    if(strcmp(className, "ValueList") == 0) 
    {
        do 
        {
            if(strcmp(signature, "valueType=(_)") == 0) { fn = WRENSETTERFN(ValueList, valueType); break; }
            if(strcmp(signature, "valueType") == 0) { fn = WRENGETTERFN(ValueList, valueType); break; }
            if(strcmp(signature, "count") == 0) { fn = WRENGETTERFN(ValueList, count); break; }
            if(strcmp(signature, "get(_,_)") == 0) { fn = valueListGet; break; }
            if(strcmp(signature, "set(_,_)") == 0) { fn = valueListSet; break; }
            if(strcmp(signature, "create(_,_)") == 0) { fn = valueListCreate; break; }
        } while(false);
    }

    if(strcmp(className, "Value") == 0) 
    {
        do 
        {
            if(strcmp(signature, "valueType=(_)") == 0) { fn = WRENSETTERFN(ValueList, valueType); break; }
            if(strcmp(signature, "valueType") == 0) { fn = WRENGETTERFN(ValueList, valueType); break; }
            if(strcmp(signature, "get(_)") == 0) { fn = valueGet; break; }
            if(strcmp(signature, "set(_)") == 0) { fn = valueSet; break; }
            if(strcmp(signature, "create(_,_)") == 0) { fn = valueCreate; break; }
        } while(false);
    }

    if(strcmp(className, "BoneInfo") == 0) 
    {
        do 
        {
            // if(strcmp(signature, "_name(_)") == 0) { fn = WRENSETTERFN(BoneInfo, name); break; }
            if(strcmp(signature, "parent=(_)") == 0) { fn = WRENSETTERFN(BoneInfo, parent); break; }
            if(strcmp(signature, "parent") == 0) { fn = WRENGETTERFN(BoneInfo, parent); break; }
        } while(false);
    }

    if(strcmp(className, "Model") == 0) 
    {
        do 
        {
            if(strcmp(signature, "meshCount") == 0) { fn = WRENGETTERFN(Model, meshCount); break; }
            if(strcmp(signature, "meshCount=(_)") == 0) { fn = WRENSETTERFN(Model, meshCount); break; }
            if(strcmp(signature, "materialCount") == 0) { fn = WRENGETTERFN(Model, materialCount); break; }
            if(strcmp(signature, "materialCount=(_)") == 0) { fn = WRENSETTERFN(Model, materialCount); break; }
            if(strcmp(signature, "boneCount") == 0) { fn = WRENGETTERFN(Model, boneCount); break; }
            if(strcmp(signature, "boneCount=(_)") == 0) { fn = WRENSETTERFN(Model, boneCount); break; }
            if(strcmp(signature, "getMaterial(_,_)") == 0) { fn = modelGetMaterial; break; }
            if(strcmp(signature, "getMaterials(_)") == 0) { fn = modelGetMaterials; break; }
            if(strcmp(signature, "setMaterial(_,_)") == 0) { fn = modelSetMaterial; break; }
            if(strcmp(signature, "setMaterialShader(_,_)") == 0) { fn = modelSetMaterialShader; break; }
            
            
        } while(false);
    }

    if(strcmp(className, "ModelAnimation") == 0) 
    {
        do 
        {
            if(strcmp(signature, "boneCount") == 0) { fn = WRENGETTERFN(ModelAnimation, boneCount); break; }
            if(strcmp(signature, "frameCount") == 0) { fn = WRENGETTERFN(ModelAnimation, frameCount); break; }
        } while(false);
    }

    if(strcmp(className, "Ray") == 0) 
    {
        do 
        {
            if(strcmp(signature, "position=(_)") == 0) { fn = WRENSETTERFN(Ray, position); break; }
            if(strcmp(signature, "direction=(_)") == 0) { fn = WRENSETTERFN(Ray, direction); break; }
        } while(false);
    }

    if(strcmp(className, "RayCollision") == 0) 
    {
        do 
        {
        } while(false);
    }

    if(strcmp(className, "BoundingBox") == 0) 
    {
        do 
        {
            if(strcmp(signature, "min=(_)") == 0) { fn = WRENSETTERFN(BoundingBox, min); break; }
            if(strcmp(signature, "max=(_)") == 0) { fn = WRENSETTERFN(BoundingBox, max); break; }
        } while(false);
    }

    if(strcmp(className, "FilePathList") == 0) {
        do 
        {
            if(strcmp(signature, "count") == 0) { fn = WRENGETTERFN(FilePathList, count); break; }
            if(strcmp(signature, "paths") == 0) { fn = WRENGETTERFN(FilePathList, paths); break; }
            if(strcmp(signature, "capacity") == 0) { fn = WRENGETTERFN(FilePathList, capacity); break; }
        } while(false);
    }

    if(strcmp(className, "Raylib") == 0) 
    {
        do 
        {
            if(strcmp(signature, "InitWindow(_,_,_)") == 0) { fn = RAYLIBFN(InitWindow); break; }
            if(strcmp(signature, "CloseWindow()") == 0) { fn = RAYLIBFN(CloseWindow); break; }
            if(strcmp(signature, "WindowShouldClose()") == 0) { fn = RAYLIBFN(WindowShouldClose); break; }
            if(strcmp(signature, "IsWindowReady()") == 0) { fn = RAYLIBFN(IsWindowReady); break; }
            if(strcmp(signature, "IsWindowFullscreen()") == 0) { fn = RAYLIBFN(IsWindowFullscreen); break; }
            if(strcmp(signature, "IsWindowHidden()") == 0) { fn = RAYLIBFN(IsWindowHidden); break; }
            if(strcmp(signature, "IsWindowMinimized()") == 0) { fn = RAYLIBFN(IsWindowMinimized); break; }
            if(strcmp(signature, "IsWindowMaximized()") == 0) { fn = RAYLIBFN(IsWindowMaximized); break; }
            if(strcmp(signature, "IsWindowFocused()") == 0) { fn = RAYLIBFN(IsWindowFocused); break; }
            if(strcmp(signature, "IsWindowResized()") == 0) { fn = RAYLIBFN(IsWindowResized); break; }
            if(strcmp(signature, "IsWindowState(_)") == 0) { fn = RAYLIBFN(IsWindowState); break; }
            if(strcmp(signature, "SetWindowState(_)") == 0) { fn = RAYLIBFN(SetWindowState); break; }
            if(strcmp(signature, "ClearWindowState(_)") == 0) { fn = RAYLIBFN(ClearWindowState); break; }
            if(strcmp(signature, "ToggleFullscreen()") == 0) { fn = RAYLIBFN(ToggleFullscreen); break; }
            if(strcmp(signature, "ToggleBorderlessWindowed()") == 0) { fn = RAYLIBFN(ToggleBorderlessWindowed); break; }
            if(strcmp(signature, "MaximizeWindow()") == 0) { fn = RAYLIBFN(MaximizeWindow); break; }
            if(strcmp(signature, "MinimizeWindow()") == 0) { fn = RAYLIBFN(MinimizeWindow); break; }
            if(strcmp(signature, "RestoreWindow()") == 0) { fn = RAYLIBFN(RestoreWindow); break; }
            if(strcmp(signature, "SetWindowIcon(_)") == 0) { fn = RAYLIBFN(SetWindowIcon); break; }
            if(strcmp(signature, "SetWindowIcons(_,_)") == 0) { fn = RAYLIBFN(SetWindowIcons); break; }
            if(strcmp(signature, "SetWindowTitle(_)") == 0) { fn = RAYLIBFN(SetWindowTitle); break; }
            if(strcmp(signature, "SetWindowPosition(_,_)") == 0) { fn = RAYLIBFN(SetWindowPosition); break; }
            if(strcmp(signature, "SetWindowMonitor(_)") == 0) { fn = RAYLIBFN(SetWindowMonitor); break; }
            if(strcmp(signature, "SetWindowMinSize(_,_)") == 0) { fn = RAYLIBFN(SetWindowMinSize); break; }
            if(strcmp(signature, "SetWindowMaxSize(_,_)") == 0) { fn = RAYLIBFN(SetWindowMaxSize); break; }
            if(strcmp(signature, "SetWindowSize(_,_)") == 0) { fn = RAYLIBFN(SetWindowSize); break; }
            if(strcmp(signature, "SetWindowOpacity(_)") == 0) { fn = RAYLIBFN(SetWindowOpacity); break; }
            if(strcmp(signature, "SetWindowFocused()") == 0) { fn = RAYLIBFN(SetWindowFocused); break; }
            // if(strcmp(signature, "GetWindowHandle()") == 0) { fn = RAYLIBFN(GetWindowHandle); break; }
            if(strcmp(signature, "GetScreenWidth()") == 0) { fn = RAYLIBFN(GetScreenWidth); break; }
            if(strcmp(signature, "GetScreenHeight()") == 0) { fn = RAYLIBFN(GetScreenHeight); break; }
            if(strcmp(signature, "GetRenderWidth()") == 0) { fn = RAYLIBFN(GetRenderWidth); break; }
            if(strcmp(signature, "GetRenderHeight()") == 0) { fn = RAYLIBFN(GetRenderHeight); break; }
            if(strcmp(signature, "GetMonitorCount()") == 0) { fn = RAYLIBFN(GetMonitorCount); break; }
            if(strcmp(signature, "GetCurrentMonitor()") == 0) { fn = RAYLIBFN(GetCurrentMonitor); break; }
            if(strcmp(signature, "GetMonitorPosition(_,_)") == 0) { fn = RAYLIBFN(GetMonitorPosition); break; }
            if(strcmp(signature, "GetMonitorWidth(_)") == 0) { fn = RAYLIBFN(GetMonitorWidth); break; }
            if(strcmp(signature, "GetMonitorHeight(_)") == 0) { fn = RAYLIBFN(GetMonitorHeight); break; }
            if(strcmp(signature, "GetMonitorPhysicalWidth(_)") == 0) { fn = RAYLIBFN(GetMonitorPhysicalWidth); break; }
            if(strcmp(signature, "GetMonitorPhysicalHeight(_)") == 0) { fn = RAYLIBFN(GetMonitorPhysicalHeight); break; }
            if(strcmp(signature, "GetMonitorRefreshRate(_)") == 0) { fn = RAYLIBFN(GetMonitorRefreshRate); break; }
            if(strcmp(signature, "GetWindowPosition(_)") == 0) { fn = RAYLIBFN(GetWindowPosition); break; }
            if(strcmp(signature, "GetWindowScaleDPI(_)") == 0) { fn = RAYLIBFN(GetWindowScaleDPI); break; }
            if(strcmp(signature, "GetMonitorName(_)") == 0) { fn = RAYLIBFN(GetMonitorName); break; }
            if(strcmp(signature, "SetClipboardText(_)") == 0) { fn = RAYLIBFN(SetClipboardText); break; }
            if(strcmp(signature, "GetClipboardText()") == 0) { fn = RAYLIBFN(GetClipboardText); break; }
            if(strcmp(signature, "EnableEventWaiting()") == 0) { fn = RAYLIBFN(EnableEventWaiting); break; }
            if(strcmp(signature, "DisableEventWaiting()") == 0) { fn = RAYLIBFN(DisableEventWaiting); break; }

            if(strcmp(signature, "ShowCursor()") == 0) { fn = RAYLIBFN(ShowCursor); break; }
            if(strcmp(signature, "HideCursor()") == 0) { fn = RAYLIBFN(HideCursor); break; }
            if(strcmp(signature, "IsCursorHidden()") == 0) { fn = RAYLIBFN(IsCursorHidden); break; }
            if(strcmp(signature, "EnableCursor()") == 0) { fn = RAYLIBFN(EnableCursor); break; }
            if(strcmp(signature, "DisableCursor()") == 0) { fn = RAYLIBFN(DisableCursor); break; }
            if(strcmp(signature, "IsCursorOnScreen()") == 0) { fn = RAYLIBFN(IsCursorOnScreen); break; }

            if(strcmp(signature, "ClearBackground(_)") == 0) { fn = RAYLIBFN(ClearBackground); break; }
            if(strcmp(signature, "BeginDrawing()") == 0) { fn = RAYLIBFN(BeginDrawing); break; }
            if(strcmp(signature, "EndDrawing()") == 0) { fn = RAYLIBFN(EndDrawing); break; }
            if(strcmp(signature, "BeginMode2D(_)") == 0) { fn = RAYLIBFN(BeginMode2D); break; }
            if(strcmp(signature, "EndMode2D()") == 0) { fn = RAYLIBFN(EndMode2D); break; }
            if(strcmp(signature, "BeginMode3D(_)") == 0) { fn = RAYLIBFN(BeginMode3D); break; }
            if(strcmp(signature, "EndMode3D()") == 0) { fn = RAYLIBFN(EndMode3D); break; }
            if(strcmp(signature, "BeginTextureMode(_)") == 0) { fn = RAYLIBFN(BeginTextureMode); break; }
            if(strcmp(signature, "EndTextureMode()") == 0) { fn = RAYLIBFN(EndTextureMode); break; }
            if(strcmp(signature, "BeginShaderMode(_)") == 0) { fn = RAYLIBFN(BeginShaderMode); break; }
            if(strcmp(signature, "EndShaderMode()") == 0) { fn = RAYLIBFN(EndShaderMode); break; }
            if(strcmp(signature, "BeginBlendMode(_)") == 0) { fn = RAYLIBFN(BeginBlendMode); break; }
            if(strcmp(signature, "EndBlendMode()") == 0) { fn = RAYLIBFN(EndBlendMode); break; }
            if(strcmp(signature, "BeginScissorMode(_,_,_,_)") == 0) { fn = RAYLIBFN(BeginScissorMode); break; }
            if(strcmp(signature, "EndScissorMode()") == 0) { fn = RAYLIBFN(EndScissorMode); break; }
            if(strcmp(signature, "BeginVrStereoMode(_)") == 0) { fn = RAYLIBFN(BeginVrStereoMode); break; }
            if(strcmp(signature, "EndVrStereoMode()") == 0) { fn = RAYLIBFN(EndVrStereoMode); break; }

            if(strcmp(signature, "LoadVrStereoConfig(_,_)") == 0) { fn = RAYLIBFN(LoadVrStereoConfig); break; }
            if(strcmp(signature, "UnloadVrStereoConfig(_)") == 0) { fn = RAYLIBFN(UnloadVrStereoConfig); break; }

            if(strcmp(signature, "LoadShader(_,_,_)") == 0) { fn = RAYLIBFN(LoadShader); break; } 
            if(strcmp(signature, "LoadShaderFromMemory(_,_,_)") == 0) { fn = RAYLIBFN(LoadShaderFromMemory); break; } 
            if(strcmp(signature, "IsShaderReady(_)") == 0) { fn = RAYLIBFN(IsShaderReady); break; } 
            if(strcmp(signature, "GetShaderLocation(_,_)") == 0) { fn = RAYLIBFN(GetShaderLocation); break; } 
            if(strcmp(signature, "GetShaderLocationAttrib(_,_)") == 0) { fn = RAYLIBFN(GetShaderLocationAttrib); break; } 
            if(strcmp(signature, "SetShaderValue(_,_,_,_)") == 0) { fn = RAYLIBFN(SetShaderValue); break; } 
            if(strcmp(signature, "SetShaderValueV(_,_,_,_,_)") == 0) { fn = RAYLIBFN(SetShaderValueV); break; } 
            if(strcmp(signature, "SetShaderValueMatrix(_,_,_)") == 0) { fn = RAYLIBFN(SetShaderValueMatrix); break; } 
            if(strcmp(signature, "SetShaderValueTexture(_,_,_)") == 0) { fn = RAYLIBFN(SetShaderValueTexture); break; } 
            if(strcmp(signature, "UnloadShader(_)") == 0) { fn = RAYLIBFN(UnloadShader); break; } 

            if(strcmp(signature, "GetMouseRay(_,_,_)") == 0) { fn = RAYLIBFN(GetMouseRay); break; } 
            if(strcmp(signature, "GetCameraMatrix(_,_)") == 0) { fn = RAYLIBFN(GetCameraMatrix); break; } 
            if(strcmp(signature, "GetCameraMatrix2D(_,_)") == 0) { fn = RAYLIBFN(GetCameraMatrix2D); break; } 
            if(strcmp(signature, "GetWorldToScreen(_,_,_)") == 0) { fn = RAYLIBFN(GetWorldToScreen); break; } 
            if(strcmp(signature, "GetScreenToWorld2D(_,_,_)") == 0) { fn = RAYLIBFN(GetScreenToWorld2D); break; } 
            if(strcmp(signature, "GetWorldToScreenEx(_,_,_,_,_)") == 0) { fn = RAYLIBFN(GetWorldToScreenEx); break; } 
            if(strcmp(signature, "GetWorldToScreen2D(_,_,_)") == 0) { fn = RAYLIBFN(GetWorldToScreen2D); break; } 

            if(strcmp(signature, "SetTargetFPS(_)") == 0) { fn = RAYLIBFN(SetTargetFPS); break; } 
            if(strcmp(signature, "GetFrameTime()") == 0) { fn = RAYLIBFN(GetFrameTime); break; } 
            if(strcmp(signature, "GetTime()") == 0) { fn = RAYLIBFN(GetTime); break; } 
            if(strcmp(signature, "GetFPS()") == 0) { fn = RAYLIBFN(GetFPS); break; } 

            if(strcmp(signature, "SwapScreenBuffer()") == 0) { fn = RAYLIBFN(SwapScreenBuffer); break; } 
            if(strcmp(signature, "PollInputEvents()") == 0) { fn = RAYLIBFN(PollInputEvents); break; } 
            if(strcmp(signature, "WaitTime(_)") == 0) { fn = RAYLIBFN(WaitTime); break; } 

            if(strcmp(signature, "SetRandomSeed(_)") == 0) { fn = RAYLIBFN(SetRandomSeed); break; } 
            if(strcmp(signature, "GetRandomValue(_,_)") == 0) { fn = RAYLIBFN(GetRandomValue); break; } 
            if(strcmp(signature, "LoadRandomSequence(_,_,_,_)") == 0) { fn = RAYLIBFN(LoadRandomSequence); break; } 
            if(strcmp(signature, "UnloadRandomSequence(_)") == 0) { fn = RAYLIBFN(UnloadRandomSequence); break; } 

            if(strcmp(signature, "TakeScreenshot(_)") == 0) { fn = RAYLIBFN(TakeScreenshot); break; } 
            if(strcmp(signature, "SetConfigFlags(_)") == 0) { fn = RAYLIBFN(SetConfigFlags); break; } 
            if(strcmp(signature, "OpenURL(_)") == 0) { fn = RAYLIBFN(OpenURL); break; } 

            if(strcmp(signature, "LoadFileData(_,_)") == 0) { fn = RAYLIBFN(LoadFileData); break; } 
            if(strcmp(signature, "UnloadFileData(_)") == 0) { fn = RAYLIBFN(UnloadFileData); break; } 
            if(strcmp(signature, "SaveFileData(_,_,_)") == 0) { fn = RAYLIBFN(SaveFileData); break; } 
            if(strcmp(signature, "ExportDataAsCode(_,_,_)") == 0) { fn = RAYLIBFN(ExportDataAsCode); break; } 
            if(strcmp(signature, "LoadFileText(_)") == 0) { fn = RAYLIBFN(LoadFileText); break; } 
            if(strcmp(signature, "UnloadFileText(_)") == 0) { fn = RAYLIBFN(UnloadFileText); break; } 
            if(strcmp(signature, "SaveFileText(_,_)") == 0) { fn = RAYLIBFN(SaveFileText); break; } 

            if(strcmp(signature, "FileExists(_)") == 0) { fn = RAYLIBFN(FileExists); break; } 
            if(strcmp(signature, "DirectoryExists(_)") == 0) { fn = RAYLIBFN(DirectoryExists); break; } 
            if(strcmp(signature, "IsFileExtension(_,_)") == 0) { fn = RAYLIBFN(IsFileExtension); break; } 
            if(strcmp(signature, "GetFileLength(_)") == 0) { fn = RAYLIBFN(GetFileLength); break; } 
            if(strcmp(signature, "GetFileExtension(_)") == 0) { fn = RAYLIBFN(GetFileExtension); break; } 
            if(strcmp(signature, "GetFileName(_)") == 0) { fn = RAYLIBFN(GetFileName); break; } 
            if(strcmp(signature, "GetFileNameWithoutExt(_)") == 0) { fn = RAYLIBFN(GetFileNameWithoutExt); break; } 
            if(strcmp(signature, "GetDirectoryPath(_)") == 0) { fn = RAYLIBFN(GetDirectoryPath); break; } 
            if(strcmp(signature, "GetPrevDirectoryPath(_)") == 0) { fn = RAYLIBFN(GetPrevDirectoryPath); break; } 
            if(strcmp(signature, "GetWorkingDirectory()") == 0) { fn = RAYLIBFN(GetWorkingDirectory); break; } 
            if(strcmp(signature, "GetApplicationDirectory()") == 0) { fn = RAYLIBFN(GetApplicationDirectory); break; } 
            if(strcmp(signature, "ChangeDirectory(_)") == 0) { fn = RAYLIBFN(ChangeDirectory); break; } 
            if(strcmp(signature, "IsPathFile(_)") == 0) { fn = RAYLIBFN(IsPathFile); break; } 
            if(strcmp(signature, "LoadDirectoryFiles(_,_)") == 0) { fn = RAYLIBFN(LoadDirectoryFiles); break; } 
            if(strcmp(signature, "LoadDirectoryFilesEx(_,_,_,_)") == 0) { fn = RAYLIBFN(LoadDirectoryFilesEx); break; } 
            if(strcmp(signature, "UnloadDirectoryFiles(_)") == 0) { fn = RAYLIBFN(UnloadDirectoryFiles); break; } 
            if(strcmp(signature, "IsFileDropped()") == 0) { fn = RAYLIBFN(IsFileDropped); break; } 
            if(strcmp(signature, "LoadDroppedFiles(_)") == 0) { fn = RAYLIBFN(LoadDroppedFiles); break; } 
            if(strcmp(signature, "UnloadDroppedFiles(_)") == 0) { fn = RAYLIBFN(UnloadDroppedFiles); break; } 
            if(strcmp(signature, "GetFileModTime(_)") == 0) { fn = RAYLIBFN(GetFileModTime); break; } 

            if(strcmp(signature, "CompressData(_,_,_)") == 0) { fn = RAYLIBFN(CompressData); break; } 
            if(strcmp(signature, "DecompressData(_,_,_)") == 0) { fn = RAYLIBFN(DecompressData); break; } 
            if(strcmp(signature, "EncodeDataBase64(_,_,_)") == 0) { fn = RAYLIBFN(EncodeDataBase64); break; } 
            if(strcmp(signature, "DecodeDataBase64(_,_)") == 0) { fn = RAYLIBFN(DecodeDataBase64); break; } 

            if(strcmp(signature, "LoadAutomationEventList(_,_)") == 0) { fn = RAYLIBFN(LoadAutomationEventList); break; } 
            if(strcmp(signature, "UnloadAutomationEventList(_)") == 0) { fn = RAYLIBFN(UnloadAutomationEventList); break; } 
            if(strcmp(signature, "ExportAutomationEventList(_,_)") == 0) { fn = RAYLIBFN(ExportAutomationEventList); break; } 
            if(strcmp(signature, "SetAutomationEventList(_)") == 0) { fn = RAYLIBFN(SetAutomationEventList); break; } 
            if(strcmp(signature, "SetAutomationEventBaseFrame(_)") == 0) { fn = RAYLIBFN(SetAutomationEventBaseFrame); break; } 
            if(strcmp(signature, "StartAutomationEventRecording()") == 0) { fn = RAYLIBFN(StartAutomationEventRecording); break; } 
            if(strcmp(signature, "StopAutomationEventRecording()") == 0) { fn = RAYLIBFN(StopAutomationEventRecording); break; } 
            if(strcmp(signature, "PlayAutomationEvent(_)") == 0) { fn = RAYLIBFN(PlayAutomationEvent); break; } 

            if(strcmp(signature, "IsKeyPressed(_)") == 0) { fn = RAYLIBFN(IsKeyPressed); break; } 
            if(strcmp(signature, "IsKeyPressedRepeat(_)") == 0) { fn = RAYLIBFN(IsKeyPressedRepeat); break; } 
            if(strcmp(signature, "IsKeyDown(_)") == 0) { fn = RAYLIBFN(IsKeyDown); break; } 
            if(strcmp(signature, "IsKeyReleased(_)") == 0) { fn = RAYLIBFN(IsKeyReleased); break; } 
            if(strcmp(signature, "IsKeyUp(_)") == 0) { fn = RAYLIBFN(IsKeyUp); break; } 
            if(strcmp(signature, "GetKeyPressed()") == 0) { fn = RAYLIBFN(GetKeyPressed); break; } 
            if(strcmp(signature, "GetCharPressed()") == 0) { fn = RAYLIBFN(GetCharPressed); break; } 
            if(strcmp(signature, "SetExitKey(_)") == 0) { fn = RAYLIBFN(SetExitKey); break; } 

            if(strcmp(signature, "IsGamepadAvailable(_)") == 0) { fn = RAYLIBFN(IsGamepadAvailable); break; } 
            if(strcmp(signature, "GetGamepadName(_)") == 0) { fn = RAYLIBFN(GetGamepadName); break; } 
            if(strcmp(signature, "IsGamepadButtonPressed(_,_)") == 0) { fn = RAYLIBFN(IsGamepadButtonPressed); break; } 
            if(strcmp(signature, "IsGamepadButtonDown(_,_)") == 0) { fn = RAYLIBFN(IsGamepadButtonDown); break; } 
            if(strcmp(signature, "IsGamepadButtonReleased(_,_)") == 0) { fn = RAYLIBFN(IsGamepadButtonReleased); break; } 
            if(strcmp(signature, "IsGamepadButtonUp(_,_)") == 0) { fn = RAYLIBFN(IsGamepadButtonUp); break; } 
            if(strcmp(signature, "GetGamepadButtonPressed()") == 0) { fn = RAYLIBFN(GetGamepadButtonPressed); break; } 
            if(strcmp(signature, "GetGamepadAxisCount(_)") == 0) { fn = RAYLIBFN(GetGamepadAxisCount); break; } 
            if(strcmp(signature, "GetGamepadAxisMovement(_,_)") == 0) { fn = RAYLIBFN(GetGamepadAxisMovement); break; } 
            if(strcmp(signature, "SetGamepadMappings(_)") == 0) { fn = RAYLIBFN(SetGamepadMappings); break; } 

            if(strcmp(signature, "IsMouseButtonPressed(_)") == 0) { fn = RAYLIBFN(IsMouseButtonPressed); break; } 
            if(strcmp(signature, "IsMouseButtonDown(_)") == 0) { fn = RAYLIBFN(IsMouseButtonDown); break; } 
            if(strcmp(signature, "IsMouseButtonReleased(_)") == 0) { fn = RAYLIBFN(IsMouseButtonReleased); break; } 
            if(strcmp(signature, "IsMouseButtonUp(_)") == 0) { fn = RAYLIBFN(IsMouseButtonUp); break; } 
            if(strcmp(signature, "GetMouseX()") == 0) { fn = RAYLIBFN(GetMouseX); break; } 
            if(strcmp(signature, "GetMouseY()") == 0) { fn = RAYLIBFN(GetMouseY); break; } 
            if(strcmp(signature, "GetMousePosition(_)") == 0) { fn = RAYLIBFN(GetMousePosition); break; } 
            if(strcmp(signature, "GetMouseDelta(_)") == 0) { fn = RAYLIBFN(GetMouseDelta); break; } 
            if(strcmp(signature, "SetMousePosition(_,_)") == 0) { fn = RAYLIBFN(SetMousePosition); break; } 
            if(strcmp(signature, "SetMouseOffset(_,_)") == 0) { fn = RAYLIBFN(SetMouseOffset); break; } 
            if(strcmp(signature, "SetMouseScale(_,_)") == 0) { fn = RAYLIBFN(SetMouseScale); break; } 
            if(strcmp(signature, "GetMouseWheelMove()") == 0) { fn = RAYLIBFN(GetMouseWheelMove); break; } 
            if(strcmp(signature, "GetMouseWheelMoveV(_)") == 0) { fn = RAYLIBFN(GetMouseWheelMoveV); break; } 
            if(strcmp(signature, "SetMouseCursor(_)") == 0) { fn = RAYLIBFN(SetMouseCursor); break; } 

            if(strcmp(signature, "GetTouchX()") == 0) { fn = RAYLIBFN(GetTouchX); break; } 
            if(strcmp(signature, "GetTouchY()") == 0) { fn = RAYLIBFN(GetTouchY); break; } 
            if(strcmp(signature, "GetTouchPosition(_,_)") == 0) { fn = RAYLIBFN(GetTouchPosition); break; } 
            if(strcmp(signature, "GetTouchPointId(_)") == 0) { fn = RAYLIBFN(GetTouchPointId); break; } 
            if(strcmp(signature, "GetTouchPointCount()") == 0) { fn = RAYLIBFN(GetTouchPointCount); break; } 

            if(strcmp(signature, "SetGesturesEnabled(_)") == 0) { fn = RAYLIBFN(SetGesturesEnabled); break; } 
            if(strcmp(signature, "IsGestureDetected(_)") == 0) { fn = RAYLIBFN(IsGestureDetected); break; } 
            if(strcmp(signature, "GetGestureDetected()") == 0) { fn = RAYLIBFN(GetGestureDetected); break; } 
            if(strcmp(signature, "GetGestureHoldDuration()") == 0) { fn = RAYLIBFN(GetGestureHoldDuration); break; } 
            if(strcmp(signature, "GetGestureDragVector(_)") == 0) { fn = RAYLIBFN(GetGestureDragVector); break; } 
            if(strcmp(signature, "GetGestureDragAngle()") == 0) { fn = RAYLIBFN(GetGestureDragAngle); break; } 
            if(strcmp(signature, "GetGesturePinchVector(_)") == 0) { fn = RAYLIBFN(GetGesturePinchVector); break; } 
            if(strcmp(signature, "GetGesturePinchAngle()") == 0) { fn = RAYLIBFN(GetGesturePinchAngle); break; } 

            if(strcmp(signature, "UpdateCamera(_,_)") == 0) { fn = RAYLIBFN(UpdateCamera); break; }
            if(strcmp(signature, "UpdateCameraPro(_,_,_,_)") == 0) { fn = RAYLIBFN(UpdateCameraPro); break; }

            if(strcmp(signature, "SetShapesTexture(_,_)") == 0) { fn = RAYLIBFN(SetShapesTexture); break; }

            if(strcmp(signature, "DrawPixel(_,_,_)") == 0) { fn = RAYLIBFN(DrawPixel); break; }
            if(strcmp(signature, "DrawPixelV(_,_)") == 0) { fn = RAYLIBFN(DrawPixelV); break; }
            if(strcmp(signature, "DrawLine(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawLine); break; }
            if(strcmp(signature, "DrawLineV(_,_,_)") == 0) { fn = RAYLIBFN(DrawLineV); break; }
            if(strcmp(signature, "DrawLineEx(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawLineEx); break; }
            if(strcmp(signature, "DrawLineStrip(_,_,_)") == 0) { fn = RAYLIBFN(DrawLineStrip); break; }
            if(strcmp(signature, "DrawLineBezier(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawLineBezier); break; }
            if(strcmp(signature, "DrawCircle(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawCircle); break; }
            if(strcmp(signature, "DrawCircleSector(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawCircleSector); break; }
            if(strcmp(signature, "DrawCircleSectorLines(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawCircleSectorLines); break; }
            if(strcmp(signature, "DrawCircleGradient(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawCircleGradient); break; }
            if(strcmp(signature, "DrawCircleV(_,_,_)") == 0) { fn = RAYLIBFN(DrawCircleV); break; }
            if(strcmp(signature, "DrawCircleLines(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawCircleLines); break; }
            if(strcmp(signature, "DrawCircleLinesV(_,_,_)") == 0) { fn = RAYLIBFN(DrawCircleLinesV); break; }
            if(strcmp(signature, "DrawEllipse(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawEllipse); break; }
            if(strcmp(signature, "DrawEllipseLines(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawEllipseLines); break; }
            if(strcmp(signature, "DrawRing(_,_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawRing); break; }
            if(strcmp(signature, "DrawRingLines(_,_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawRingLines); break; }
            if(strcmp(signature, "DrawRectangle(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawRectangle); break; }
            if(strcmp(signature, "DrawRectangleV(_,_,_)") == 0) { fn = RAYLIBFN(DrawRectangleV); break; }
            if(strcmp(signature, "DrawRectangleRec(_,_)") == 0) { fn = RAYLIBFN(DrawRectangleRec); break; }
            if(strcmp(signature, "DrawRectanglePro(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawRectanglePro); break; }
            if(strcmp(signature, "DrawRectangleGradientV(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawRectangleGradientV); break; }
            if(strcmp(signature, "DrawRectangleGradientH(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawRectangleGradientH); break; }
            if(strcmp(signature, "DrawRectangleGradientEx(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawRectangleGradientEx); break; }
            if(strcmp(signature, "DrawRectangleLines(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawRectangleLines); break; }
            if(strcmp(signature, "DrawRectangleLinesEx(_,_,_)") == 0) { fn = RAYLIBFN(DrawRectangleLinesEx); break; }
            if(strcmp(signature, "DrawRectangleRounded(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawRectangleRounded); break; }
            if(strcmp(signature, "DrawRectangleRoundedLines(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawRectangleRoundedLines); break; }
            if(strcmp(signature, "DrawTriangle(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawTriangle); break; }
            if(strcmp(signature, "DrawTriangleLines(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawTriangleLines); break; }
            if(strcmp(signature, "DrawTriangleFan(_,_,_)") == 0) { fn = RAYLIBFN(DrawTriangleFan); break; }
            if(strcmp(signature, "DrawTriangleStrip(_,_,_)") == 0) { fn = RAYLIBFN(DrawTriangleStrip); break; }
            if(strcmp(signature, "DrawPoly(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawPoly); break; }
            if(strcmp(signature, "DrawPolyLines(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawPolyLines); break; }
            if(strcmp(signature, "DrawPolyLinesEx(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawPolyLinesEx); break; }

            if(strcmp(signature, "DrawSplineLinear(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawSplineLinear); break; }
            if(strcmp(signature, "DrawSplineBasis(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawSplineBasis); break; }
            if(strcmp(signature, "DrawSplineCatmullRom(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawSplineCatmullRom); break; }
            if(strcmp(signature, "DrawSplineBezierQuadratic(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawSplineBezierQuadratic); break; }
            if(strcmp(signature, "DrawSplineBezierCubic(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawSplineBezierCubic); break; }
            if(strcmp(signature, "DrawSplineSegmentLinear(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawSplineSegmentLinear); break; }
            if(strcmp(signature, "DrawSplineSegmentBasis(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawSplineSegmentBasis); break; }
            if(strcmp(signature, "DrawSplineSegmentCatmullRom(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawSplineSegmentCatmullRom); break; }
            if(strcmp(signature, "DrawSplineSegmentBezierQuadratic(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawSplineSegmentBezierQuadratic); break; }
            if(strcmp(signature, "DrawSplineSegmentBezierCubic(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawSplineSegmentBezierCubic); break; }

            if(strcmp(signature, "GetSplinePointLinear(_,_,_)") == 0) { fn = RAYLIBFN(GetSplinePointLinear); break; }
            if(strcmp(signature, "GetSplinePointBasis(_,_,_,_,_)") == 0) { fn = RAYLIBFN(GetSplinePointBasis); break; }
            if(strcmp(signature, "GetSplinePointCatmullRom(_,_,_,_,_)") == 0) { fn = RAYLIBFN(GetSplinePointCatmullRom); break; }
            if(strcmp(signature, "GetSplinePointBezierQuad(_,_,_,_)") == 0) { fn = RAYLIBFN(GetSplinePointBezierQuad); break; }
            if(strcmp(signature, "GetSplinePointBezierCubic(_,_,_,_,_)") == 0) { fn = RAYLIBFN(GetSplinePointBezierCubic); break; }

            if(strcmp(signature, "CheckCollisionRecs(_,_)") == 0) { fn = RAYLIBFN(CheckCollisionRecs); break; }
            if(strcmp(signature, "CheckCollisionCircles(_,_,_,_)") == 0) { fn = RAYLIBFN(CheckCollisionCircles); break; }
            if(strcmp(signature, "CheckCollisionCircleRec(_,_,_)") == 0) { fn = RAYLIBFN(CheckCollisionCircleRec); break; }
            if(strcmp(signature, "CheckCollisionPointRec(_,_)") == 0) { fn = RAYLIBFN(CheckCollisionPointRec); break; }
            if(strcmp(signature, "CheckCollisionPointCircle(_,_,_)") == 0) { fn = RAYLIBFN(CheckCollisionPointCircle); break; }
            if(strcmp(signature, "CheckCollisionPointTriangle(_,_,_,_)") == 0) { fn = RAYLIBFN(CheckCollisionPointTriangle); break; }
            if(strcmp(signature, "CheckCollisionPointPoly(_,_,_)") == 0) { fn = RAYLIBFN(CheckCollisionPointPoly); break; }
            if(strcmp(signature, "CheckCollisionLines(_,_,_,_,_)") == 0) { fn = RAYLIBFN(CheckCollisionLines); break; }
            if(strcmp(signature, "CheckCollisionPointLine(_,_,_,_)") == 0) { fn = RAYLIBFN(CheckCollisionPointLine); break; }
            if(strcmp(signature, "GetCollisionRec(_,_,_)") == 0) { fn = RAYLIBFN(GetCollisionRec); break; }

            if(strcmp(signature, "LoadImage(_,_)") == 0) { fn = RAYLIBFN(LoadImage); break; }
            if(strcmp(signature, "LoadImageRaw(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(LoadImageRaw); break; }
            if(strcmp(signature, "LoadImageSvg(_,_,_,_)") == 0) { fn = RAYLIBFN(LoadImageSvg); break; }
            if(strcmp(signature, "LoadImageAnim(_,_,_)") == 0) { fn = RAYLIBFN(LoadImageAnim); break; }
            if(strcmp(signature, "LoadImageFromMemory(_,_,_,_)") == 0) { fn = RAYLIBFN(LoadImageFromMemory); break; }
            if(strcmp(signature, "LoadImageFromTexture(_,_)") == 0) { fn = RAYLIBFN(LoadImageFromTexture); break; }
            if(strcmp(signature, "LoadImageFromScreen(_)") == 0) { fn = RAYLIBFN(LoadImageFromScreen); break; }
            if(strcmp(signature, "IsImageReady(_)") == 0) { fn = RAYLIBFN(IsImageReady); break; }
            if(strcmp(signature, "UnloadImage(_)") == 0) { fn = RAYLIBFN(UnloadImage); break; }
            if(strcmp(signature, "ExportImage(_,_)") == 0) { fn = RAYLIBFN(ExportImage); break; }
            if(strcmp(signature, "ExportImageToMemory(_,_,_)") == 0) { fn = RAYLIBFN(ExportImageToMemory); break; }
            if(strcmp(signature, "ExportImageAsCode(_,_)") == 0) { fn = RAYLIBFN(ExportImageAsCode); break; }

            if(strcmp(signature, "GenImageColor(_,_,_,_)") == 0) { fn = RAYLIBFN(GenImageColor); break; }
            if(strcmp(signature, "GenImageGradientLinear(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(GenImageGradientLinear); break; }
            if(strcmp(signature, "GenImageGradientRadial(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(GenImageGradientRadial); break; }
            if(strcmp(signature, "GenImageGradientSquare(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(GenImageGradientSquare); break; }
            if(strcmp(signature, "GenImageChecked(_,_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(GenImageChecked); break; }
            if(strcmp(signature, "GenImageWhiteNoise(_,_,_,_)") == 0) { fn = RAYLIBFN(GenImageWhiteNoise); break; }
            if(strcmp(signature, "GenImagePerlinNoise(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(GenImagePerlinNoise); break; }
            if(strcmp(signature, "GenImageCellular(_,_,_,_)") == 0) { fn = RAYLIBFN(GenImageCellular); break; }
            if(strcmp(signature, "GenImageText(_,_,_,_)") == 0) { fn = RAYLIBFN(GenImageText); break; }

            if(strcmp(signature, "ImageCopy(_,_)") == 0) { fn = RAYLIBFN(ImageCopy); break; }
            if(strcmp(signature, "ImageFromImage(_,_,_)") == 0) { fn = RAYLIBFN(ImageFromImage); break; }
            if(strcmp(signature, "ImageText(_,_,_,_)") == 0) { fn = RAYLIBFN(ImageText); break; }
            if(strcmp(signature, "ImageTextEx(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(ImageTextEx); break; }
            if(strcmp(signature, "ImageFormat(_,_)") == 0) { fn = RAYLIBFN(ImageFormat); break; }
            if(strcmp(signature, "ImageToPOT(_,_)") == 0) { fn = RAYLIBFN(ImageToPOT); break; }
            if(strcmp(signature, "ImageCrop(_,_)") == 0) { fn = RAYLIBFN(ImageCrop); break; }
            if(strcmp(signature, "ImageAlphaCrop(_,_)") == 0) { fn = RAYLIBFN(ImageAlphaCrop); break; }
            if(strcmp(signature, "ImageAlphaClear(_,_,_)") == 0) { fn = RAYLIBFN(ImageAlphaClear); break; }
            if(strcmp(signature, "ImageAlphaMask(_,_)") == 0) { fn = RAYLIBFN(ImageAlphaMask); break; }
            if(strcmp(signature, "ImageAlphaPremultiply(_)") == 0) { fn = RAYLIBFN(ImageAlphaPremultiply); break; }
            if(strcmp(signature, "ImageBlurGaussian(_,_)") == 0) { fn = RAYLIBFN(ImageBlurGaussian); break; }
            if(strcmp(signature, "ImageKernelConvolution(_,_,_)") == 0) { fn = RAYLIBFN(ImageKernelConvolution); break; }
            if(strcmp(signature, "ImageResize(_,_,_)") == 0) { fn = RAYLIBFN(ImageResize); break; }
            if(strcmp(signature, "ImageResizeNN(_,_,_)") == 0) { fn = RAYLIBFN(ImageResizeNN); break; }
            if(strcmp(signature, "ImageResizeCanvas(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(ImageResizeCanvas); break; }
            if(strcmp(signature, "ImageMipmaps(_)") == 0) { fn = RAYLIBFN(ImageMipmaps); break; }
            if(strcmp(signature, "ImageDither(_,_,_,_,_)") == 0) { fn = RAYLIBFN(ImageDither); break; }
            if(strcmp(signature, "ImageFlipVertical(_)") == 0) { fn = RAYLIBFN(ImageFlipVertical); break; }
            if(strcmp(signature, "ImageFlipHorizontal(_)") == 0) { fn = RAYLIBFN(ImageFlipHorizontal); break; }
            if(strcmp(signature, "ImageRotate(_,_)") == 0) { fn = RAYLIBFN(ImageRotate); break; }
            if(strcmp(signature, "ImageRotateCW(_)") == 0) { fn = RAYLIBFN(ImageRotateCW); break; }
            if(strcmp(signature, "ImageRotateCCW(_)") == 0) { fn = RAYLIBFN(ImageRotateCCW); break; }
            if(strcmp(signature, "ImageColorTint(_,_)") == 0) { fn = RAYLIBFN(ImageColorTint); break; }
            if(strcmp(signature, "ImageColorInvert(_)") == 0) { fn = RAYLIBFN(ImageColorInvert); break; }
            if(strcmp(signature, "ImageColorGrayscale(_)") == 0) { fn = RAYLIBFN(ImageColorGrayscale); break; }
            if(strcmp(signature, "ImageColorContrast(_,_)") == 0) { fn = RAYLIBFN(ImageColorContrast); break; }
            if(strcmp(signature, "ImageColorBrightness(_,_)") == 0) { fn = RAYLIBFN(ImageColorBrightness); break; }
            if(strcmp(signature, "ImageColorReplace(_,_,_)") == 0) { fn = RAYLIBFN(ImageColorReplace); break; }
            if(strcmp(signature, "LoadImageColors(_,_)") == 0) { fn = RAYLIBFN(LoadImageColors); break; }
            if(strcmp(signature, "LoadImagePalette(_,_,_,_)") == 0) { fn = RAYLIBFN(LoadImagePalette); break; }
            if(strcmp(signature, "UnloadImageColors(_)") == 0) { fn = RAYLIBFN(UnloadImageColors); break; }
            if(strcmp(signature, "UnloadImagePalette(_)") == 0) { fn = RAYLIBFN(UnloadImagePalette); break; }
            if(strcmp(signature, "GetImageAlphaBorder(_,_,_)") == 0) { fn = RAYLIBFN(GetImageAlphaBorder); break; }
            if(strcmp(signature, "GetImageColor(_,_,_,_)") == 0) { fn = RAYLIBFN(GetImageColor); break; }

            if(strcmp(signature, "ImageClearBackground(_,_)") == 0) { fn = RAYLIBFN(ImageClearBackground); break; }
            if(strcmp(signature, "ImageDrawPixel(_,_,_,_)") == 0) { fn = RAYLIBFN(ImageDrawPixel); break; }
            if(strcmp(signature, "ImageDrawPixelV(_,_,_)") == 0) { fn = RAYLIBFN(ImageDrawPixelV); break; }
            if(strcmp(signature, "ImageDrawLine(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(ImageDrawLine); break; }
            if(strcmp(signature, "ImageDrawLineV(_,_,_,_)") == 0) { fn = RAYLIBFN(ImageDrawLineV); break; }
            if(strcmp(signature, "ImageDrawCircle(_,_,_,_,_)") == 0) { fn = RAYLIBFN(ImageDrawCircle); break; }
            if(strcmp(signature, "ImageDrawCircleV(_,_,_,_)") == 0) { fn = RAYLIBFN(ImageDrawCircleV); break; }
            if(strcmp(signature, "ImageDrawCircleLines(_,_,_,_,_)") == 0) { fn = RAYLIBFN(ImageDrawCircleLines); break; }
            if(strcmp(signature, "ImageDrawCircleLinesV(_,_,_,_)") == 0) { fn = RAYLIBFN(ImageDrawCircleLinesV); break; }
            if(strcmp(signature, "ImageDrawRectangle(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(ImageDrawRectangle); break; }
            if(strcmp(signature, "ImageDrawRectangleV(_,_,_,_)") == 0) { fn = RAYLIBFN(ImageDrawRectangleV); break; }
            if(strcmp(signature, "ImageDrawRectangleRec(_,_,_)") == 0) { fn = RAYLIBFN(ImageDrawRectangleRec); break; }
            if(strcmp(signature, "ImageDrawRectangleLines(_,_,_,_)") == 0) { fn = RAYLIBFN(ImageDrawRectangleLines); break; }
            if(strcmp(signature, "ImageDraw(_,_,_,_,_)") == 0) { fn = RAYLIBFN(ImageDraw); break; }
            if(strcmp(signature, "ImageDrawText(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(ImageDrawText); break; }
            if(strcmp(signature, "ImageDrawTextEx(_,_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(ImageDrawTextEx); break; }

            if(strcmp(signature, "LoadTexture(_,_)") == 0) { fn = RAYLIBFN(LoadTexture); break; }
            if(strcmp(signature, "LoadTextureFromImage(_,_)") == 0) { fn = RAYLIBFN(LoadTextureFromImage); break; }
            if(strcmp(signature, "LoadTextureCubemap(_,_,_)") == 0) { fn = RAYLIBFN(LoadTextureCubemap); break; }
            if(strcmp(signature, "LoadRenderTexture(_,_,_)") == 0) { fn = RAYLIBFN(LoadRenderTexture); break; }
            if(strcmp(signature, "IsTextureReady(_)") == 0) { fn = RAYLIBFN(IsTextureReady); break; }
            if(strcmp(signature, "UnloadTexture(_)") == 0) { fn = RAYLIBFN(UnloadTexture); break; }
            if(strcmp(signature, "IsRenderTextureReady(_)") == 0) { fn = RAYLIBFN(IsRenderTextureReady); break; }
            if(strcmp(signature, "UnloadRenderTexture(_)") == 0) { fn = RAYLIBFN(UnloadRenderTexture); break; }
            if(strcmp(signature, "UpdateTexture(_,_)") == 0) { fn = RAYLIBFN(UpdateTexture); break; }
            if(strcmp(signature, "UpdateTextureRec(_,_,_)") == 0) { fn = RAYLIBFN(UpdateTextureRec); break; }
            
            if(strcmp(signature, "GenTextureMipmaps(_)") == 0) { fn = RAYLIBFN(GenTextureMipmaps); break; }
            if(strcmp(signature, "SetTextureFilter(_,_)") == 0) { fn = RAYLIBFN(SetTextureFilter); break; }
            if(strcmp(signature, "SetTextureWrap(_,_)") == 0) { fn = RAYLIBFN(SetTextureWrap); break; }

            if(strcmp(signature, "DrawTexture(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawTexture); break; }
            if(strcmp(signature, "DrawTextureV(_,_,_)") == 0) { fn = RAYLIBFN(DrawTextureV); break; }
            if(strcmp(signature, "DrawTextureEx(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawTextureEx); break; }
            if(strcmp(signature, "DrawTextureRec(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawTextureRec); break; }
            if(strcmp(signature, "DrawTexturePro(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawTexturePro); break; }
            if(strcmp(signature, "DrawTextureNPatch(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawTextureNPatch); break; }

            if(strcmp(signature, "Fade(_,_,_)") == 0) { fn = RAYLIBFN(Fade); break; }
            if(strcmp(signature, "ColorToInt(_)") == 0) { fn = RAYLIBFN(ColorToInt); break; }
            if(strcmp(signature, "ColorNormalize(_,_)") == 0) { fn = RAYLIBFN(ColorNormalize); break; }
            if(strcmp(signature, "ColorFromNormalized(_,_)") == 0) { fn = RAYLIBFN(ColorFromNormalized); break; }
            if(strcmp(signature, "ColorToHSV(_,_)") == 0) { fn = RAYLIBFN(ColorToHSV); break; }
            if(strcmp(signature, "ColorFromHSV(_,_,_,_)") == 0) { fn = RAYLIBFN(ColorFromHSV); break; }
            if(strcmp(signature, "ColorTint(_,_,_)") == 0) { fn = RAYLIBFN(ColorTint); break; }
            if(strcmp(signature, "ColorBrightness(_,_,_)") == 0) { fn = RAYLIBFN(ColorBrightness); break; }
            if(strcmp(signature, "ColorContrast(_,_,_)") == 0) { fn = RAYLIBFN(ColorContrast); break; }
            if(strcmp(signature, "ColorAlpha(_,_,_)") == 0) { fn = RAYLIBFN(ColorAlpha); break; }
            if(strcmp(signature, "ColorAlphaBlend(_,_,_,_)") == 0) { fn = RAYLIBFN(ColorAlphaBlend); break; }
            if(strcmp(signature, "GetColor(_,_)") == 0) { fn = RAYLIBFN(GetColor); break; }
            if(strcmp(signature, "GetPixelColor(_,_,_)") == 0) { fn = RAYLIBFN(GetPixelColor); break; }
            if(strcmp(signature, "SetPixelColor(_,_,_)") == 0) { fn = RAYLIBFN(SetPixelColor); break; }
            if(strcmp(signature, "GetPixelDataSize(_,_,_)") == 0) { fn = RAYLIBFN(GetPixelDataSize); break; }

            if(strcmp(signature, "GetFontDefault(_)") == 0) { fn = RAYLIBFN(GetFontDefault); break; }
            if(strcmp(signature, "LoadFont(_,_)") == 0) { fn = RAYLIBFN(LoadFont); break; }
            if(strcmp(signature, "LoadFontEx(_,_,_,_,_)") == 0) { fn = RAYLIBFN(LoadFontEx); break; }
            if(strcmp(signature, "LoadFontFromImage(_,_,_,_)") == 0) { fn = RAYLIBFN(LoadFontFromImage); break; }
            if(strcmp(signature, "LoadFontFromMemory(_,_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(LoadFontFromMemory); break; }
            if(strcmp(signature, "IsFontReady(_)") == 0) { fn = RAYLIBFN(IsFontReady); break; }
            if(strcmp(signature, "LoadFontData(_,_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(LoadFontData); break; }
            if(strcmp(signature, "GenImageFontAtlas(_,_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(GenImageFontAtlas); break; }
            if(strcmp(signature, "UnloadFontData(_,_)") == 0) { fn = RAYLIBFN(UnloadFontData); break; }
            if(strcmp(signature, "UnloadFont(_)") == 0) { fn = RAYLIBFN(UnloadFont); break; }
            if(strcmp(signature, "ExportFontAsCode(_,_)") == 0) { fn = RAYLIBFN(ExportFontAsCode); break; }

            if(strcmp(signature, "DrawFPS(_,_)") == 0) { fn = RAYLIBFN(DrawFPS); break; }
            if(strcmp(signature, "DrawText(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawText); break; }
            if(strcmp(signature, "DrawTextEx(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawTextEx); break; }
            if(strcmp(signature, "DrawTextPro(_,_,_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawTextPro); break; }
            if(strcmp(signature, "DrawTextCodepoint(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawTextCodepoint); break; }
            if(strcmp(signature, "DrawTextCodepoints(_,_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawTextCodepoints); break; }

            if(strcmp(signature, "SetTextLineSpacing(_)") == 0) { fn = RAYLIBFN(SetTextLineSpacing); break; }
            if(strcmp(signature, "MeasureText(_,_)") == 0) { fn = RAYLIBFN(MeasureText); break; }
            if(strcmp(signature, "MeasureTextEx(_,_,_,_,_)") == 0) { fn = RAYLIBFN(MeasureTextEx); break; }
            if(strcmp(signature, "GetGlyphIndex(_,_)") == 0) { fn = RAYLIBFN(GetGlyphIndex); break; }
            if(strcmp(signature, "GetGlyphInfo(_,_,_)") == 0) { fn = RAYLIBFN(GetGlyphInfo); break; }
            if(strcmp(signature, "GetGlyphAtlasRec(_,_,_)") == 0) { fn = RAYLIBFN(GetGlyphAtlasRec); break; }

            if(strcmp(signature, "LoadUTF8(_,_)") == 0) { fn = RAYLIBFN(LoadUTF8); break; }
            if(strcmp(signature, "UnloadUTF8(_)") == 0) { fn = RAYLIBFN(UnloadUTF8); break; }
            if(strcmp(signature, "LoadCodepoints(_,_)") == 0) { fn = RAYLIBFN(LoadCodepoints); break; }
            if(strcmp(signature, "UnloadCodepoints(_)") == 0) { fn = RAYLIBFN(UnloadCodepoints); break; }
            if(strcmp(signature, "GetCodepointCount(_)") == 0) { fn = RAYLIBFN(GetCodepointCount); break; }
            if(strcmp(signature, "GetCodepoint(_,_)") == 0) { fn = RAYLIBFN(GetCodepoint); break; }
            if(strcmp(signature, "GetCodepointNext(_,_)") == 0) { fn = RAYLIBFN(GetCodepointNext); break; }
            if(strcmp(signature, "GetCodepointPrevious(_,_)") == 0) { fn = RAYLIBFN(GetCodepointPrevious); break; }
            if(strcmp(signature, "CodepointToUTF8(_,_)") == 0) { fn = RAYLIBFN(CodepointToUTF8); break; }

            if(strcmp(signature, "TextCopy(_,_)") == 0) { fn = RAYLIBFN(TextCopy); break; }
            if(strcmp(signature, "TextIsEqual(_,_)") == 0) { fn = RAYLIBFN(TextIsEqual); break; }
            if(strcmp(signature, "TextLength(_)") == 0) { fn = RAYLIBFN(TextLength); break; }
            if(strcmp(signature, "TextFormat(_)") == 0) { fn = RAYLIBFN(TextFormat); break; }
            if(strcmp(signature, "TextSubtext(_,_,_)") == 0) { fn = RAYLIBFN(TextSubtext); break; }
            if(strcmp(signature, "TextReplace(_,_,_)") == 0) { fn = RAYLIBFN(TextReplace); break; }
            if(strcmp(signature, "TextInsert(_,_,_)") == 0) { fn = RAYLIBFN(TextInsert); break; }
            if(strcmp(signature, "TextJoin(_,_,_)") == 0) { fn = RAYLIBFN(TextJoin); break; }
            if(strcmp(signature, "TextSplit(_,_,_)") == 0) { fn = RAYLIBFN(TextSplit); break; }
            if(strcmp(signature, "TextAppend(_,_,_)") == 0) { fn = RAYLIBFN(TextAppend); break; }
            if(strcmp(signature, "TextFindIndex(_,_)") == 0) { fn = RAYLIBFN(TextFindIndex); break; }
            if(strcmp(signature, "TextToUpper(_)") == 0) { fn = RAYLIBFN(TextToUpper); break; }
            if(strcmp(signature, "TextToLower(_)") == 0) { fn = RAYLIBFN(TextToLower); break; }
            if(strcmp(signature, "TextToPascal(_)") == 0) { fn = RAYLIBFN(TextToPascal); break; }
            if(strcmp(signature, "TextToInteger(_)") == 0) { fn = RAYLIBFN(TextToInteger); break; }

            if(strcmp(signature, "DrawLine3D(_,_,_)") == 0) { fn = RAYLIBFN(DrawLine3D); break; }
            if(strcmp(signature, "DrawPoint3D(_,_)") == 0) { fn = RAYLIBFN(DrawPoint3D); break; }
            if(strcmp(signature, "DrawCircle3D(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawCircle3D); break; }
            if(strcmp(signature, "DrawTriangle3D(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawTriangle3D); break; }
            if(strcmp(signature, "DrawTriangleStrip3D(_,_,_)") == 0) { fn = RAYLIBFN(DrawTriangleStrip3D); break; }
            if(strcmp(signature, "DrawCube(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawCube); break; }
            if(strcmp(signature, "DrawCubeV(_,_,_)") == 0) { fn = RAYLIBFN(DrawCubeV); break; }
            if(strcmp(signature, "DrawCubeWires(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawCubeWires); break; }
            if(strcmp(signature, "DrawCubeWiresV(_,_,_)") == 0) { fn = RAYLIBFN(DrawCubeWiresV); break; }
            if(strcmp(signature, "DrawSphere(_,_,_)") == 0) { fn = RAYLIBFN(DrawSphere); break; }
            if(strcmp(signature, "DrawSphereEx(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawSphereEx); break; }
            if(strcmp(signature, "DrawSphereWires(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawSphereWires); break; }
            if(strcmp(signature, "DrawCylinder(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawCylinder); break; }
            if(strcmp(signature, "DrawCylinderEx(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawCylinderEx); break; }
            if(strcmp(signature, "DrawCylinderWires(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawCylinderWires); break; }
            if(strcmp(signature, "DrawCylinderWiresEx(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawCylinderWiresEx); break; }
            if(strcmp(signature, "DrawCapsule(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawCapsule); break; }
            if(strcmp(signature, "DrawCapsuleWires(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawCapsuleWires); break; }
            if(strcmp(signature, "DrawPlane(_,_,_)") == 0) { fn = RAYLIBFN(DrawPlane); break; }
            if(strcmp(signature, "DrawRay(_,_)") == 0) { fn = RAYLIBFN(DrawRay); break; }
            if(strcmp(signature, "DrawGrid(_,_)") == 0) { fn = RAYLIBFN(DrawGrid); break; }

            if(strcmp(signature, "LoadModel(_,_)") == 0) { fn = RAYLIBFN(LoadModel); break; }
            if(strcmp(signature, "LoadModelFromMesh(_,_)") == 0) { fn = RAYLIBFN(LoadModelFromMesh); break; }
            if(strcmp(signature, "IsModelReady(_)") == 0) { fn = RAYLIBFN(IsModelReady); break; }
            if(strcmp(signature, "UnloadModel(_)") == 0) { fn = RAYLIBFN(UnloadModel); break; }
            if(strcmp(signature, "GetModelBoundingBox(_,_)") == 0) { fn = RAYLIBFN(GetModelBoundingBox); break; }

            if(strcmp(signature, "DrawModel(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawModel); break; }
            if(strcmp(signature, "DrawModelEx(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawModelEx); break; }
            if(strcmp(signature, "DrawModelWires(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawModelWires); break; }
            if(strcmp(signature, "DrawModelWiresEx(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawModelWiresEx); break; }
            if(strcmp(signature, "DrawBoundingBox(_,_)") == 0) { fn = RAYLIBFN(DrawBoundingBox); break; }
            if(strcmp(signature, "DrawBillboard(_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawBillboard); break; }
            if(strcmp(signature, "DrawBillboardRec(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawBillboardRec); break; }
            if(strcmp(signature, "DrawBillboardPro(_,_,_,_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(DrawBillboardPro); break; }

            if(strcmp(signature, "UploadMesh(_,_)") == 0) { fn = RAYLIBFN(UploadMesh); break; }
            if(strcmp(signature, "UpdateMeshBuffer(_,_,_,_,_)") == 0) { fn = RAYLIBFN(UpdateMeshBuffer); break; }
            if(strcmp(signature, "UnloadMesh(_)") == 0) { fn = RAYLIBFN(UnloadMesh); break; }
            if(strcmp(signature, "DrawMesh(_,_,_)") == 0) { fn = RAYLIBFN(DrawMesh); break; }
            if(strcmp(signature, "DrawMeshInstanced(_,_,_,_)") == 0) { fn = RAYLIBFN(DrawMeshInstanced); break; }
            if(strcmp(signature, "ExportMesh(_,_)") == 0) { fn = RAYLIBFN(ExportMesh); break; }
            if(strcmp(signature, "GetMeshBoundingBox(_,_)") == 0) { fn = RAYLIBFN(GetMeshBoundingBox); break; }
            if(strcmp(signature, "GenMeshTangents(_)") == 0) { fn = RAYLIBFN(GenMeshTangents); break; }

            if(strcmp(signature, "GenMeshPoly(_,_,_)") == 0) { fn = RAYLIBFN(GenMeshPoly); break; }
            if(strcmp(signature, "GenMeshPlane(_,_,_,_,_)") == 0) { fn = RAYLIBFN(GenMeshPlane); break; }
            if(strcmp(signature, "GenMeshCube(_,_,_,_)") == 0) { fn = RAYLIBFN(GenMeshCube); break; }
            if(strcmp(signature, "GenMeshSphere(_,_,_,_)") == 0){ fn = RAYLIBFN(GenMeshSphere); break; }
            if(strcmp(signature, "GenMeshHemiSphere(_,_,_,_)") == 0) { fn = RAYLIBFN(GenMeshHemiSphere); break; }
            if(strcmp(signature, "GenMeshCylinder(_,_,_,_)") == 0) { fn = RAYLIBFN(GenMeshCylinder); break; }
            if(strcmp(signature, "GenMeshCone(_,_,_,_)") == 0) { fn = RAYLIBFN(GenMeshCone); break; }
            if(strcmp(signature, "GenMeshTorus(_,_,_,_,_)") == 0) { fn = RAYLIBFN(GenMeshTorus); break; }
            if(strcmp(signature, "GenMeshKnot(_,_,_,_,_)") == 0) { fn = RAYLIBFN(GenMeshKnot); break; }
            if(strcmp(signature, "GenMeshHeightmap(_,_,_)") == 0) { fn = RAYLIBFN(GenMeshHeightmap); break; }
            if(strcmp(signature, "GenMeshCubicmap(_,_,_)") == 0) { fn = RAYLIBFN(GenMeshCubicmap); break; }

            if(strcmp(signature, "LoadMaterials(_,_,_)") == 0) { fn = RAYLIBFN(LoadMaterials); break; }
            if(strcmp(signature, "LoadMaterialDefault(_)") == 0) { fn = RAYLIBFN(LoadMaterialDefault); break; }
            if(strcmp(signature, "IsMaterialReady(_)") == 0) { fn = RAYLIBFN(IsMaterialReady); break; }
            if(strcmp(signature, "UnloadMaterial(_)") == 0) { fn = RAYLIBFN(UnloadMaterial); break; }
            if(strcmp(signature, "SetMaterialTexture(_,_,_)") == 0) { fn = RAYLIBFN(SetMaterialTexture); break; }
            if(strcmp(signature, "SetModelMeshMaterial(_,_,_)") == 0) { fn = RAYLIBFN(SetModelMeshMaterial); break; }

            if(strcmp(signature, "LoadModelAnimations(_,_,_)") == 0) { fn = RAYLIBFN(LoadModelAnimations); break; }
            if(strcmp(signature, "UpdateModelAnimation(_,_,_)") == 0) { fn = RAYLIBFN(UpdateModelAnimation); break; }
            if(strcmp(signature, "UnloadModelAnimation(_)") == 0) { fn = RAYLIBFN(UnloadModelAnimation); break; }
            if(strcmp(signature, "UnloadModelAnimations(_,_)") == 0) { fn = RAYLIBFN(UnloadModelAnimations); break; }
            if(strcmp(signature, "IsModelAnimationValid(_,_)") == 0) { fn = RAYLIBFN(IsModelAnimationValid); break; }

            if(strcmp(signature, "CheckCollisionSpheres(_,_,_,_)") == 0) { fn = RAYLIBFN(CheckCollisionSpheres); break; }
            if(strcmp(signature, "CheckCollisionBoxes(_,_)") == 0) { fn = RAYLIBFN(CheckCollisionBoxes); break; }
            if(strcmp(signature, "CheckCollisionBoxSphere(_,_,_)") == 0) { fn = RAYLIBFN(CheckCollisionBoxSphere); break; }
            if(strcmp(signature, "GetRayCollisionSphere(_,_,_,_)") == 0) { fn = RAYLIBFN(GetRayCollisionSphere); break; }
            if(strcmp(signature, "GetRayCollisionBox(_,_,_)") == 0) { fn = RAYLIBFN(GetRayCollisionBox); break; }
            if(strcmp(signature, "GetRayCollisionMesh(_,_,_,_)") == 0) { fn = RAYLIBFN(GetRayCollisionMesh); break; }
            if(strcmp(signature, "GetRayCollisionTriangle(_,_,_,_,_)") == 0) { fn = RAYLIBFN(GetRayCollisionTriangle); break; }
            if(strcmp(signature, "GetRayCollisionQuad(_,_,_,_,_,_)") == 0) { fn = RAYLIBFN(GetRayCollisionQuad); break; }
            if(strcmp(signature, "PackRectangles(_,_,_,_,_)") == 0) { fn = RAYLIBFN(PackRectangles); break; }
            

        } while(false);
    }

    return fn;
}

#define MLCLS(cls) cls##Malloc 
WrenForeignClassMethods wrenRaylibBindClass(WrenVM* vm, const char* className)
{
    WrenForeignClassMethods ret;
    ret.allocate = nullptr;
    ret.finalize = nullptr;
    do 
    {
        if(strcmp(className, "Vector2") == 0) { ret.allocate = Vector2Malloc; break;}
        if(strcmp(className, "Vector3") == 0) { ret.allocate = Vector3Malloc; break;}
        if(strcmp(className, "Vector4") == 0) { ret.allocate = Vector4Malloc; break;}
        if(strcmp(className, "Quaternion") == 0) { ret.allocate = QuaternionMalloc; break;}
        if(strcmp(className, "Matrix") == 0) { ret.allocate = MatrixMalloc; break;}
        if(strcmp(className, "float3") == 0) { ret.allocate = float3Malloc; break;}
        if(strcmp(className, "float16") == 0) { ret.allocate = float16Malloc; break;}
        if(strcmp(className, "Color") == 0) { ret.allocate = MLCLS(Color); break;}
        if(strcmp(className, "Rectangle") == 0) { ret.allocate = MLCLS(Rectangle); break;}
        if(strcmp(className, "Image") == 0) { ret.allocate = MLCLS(Image); break;}
        if(strcmp(className, "Texture") == 0) { ret.allocate = MLCLS(Texture); break;}
        if(strcmp(className, "RenderTexture") == 0) { ret.allocate = MLCLS(RenderTexture); break;}
        if(strcmp(className, "NPatchInfo") == 0) { ret.allocate = MLCLS(NPatchInfo); break;}
        if(strcmp(className, "GlyphInfo") == 0) { ret.allocate = MLCLS(GlyphInfo); break;}
        if(strcmp(className, "Font") == 0) { ret.allocate = MLCLS(Font); break;}
        if(strcmp(className, "Camera3D") == 0) { ret.allocate = MLCLS(Camera3D); break;}
        if(strcmp(className, "Camera2D") == 0) { ret.allocate = MLCLS(Camera2D); break;}
        if(strcmp(className, "Mesh") == 0) { ret.allocate = MLCLS(Mesh); break;}
        if(strcmp(className, "Shader") == 0) { ret.allocate = MLCLS(Shader); break;}
        if(strcmp(className, "MaterialMap") == 0) { ret.allocate = MLCLS(MaterialMap); break;}
        if(strcmp(className, "Material") == 0) { ret.allocate = MLCLS(Material); break;}
        if(strcmp(className, "Transform") == 0) { ret.allocate = MLCLS(Transform); break;}
        if(strcmp(className, "BoneInfo") == 0) { ret.allocate = MLCLS(BoneInfo); break;}
        if(strcmp(className, "Model") == 0) { ret.allocate = MLCLS(Model); break;}
        if(strcmp(className, "ModelAnimation") == 0) { ret.allocate = MLCLS(ModelAnimation); break;}
        if(strcmp(className, "Ray") == 0) { ret.allocate = MLCLS(Ray); break;}
        if(strcmp(className, "RayCollision") == 0) { ret.allocate = MLCLS(RayCollision); break;}
        if(strcmp(className, "BoundingBox") == 0) { ret.allocate = MLCLS(BoundingBox); break;}
        if(strcmp(className, "Wave") == 0) { ret.allocate = MLCLS(Wave); break;}
        if(strcmp(className, "AudioStream") == 0) { ret.allocate = MLCLS(AudioStream); break;}
        if(strcmp(className, "Sound") == 0) { ret.allocate = MLCLS(Sound); break;}
        if(strcmp(className, "Music") == 0) { ret.allocate = MLCLS(Music); break;}
        if(strcmp(className, "VrDeviceInfo") == 0) { ret.allocate = MLCLS(VrDeviceInfo); break;}
        if(strcmp(className, "VrStereoConfig") == 0) { ret.allocate = MLCLS(VrStereoConfig); break;}
        if(strcmp(className, "FilePathList") == 0) { ret.allocate = MLCLS(FilePathList); break;}
        if(strcmp(className, "AutomationEvent") == 0) { ret.allocate = MLCLS(AutomationEvent); break;}
        if(strcmp(className, "AutomationEventList") == 0) { ret.allocate = MLCLS(AutomationEventList); break;}
        if(strcmp(className, "ValueList") == 0) { ret.allocate = MLCLS(ValueList); break;}
        if(strcmp(className, "Value") == 0) { ret.allocate = MLCLS(Value); break;}
        
    } while(false);
    return ret;
}

} // namespace cico
