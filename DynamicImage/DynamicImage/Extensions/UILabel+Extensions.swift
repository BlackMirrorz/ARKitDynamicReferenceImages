//
//  UILabel+Extensions.swift
//  DynamicImage
//
//  Created By Josh Robbins (∩｀-´)⊃━☆ﾟ.*･｡ﾟ* 27/04/2019.
//  Copyright © 2019 BlackMirrorz. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
  
  /// Updates The Text And Hides It After A Delay
  ///
  /// - Parameters:
  ///   - text: String
  ///   - delay: Double
  func showText(_ text: String, andHideAfter delay: Double){
    
    DispatchQueue.main.async {
      
      self.text = text
      self.alpha = 1
      UIView.animate(withDuration: delay, animations: { self.alpha = 0 } )
    }
    
  }
}
