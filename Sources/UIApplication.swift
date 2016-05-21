//
//  UIApplication.swift
//  ReactiveUIKit
//
//  Created by Srdan Rasic on 20/05/16.
//  Copyright © 2016 Srdan Rasic. All rights reserved.
//

import UIKit
import ReactiveKit

extension UIApplication {

  public var rNetworkActivityIndicatorVisible: Property<Bool> {
    return rAssociatedPropertyForValueForKey("networkActivityIndicatorVisible")
  }
}
