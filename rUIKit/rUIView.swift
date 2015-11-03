//
//  rUIView.swift
//  rUIKit
//
//  Created by Srdan Rasic on 03/11/15.
//  Copyright © 2015 Srdan Rasic. All rights reserved.
//

import rFoundation
import rStreams
import UIKit

extension UIView {
  
  public var rAlpha: Observable<CGFloat> {
    return rAssociatedObservableForValueForKey("alpha")
  }
  
  public var rBackgroundColor: Observable<UIColor?> {
    return rAssociatedObservableForValueForKey("backgroundColor")
  }
  
  public var rHidden: Observable<Bool> {
    return rAssociatedObservableForValueForKey("hidden")
  }
  
  public var rUserInteractionEnabled: Observable<Bool> {
    return rAssociatedObservableForValueForKey("userInteractionEnabled")
  }
  
  public var rTintColor: Observable<UIColor?> {
    return rAssociatedObservableForValueForKey("tintColor")
  }
}
