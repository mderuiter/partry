//
//  ViewController.swift
//  PartyAR
//
//  Created by milan de Ruiter on 06/04/2019.
//  Copyright © 2019 Milan de Ruiter. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

protocol SpinnerDelegate: class {
    func updateSpinner()
}

fileprivate let ReferenceImageGroupName = "AR Resources"

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var sceneDelegate: CustomARSceneDelegate?
    private var sessionDelegate: CustomARSessionDelegate?
    
    lazy var statusViewController: StatusViewController = {
        return children.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneDelegate = CustomARSceneDelegate()
        sceneDelegate?.sceneView = sceneView
        sceneDelegate?.spinnerDelegate = self
        
        sessionDelegate = CustomARSessionDelegate()
        sessionDelegate?.delegate = self
        sessionDelegate?.sceneView = sceneView
        
        sceneView.delegate = sceneDelegate
        sceneView.session.delegate = sessionDelegate
        sceneView.automaticallyUpdatesLighting = false
        sceneView.autoenablesDefaultLighting = false
        
        self.spinner.startAnimating()
        
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.sessionDelegate?.restartExperience()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        restartTracking()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, touch.view == self.sceneView else {
            return
        }
        
        let viewTouchLocation:CGPoint = touch.location(in: sceneView)
        guard let result = sceneView.hitTest(viewTouchLocation, options: nil).first,
            let plane = sceneDelegate?.planes.first(where: { $0.1.node == result.node })?.value,
            let imagePlane = plane as? ImagePlane
            else { return }
        
        print(sceneDelegate?.planes.count)
        imagePlane.textNode?.isHidden = !imagePlane.textNode!.isHidden
        print("Is tapped on image")
        //videoPlane.toggleVideoPlayer()
    }
    
}

extension ViewController: SpinnerDelegate {
    
    func updateSpinner() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.statusViewController.showMessage("Application is ready")
        }
    }
    
}

extension ViewController: ARRestartDelegate {
    
    func restartTracking() {
        guard let detectionImages = ARReferenceImage.referenceImages(inGroupNamed: ReferenceImageGroupName, bundle: nil) else { return }
        
        let imageTrackingConfiguration: ARImageTrackingConfiguration = {
            let configuration = ARImageTrackingConfiguration()
            configuration.trackingImages = detectionImages
            configuration.isLightEstimationEnabled = true
            return configuration
        }()
        
        sceneView.session.run(imageTrackingConfiguration, options: [.resetTracking, .removeExistingAnchors])
        statusViewController.showMessage("Loaded images")
    }
    
}
