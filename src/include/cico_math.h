#ifndef CICO_MATH_H
#define CICO_MATH_H

namespace cico
{
    /**
     * EasingType 动画曲线类型枚举
    */
    enum EasingType {
        Linear,
        InQuad,
        OutQuad,
        InOutQuad,
        InCubic,
        OutCubic,
        InOutCubic,
        InQuart,
        OutQuart,
        InOutQuart,
        InQuint,
        OutQuint,
        InOutQuint,
        InSine,
        OutSine,
        InOutSine,
        InExpo,
        OutExpo,
        InOutExpo,
        InCirc,
        OutCirc,
        InOutCirc,
        InBack,
        OutBack,
        InOutBack,
        InElastic,
        OutElastic,
        InOutElastic,
        InBounce,
        OutBounce,
        InOutBounce
    };

    /**
     * easing 31 种常用动画曲线
    */
    float easing(float x, EasingType type);
} // namespace cico


#endif //CICO_MATH_H