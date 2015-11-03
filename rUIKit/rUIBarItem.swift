//
//  rUIBarItem.swift
//  rUIKit
//
//  Created by Srdan Rasic on 03/11/15.
//  Copyright © 2015 Srdan Rasic. All rights reserved.
//

import rFoundation
import rStreams
import UIKit

extension UIBarItem {
  
  public var rTitle: Observable<String?> {
    return rAssociatedObservableForValueForKey("title")
  }
  
  public var rImage: Observable<UIImage?> {
    return rAssociatedObservableForValueForKey("image")
  }
  
  public var rEnabled: Observable<Bool> {
    return rAssociatedObservableForValueForKey("enabled")
  }
}
