/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import XCTest
@testable import QuadTree

class QuadTreeTests: XCTestCase {

  func testQuadTreeZeroPoints() {
    let size = CGSize(width: 1,height: 1)
    let region = CGRect(origin: .zero, size: size)
    var tree = QuadTree<CGPoint>(region: region)
    tree.insert(CGPoint(x: 1,y: 1)) // right outside the boundary
    XCTAssert(tree.allItems().isEmpty)
  }

  func testQuadTreeOnePoint() {
    let size = CGSize(width: 1000,height: 1000)
    let region = CGRect(origin: .zero, size: size)
    var tree = QuadTree<CGPoint>(region: region)
    XCTAssert(tree.allItems().isEmpty)

    tree.insert(CGPoint(x: 10,y: 10))

    let noPoints = tree.find(in: CGRect(x: 100, y: 100, width: 100, height: 100))
    XCTAssert(noPoints.isEmpty)

    let onePoint = tree.find(in: CGRect(x: 9, y: 9, width: 2, height: 2))
    XCTAssertEqual(onePoint.count, 1)

    let allPoints = tree.allItems()
    XCTAssertEqual(allPoints.count, 1)
  }

  func testQuadTreeTwoPoints() {
    let size = CGSize(width: 1,height: 1)
    let region = CGRect(origin: .zero, size: size)
    var tree = QuadTree<CGPoint>(region: region)
    tree.insert(CGPoint(x: 0.5,y: 0.5))
    tree.insert(CGPoint(x: 0.6,y: 0.6))
    XCTAssertEqual(tree.allItems().count, 2)
  }

  func testQuadTreeCOW() {
    let size = CGSize(width: 1,height: 1)
    let region = CGRect(origin: .zero, size: size)
    var tree1 = QuadTree<CGPoint>(region: region)
    var tree2 = tree1

    for _ in 1...5000 {
      tree2.insert(CGPoint(x: CGFloat.random(in: 0..<1),
                           y: CGFloat.random(in: 0..<1)))
    }

    XCTAssertEqual(tree1.allItems().count, 0)
    XCTAssertEqual(tree2.allItems().count, 5000)

    for _ in 1...10000 {
      tree1.insert(CGPoint(x: CGFloat.random(in: 0..<1),
                           y: CGFloat.random(in: 0..<1)))
    }

    XCTAssertEqual(tree1.allItems().count, 10000)
    XCTAssertEqual(tree2.allItems().count, 5000)
  }


}
