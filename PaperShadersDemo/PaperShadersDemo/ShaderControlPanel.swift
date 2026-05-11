import SwiftUI

enum DemoShader: String, CaseIterable, Identifiable {
    case texture
    case distortion

    var id: Self { self }

    var title: String {
        switch self {
        case .texture:
            "Texture"
        case .distortion:
            "Distortion"
        }
    }

    var description: String {
        switch self {
        case .texture:
            "Adds paper-like grain to the view."
        case .distortion:
            "Adds a subtle distortion to the view, replicating ink on paper."
        }
    }

    var tint: Color {
        switch self {
        case .texture:
            .orange
        case .distortion:
            .blue
        }
    }

    var toggleTitle: String {
        switch self {
        case .texture:
            "Enable texture shader"
        case .distortion:
            "Enable distortion shader"
        }
    }
}

struct TextureSettings {
    var isEnabled = true
    var color1Opacity = 0.20
    var color2Opacity = 0.07
    var density = 0.52
    var scale = 0.91
    var lacunarity = 1.55
    var gain = 0.56
    var octaves = 3.0
}

struct DistortionSettings {
    var isEnabled = true
    var amplitude = 0.72
    var scale = 0.96
    var gradientStep = 0.04
    var lacunarity = 1.24
    var gain = 0.53
    var octaves = 5.0
}

struct ShaderControlPanel: View {
    @Binding var selectedShader: DemoShader
    @Binding var textureSettings: TextureSettings
    @Binding var distortionSettings: DistortionSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Picker("Shader", selection: $selectedShader) {
                ForEach(DemoShader.allCases) { shader in
                    Text(shader.title).tag(shader)
                }
            }
            .pickerStyle(.segmented)

            VStack(alignment: .leading, spacing: 12) {
                Toggle(selectedShader.toggleTitle, isOn: selectedShaderBinding)
                    .tint(selectedShader.tint)
                    .font(.headline)

                Text(selectedShader.description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if selectedShader == .texture {
                TextureControls(settings: $textureSettings)
            } else {
                DistortionControls(settings: $distortionSettings)
            }
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.thinMaterial)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.quaternary, lineWidth: 1)
        }
    }

    private var selectedShaderBinding: Binding<Bool> {
        Binding(
            get: {
                switch selectedShader {
                case .texture:
                    textureSettings.isEnabled
                case .distortion:
                    distortionSettings.isEnabled
                }
            },
            set: { isEnabled in
                switch selectedShader {
                case .texture:
                    textureSettings.isEnabled = isEnabled
                case .distortion:
                    distortionSettings.isEnabled = isEnabled
                }
            }
        )
    }
}

private struct TextureControls: View {
    @Binding var settings: TextureSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ParameterSlider(
                title: "color1",
                value: $settings.color1Opacity,
                range: 0...1,
                tint: DemoShader.texture.tint,
                valueLabel: settings.color1Opacity.formatted(.percent.precision(.fractionLength(0))),
                explanation: "The color used for one half of the grains.",
                swatch: .white.opacity(settings.color1Opacity)
            )

            ParameterSlider(
                title: "color2",
                value: $settings.color2Opacity,
                range: 0...1,
                tint: DemoShader.texture.tint,
                valueLabel: settings.color2Opacity.formatted(.percent.precision(.fractionLength(0))),
                explanation: "The color used for the other half of the grains.",
                swatch: .black.opacity(max(settings.color2Opacity, 0.08))
            )

            ParameterSlider(
                title: "density",
                value: $settings.density,
                range: 0...1,
                tint: DemoShader.texture.tint,
                valueLabel: settings.density.formatted(.number.precision(.fractionLength(2))),
                explanation: "How much of the space is filled by the grains. Higher values make grains bigger."
            )

            ParameterSlider(
                title: "scale",
                value: $settings.scale,
                range: 0.1...30,
                tint: DemoShader.texture.tint,
                valueLabel: settings.scale.formatted(.number.precision(.fractionLength(2))),
                explanation: "The scale of the texture. Lower values make grains smaller, higher values make grains larger."
            )

            ParameterSlider(
                title: "lacunarity",
                value: $settings.lacunarity,
                range: 1...3,
                tint: DemoShader.texture.tint,
                valueLabel: settings.lacunarity.formatted(.number.precision(.fractionLength(2))),
                explanation: "How quickly the noise frequency increases between layers. Higher values make details finer. Lower values make the noise layers closer together and smoother."
            )

            ParameterSlider(
                title: "gain",
                value: $settings.gain,
                range: 0...1,
                tint: DemoShader.texture.tint,
                valueLabel: settings.gain.formatted(.number.precision(.fractionLength(2))),
                explanation: "How quickly each successive noise layer loses strength. Higher values make it rougher. Lower values make it smoother."
            )

            ParameterSlider(
                title: "octaves",
                value: $settings.octaves,
                range: 1...8,
                step: 1,
                tint: DemoShader.texture.tint,
                valueLabel: Int(settings.octaves.rounded()).formatted(),
                explanation: "The number of noise layers used to build the texturre. Fewer octaves look smoother and simpler. More octaves add finer detail."
            )
        }
    }
}

private struct DistortionControls: View {
    @Binding var settings: DistortionSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ParameterSlider(
                title: "amplitude",
                value: $settings.amplitude,
                range: 0...30,
                tint: DemoShader.distortion.tint,
                valueLabel: settings.amplitude.formatted(.number.precision(.fractionLength(2))),
                explanation: "The intensity of the distortion."
            )

            ParameterSlider(
                title: "scale",
                value: $settings.scale,
                range: 0.1...30,
                tint: DemoShader.distortion.tint,
                valueLabel: settings.scale.formatted(.number.precision(.fractionLength(2))),
                explanation: "The scale of the distortion pattern. Lower values make it tighter, higher values spread it out."
            )

            ParameterSlider(
                title: "gradientStep",
                value: $settings.gradientStep,
                range: 0.01...3,
                tint: DemoShader.distortion.tint,
                valueLabel: settings.gradientStep.formatted(.number.precision(.fractionLength(2))),
                explanation: "The sampling step used to compute the distortion direction. Higher values make it smoother. Lower values preserve sharper, finer detail."
            )

            ParameterSlider(
                title: "lacunarity",
                value: $settings.lacunarity,
                range: 1...3,
                tint: DemoShader.distortion.tint,
                valueLabel: settings.lacunarity.formatted(.number.precision(.fractionLength(2))),
                explanation: "How quickly the noise frequency increases between layers. Higher values make details finer. Lower values make the noise layers closer together and smoother."
            )

            ParameterSlider(
                title: "gain",
                value: $settings.gain,
                range: 0...1,
                tint: DemoShader.distortion.tint,
                valueLabel: settings.gain.formatted(.number.precision(.fractionLength(2))),
                explanation: "How quickly each successive noise layer loses strength. Higher values make it rougher. Lower values make it smoother."
            )

            ParameterSlider(
                title: "octaves",
                value: $settings.octaves,
                range: 1...8,
                step: 1,
                tint: DemoShader.distortion.tint,
                valueLabel: Int(settings.octaves.rounded()).formatted(),
                explanation: "The number of noise layers used to build the distortion. Fewer octaves look smoother and simpler. More octaves add finer detail."
            )
        }
    }
}

private struct ParameterSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    var step: Double?
    let tint: Color
    let valueLabel: String
    let explanation: String
    var swatch: Color?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 10) {
                Text(title)
                    .font(.headline)

                Spacer()

                if let swatch {
                    Circle()
                        .fill(swatch)
                        .frame(width: 14, height: 14)
                        .overlay {
                            Circle()
                                .stroke(.quaternary, lineWidth: 1)
                        }
                }

                Text(valueLabel)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }

            if let step {
                Slider(value: $value, in: range, step: step)
                    .tint(tint)
            } else {
                Slider(value: $value, in: range)
                    .tint(tint)
            }

            Text(explanation)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
