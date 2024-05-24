//
//  ARViewContainer.swift
//  StyleOn
//
//  Created by Darren Thiores on 21/05/24.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        ARVariables.arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        ARVariables.arView.setupBodyTracking()
        
        ARVariables.arView.scene.addAnchor(bodySkeletonAnchor)
        
        return ARVariables.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
    }
}
