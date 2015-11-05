# ReactiveKit

__ReactiveKit__ is a collection of Swift frameworks for reactive and functional reactive programming.

* [ReactiveKit](https://github.com/ReactiveKit/ReactiveKit) - A core framework that provides cold Stream and hot ActiveStream types and their derivatives -  Operation, Observable and ObservableCollection types.
* [ReactiveFoundation](https://github.com/ReactiveKit/ReactiveFoundation) - Foundation framework extensions like type-safe KVO.
* [ReactiveUIKit](https://github.com/ReactiveKit/ReactiveUIKit) - UIKit extensions (bindings).

## rUIKit

Extends UIKit objects with bindings.


```swift
extension UILabel {
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
extension UIRefreshControl {
  public var rRefreshing: Observable<Bool>
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

## Installation

### Carthage

```
github "ReactiveKit/ReactiveKit" 
github "ReactiveKit/ReactiveFoundation"
github "ReactiveKit/ReactiveUIKit"
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
