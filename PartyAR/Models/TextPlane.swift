//
//  TextPlane.swift
//  PartyAR
//
//  Created by milan de Ruiter on 06/04/2019.
//  Copyright © 2019 Milan de Ruiter. All rights reserved.
//

import UIKit
import ARKit

class TextPlane: Plane {
    
    init(text: String) {
        super.init()
        plane = SCNBox(width: 1, height: CGFloat(0.1), length: 0, chamferRadius: 0)
        
        let text = SCNText(string: text, extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 2.0)
        text.flatness = 0.01
        text.firstMaterial?.diffuse.contents = UIColor.white
        
        node = SCNNode(geometry: text)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        node.eulerAngles.x = -.pi / 2
        
        let fontSize = Float(0.04)
        node.scale = SCNVector3(fontSize, fontSize, fontSize)
        
        addChildNode(node)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
