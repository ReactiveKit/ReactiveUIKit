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

#if os(iOS)

import ReactiveKit
import UIKit

extension UISlider {
  
  private struct AssociatedKeys {
    static var ValueKey = "r_ValueKey"
  }
  
  public var rValue: Observable<Float> {
    if let rValue: AnyObject = objc_getAssociatedObject(self, &AssociatedKeys.ValueKey) {
      return rValue as! Observable<Float>
    } else {
      let rValue = Observable<Float>(self.value)
      objc_setAssociatedObject(self, &AssociatedKeys.ValueKey, rValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      
      var updatingFromSelf: Bool = false
      
      rValue.observe(on: ImmediateOnMainExecutionContext) { [weak self] value in
        if !updatingFromSelf {
          self?.value = value
        }
      }
      
      self.rControlEvent
        .filter { $0 == UIControlEvents.ValueChanged }
        .observe(on: ImmediateOnMainExecutionContext) { [weak self] event in
          guard let unwrappedSelf = self else { return }
          updatingFromSelf = true
          unwrappedSelf.rValue.value = unwrappedSelf.value
          updatingFromSelf = false
        }
      
      return rValue
    }
  }
}
  
extension UISlider: BindableType {
    
  public func observer(disconnectDisposable: DisposableType?) -> (Float -> ()) {
    return self.rValue.observer(disconnectDisposable)
  }
}

#endif
