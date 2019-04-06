//
//  ViewPlane.swift
//  PartyAR
//
//  Created by milan de Ruiter on 06/04/2019.
//  Copyright © 2019 Milan de Ruiter. All rights reserved.
//

import UIKit

class ViewPlane: Plane {

    private var view: UIView? = nil
    
    init() {
        super.init()

        guard let view = Bundle.main.loadNibNamed("PersonaView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        
        
        view.backgroundColor = .clear
        self.view = view
        
        node.geometry?.firstMaterial?.diffuse.contents = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
