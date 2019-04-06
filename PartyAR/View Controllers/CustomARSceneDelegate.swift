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
    
    func addVideo(_ video: String, for node: SCNNode, anchor: ARImageAnchor) {
        guard let url = Bundle.main.url(forResource: video, withExtension: "mp4") else { return }
        let plane = VideoPlane(url: url)
        addPlane(plane, to: node, with: anchor)
    }
    
    func addImage(_ named: String, for node: SCNNode, anchor: ARImageAnchor) {
        let plane = ImagePlane(image: UIImage(named: "sogeti")!)
        addPlane(plane, to: node, with: anchor)
    }
    
    func addPlane(color: UIColor, for node: SCNNode, anchor: ARImageAnchor) {
        let plane = Plane(color: color)
        addPlane(plane, to: node, with: anchor)
    }
    
    func addPlane(_ plane: Plane, to node: SCNNode, with anchor: ARImageAnchor) {
        plane.update(for: anchor)
        plane.addLightNode(with: sceneLight)
        planes[anchor] = plane
        node.addChildNode(plane)
    }
    
}

extension CustomARSceneDelegate: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        let imageName = imageAnchor.referenceImage.name
        
        switch imageName {
        case "Sogeti": addImage("sogeti", for: node, anchor: imageAnchor)
        case "Image1": addVideo("Plank Challange", for: node, anchor: imageAnchor)
        case "Image2": addVideo("Diggy Dex", for: node, anchor: imageAnchor)
        case "Image3": addPlane(color: .red, for: node, anchor: imageAnchor)
        default: return
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
