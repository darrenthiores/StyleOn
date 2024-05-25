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
    var arDelegate: ARViewDelegate
    
    func makeUIView(context: Context) -> ARView {
        ARVariables.arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        
        arDelegate.setupBodyTracking(ARVariables.arView)
        
        ARVariables.arView.scene.addAnchor(BodySkeletonVariables.bodySkeletonAnchor)
        
        return ARVariables.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
    }
}
