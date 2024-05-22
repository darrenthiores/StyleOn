//
//  ARViewExtension.swift
//  StyleOn
//
//  Created by Darren Thiores on 21/05/24.
//

import Foundation
import RealityKit
import ARKit

extension ARView: ARSessionDelegate {
    func setupBodyTracking() {
        let config = ARBodyTrackingConfiguration()
        self.session.run(config)
        
        self.session.delegate = self
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
                
                if let skeleton = bodySkeleton {
                    skeleton.update(with: bodyAnchor)
                } else {
                    let skeleton = BodySkeleton(for: bodyAnchor)
                    bodySkeleton = skeleton
                    
                    bodySkeletonAnchor.addChild(skeleton)
                }
            }
        }
    }
}
