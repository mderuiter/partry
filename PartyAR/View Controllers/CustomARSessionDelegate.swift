//
//  CustomARSessionDelegate.swift
//  PartyAR
//
//  Created by milan de Ruiter on 13/03/2019.
//  Copyright © 2019 milan de Ruiter. All rights reserved.
//

import UIKit
import ARKit

protocol ARRestartDelegate: class {
    func restartTracking()
}

class CustomARSessionDelegate: NSObject {
    var isRestartAvailable = true
    weak var delegate: ARRestartDelegate?
}

extension CustomARSessionDelegate: ARSessionDelegate {
    
    func sessionInterruptionEnded(_ session: ARSession) {
        restartExperience()
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
    func restartExperience() {
        guard isRestartAvailable else { return }
        isRestartAvailable = false
        delegate?.restartTracking()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isRestartAvailable = true
        }
    }
    
}
