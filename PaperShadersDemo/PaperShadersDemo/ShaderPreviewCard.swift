import PaperShaders
import SwiftUI

struct ShaderPreviewCard: View {
    let textureSettings: TextureSettings
    let distortionSettings: DistortionSettings

    var body: some View {
        PreviewSurface()
            .drawingGroup()
            .modifier(
                PreviewShaderEffects(
                    textureSettings: textureSettings,
                    distortionSettings: distortionSettings
                )
            )
            .shadow(color: .black.opacity(0.09), radius: 30, y: 18)
    }
}

private struct PreviewSurface: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("This is a preview of the shaders.")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)

            HStack(alignment: .center, spacing: 16) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.primary)
                    .frame(maxWidth: .infinity, maxHeight: 140)

                Circle()
                    .fill(.primary)
                    .frame(width: 140, height: 140)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .fill(previewBackground)
                .stroke(.primary.opacity(0.1), lineWidth: 1)
        )
    }

    private var previewBackground: Color {
        switch colorScheme {
        case .dark:
            Color(red: 0.2039, green: 0.1921, blue: 0.1667)
        default:
            Color(red: 0.9725, green: 0.9607, blue: 0.9254)
        }
    }
}

private struct PreviewShaderEffects: ViewModifier {
    let textureSettings: TextureSettings
    let distortionSettings: DistortionSettings

    @ViewBuilder
    func body(content: Content) -> some View {
        if textureSettings.isEnabled, distortionSettings.isEnabled {
            content
                .paperDistortion(
                    amplitude: distortionSettings.amplitude,
                    scale: distortionSettings.scale,
                    gradientStep: distortionSettings.gradientStep,
                    lacunarity: distortionSettings.lacunarity,
                    gain: distortionSettings.gain,
                    octaves: Int(distortionSettings.octaves.rounded())
                )
                .paperTexture(
                    color1: .white.opacity(textureSettings.color1Opacity),
                    color2: .black.opacity(textureSettings.color2Opacity),
                    density: textureSettings.density,
                    scale: textureSettings.scale,
                    lacunarity: textureSettings.lacunarity,
                    gain: textureSettings.gain,
                    octaves: Int(textureSettings.octaves.rounded())
                )
        } else if textureSettings.isEnabled {
            content.paperTexture(
                color1: .white.opacity(textureSettings.color1Opacity),
                color2: .black.opacity(textureSettings.color2Opacity),
                density: textureSettings.density,
                scale: textureSettings.scale,
                lacunarity: textureSettings.lacunarity,
                gain: textureSettings.gain,
                octaves: Int(textureSettings.octaves.rounded())
            )
        } else if distortionSettings.isEnabled {
            content.paperDistortion(
                amplitude: distortionSettings.amplitude,
                scale: distortionSettings.scale,
                gradientStep: distortionSettings.gradientStep,
                lacunarity: distortionSettings.lacunarity,
                gain: distortionSettings.gain,
                octaves: Int(distortionSettings.octaves.rounded())
            )
        } else {
            content
        }
    }
}
