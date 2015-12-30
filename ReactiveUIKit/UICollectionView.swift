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

extension UICollectionView {
  private struct AssociatedKeys {
    static var DataSourceKey = "r_DataSourceKey"
  }
}

extension ObservableCollectionType where Collection.Index == Int, Event == ObservableCollectionEvent<Collection> {
  public func bindTo(collectionView: UICollectionView, animated: Bool = true, proxyDataSource: RKCollectionViewProxyDataSource? = nil, createCell: (NSIndexPath, Collection, UICollectionView) -> UICollectionViewCell) -> DisposableType {
    
    let dataSource = RKCollectionViewDataSource(collection: self, collectionView: collectionView, animated: animated, proxyDataSource: proxyDataSource, createCell: createCell)
    objc_setAssociatedObject(collectionView, &UICollectionView.AssociatedKeys.DataSourceKey, dataSource, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    
    return BlockDisposable { [weak collectionView] in
      if let collectionView = collectionView {
        objc_setAssociatedObject(collectionView, &UICollectionView.AssociatedKeys.DataSourceKey, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      }
    }
  }
}

@objc public protocol RKCollectionViewProxyDataSource {
  optional func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
  optional func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool
  optional func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
}

public class RKCollectionViewDataSource<C: ObservableCollectionType where C.Collection.Index == Int, C.Event == ObservableCollectionEvent<C.Collection>>: NSObject, UICollectionViewDataSource {
  
  private let observableCollection: C
  private var sourceCollection: C.Collection
  private weak var collectionView: UICollectionView!
  private let createCell: (NSIndexPath, C.Collection, UICollectionView) -> UICollectionViewCell
  private weak var proxyDataSource: RKCollectionViewProxyDataSource?
  private let animated: Bool
  
  public init(collection: C, collectionView: UICollectionView, animated: Bool = true, proxyDataSource: RKCollectionViewProxyDataSource?, createCell: (NSIndexPath, C.Collection, UICollectionView) -> UICollectionViewCell) {
    self.collectionView = collectionView
    self.createCell = createCell
    self.proxyDataSource = proxyDataSource
    self.observableCollection = collection
    self.sourceCollection = collection.collection
    self.animated = animated
    super.init()
    
    collectionView.dataSource = self
    collectionView.reloadData()

    observableCollection.skip(1).observe(on: Queue.main.context) { [weak self] event in
      if let uSelf = self {
        uSelf.sourceCollection = event.collection
        if animated {
          uSelf.collectionView.performBatchUpdates({
            RKCollectionViewDataSource.applyRowUnitChangeSet(event, collectionView: uSelf.collectionView, sectionIndex: 0, dataSource: uSelf.proxyDataSource)
            }, completion: nil)
        } else {
          uSelf.collectionView.reloadData()
        }
      }
    }.disposeIn(rBag)
  }
  
  private class func applyRowUnitChangeSet(changeSet: ObservableCollectionEvent<C.Collection>, collectionView: UICollectionView, sectionIndex: Int, dataSource: RKCollectionViewProxyDataSource?) {
    
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
  
  /// MARK - UICollectionViewDataSource
  
  @objc public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  @objc public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sourceCollection.count
  }
  
  @objc public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    return createCell(indexPath, sourceCollection, collectionView)
  }
  
  @objc public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    if let view = proxyDataSource?.collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath) {
      return view
    } else {
      fatalError("Dear Sir/Madam, your collection view has asked for a supplementary view of a \(kind) kind. Please provide a proxy data source object in bindTo() method that implements `collectionView(collectionView:viewForSupplementaryElementOfKind:atIndexPath)` method!")
    }
  }
  
  @objc public func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return proxyDataSource?.collectionView?(collectionView, canMoveItemAtIndexPath: indexPath) ?? false
  }
  
  @objc public func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    proxyDataSource?.collectionView?(collectionView, moveItemAtIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
  }
}
