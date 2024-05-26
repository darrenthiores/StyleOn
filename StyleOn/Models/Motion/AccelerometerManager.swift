//
//  AcceleroManager.swift
//  StyleOn
//
//  Created by Darren Thiores on 26/05/24.
//

import Foundation
import CoreMotion

class AccelerometerManager: ObservableObject {
    private let manager = CMMotionManager()
    
    @Published var x = 0.0
    @Published var y = 0.0
    @Published var z = 0.0
    
    init(){
        manager.accelerometerUpdateInterval = 1
        
        manager.startAccelerometerUpdates(to: OperationQueue.current!) { [weak self] data, error in
            if let myData = data {
                DispatchQueue.main.async {
                    self?.x = myData.acceleration.x
                    self?.y = myData.acceleration.y
                    self?.z = myData.acceleration.z
                }
            }
        }
    }
    
    func stopUpdates() {
        manager.stopAccelerometerUpdates()
    }
}
