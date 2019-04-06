//
//  ImagePlane.swift
//  Augemented
//
//  Created by milan de Ruiter on 12/03/2019.
//  Copyright © 2019 milan de Ruiter. All rights reserved.
//

import UIKit

class ImagePlane: Plane {
    
    private let image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init()
        node.geometry?.firstMaterial?.diffuse.contents = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

