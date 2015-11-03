//
//  r UIProgressView.swift
//  rUIKit
//
//  Created by Srdan Rasic on 03/11/15.
//  Copyright © 2015 Srdan Rasic. All rights reserved.
//

import rFoundation
import rStreams
import UIKit

extension UIProgressView {
  
  public var rProgress: Observable<Float> {
    return rAssociatedObservableForValueForKey("progress")
  }
}
