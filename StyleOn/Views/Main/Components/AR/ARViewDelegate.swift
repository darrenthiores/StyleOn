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
//                print("Updated body anchor")
//                
//                let skeleton = bodyAnchor.skeleton
//                
//                let rootJointTransform = skeleton.modelTransform(for: .root)!
//                let rootJointPosition = simd_make_float3(rootJointTransform.columns.3)
//                print("root \(rootJointPosition)")
//                
//                let leftHandTransform = skeleton.modelTransform(for: .leftHand)!
//                let leftHandOffset = simd_make_float3(leftHandTransform.columns.3)
//                let leftHandPosition = rootJointPosition + leftHandOffset
//                print("leftHand: \(leftHandPosition)")
                
                if let skeleton = BodySkeletonVariables.bodySkeleton {
                    skeleton.setWearables(shirt: shirt, pant: pant, with: bodyAnchor)
                    skeleton.update(with: bodyAnchor)
                } else {
                    let skeleton = BodySkeleton(for: bodyAnchor)
                    BodySkeletonVariables.bodySkeleton = skeleton
                    
                    BodySkeletonVariables.bodySkeletonAnchor.addChild(skeleton)
                }
            }
        }
    }
}
