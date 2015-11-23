//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Srdan Rasic (@srdanrasic)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import ReactiveKit
import ReactiveFoundation

@objc class RKUIControlHelper: NSObject
{
  weak var control: UIControl?
  let observer: UIControlEvents -> Void
  
  init(control: UIControl, observer: UIControlEvents -> Void) {
    self.control = control
    self.observer = observer
    super.init()
    control.addTarget(self, action: Selector("eventHandlerTouchDown"), forControlEvents: UIControlEvents.TouchDown)
    control.addTarget(self, action: Selector("eventHandlerTouchDownRepeat"), forControlEvents: UIControlEvents.TouchDownRepeat)
    control.addTarget(self, action: Selector("eventHandlerTouchDragInside"), forControlEvents: UIControlEvents.TouchDragInside)
    control.addTarget(self, action: Selector("eventHandlerTouchDragOutside"), forControlEvents: UIControlEvents.TouchDragOutside)
    control.addTarget(self, action: Selector("eventHandlerTouchDragEnter"), forControlEvents: UIControlEvents.TouchDragEnter)
    control.addTarget(self, action: Selector("eventHandlerTouchDragExit"), forControlEvents: UIControlEvents.TouchDragExit)
    control.addTarget(self, action: Selector("eventHandlerTouchUpInside"), forControlEvents: UIControlEvents.TouchUpInside)
    control.addTarget(self, action: Selector("eventHandlerTouchUpOutside"), forControlEvents: UIControlEvents.TouchUpOutside)
    control.addTarget(self, action: Selector("eventHandlerTouchCancel"), forControlEvents: UIControlEvents.TouchCancel)
    control.addTarget(self, action: Selector("eventHandlerValueChanged"), forControlEvents: UIControlEvents.ValueChanged)
    control.addTarget(self, action: Selector("eventHandlerEditingDidBegin"), forControlEvents: UIControlEvents.EditingDidBegin)
    control.addTarget(self, action: Selector("eventHandlerEditingChanged"), forControlEvents: UIControlEvents.EditingChanged)
    control.addTarget(self, action: Selector("eventHandlerEditingDidEnd"), forControlEvents: UIControlEvents.EditingDidEnd)
    control.addTarget(self, action: Selector("eventHandlerEditingDidEndOnExit"), forControlEvents: UIControlEvents.EditingDidEndOnExit)
  }
  
  func eventHandlerTouchDown() {
    observer(.TouchDown)
  }
  
  func eventHandlerTouchDownRepeat() {
    observer(.TouchDownRepeat)
  }
  
  func eventHandlerTouchDragInside() {
    observer(.TouchDragInside)
  }
  
  func eventHandlerTouchDragOutside() {
    observer(.TouchDragOutside)
  }
  
  func eventHandlerTouchDragEnter() {
    observer(.TouchDragEnter)
  }
  
  func eventHandlerTouchDragExit() {
    observer(.TouchDragExit)
  }
  
  func eventHandlerTouchUpInside() {
    observer(.TouchUpInside)
  }
  
  func eventHandlerTouchUpOutside() {
    observer(.TouchUpOutside)
  }
  
  func eventHandlerTouchCancel() {
    observer(.TouchCancel)
  }
  
  func eventHandlerValueChanged() {
    observer(.ValueChanged)
  }
  
  func eventHandlerEditingDidBegin() {
    observer(.EditingDidBegin)
  }
  
  func eventHandlerEditingChanged() {
    observer(.EditingChanged)
  }
  
  func eventHandlerEditingDidEnd() {
    observer(.EditingDidEnd)
  }
  
  func eventHandlerEditingDidEndOnExit() {
    observer(.EditingDidEndOnExit)
  }
  
  deinit {
    control?.removeTarget(self, action: nil, forControlEvents: UIControlEvents.AllEvents)
  }
}

extension UIControl {
  
  private struct AssociatedKeys {
    static var ControlEventKey = "r_ControlEventKey"
    static var ControlBondHelperKey = "r_ControlBondHelperKey"
  }
  
  public var rControlEvent: ActiveStream<UIControlEvents> {
    if let rControlEvent: AnyObject = objc_getAssociatedObject(self, &AssociatedKeys.ControlEventKey) {
      return rControlEvent as! ActiveStream<UIControlEvents>
    } else {
      var capturedObserver: (UIControlEvents -> Void)! = nil
      
      let rControlEvent = ActiveStream<UIControlEvents> { observer in
        capturedObserver = observer
        return nil
      }
      
      let controlHelper = RKUIControlHelper(control: self, observer: capturedObserver)
      
      objc_setAssociatedObject(self, &AssociatedKeys.ControlBondHelperKey, controlHelper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      objc_setAssociatedObject(self, &AssociatedKeys.ControlEventKey, rControlEvent, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return rControlEvent
    }
  }
  
  public var rEnabled: Observable<Bool> {
    return rAssociatedObservableForValueForKey("enabled")
  }
}
