//
//  BodySkeleton.swift
//  StyleOn
//
//  Created by Darren Thiores on 21/05/24.
//

import Foundation
import ARKit
import RealityKit

class BodySkeleton: Entity {
    var joints: [String: Entity] = [:]
    var shirt: Wearable?
    var pant: Wearable?
    var shirtEntity: Entity?
    var pantEntity: Entity?
    // var imageEntity: Entity?
    
    required init(for bodyAnchor: ARBodyAnchor) {
        super.init()
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            var jointRadius: Float = 0.03
            var jointColor: UIColor = .green
            
            var jointEntity = makeJoint(radius: jointRadius, color: jointColor)
            joints[jointName] = jointEntity
            self.addChild(jointEntity)
        }
        
//        do {
//            let path = Bundle.main.path(forResource: "BlueCollarPolo", ofType: "usdz")!
//            let url = URL(fileURLWithPath: path)
//            var shirtEntity = try Entity.load(contentsOf: url)
//            
//            shirtEntity.scale = [0.25, 0.25, 0.25]
//            shirtEntity.position = simd_make_float3(bodyAnchor.transform.columns.3)
//            
//            self.addChild(shirtEntity)
//            self.shirtEntity = shirtEntity
//            
//        } catch {
//            print("load shirt error \(error.localizedDescription)")
//        }
//        
//        do {
//            let path = Bundle.main.path(forResource: "WhitePants", ofType: "usdz")!
//            let url = URL(fileURLWithPath: path)
//            var pantEntity = try Entity.load(contentsOf: url)
//            
//            pantEntity.scale = [0.4, 0.4, 0.4]
//            pantEntity.position = simd_make_float3(bodyAnchor.transform.columns.3)
//            
//            self.addChild(pantEntity)
//            self.pantEntity = pantEntity
//            
//            print("load pants succeed")
//            
//        } catch {
//            print("load pants error \(error.localizedDescription)")
//        }
        
//        do {
//            var plane: MeshResource = .generatePlane(width: 1, depth: 0.45)
//            var material = SimpleMaterial()
//            let path = Bundle.main.path(forResource: "blackTShirt", ofType: "png")!
//            let url = URL(fileURLWithPath: path)
//            
//            if #available(iOS 15.0, *) {
//                print("here init")
//                
//                material.color = try .init(
//                    tint: .white.withAlphaComponent(0.999),
//                    texture: .init(.load(contentsOf: url))
//                )
//            }
//            
//            material.metallic = .float(1.0)
//            material.roughness = .float(0.0)
//            
//            let ballEntity = ModelEntity(mesh: plane, materials: [material])
//            if let jointTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName.root) {
//                ballEntity.orientation = Transform(matrix: jointTransform).rotation
//            }
//            
//            self.addChild(ballEntity)
//            self.imageEntity = ballEntity
//            
//        } catch {
//            print("load shirt error \(error.localizedDescription)")
//        }
        
        self.update(with: bodyAnchor)
    }
    
    required init() {
        fatalError("Shouldn't go this way")
    }
    
    func makeJoint(radius: Float, color: UIColor) -> Entity {
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(
            color: color,
            roughness: 0.8,
            isMetallic: false
        )
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        
        return modelEntity
    }
    
    func update(with bodyAnchor: ARBodyAnchor) {
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            if let jointEntity = joints[jointName], let jointTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: jointName)) {
                let jointOffset = simd_make_float3(jointTransform.columns.3)
                jointEntity.position = rootPosition + jointOffset
                jointEntity.orientation = Transform(matrix: jointTransform).rotation
                
                if jointName == "spine_5_joint" {
                    shirtEntity?.position = rootPosition + jointOffset
//                    shirtEntity?.orientation = Transform(matrix: jointTransform).rotation
                    
                    let positiveY = jointOffset.y < 0 ? -jointOffset.y : jointOffset.y
                    pantEntity?.position = rootPosition - simd_float3(0, positiveY * 2, 0)
                }
                
            }
        }
        
//        let positiveY = rootPosition.y < 0 ? -rootPosition.y : rootPosition.y
//        pantEntity?.position = rootPosition - simd_float3(0, positiveY, 0)
        
//        if let rootJointTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName.root) {
//             shirtEntity?.orientation = Transform(matrix: rootJointTransform).rotation
//             pantEntity?.orientation = Transform(matrix: rootJointTransform).rotation
//            // imageEntity?.orientation = Transform(matrix: rootJointTransform).rotation
//        }
        
        // shirtEntity?.position = simd_make_float3(bodyAnchor.transform.columns.3)
        // imageEntity?.position = simd_make_float3(bodyAnchor.transform.columns.3)
    }
    
    func setWearables(
        shirt: Wearable?,
        pant: Wearable?,
        with bodyAnchor: ARBodyAnchor
    ) {
        if shirt?.id != self.shirt?.id {
            if shirt?.id == Wearable.searchWearable.id {
                if let shirtEntity = shirtEntity {
                    self.removeChild(shirtEntity)
                }
                
                self.shirt = nil
                shirtEntity = nil
                
                return
            }
            
            if let shirt = shirt {
                self.shirt = shirt
                
                if let shirtEntity = shirtEntity {
                    self.removeChild(shirtEntity)
                }
                
                loadShirt(shirt: shirt, with: bodyAnchor)
            } else {
                if let shirtEntity = shirtEntity {
                    self.removeChild(shirtEntity)
                }
                
                self.shirt = nil
                shirtEntity = nil
            }
        }
        
        if pant?.id != self.pant?.id {
            if pant?.id == Wearable.searchWearable.id {
                if let pantEntity = pantEntity {
                    self.removeChild(pantEntity)
                }
                
                self.pant = nil
                pantEntity = nil
                
                return
            }
            
            if let pant = pant {
                self.pant = pant
                
                if let pantEntity = pantEntity {
                    self.removeChild(pantEntity)
                }
                
                loadPant(pant: pant, with: bodyAnchor)
            } else {
                if let pantEntity = pantEntity {
                    self.removeChild(pantEntity)
                }
                
                self.pant = nil
                pantEntity = nil
            }
        }
    }
    
    private func loadShirt(
        shirt: Wearable,
        with bodyAnchor: ARBodyAnchor
    ) {
        DispatchQueue.main.async {
            do {
                let path = Bundle.main.path(forResource: shirt.id, ofType: "usdz")!
                let url = URL(fileURLWithPath: path)
                var shirtEntity = try Entity.load(contentsOf: url)
                
                shirtEntity.scale = shirt.scale
                shirtEntity.position = simd_make_float3(bodyAnchor.transform.columns.3)
                
                self.addChild(shirtEntity)
                self.shirtEntity = shirtEntity
                
            } catch {
                print("load shirt error \(error.localizedDescription)")
            }
        }
    }
    
    private func loadPant(
        pant: Wearable,
        with bodyAnchor: ARBodyAnchor
    ) {
        DispatchQueue.main.async {
            do {
                let path = Bundle.main.path(forResource: pant.id, ofType: "usdz")!
                let url = URL(fileURLWithPath: path)
                var pantEntity = try Entity.load(contentsOf: url)
                
                pantEntity.scale = pant.scale
                pantEntity.position = simd_make_float3(bodyAnchor.transform.columns.3)
                
                self.addChild(pantEntity)
                self.pantEntity = pantEntity
                
            } catch {
                print("load pant error \(error.localizedDescription)")
            }
        }
    }
}
