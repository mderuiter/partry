//
//  Plane.swift
//  Augemented
//
//  Created by milan de Ruiter on 12/03/2019.
//  Copyright © 2019 milan de Ruiter. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class Plane: SCNNode {
    
    var plane: SCNBox
    var node: SCNNode
    
    var textNode: TextPlane?
    
    init(color: UIColor = .clear) {
        plane = SCNBox(width: 1, height: CGFloat(0.1), length: 0, chamferRadius: 0)
        node = SCNNode(geometry: plane)
        node.geometry?.firstMaterial?.diffuse.contents = color
        node.eulerAngles.x = -.pi / 2
   
        super.init()
        addChildNode(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for anchor: ARImageAnchor) {
        plane.width = anchor.referenceImage.physicalSize.width
        plane.height = anchor.referenceImage.physicalSize.height
    }
    
    //Adding the scene light to light node
    func addLightNode(with sceneLight: SCNLight) {
//        let sceneLight = sceneLight
//        sceneLight.type = .omni
//        
//        let lightNode = SCNNode()
//        
//        lightNode.light = sceneLight
//        lightNode.position = SCNVector3(1, 1, 1)
//        
//        addChildNode(lightNode)
    }
    
}
