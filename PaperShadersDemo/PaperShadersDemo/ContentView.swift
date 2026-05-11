import SwiftUI

struct ContentView: View {
    @State private var selectedShader: DemoShader = .texture
    @State private var textureSettings = TextureSettings()
    @State private var distortionSettings = DistortionSettings()

    var body: some View {
        VStack(spacing: 0) {
            ShaderPreviewCard(
                textureSettings: textureSettings,
                distortionSettings: distortionSettings
            )
            .padding(.horizontal, 8)
            .padding(.top, 16)
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
            .zIndex(1)

            ScrollView {
                VStack(spacing: 28) {
                    ShaderControlPanel(
                        selectedShader: $selectedShader,
                        textureSettings: $textureSettings,
                        distortionSettings: $distortionSettings
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 32)
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
            }
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
        }
        .background {
            Rectangle()
                .fill(.background)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
