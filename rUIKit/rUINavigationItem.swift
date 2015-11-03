//
//  rUINavigationItem.swift
//  rUIKit
//
//  Created by Srdan Rasic on 03/11/15.
//  Copyright © 2015 Srdan Rasic. All rights reserved.
//

import rFoundation
import rKit
import UIKit

extension UINavigationItem {
  
  public var rTitle: Observable<String?> {
    return rAssociatedObservableForValueForKey("title")
  }
}
