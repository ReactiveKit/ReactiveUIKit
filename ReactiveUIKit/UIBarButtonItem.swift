//
//  UIBarButtonItem.swift
//  ReactiveUIKit
//
//  Created by Ivan Misuno on 01/01/16.
//  Copyright © 2016 Srdan Rasic. All rights reserved.
//

import UIKit
import ReactiveKit
import ReactiveFoundation

@objc class RKUIBarButtonItemHelper: NSObject
{
    weak var barButtonItem: UIBarButtonItem?
    let observer: Void -> Void

    init(barButtonItem: UIBarButtonItem, observer: Void -> Void) {
        self.barButtonItem = barButtonItem
        self.observer = observer
        super.init()
        if barButtonItem.target != nil {
            NSLog("Hijacking existing UIBarButtonItem's target and action: \(barButtonItem)")
        }
        barButtonItem.target = self
        barButtonItem.action = Selector("eventHandler:")
    }

    func eventHandler(sender: AnyObject) {
        observer()
    }

    deinit {
        barButtonItem?.target = nil
    }
}

extension UIBarButtonItem {

    private struct AssociatedKeys {
        static var BarButtonItemActionKey = "r_BarButtonItemActionKey"
        static var BarButtonItemBondHelperKey = "r_BarButtonItemBondHelperKey"
    }

    public var rAction: ActiveStream<Void> {
        if let rAction: AnyObject = objc_getAssociatedObject(self, &AssociatedKeys.BarButtonItemActionKey) {
            return rAction as! ActiveStream<Void>
        } else {
            var capturedObserver: (Void -> Void)! = nil

            let rAction = ActiveStream<Void> { observer in
                capturedObserver = observer
                return nil
            }

            let barButtonItemHelper = RKUIBarButtonItemHelper(barButtonItem: self, observer: capturedObserver)

            objc_setAssociatedObject(self, &AssociatedKeys.BarButtonItemBondHelperKey, barButtonItemHelper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(self, &AssociatedKeys.BarButtonItemActionKey, rAction, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return rAction
        }
    }
}
