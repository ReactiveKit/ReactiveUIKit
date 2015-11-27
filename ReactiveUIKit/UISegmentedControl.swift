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


import ReactiveKit
import UIKit

extension UISegmentedControl {
  
  private struct AssociatedKeys {
    static var SelectedSegmentIndexKey = "r_SelectedSegmentIndexKey"
  }
  
  public var rSelectedSegmentIndex: Observable<Int> {
    if let rSelectedSegmentIndex: AnyObject = objc_getAssociatedObject(self, &AssociatedKeys.SelectedSegmentIndexKey) {
      return rSelectedSegmentIndex as! Observable<Int>
    } else {
      let rSelectedSegmentIndex = Observable<Int>(self.selectedSegmentIndex)
      objc_setAssociatedObject(self, &AssociatedKeys.SelectedSegmentIndexKey, rSelectedSegmentIndex, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      
      var updatingFromSelf: Bool = false
      
      rSelectedSegmentIndex.observe(on: ImmediateOnMainExecutionContext) { [weak self] selectedSegmentIndex in
        if !updatingFromSelf {
          self?.selectedSegmentIndex = selectedSegmentIndex
        }
      }
      
      self.rControlEvent
        .filter { $0 == UIControlEvents.ValueChanged }
        .observe(on: ImmediateOnMainExecutionContext) { [weak self] event in
          guard let unwrappedSelf = self else { return }
          updatingFromSelf = true
          unwrappedSelf.rSelectedSegmentIndex.value = unwrappedSelf.selectedSegmentIndex
          updatingFromSelf = false
        }
      
      return rSelectedSegmentIndex
    }
  }
}

extension UISegmentedControl: BindableType {
  
  public func observer(disconnectDisposable: DisposableType?) -> (Int -> ()) {
    return self.rSelectedSegmentIndex.observer(disconnectDisposable)
  }
}
  