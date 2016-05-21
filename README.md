# ReactiveUIKit

ReactiveUIKit is a framework from ReactiveKit collection of frameworks that extends UIKit objects with bindings. Consult ReactiveKit [documentation](https://github.com/ReactiveKit/ReactiveKit) to learn how to work with the Propertys it provides.

All extensions are prefixed with `r` so you can learn them on the fly as you work. Just start typing `.r` on instance of any UIKit object to see what's available.

ReactiveUIKit supports iOS and tvOS.


```swift
extension UILabel {
  public var rText: Property<String?>
  public var rAttributedText: Property<NSAttributedString?>
  public var rTextColor: Property<UIColor?>
}
```

```swift
extension UITextView {
  public var rText: Property<String?>
  public var rAttributedText: Property<NSAttributedString?>
  public var rTextColor: Property<UIColor?>
}
```

```swift
extension UITextField {
  public var rText: Property<String?>
  public var rAttributedText: Property<NSAttributedString?>
  public var rTextColor: Property<UIColor?>
}
```

```swift
extension UIImageView {
  public var rImage: Property<UIImage?>
}
```

```swift
extension UINavigationItem {
  public var rTitle: Property<String?>
}
```

```swift
extension UIProgressView {
  public var rProgress: Property<Float>
}
```

```swift
extension UIBarItem {
public var rTitle: Property<String?>
public var rImage: Property<UIImage?>
public var rEnabled: Property<Bool>
}
```

```swift
extension UIBarButtonItem {
public var rTap: Stream<Void>
}
```

```swift
extension UIActivityIndicatorView {
  public var rAnimating: Property<Bool>
}
```

```swift
extension UISlider {
  public var rValue: Property<Float>
}
```

```swift
extension UIRefreshControl {
  public var rRefreshing: Property<Bool>
}
```

```swift
extension UISwitch {
  public var rOn: Property<Bool>
}
```

```swift
extension UISegmentedControl {
  public var rSelectedSegmentIndex: Property<Int>
}
```

```swift
extension UIRefreshControl {
  public var rRefreshing: Property<Bool>
}
```

```swift
extension UIDatePicker {
  public var rDate: Property<NSDate>
}
```

```swift
extension UIButton {
  public var rTitle: Property<String?>
  public var rTap: Stream<Void>
  public var rSelected: Property<Bool>
  public var rHighlighted: Property<Bool>
}
```

```swift
extension UIControl {
  public var rControlEvent: Stream<UIControlEvents>
  public var rEnabled: Property<Bool>
}
```

```swift
extension UIView {
  public var rAlpha: Property<CGFloat>
  public var rBackgroundColor: Property<UIColor?>
  public var rHidden: Property<Bool>
  public var rUserInteractionEnabled: Property<Bool>
  public var rTintColor: Property<UIColor?>
}
```


```swift
extension PropertyCollectionType {
  public func bindTo(tableView: UITableView, createCell: (NSIndexPath, PropertyCollection<Collection>, UITableView) -> UITableViewCell) -> Disposable
}
```

```swift
extension PropertyCollectionType {
  public func bindTo(collectionView: UICollectionView, createCell: (NSIndexPath, PropertyCollection<Collection>, UICollectionView) -> UICollectionViewCell) -> Disposable
}
```

## Installation

### CocoaPods

```
pod 'ReactiveKit', '~> 2.0'
pod 'ReactiveUIKit', '~> 2.0'
```

### Carthage

```
github "ReactiveKit/ReactiveKit" ~> 2.0
github "ReactiveKit/ReactiveUIKit" ~> 2.0
```

## License

The MIT License (MIT)

Copyright (c) 2015-2016 Srdan Rasic (@srdanrasic)

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
