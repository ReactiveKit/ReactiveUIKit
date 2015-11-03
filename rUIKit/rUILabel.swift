//
//  rUILabel.swift
//  rUIKit
//
//  Created by Srdan Rasic on 03/11/15.
//  Copyright © 2015 Srdan Rasic. All rights reserved.
//

import rFoundation
import rKit
import UIKit

extension UILabel {
  
  public var rText: Observable<String?> {
    return rAssociatedObservableForValueForKey("text")
  }
  
  public var rAttributedText: Observable<NSAttributedString?> {
    return rAssociatedObservableForValueForKey("attributedText")
  }
  
  public var rTextColor: Observable<UIColor?> {
    return rAssociatedObservableForValueForKey("textColor")
  }
}

extension UILabel: BindableType {
  public func sink(disconnectDisposable: DisposableType?) -> (String? -> ()) {
    return self.rText.sink(disconnectDisposable)
  }
}
