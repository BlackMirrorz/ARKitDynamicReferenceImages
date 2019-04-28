//
//  VideoNode.swift
//  DynamicImage
//
//  Created By Josh Robbins (∩｀-´)⊃━☆ﾟ.*･｡ﾟ* 27/04/2019.
//  Copyright © 2019 BlackMirrorz. All rights reserved.
//

import Foundation
import ARKit

class VideoNode: SCNNode{
  
  //---------------------
  //MARK:- Initialization
  //---------------------
  
  /// Intializes AN AVPlayer Onto An SCNPlane Accounting For The ARReferenceImage Size
  ///
  /// - Parameter target: ARReferenceImage
  init(withReferenceImage target: ARReferenceImage) {
    super.init()
    
    //1. Create An SCNNode To Hold Our VideoPlayer
    let videoPlayerNode = SCNNode()
    
    //2. Create An SCNPlane & An AVPlayer
    let videoPlayerGeometry = SCNPlane(width: target.physicalSize.width, height: target.physicalSize.height)
    var videoPlayer = AVPlayer()
    
    //3. If We Have A Valid Name & A Valid Video URL The Instanciate The AVPlayer
    if let targetName = target.name,
      let validURL = Bundle.main.url(forResource: targetName + "Movie", withExtension: "mp4", subdirectory: nil) {
      videoPlayer = AVPlayer(url: validURL)
      videoPlayer.play()
    }
    
    //4. Assign The AVPlayer & The Geometry To The Video Player
    videoPlayerGeometry.firstMaterial?.diffuse.contents = videoPlayer
    videoPlayerNode.geometry = videoPlayerGeometry
    
    //5. Rotate It
    videoPlayerNode.eulerAngles.x = -.pi / 2
    
    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem, queue: .main) {  _ in
      videoPlayer.seek(to: CMTime.zero)
      videoPlayer.play()
    }
    
    self.addChildNode(videoPlayerNode)
    
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  deinit { NotificationCenter.default.removeObserver(self) }
}
