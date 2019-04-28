//
//  ImageDownloader.swift
//  DynamicImage
//
//  Created By Josh Robbins (∩｀-´)⊃━☆ﾟ.*･｡ﾟ* 27/04/2019.
//  Copyright © 2019 BlackMirrorz. All rights reserved.
//

import Foundation
import UIKit
import ARKit

//-------------------
//MARK:- Media Suffix
//-------------------

enum FileSuffix {
 
  case JPEG, PNG
  
  /// The Type Of Extension
  var name: String{
    switch self {
    case .JPEG: return ".jpg"
    case .PNG:  return ".png"
    }
  }
}

//------------------------------
//MARK:- Reference Image Payload
//------------------------------

/// Constructor For Generating Dynamic Reference Images
struct ReferenceImagePayload{
  
  var name: String
  var extensionType: String
  var orientation: CGImagePropertyOrientation
  var widthInM: CGFloat = 0.1

}

class ImageDownloader{
  
  typealias completionHandler = (Result<Set<ARReferenceImage>, Error>) -> ()
  typealias ImageData = (image: UIImage, orientation: CGImagePropertyOrientation, physicalWidth: CGFloat, name: String)
  
  static let BASE_PATH = "http://blackmirrorz.tech/images/DynamicReferenceImages/"
  
  static let payloadData: [ReferenceImagePayload] = [
    ReferenceImagePayload(name: "sally", extensionType: FileSuffix.JPEG.name, orientation: .up, widthInM: 0.1),
    ReferenceImagePayload(name: "choco", extensionType: FileSuffix.JPEG.name, orientation: .up, widthInM: 0.1),
    ReferenceImagePayload(name: "cony", extensionType: FileSuffix.JPEG.name, orientation: .up, widthInM: 0.1),
    ReferenceImagePayload(name: "brown", extensionType: FileSuffix.JPEG.name, orientation: .up, widthInM: 0.1)
  ]
  
  static var receivedImageData = [ImageData]()
  
  
  /// Downloads Images From A Specified Server And If Succesful Converts Them To A Set Of ARReferenceImages
  ///
  /// - Parameter completion: (Result<[UIImage], Error>)
  class func downloadImagesFromPaths(_ completion: @escaping completionHandler) {
  
    let operationQueue = OperationQueue()
   
    operationQueue.maxConcurrentOperationCount = 6
    
    let completionOperation = BlockOperation {
      
      OperationQueue.main.addOperation({
      
       completion(.success(referenceImageFrom(receivedImageData)))
        
      })
    }
 
    payloadData.forEach { (payload) in
      
      guard let url = URL(string: BASE_PATH + payload.name + payload.extensionType) else { return }

      let operation = BlockOperation(block: {
        
        do{
         
          let imageData = try Data(contentsOf: url)
          
          if let image = UIImage(data: imageData){
            
             receivedImageData.append(ImageData(image, payload.orientation, payload.widthInM, payload.name))
          }
         
        }catch{
          
          completion(.failure(error))
        }
        
      })
      
      completionOperation.addDependency(operation)
      
    }
    
    operationQueue.addOperations(completionOperation.dependencies, waitUntilFinished: false)
    operationQueue.addOperation(completionOperation)
 
  }
  
  /// Creates A Set Of <ARReferenceImage> From An Array Of [ImageData]
  ///
  /// - Parameter downloadedData: [ImageData]
  /// - Returns: Set<ARReferenceImage>
  class func referenceImageFrom(_ downloadedData: [ImageData]) -> Set<ARReferenceImage>{
    
    var referenceImages = Set<ARReferenceImage>()
    
    downloadedData.forEach {
      
      guard let cgImage = $0.image.cgImage else { return }
      let referenceImage = ARReferenceImage(cgImage, orientation: $0.orientation, physicalWidth: $0.physicalWidth)
      referenceImage.name = $0.name
      referenceImages.insert(referenceImage)
    }
    
    return referenceImages
    
  }
  
}
