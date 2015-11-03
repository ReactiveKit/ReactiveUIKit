//
//  rUIRefreshControl.swift
//  rUIKit
//
//  Created by Srdan Rasic on 03/11/15.
//  Copyright © 2015 Srdan Rasic. All rights reserved.
//

import rFoundation
import rKit
import UIKit

extension UIRefreshControl {
  
  public var rRefreshing: Observable<Bool> {
    return rAssociatedObservableForValueForKey("refreshing") { [weak self] value in
      if value {
        self?.beginRefreshing()
      } else {
        self?.endRefreshing()
      }
    }
  }
}
