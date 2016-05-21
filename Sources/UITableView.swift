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

private func applyRowUnitChangeSet<C: CollectionChangesetType where C.Collection.Index == Int>(changeSet: C, tableView: UITableView, sectionIndex: Int) {
  if changeSet.inserts.count > 0 {
    let indexPaths = changeSet.inserts.map { NSIndexPath(forItem: $0, inSection: sectionIndex) }
    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }

  if changeSet.updates.count > 0 {
    let indexPaths = changeSet.updates.map { NSIndexPath(forItem: $0, inSection: sectionIndex) }
    tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }

  if changeSet.deletes.count > 0 {
    let indexPaths = changeSet.deletes.map { NSIndexPath(forItem: $0, inSection: sectionIndex) }
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }
}

extension StreamType where Element: ArrayConvertible {

  public func bindTo(tableView: UITableView, animated: Bool = true, createCell: (NSIndexPath, [Element.Element], UITableView) -> UITableViewCell) -> Disposable {
    return map { CollectionChangeset.initial($0.toArray()) }.bindTo(tableView, animated: animated, createCell: createCell)
  }
}

extension StreamType where Element: CollectionChangesetType, Element.Collection.Index == Int, Event.Element == Element {

  public func bindTo(tableView: UITableView, animated: Bool = true, createCell: (NSIndexPath, Element.Collection, UITableView) -> UITableViewCell) -> Disposable {

    typealias Collection = Element.Collection

    let dataSource = tableView.rDataSource
    let numberOfItems = Property(0)
    let collection = Property<Collection!>(nil)

    dataSource.feed(
      collection,
      to: #selector(UITableViewDataSource.tableView(_:cellForRowAtIndexPath:)),
      map: { (value: Collection!, tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell in
        return createCell(indexPath, value, tableView)
    })

    dataSource.feed(
      numberOfItems,
      to: #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:)),
      map: { (value: Int, _: UITableView, _: Int) -> Int in value }
    )

    dataSource.feed(
      Property(1),
      to: #selector(UITableViewDataSource.numberOfSectionsInTableView(_:)),
      map: { (value: Int, _: UITableView) -> Int in value }
    )

    tableView.reloadData()

    let serialDisposable = SerialDisposable(otherDisposable: nil)
    serialDisposable.otherDisposable = observeNext { [weak tableView] event in
      ImmediateOnMainExecutionContext {
        guard let tableView = tableView else { serialDisposable.dispose(); return }
        let justReload = collection.value == nil
        collection.value = event.collection
        numberOfItems.value = event.collection.count
        if justReload || !animated || event.inserts.count + event.deletes.count + event.updates.count == 0 {
          tableView.reloadData()
        } else {
          tableView.beginUpdates()
          applyRowUnitChangeSet(event, tableView: tableView, sectionIndex: 0)
          tableView.endUpdates()
        }
      }
    }
    return serialDisposable
  }
}

extension UITableView {

  public var rDelegate: ProtocolProxy {
    return protocolProxyFor(UITableViewDelegate.self, setter: NSSelectorFromString("setDelegate:"))
  }

  public var rDataSource: ProtocolProxy {
    return protocolProxyFor(UITableViewDataSource.self, setter: NSSelectorFromString("setDataSource:"))
  }
}
