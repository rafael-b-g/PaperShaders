//
//  Paper.metal
//  PaperShaders
//
//  Created by Rafa on 07/05/26.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;


half4 blendColors(half4 baseColor, half4 overlayColor) {
    half oneMinusOverlayAlpha = 1.0h - overlayColor.a;
    half3 blendedRGB = overlayColor.rgb + baseColor.rgb * oneMinusOverlayAlpha;
    half blendedAlpha = overlayColor.a + baseColor.a * oneMinusOverlayAlpha;
    return half4(blendedRGB, blendedAlpha);
}

float hash12(float2 p) {
    float3 p3  = fract(float3(p.xyx) * 0.7137);
    p3 += dot(p3, p3.yzx + 37.206);
    return fract((p3.x + p3.y) * p3.z);
}

float noise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);

    float a = hash12(i);
    float b = hash12(i + float2(1.0, 0.0));
    float c = hash12(i + float2(0.0, 1.0));
    float d = hash12(i + float2(1.0, 1.0));

    float2 u = smoothstep(float2(0.0), float2(1.0), f);

    return mix(
        mix(a, b, u.x),
        mix(c, d, u.x),
        u.y
    );
}

float fbm(
    float2 p,
    float lacunarity,
    float gain,
    float octaveCount
) {
    constexpr float initialAmplitude = 0.5;
    constexpr float initialFrequency = 1.0;

    int octaveIterations = int(octaveCount);
    if (octaveIterations <= 0) {
        return 0.0;
    }

    float value = 0.0;
    float octaveAmplitude = initialAmplitude;
    float frequency = initialFrequency;

    for (int i = 0; i < octaveIterations; i++) {
        value += octaveAmplitude * noise(p * frequency);

        frequency *= lacunarity;
        octaveAmplitude *= gain;
    }

    float maxValue;

    if (abs(gain - 1.0) < 0.0001) {
        maxValue = initialAmplitude * float(octaveIterations);
    } else {
        maxValue = initialAmplitude
            * (1.0 - pow(gain, float(octaveIterations)))
            / (1.0 - gain);
    }

    return value / maxValue;
}

float2 noiseGradient(
    float2 p,
    float gradientStep,
    float fbmLacunarity,
    float fbmGain,
    float fbmOctaveCount
) {
    float x1 = fbm(
        p + float2(gradientStep, 0.0),
        fbmLacunarity,
        fbmGain,
        fbmOctaveCount
    );

    float x0 = fbm(
        p - float2(gradientStep, 0.0),
        fbmLacunarity,
        fbmGain,
        fbmOctaveCount
    );

    float y1 = fbm(
        p + float2(0.0, gradientStep),
        fbmLacunarity,
        fbmGain,
        fbmOctaveCount
    );

    float y0 = fbm(
        p - float2(0.0, gradientStep),
        fbmLacunarity,
        fbmGain,
        fbmOctaveCount
    );

    return float2(x1 - x0, y1 - y0) / (2.0 * gradientStep);
}

[[ stitchable ]]
float2 paperDistortion(
    float2 position,
    float amplitude,
    float scale,
    float gradientStep,
    float fbmLacunarity,
    float fbmGain,
    float fbmOctaveCount
) {
    float seed = 7.0;
    float2 seedOffsetScale = float2(17.33, 31.58);
    
    float2 p = position / scale;
    p += seed * seedOffsetScale;

    float2 g = noiseGradient(
        p,
        gradientStep,
        fbmLacunarity,
        fbmGain,
        fbmOctaveCount
    );

    float2 displacement = g * amplitude;

    float len = length(displacement);
    if (len > amplitude) {
        displacement = displacement / len * amplitude;
    }

    return position + displacement;
}

[[ stitchable ]]
half4 paperTexture(
    float2 position,
    half4 currentColor,
    half4 color1,
    half4 color2,
    float density,
    float scale,
    float fbmLacunarity,
    float fbmGain,
    float fbmOctaveCount
) {
    float seed = 7.0;
    float2 seedOffsetScale = float2(17.33, 31.58);
    
    float2 p = position / scale;
    p += seed * seedOffsetScale;
    
    float value = fbm(p, fbmLacunarity, fbmGain, fbmOctaveCount);
    
    if (value >= 1 - (density / 2)) {
        return blendColors(currentColor, color1);
    } else if (value <= density / 2) {
        return blendColors(currentColor, color2);
    } else {
        return currentColor;
    }
}
