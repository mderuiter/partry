//
//  CustomARSceneDelegate.swift
//  PartyAR
//
//  Created by milan de Ruiter on 06/04/2019.
//  Copyright © 2019 Milan de Ruiter. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class CustomARSceneDelegate: NSObject {

    var planes: [ARImageAnchor: Plane] = [:]
    private var sceneLight = SCNLight()
    
    var sceneView: ARSCNView?
    weak var spinnerDelegate: SpinnerDelegate?
    
    func addPersona(for node: SCNNode, anchor: ARImageAnchor) {
        let plane = ViewPlane()
        addPlane(plane, to: node, with: anchor)
    }
    
    func addText(plane: Plane, for node: SCNNode, anchor: ARImageAnchor) {
        let textPlane = TextPlane(text: """
            JOHN DOEEEE
            16 jaar
            """)
        
        plane.textNode = textPlane
        plane.textNode?.isHidden = true
        addPlane(textPlane, to: node, with: anchor, on: .init(0.1, 0, -0.4))
    }
    
    func addImage(_ named: String, for node: SCNNode, anchor: ARImageAnchor) {
        let plane = ImagePlane(image: UIImage(named: named)!)
        addText(plane: plane, for: node, anchor: anchor)
        addPlane(plane, to: node, with: anchor, on: .init(0, 0, -0.5))
    }
    
    func addPlane(color: UIColor, for node: SCNNode, anchor: ARImageAnchor) {
        let plane = Plane(color: color)
        addPlane(plane, to: node, with: anchor)
    }
    
    func addPlane(_ plane: Plane, to node: SCNNode, with anchor: ARImageAnchor, on position: SCNVector3 = .init(0, 0, 0)) {
        plane.update(for: anchor)
        plane.addLightNode(with: sceneLight)
        planes[anchor] = plane
        node.addChildNode(plane)
        plane.node.position.z += position.z
        plane.node.position.x += position.x
    }
    
}

extension CustomARSceneDelegate: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        let imageName = imageAnchor.referenceImage.name
        if imageName == "qrcode" {
            addImage("sims", for: node, anchor: imageAnchor)
            //addPersona(for: node, anchor: imageAnchor)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        // Get the Current Light Estimate
        guard let lightEstimate = self.sceneView?.session.currentFrame?.lightEstimate else { return }
        
        spinnerDelegate?.updateSpinner()
        
        //Get the ambientIntensity and color temperature
        let ambientLightEstimate = lightEstimate.ambientIntensity
        let ambientColorTemperature = lightEstimate.ambientColorTemperature
        
        // Scene lighting adjustment
        sceneLight.intensity = ambientLightEstimate
        sceneLight.temperature = ambientColorTemperature
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor, let plane = planes[imageAnchor] else { return }
        
        if imageAnchor.isTracked {
            plane.update(for: imageAnchor)
        }
        
        if let videoPlane = plane as? VideoPlane {
            if imageAnchor.isTracked {
                videoPlane.restartVideo()
            } else {
                videoPlane.pauseVideo()
            }
        }
    }
    
}
