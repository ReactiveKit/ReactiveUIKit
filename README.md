# ReactiveUIKit

ReactiveUIKit is a framework from ReactiveKit collection of frameworks that extends UIKit objects with bindings. Consult ReactiveKit [documentation](https://github.com/ReactiveKit/ReactiveKit) to learn how to work with the Observables it provides.

All extensions are prefixed with `r` so you can learn them on the fly as you work. Just start typing `.r` on instance of any UIKit object to see what's available.

ReactiveUIKit supports iOS and tvOS.


```swift
extension UILabel {
  public var rText: Observable<String?>
  public var rAttributedText: Observable<NSAttributedString?>
  public var rTextColor: Observable<UIColor?>
}
```

```swift
extension UITextView {
  public var rText: Observable<String?>
  public var rAttributedText: Observable<NSAttributedString?>
  public var rTextColor: Observable<UIColor?>
}
```

```swift
extension UITextField {
  public var rText: Observable<String?>
  public var rAttributedText: Observable<NSAttributedString?>
  public var rTextColor: Observable<UIColor?>
}
```

```swift
extension UIImageView {
  public var rImage: Observable<UIImage?>
}
```

```swift
extension UINavigationItem {
  public var rTitle: Observable<String?>
}
```

```swift
extension UIProgressView {
  public var rProgress: Observable<Float>
}
```

```swift
extension UIBarItem {
  public var rTitle: Observable<String?>
  public var rImage: Observable<UIImage?>
  public var rEnabled: Observable<Bool>
}
```

```swift
extension UIActivityIndicatorView {
  public var rAnimating: Observable<Bool>
}
```

```swift
extension UISlider {
  public var rValue: Observable<Float>
}
```

```swift
extension UIRefreshControl {
  public var rRefreshing: Observable<Bool>
}
```

```swift
extension UISwitch {
  public var rOn: Observable<Bool>
}
```

```swift
extension UISegmentedControl {
  public var rSelectedSegmentIndex: Observable<Int>
}
```

```swift
extension UIRefreshControl {
  public var rRefreshing: Observable<Bool>
}
```

```swift
extension UIDatePicker {
  public var rDate: Observable<NSDate>
}
```

```swift
extension UIButton {
  public var rTitle: Observable<String?>
  public var rTap: ActiveStream<Void>
  public var rSelected: Observable<Bool>
  public var rHighlighted: Observable<Bool>
}
```

```swift
extension UIControl {
  public var rControlEvent: ActiveStream<UIControlEvents>
  public var rEnabled: Observable<Bool>
}
```

```swift
extension UIView {
  public var rAlpha: Observable<CGFloat>
  public var rBackgroundColor: Observable<UIColor?>
  public var rHidden: Observable<Bool>
  public var rUserInteractionEnabled: Observable<Bool>
  public var rTintColor: Observable<UIColor?>
}
```


```swift
extension ObservableCollectionType where Collection == Array<Generator.Element> {
  public func bindTo(tableView: UITableView, createCell: (NSIndexPath, ObservableCollection<Collection>, UITableView) -> UITableViewCell) -> DisposableType
}
```

```swift
extension ObservableCollectionType where Collection == Array<Generator.Element> {
  public func bindTo(collectionView: UICollectionView, createCell: (NSIndexPath, ObservableCollection<Collection>, UICollectionView) -> UICollectionViewCell) -> DisposableType
}
```

## Installation

### CocoaPods

```
pod 'ReactiveKit', '~> 1.0'
pod 'ReactiveUIKit', '~> 1.0'
pod 'ReactiveFoundation', '~> 1.0'
```

### Carthage

```
github "ReactiveKit/ReactiveKit" 
github "ReactiveKit/ReactiveUIKit"
github "ReactiveKit/ReactiveFoundation"
```

## License

The MIT License (MIT)

Copyright (c) 2015 Srdan Rasic (@srdanrasic)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
