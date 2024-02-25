#include "cico_math.h"
#include <algorithm>
#include <math.h>

namespace cico
{

float bounceOut(float x)
{
	static float En1 = 7.5625;
	static float Ed1 = 2.75;

	if (x < 1 / Ed1) {
		return En1 * x * x;
	} else if (x < 2 / Ed1) {
		return En1 * (x -= 1.5 / Ed1) * x + 0.75;
	} else if (x < 2.5 / Ed1) {
		return En1 * (x -= 2.25 / Ed1) * x + 0.9375;
	} else {
		return En1 * (x -= 2.625 / Ed1) * x + 0.984375;
	}
}

float easing(float x, EasingType type)
{
    static float EPI2 = 6.28318530717958647692;
    static float EPI = 3.14159265;
	static float Ec1 = 1.70158;
	static float Ec2 = Ec1 * 1.525;
	static float Ec3 = Ec1 + 1;
	static float Ec4 = (2 * EPI) / 3;
	static float Ec5 = (2 * EPI) / 4.5;
	switch (type)
	{
        case Linear:
			// do nothing
			break;
        case InQuad:
			x = x * x;
			break;
        case OutQuad:
			x = 1 - (1 - x) * (1 - x);
			break;
        case InOutQuad:
			x = x < 0.5 ? 2 * x * x : 1 - pow(-2 * x + 2, 2) / 2;
			break;
        case InCubic:
			x = x * x * x;
			break;
        case OutCubic:
			x = 1 - pow(1 - x, 3);
			break;
        case InOutCubic:
			x = x < 0.5 ? 4 * x * x * x : 1 - pow(-2 * x + 2, 3) / 2;
			break;
        case InQuart:
			x = x * x * x * x;
			break;
        case OutQuart:
			x = 1 - pow(1 - x, 4);
			break;
        case InOutQuart:
			x = x < 0.5 ? 8 * x * x * x * x : 1 - pow(-2 * x + 2, 4) / 2;
			break;
        case InQuint:
			x = x * x * x * x * x;
			break;
        case OutQuint:
			x = 1 - pow(1 - x, 5);
			break;
        case InOutQuint:
			x = x < 0.5 ? 16 * x * x * x * x * x : 1 - pow(-2 * x + 2, 5) / 2;
			break;
        case InSine:
			x = 1 - cos((x * EPI) / 2);
			break;
        case OutSine:
			x = sin((x * EPI) / 2);
			break;
        case InOutSine:
			x = -(cos(EPI * x) - 1) / 2;
			break;
        case InExpo:
			x = x == 0 ? 0 : pow(2, 10 * x - 10);
			break;
        case OutExpo:
			x = x == 1 ? 1 : 1 - pow(2, -10 * x);
			break;
        case InOutExpo:
			x = x == 0
			? 0
			: x == 1
			? 1
			: x < 0.5
			? pow(2, 20 * x - 10) / 2
			: (2 - pow(2, -20 * x + 10)) / 2;
			break;
        case InCirc:
			x = 1 - sqrt(1 - pow(x, 2));
			break;
        case OutCirc:
			x = sqrt(1 - pow(x - 1, 2));
			break;
        case InOutCirc:
			x = x < 0.5
			? (1 - sqrt(1 - pow(2 * x, 2))) / 2
			: (sqrt(1 - pow(-2 * x + 2, 2)) + 1) / 2;
			break;
        case InBack:
			x = Ec3 * x * x * x - Ec1 * x * x;
			break;
        case OutBack:
			x = 1 + Ec3 * pow(x - 1, 3) + Ec1 * pow(x - 1, 2);
			break;
        case InOutBack:
			x = x < 0.5
			? (pow(2 * x, 2) * ((Ec2 + 1) * 2 * x - Ec2)) / 2
			: (pow(2 * x - 2, 2) * ((Ec2 + 1) * (x * 2 - 2) + Ec2) + 2) / 2;
			break;
        case InElastic:
			x = x == 0
			? 0
			: x == 1
			? 1
			: -pow(2, 10 * x - 10) * sin((x * 10 - 10.75) * Ec4);
			break;
        case OutElastic:
			x = x == 0
			? 0
			: x == 1
			? 1
			: pow(2, -10 * x) * sin((x * 10 - 0.75) * Ec4) + 1;
			break;
        case InOutElastic:
			x = x == 0
			? 0
			: x == 1
			? 1
			: x < 0.5
			? -(pow(2, 20 * x - 10) * sin((20 * x - 11.125) * Ec5)) / 2
			: (pow(2, -20 * x + 10) * sin((20 * x - 11.125) * Ec5)) / 2 + 1;
			break;
        case InBounce:
			x = 1 - bounceOut(1 - x);
			break;
        case OutBounce:
			x = bounceOut(x);
			break;
        case InOutBounce:
			x = x < 0.5
			? (1 - bounceOut(1 - 2 * x)) / 2
			: (1 + bounceOut(2 * x - 1)) / 2;
			break;
	default:
		break;
	}
	return x;
}
} // namespace cico
