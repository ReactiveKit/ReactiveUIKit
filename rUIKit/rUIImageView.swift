//
//  rImageView.swift
//  rUIKit
//
//  Created by Srdan Rasic on 03/11/15.
//  Copyright © 2015 Srdan Rasic. All rights reserved.
//

import rFoundation
import rKit
import UIKit

extension UIImageView {
  
  public var rImage: Observable<UIImage?> {
    return rAssociatedObservableForValueForKey("image")
  }
}
