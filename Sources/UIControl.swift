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

@objc class RKUIControlHelper: NSObject
{
  weak var control: UIControl?
  let pushStream = PushStream<UIControlEvents>()
  
  init(control: UIControl) {
    self.control = control
    super.init()
    control.addTarget(self, action: #selector(RKUIControlHelper.eventHandlerTouchDown), forControlEvents: UIControlEvents.TouchDown)
    control.addTarget(self, action: #selector(RKUIControlHelper.eventHandlerTouchDownRepeat), forControlEvents: UIControlEvents.TouchDownRepeat)
    control.addTarget(self, action: #selector(RKUIControlHelper.eventHandlerTouchDragInside), forControlEvents: UIControlEvents.TouchDragInside)
    control.addTarget(self, action: #selector(RKUIControlHelper.eventHandlerTouchDragOutside), forControlEvents: UIControlEvents.TouchDragOutside)
    control.addTarget(self, action: #selector(RKUIControlHelper.eventHandlerTouchDragEnter), forControlEvents: UIControlEvents.TouchDragEnter)
    control.addTarget(self, action: #selector(RKUIControlHelper.eventHandlerTouchDragExit), forControlEvents: UIControlEvents.TouchDragExit)
    control.addTarget(self, action: #selector(RKUIControlHelper.eventHandlerTouchUpInside), forControlEvents: UIControlEvents.TouchUpInside)
    control.addTarget(self, action: #selector(RKUIControlHelper.eventHandlerTouchUpOutside), forControlEvents: UIControlEvents.TouchUpOutside)
    control.addTarget(self, action: #selector(RKUIControlHelper.eventHandlerTouchCancel), forControlEvents: UIControlEvents.TouchCancel)
    control.addTarget(self, action: #selector(RKUIControlHelper.eventHandlerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    control.addTarget(self, action: #selector(RKUIControlHelper.eventHandlerEditingDidBegin), forControlEvents: UIControlEvents.EditingDidBegin)
    control.addTarget(self, action: #selector(RKUIControlHelper.eventHandlerEditingChanged), forControlEvents: UIControlEvents.EditingChanged)
    control.addTarget(self, action: #selector(RKUIControlHelper.eventHandlerEditingDidEnd), forControlEvents: UIControlEvents.EditingDidEnd)
    control.addTarget(self, action: #selector(RKUIControlHelper.eventHandlerEditingDidEndOnExit), forControlEvents: UIControlEvents.EditingDidEndOnExit)
  }
  
  func eventHandlerTouchDown() {
    pushStream.next(.TouchDown)
  }
  
  func eventHandlerTouchDownRepeat() {
    pushStream.next(.TouchDownRepeat)
  }
  
  func eventHandlerTouchDragInside() {
    pushStream.next(.TouchDragInside)
  }
  
  func eventHandlerTouchDragOutside() {
    pushStream.next(.TouchDragOutside)
  }
  
  func eventHandlerTouchDragEnter() {
    pushStream.next(.TouchDragEnter)
  }
  
  func eventHandlerTouchDragExit() {
    pushStream.next(.TouchDragExit)
  }
  
  func eventHandlerTouchUpInside() {
    pushStream.next(.TouchUpInside)
  }
  
  func eventHandlerTouchUpOutside() {
    pushStream.next(.TouchUpOutside)
  }
  
  func eventHandlerTouchCancel() {
    pushStream.next(.TouchCancel)
  }
  
  func eventHandlerValueChanged() {
    pushStream.next(.ValueChanged)
  }
  
  func eventHandlerEditingDidBegin() {
    pushStream.next(.EditingDidBegin)
  }
  
  func eventHandlerEditingChanged() {
    pushStream.next(.EditingChanged)
  }
  
  func eventHandlerEditingDidEnd() {
    pushStream.next(.EditingDidEnd)
  }
  
  func eventHandlerEditingDidEndOnExit() {
    pushStream.next(.EditingDidEndOnExit)
  }
  
  deinit {
    control?.removeTarget(self, action: nil, forControlEvents: UIControlEvents.AllEvents)
    pushStream.completed()
  }
}

extension UIControl {
  
  private struct AssociatedKeys {
    static var ControlHelperKey = "r_ControlHelperKey"
  }
  
  public var rControlEvent: Stream<UIControlEvents> {
    if let controlHelper: AnyObject = objc_getAssociatedObject(self, &AssociatedKeys.ControlHelperKey) {
      return (controlHelper as! RKUIControlHelper).pushStream.toStream()
    } else {
      let controlHelper = RKUIControlHelper(control: self)
      objc_setAssociatedObject(self, &AssociatedKeys.ControlHelperKey, controlHelper, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return controlHelper.pushStream.toStream()
    }
  }
  
  public var rEnabled: Property<Bool> {
    return rAssociatedPropertyForValueForKey("enabled")
  }
}
