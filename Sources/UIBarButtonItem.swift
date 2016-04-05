//
//  UIBarButtonItem.swift
//  ReactiveUIKit
//
//  Created by Srdan Rasic on 02/04/16.
//  Copyright © 2016 Srdan Rasic. All rights reserved.
//

import UIKit
import ReactiveKit

@objc class RKUIBarButtonItemHelper: NSObject
{
  weak var barButtonItem: UIBarButtonItem?
  let pushStream = PushStream<Void>()

  init(barButtonItem: UIBarButtonItem) {
    self.barButtonItem = barButtonItem
    super.init()
    barButtonItem.target = self
    barButtonItem.action = #selector(RKUIBarButtonItemHelper.barButtonItemDidTap)
  }

  func barButtonItemDidTap() {
    pushStream.next()
  }

  deinit {
    barButtonItem?.target = nil
    pushStream.completed()
  }
}

extension UIBarButtonItem {

  private struct AssociatedKeys {
    static var BarButtonItemHelperKey = "r_BarButtonItemHelperKey"
  }

  public var rTap: Stream<Void> {
    if let helper: AnyObject = objc_getAssociatedObject(self, &AssociatedKeys.BarButtonItemHelperKey) {
      return (helper as! RKUIBarButtonItemHelper).pushStream.toStream()
    } else {
      let helper = RKUIBarButtonItemHelper(barButtonItem: self)
      objc_setAssociatedObject(self, &AssociatedKeys.BarButtonItemHelperKey, helper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return helper.pushStream.toStream()
    }
  }
}
