//
//  PaperShadersDemoApp.swift
//  PaperShadersDemo
//
//  Created by Rafa on 11/05/26.
//

import SwiftUI

@main
struct PaperShadersDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                #if os(iOS)
                    .statusBarHidden()
                #endif
        }
    }
}
