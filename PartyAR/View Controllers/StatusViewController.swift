//
//  StatusViewController.swift
//  PartyAR
//
//  Created by milan de Ruiter on 13/03/2019.
//  Copyright © 2019 milan de Ruiter. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak private var messagePanel: UIVisualEffectView!
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak private var restartExperienceButton: UIButton!
    
    // MARK: - Properties
    
    var restartExperienceHandler: () -> Void = {}
    
    // MARK: - Message Handling
    
    func showMessage(_ text: String, autoHide: Bool = true) {
        messageLabel.text = text
        setMessageHidden(false, animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction private func restartExperience(_ sender: UIButton) {
        restartExperienceHandler()
    }
    
    // MARK: - Panel Visibility
    
    private func setMessageHidden(_ hide: Bool, animated: Bool) {
        messagePanel.isHidden = false
        
        guard animated else {
            messagePanel.alpha = hide ? 0 : 1
            return
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState], animations: {
            self.messagePanel.alpha = hide ? 0 : 1
        }, completion: nil)
    }
    
}
