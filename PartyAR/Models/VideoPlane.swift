//
//  VideoPlane.swift
//  Augemented
//
//  Created by milan de Ruiter on 12/03/2019.
//  Copyright © 2019 milan de Ruiter. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class VideoPlane: Plane {

    private let url: URL
    private let videoPlayer: AVPlayer
    
    private var pausedByUser: Bool = false
    
    init(url: URL) {
        self.url = url
        self.videoPlayer = AVPlayer(url: url)
        super.init()
        
        videoPlayer.volume = 10
        node.geometry?.firstMaterial?.diffuse.contents = videoPlayer
        videoPlayer.seek(to: CMTime.zero)
        videoPlayer.play()
    }
    
    func restartVideo() {
        if !pausedByUser {
            videoPlayer.play()
        }
    }
    
    func pauseVideo() {
        videoPlayer.seek(to: CMTime.zero)
        videoPlayer.pause()
        pausedByUser = false
    }
    
    func toggleVideoPlayer() {
        if videoPlayer.rate > 0 {
            pausedByUser = true
            videoPlayer.pause()
        } else {
            pausedByUser = false
            videoPlayer.play()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
