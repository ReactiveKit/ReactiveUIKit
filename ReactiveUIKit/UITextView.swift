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


import ReactiveFoundation
import ReactiveKit
import UIKit

extension UITextView {
  
  private struct AssociatedKeys {
    static var TextKey = "r_TextKey"
    static var AttributedTextKey = "r_AttributedTextKey"
  }
  
  public var rText: Observable<String?> {
    if let rText: AnyObject = objc_getAssociatedObject(self, &AssociatedKeys.TextKey) {
      return rText as! Observable<String?>
    } else {
      let rText = Observable<String?>(self.text)
      objc_setAssociatedObject(self, &AssociatedKeys.TextKey, rText, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      
      var updatingFromSelf: Bool = false
      
      rText.observe(on: ImmediateOnMainExecutionContext) { [weak self] (text: String?) in
        if !updatingFromSelf {
          self?.text = text
        }
      }
      
      NSNotificationCenter.defaultCenter()
        .rNotification(UITextViewTextDidChangeNotification, object: self)
        .observe(on: ImmediateOnMainExecutionContext) { [weak rText] notification in
          if let textView = notification.object as? UITextView, rText = rText {
            updatingFromSelf = true
            rText.value = textView.text
            updatingFromSelf = false
          }
        }.disposeIn(rBag)
      
      return rText
    }
  }
  
  public var rAttributedText: Observable<NSAttributedString?> {
    if let rAttributedText: AnyObject = objc_getAssociatedObject(self, &AssociatedKeys.AttributedTextKey) {
      return rAttributedText as! Observable<NSAttributedString?>
    } else {
      let rAttributedText = Observable<NSAttributedString?>(self.attributedText)
      objc_setAssociatedObject(self, &AssociatedKeys.AttributedTextKey, rAttributedText, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      
      var updatingFromSelf: Bool = false
      
      rAttributedText.observe(on: ImmediateOnMainExecutionContext) { [weak self] (text: NSAttributedString?) in
        if !updatingFromSelf {
          self?.attributedText = text
        }
      }
      
      NSNotificationCenter.defaultCenter()
        .rNotification(UITextViewTextDidChangeNotification, object: self)
        .observe(on: ImmediateOnMainExecutionContext) { [weak rAttributedText] notification in
        if let textView = notification.object as? UITextView, rAttributedText = rAttributedText {
          updatingFromSelf = true
          rAttributedText.value = textView.attributedText
          updatingFromSelf = false
        }
        }.disposeIn(rBag)
      
      return rAttributedText
    }
  }
  
  public var rTextColor: Observable<UIColor?> {
    return rAssociatedObservableForValueForKey("textColor")
  }
}

extension UITextView: BindableType {
  
  public func observer(disconnectDisposable: DisposableType?) -> (String? -> ()) {
    return self.rText.observer(disconnectDisposable)
  }
}
