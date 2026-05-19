//
//  Paper.metal
//  PaperShaders
//
//  Created by Rafa on 11/05/26.
//

import Foundation
import SwiftUI

private enum PaperShaderLibrary {
    static let library = ShaderLibrary.bundle(.module)
}

extension View {
    /// Adds a paper-like grain overlay to the view.
    ///
    /// Use `color1` and `color2` to control the color of the grains.
    /// Increase `density` for more visible texture. Adjust `scale` to make the grains
    /// larger or smaller. `lacunarity`, `gain`, and `octaves` control the fractal noise shape:
    /// higher `lacunarity` adds more frequency between layers (finer details),
    /// lower `gain` softens the fine details, and higher `octaves` adds more detail.
    ///
    /// - Parameters:
    ///   - color1: The color used for one half of the grains.
    ///   - color2: The color used for the other half of the grains.
    ///   - density: How much of the space is filled by the grains. Higher values make grains bigger.
    ///   - scale: The scale of the texture. Lower values make grains smaller, higher values make grains larger.
    ///   - lacunarity: How quickly the noise frequency increases between layers. Higher values make details finer. Lower values make the noise layers closer together and smoother.
    ///   - gain: How quickly each successive noise layer loses strength. Higher values make it rougher. Lower values make it smoother.
    ///   - octaves: The number of noise layers used to build the texturre. Fewer octaves look smoother and simpler. More octaves add finer detail.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
    public func paperTexture(
        color1: Color = .white.opacity(0.2),
        color2: Color = .black.opacity(0.07),
        density: CGFloat = 0.52,
        scale: CGFloat = 0.91,
        lacunarity: CGFloat = 1.55,
        gain: CGFloat = 0.56,
        octaves: Int = 3
    ) -> some View {
        self
            .overlay {
                // This shape determines the mask of the effect (currently fixed to a rectangle)
                Rectangle()
                    .foregroundStyle(.black)
                    .allowsHitTesting(false)
                    .colorEffect(
                        PaperShaderLibrary.library.paperTexture(
                            .color(color1),
                            .color(color2),
                            .float(density),
                            .float(scale),
                            .float(lacunarity),
                            .float(gain),
                            .float(Float(octaves))
                        )
                    )
                    .ignoresSafeArea()
            }
    }

    /// Adds a subtle distortion to the view, replicating ink on paper.
    ///
    /// Use `amplitude` to control the intensity of the distortion, and `scale` to control the scale
    /// of the distortion field. `gradientStep` affects how the distortion samples the noise
    /// gradient, which changes how sharp or smooth the distortion feels. `lacunarity`, `gain`,
    /// and `octaves` shape the underlying fractal noise in the same way as in `paperTexture`.
    ///
    /// - Parameters:
    ///   - amplitude: The intensity of the distortion.
    ///   - scale: The scale of the distortion pattern. Lower values make it tighter, higher values spread it out.
    ///   - gradientStep: The sampling step used to compute the distortion direction. Higher values make it smoother. Lower values preserve sharper, finer detail.
    ///   - lacunarity: How quickly the noise frequency increases between layers. Higher values make details finer. Lower values make the noise layers closer together and smoother.
    ///   - gain: How quickly each successive noise layer loses strength. Higher values make it rougher. Lower values make it smoother.
    ///   - octaves: The number of noise layers used to build the distortion. Fewer octaves look smoother and simpler. More octaves add finer detail.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
    public func paperDistortion(
        amplitude: CGFloat = 0.72,
        scale: CGFloat = 0.96,
        gradientStep: CGFloat = 0.04,
        lacunarity: CGFloat = 1.24,
        gain: CGFloat = 0.53,
        octaves: Int = 5
    ) -> some View {
        distortionEffect(
            PaperShaderLibrary.library.paperDistortion(
                .float(amplitude),
                .float(scale),
                .float(gradientStep),
                .float(lacunarity),
                .float(gain),
                .float(Float(octaves))
            ),
            maxSampleOffset: CGSize(width: amplitude, height: amplitude)
        )
    }
}
