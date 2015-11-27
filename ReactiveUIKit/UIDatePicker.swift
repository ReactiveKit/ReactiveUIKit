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
  
import ReactiveFoundation
import ReactiveKit
import UIKit
  
extension UIDatePicker {
  
  private struct AssociatedKeys {
    static var DateKey = "r_DateKey"
  }
  
  public var rDate: Observable<NSDate> {
    if let rDate: AnyObject = objc_getAssociatedObject(self, &AssociatedKeys.DateKey) {
      return rDate as! Observable<NSDate>
    } else {
      let rDate = Observable<NSDate>(self.date)
      objc_setAssociatedObject(self, &AssociatedKeys.DateKey, rDate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      
      var updatingFromSelf: Bool = false
      
      rDate.observe(on: ImmediateOnMainExecutionContext) { [weak self] (date: NSDate) in
        if !updatingFromSelf {
          self?.date = date
        }
      }
      
      self.rControlEvent
        .filter { $0 == UIControlEvents.ValueChanged }
        .observe(on: ImmediateOnMainExecutionContext) { [weak self] event in
          guard let unwrappedSelf = self else { return }
          updatingFromSelf = true
          unwrappedSelf.rDate.value = unwrappedSelf.date
          updatingFromSelf = false
        }
      
      return rDate
    }
  }
}
  
extension UIDatePicker: BindableType {
  
  public func observer(disconnectDisposable: DisposableType?) -> (NSDate -> ()) {
    return self.rDate.observer(disconnectDisposable)
  }
}


#endif
