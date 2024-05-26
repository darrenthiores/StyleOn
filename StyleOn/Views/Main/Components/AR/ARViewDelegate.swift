//
//  ARViewExtension.swift
//  StyleOn
//
//  Created by Darren Thiores on 21/05/24.
//

import Foundation
import RealityKit
import ARKit

class ARViewDelegate: NSObject, ARSessionDelegate {
    var arView: ARView?
    var shirt: Wearable?
    var pant: Wearable?
    
    func setupBodyTracking(_ arView: ARView) {
        self.arView = arView
        
        let config = ARBodyTrackingConfiguration()
        self.arView?.session.run(config)
        
        self.arView?.session.delegate = self
    }
    
    func setupWearables(shirt: Wearable?, pant: Wearable?) {
        self.shirt = shirt
        self.pant = pant
    }
    
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            
            if let bodyAnchor = anchor as? ARBodyAnchor {
                if let skeleton = BodySkeletonVariables.bodySkeleton {
                    skeleton.setWearables(shirt: shirt, pant: pant, with: bodyAnchor)
                    skeleton.update(with: bodyAnchor)
                } else {
                    let skeleton = BodySkeleton(for: bodyAnchor)
                    BodySkeletonVariables.bodySkeleton = skeleton
                    
                    BodySkeletonVariables.bodySkeletonAnchor.addChild(skeleton)
                }
            }
            
            if let faceAnchor = anchor as? ARFaceAnchor {
                if let skeleton = BodySkeletonVariables.bodySkeleton {
                    skeleton.setWearables(shirt: shirt, pant: pant, with: faceAnchor)
                    skeleton.update(with: faceAnchor)
                } else {
                    let skeleton = BodySkeleton(for: faceAnchor)
                    BodySkeletonVariables.bodySkeleton = skeleton
                    
                    BodySkeletonVariables.bodySkeletonAnchor.addChild(skeleton)
                }
            }
        }
    }
    
    func switchCamera() {
        guard var newConfig = self.arView?.session.configuration else {
            fatalError("Unexpectedly failed to get the configuration.")
        }
        
        switch newConfig {
        case is ARBodyTrackingConfiguration:
            newConfig = ARFaceTrackingConfiguration()
        case is ARFaceTrackingConfiguration:
            newConfig = ARBodyTrackingConfiguration()
        default:
            newConfig = ARBodyTrackingConfiguration()
        }
        
        if let skeleton = BodySkeletonVariables.bodySkeleton {
            skeleton.reset()
            
            if skeleton.children.isEmpty {
                self.arView?.session.run(newConfig)
            }
        }
    }
}
