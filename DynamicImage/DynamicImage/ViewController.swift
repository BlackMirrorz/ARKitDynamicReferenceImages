//
//  ViewController.swift
//  DynamicImage
//
//  Created By Josh Robbins (∩｀-´)⊃━☆ﾟ.*･｡ﾟ* 27/04/2019.
//  Copyright © 2019 BlackMirrorz. All rights reserved.
//

import UIKit
import ARKit

//------------------------
//MARK:- ARSCNViewDelegate
//------------------------

extension ViewController: ARSCNViewDelegate{
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
   
    guard let imageAnchor = anchor as? ARImageAnchor, let imageName = imageAnchor.name?.capitalized else { return }
    trackingLabel.showText("\(imageName) Detected", andHideAfter: 5)
    node.addChildNode(VideoNode(withReferenceImage: imageAnchor.referenceImage))
    
  }
  
}

class ViewController: UIViewController {
  
  @IBOutlet weak var contentStackView: UIStackView!{
    didSet{
      contentStackView.subviews.forEach { $0.isHidden = true }
    }
  }
  
  @IBOutlet weak var trackingLabel: UILabel!
  
  @IBOutlet weak var downloadButton: UIButton!{
    didSet{
      downloadButton.layer.cornerRadius = 10
      downloadButton.layer.borderWidth = 2
      downloadButton.layer.borderColor = UIColor.white.cgColor
      downloadButton.layer.masksToBounds = true
    }
  }
  
  @IBOutlet weak var downloadSpinner: UIActivityIndicatorView!{
    didSet{
      downloadSpinner.alpha = 0
    }
  }
  
  @IBOutlet weak var downloadLabel: UILabel!{
    didSet{
      downloadLabel.text = ""
    }
  }
  
  @IBOutlet weak var augmentedRealityView: ARSCNView!
  var augmentedRealityConfiguration = ARImageTrackingConfiguration()
  var augmentedRealitySession = ARSession()
 
  //---------------------
  //MARK:- View LifeCycle
  //---------------------
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startARSession()
  
  }
  
  //-----------------------------------------
  //MARK:- Dynamic Reference Image Generation
  //-----------------------------------------
  
  /// Downloads Our Images From The Server And Initializes Our ARSession
  @IBAction func  generateImagesFromServer(){
  
    self.contentStackView.subviews[0].isHidden = false
    self.contentStackView.subviews[1].isHidden = true
    self.downloadSpinner.alpha = 1
    self.downloadSpinner.startAnimating()
    self.downloadLabel.text = "Downloading Images From Server"
    
    ImageDownloader.downloadImagesFromPaths { (result) in
      
      switch result{
        
      case .success(let dynamicConent):
        
        self.augmentedRealityConfiguration.maximumNumberOfTrackedImages = 10
        self.augmentedRealityConfiguration.trackingImages = dynamicConent
        self.augmentedRealitySession.run(self.augmentedRealityConfiguration, options: [.resetTracking, .removeExistingAnchors])
        
        
        DispatchQueue.main.async {
          
          self.downloadSpinner.alpha = 0
          self.downloadSpinner.stopAnimating()
          self.contentStackView.subviews[0].isHidden = true
          self.contentStackView.subviews[1].isHidden = false
          self.trackingLabel.showText("Images Generated Sucesfully", andHideAfter: 5)
          
        }
       
      case .failure(let error):
        
        print("An Error Occured Generating The Dynamic Reference Images \(error)")
      }
    }
    
  }

  //----------------
  //MARK:- ARSession
  //----------------
  func startARSession(){
    
    augmentedRealityView.session = augmentedRealitySession
    augmentedRealityView.delegate = self

    augmentedRealitySession.run(augmentedRealityConfiguration, options: [.resetTracking, .removeExistingAnchors])
    
  }
  

}

