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
    
    let maxFrameUpdateCount: Int = 10
    var currentFrameCount: Int = 0
    
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
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        currentFrameCount += 1
        
        if currentFrameCount < maxFrameUpdateCount {
            return
        }
        
        currentFrameCount = 0
        
        DispatchQueue.global(qos: .background).async {
            let qrResponses = QRScanner.findQR(in: frame)
            print(qrResponses)
//            for response in qrResponses {
//                print(response.feature.messageString ?? "no message found")
//            }
        }
    }
    
}
