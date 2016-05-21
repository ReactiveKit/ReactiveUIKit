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

private func applyRowUnitChangeSet<C: CollectionChangesetType where C.Collection.Index == Int>(changeSet: C, collectionView: UICollectionView, sectionIndex: Int) {
  if changeSet.inserts.count > 0 {
    let indexPaths = changeSet.inserts.map { NSIndexPath(forItem: $0, inSection: sectionIndex) }
    collectionView.insertItemsAtIndexPaths(indexPaths)
  }

  if changeSet.updates.count > 0 {
    let indexPaths = changeSet.updates.map { NSIndexPath(forItem: $0, inSection: sectionIndex) }
    collectionView.reloadItemsAtIndexPaths(indexPaths)
  }

  if changeSet.deletes.count > 0 {
    let indexPaths = changeSet.deletes.map { NSIndexPath(forItem: $0, inSection: sectionIndex) }
    collectionView.deleteItemsAtIndexPaths(indexPaths)
  }
}

extension StreamType where Element: ArrayConvertible {

  public func bindTo(collectionView: UICollectionView, animated: Bool = true, createCell: (NSIndexPath, [Element.Element], UICollectionView) -> UICollectionViewCell) -> Disposable {
    return map { CollectionChangeset.initial($0.toArray()) }.bindTo(collectionView, animated: animated, createCell: createCell)
  }
}

extension StreamType where Element: CollectionChangesetType, Element.Collection.Index == Int, Event.Element == Element {

  public func bindTo(collectionView: UICollectionView, animated: Bool = true, createCell: (NSIndexPath, Element.Collection, UICollectionView) -> UICollectionViewCell) -> Disposable {

    typealias Collection = Element.Collection

    let dataSource = collectionView.rDataSource
    let numberOfItems = Property(0)
    let collection = Property<Collection!>(nil)

    dataSource.feed(
      collection,
      to: #selector(UICollectionViewDataSource.collectionView(_:cellForItemAtIndexPath:)),
      map: { (value: Collection!, collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell in
        return createCell(indexPath, value, collectionView)
    })

    dataSource.feed(
      numberOfItems,
      to: #selector(UICollectionViewDataSource.collectionView(_:numberOfItemsInSection:)),
      map: { (value: Int, _: UICollectionView, _: Int) -> Int in value }
    )

    dataSource.feed(
      Property(1),
      to: #selector(UICollectionViewDataSource.numberOfSectionsInCollectionView(_:)),
      map: { (value: Int, _: UICollectionView) -> Int in value }
    )

    collectionView.reloadData()

    let serialDisposable = SerialDisposable(otherDisposable: nil)
    serialDisposable.otherDisposable = observeNext { [weak collectionView] event in
      ImmediateOnMainExecutionContext {
        guard let collectionView = collectionView else { serialDisposable.dispose(); return }
        let justReload = collection.value == nil
        collection.value = event.collection
        numberOfItems.value = event.collection.count
        if justReload || !animated || event.inserts.count + event.deletes.count + event.updates.count == 0 {
          collectionView.reloadData()
        } else {
          collectionView.performBatchUpdates({
            applyRowUnitChangeSet(event, collectionView: collectionView, sectionIndex: 0)
          }, completion: nil)
        }
      }
    }
    return serialDisposable
  }
}

extension UICollectionView {

  public var rDelegate: ProtocolProxy {
    return protocolProxyFor(UICollectionViewDelegate.self, setter: NSSelectorFromString("setDelegate:"))
  }

  public var rDataSource: ProtocolProxy {
    return protocolProxyFor(UICollectionViewDataSource.self, setter: NSSelectorFromString("setDataSource:"))
  }
}
