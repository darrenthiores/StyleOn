//
//  TiltPadView.swift
//  StyleOn
//
//  Created by Darren Thiores on 26/05/24.
//

import SwiftUI

struct TiltPadView: View {
    @StateObject private var accelerometerManager = AccelerometerManager()
    @State private var timer = Timer
        .publish(every: 0.1, on: .main, in: .common)
        .autoconnect()
    @State private var presentMain: Bool = false
    @State private var isPortrait: Bool = false
    
    private var imageName: String {
        if isPortrait {
            return "HoldVertical"
        } else {
            return "HoldHorizontal"
        }
    }
    
    var body: some View {
        VStack(spacing: 64) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 500)
            
            Text("Hold your device upright\nwith the screen facing you")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
        }
        .onReceive(timer) { _ in
            if isPortrait {
                if (accelerometerManager.y <= -0.878) && (accelerometerManager.y >= -0.9879) || (accelerometerManager.y >= 0.878) && (accelerometerManager.y <= 0.9879) {
                    accelerometerManager.stopUpdates()
                    presentMain = true
                }
            } else {
                if (accelerometerManager.x <= -0.878) && (accelerometerManager.x >= -0.9879) || (accelerometerManager.x >= 0.878) && (accelerometerManager.x <= 0.9879) {
                    accelerometerManager.stopUpdates()
                    presentMain = true
                }
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIDevice.orientationDidChangeNotification
            )
        ) { _ in
            guard let scene = UIApplication.shared.windows.first?.windowScene else {
                return
            }
            
            self.isPortrait = scene.interfaceOrientation.isPortrait
        }
        .onAppear {
            guard let scene = UIApplication.shared.windows.first?.windowScene else {
                return
            }
            
            self.isPortrait = scene.interfaceOrientation.isPortrait
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        .navigationDestination(isPresented: $presentMain) {
            MainView()
        }
    }
}

#Preview {
    TiltPadView()
}
