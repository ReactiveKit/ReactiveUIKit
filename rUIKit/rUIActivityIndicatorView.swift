//
//  rActivityIndicatorView.swift
//  rUIKit
//
//  Created by Srdan Rasic on 03/11/15.
//  Copyright © 2015 Srdan Rasic. All rights reserved.
//

import rFoundation
import rStreams
import UIKit

extension UIActivityIndicatorView {
  
  public var rAnimating: Observable<Bool> {
    return rAssociatedObservableForValueForKey("isAnimating", initial: self.isAnimating()) { [weak self] animating in
      if animating {
        self?.startAnimating()
      } else {
        self?.stopAnimating()
      }
    }
  }
}
