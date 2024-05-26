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
    var shirt: Wearable?
    var pant: Wearable?
    var shirtEntity: Entity?
    var pantEntity: Entity?
    
    required init(for bodyAnchor: ARBodyAnchor) {
        super.init()
        self.update(with: bodyAnchor)
    }
    
    required init(for faceAnchor: ARFaceAnchor) {
        super.init()
        self.update(with: faceAnchor)
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
        
        if let jointTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: "spine_4_joint")) {
            let jointOffset = simd_make_float3(jointTransform.columns.3)
            
            shirtEntity?.position = rootPosition + jointOffset - simd_float3(x: 0, y: 0, z: 0.2)
            
            let positiveY = jointOffset.y < 0 ? -jointOffset.y : jointOffset.y
            pantEntity?.position = rootPosition - simd_float3(0, positiveY * 3, 0.2)
        }
    }
    
    func update(with faceAnchor: ARFaceAnchor) {
        let rootPosition = simd_make_float3(faceAnchor.transform.columns.3)
        let positiveY = rootPosition.y < 0 ? -rootPosition.y : rootPosition.y
        
        shirtEntity?.position = simd_make_float3(
            rootPosition.x,
            rootPosition.y - positiveY * 4,
            rootPosition.z
        )
        
        pantEntity?.position = simd_make_float3(
            rootPosition.x,
            rootPosition.y - positiveY * 12,
            rootPosition.z
        )
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
    
    func setWearables(
        shirt: Wearable?,
        pant: Wearable?,
        with faceAnchor: ARFaceAnchor
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
                
                loadShirt(shirt: shirt, with: faceAnchor)
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
                
                loadPant(pant: pant, with: faceAnchor)
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
    
    private func loadShirt(
        shirt: Wearable,
        with faceAnchor: ARFaceAnchor
    ) {
        DispatchQueue.main.async {
            do {
                let path = Bundle.main.path(forResource: shirt.id, ofType: "usdz")!
                let url = URL(fileURLWithPath: path)
                var shirtEntity = try Entity.load(contentsOf: url)
                
                shirtEntity.scale = shirt.scale
                
                let rootPosition = faceAnchor.transform.columns.3
                let positiveY = rootPosition.y < 0 ? -rootPosition.y : rootPosition.y
                
                shirtEntity.position = simd_make_float3(
                    rootPosition.x,
                    rootPosition.y - positiveY * 4,
                    rootPosition.z
                )
                
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
    
    private func loadPant(
        pant: Wearable,
        with faceAnchor: ARFaceAnchor
    ) {
        DispatchQueue.main.async {
            do {
                let path = Bundle.main.path(forResource: pant.id, ofType: "usdz")!
                let url = URL(fileURLWithPath: path)
                var pantEntity = try Entity.load(contentsOf: url)
                
                pantEntity.scale = pant.scale
                
                let rootPosition = faceAnchor.transform.columns.3
                let positiveY = rootPosition.y < 0 ? -rootPosition.y : rootPosition.y
                
                pantEntity.position = simd_make_float3(
                    rootPosition.x,
                    rootPosition.y - positiveY * 12,
                    rootPosition.z
                )
                
                self.addChild(pantEntity)
                self.pantEntity = pantEntity
                
            } catch {
                print("load pant error \(error.localizedDescription)")
            }
        }
    }
    
    func reset() {
        for children in self.children {
            self.removeChild(children)
        }
        
        shirt = nil
        self.shirtEntity = nil
        
        pant = nil
        self.pantEntity = nil
    }
}
