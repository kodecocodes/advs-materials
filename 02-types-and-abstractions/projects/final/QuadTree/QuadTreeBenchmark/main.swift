/// Copyright (c) 2023 Kodeco Inc
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import CollectionsBenchmark
import CoreGraphics.CGBase

struct TestPoints {
  let region: CGRect
  let points: [CGPoint]
  
  init(size: Int) {
    region = CGRect(origin: .zero, size: CGSize(width: size, height: size))
    points = zip((0..<size).shuffled(), (0..<size).shuffled())
      .map { CGPoint(x: $0.0, y: $0.1) }
  }
}

var benchmark = Benchmark(title: "QuadTree Benchmarks")
benchmark.registerInputGenerator(for: TestPoints.self) { size in
  TestPoints(size: size)
}


benchmark.add(title: "QuadTree find",
              input: TestPoints.self) { testPoints in
  let tree = QuadTree(region: testPoints.region, points: testPoints.points)
                  
  return { timer in
    testPoints.points.forEach { point in
      let searchRegion = CGRect(origin: point, size: .zero).insetBy(dx: -1, dy: -1)
      blackHole(tree.find(in: searchRegion))
    }
  }
}

benchmark.addSimple(title: "Array<CGPoint> filter",
                    input: TestPoints.self) { testPoints in
  testPoints.points.forEach { point in
    let searchRegion =  CGRect(origin: point, size: .zero).insetBy(dx: -1, dy: -1)
    blackHole(testPoints.points.filter { candidate in
      searchRegion.contains(candidate)
    })
  }
}

benchmark.addSimple(title: "QuadTree insert",
                    input: TestPoints.self) { testPoints in
  blackHole(QuadTree(region: testPoints.region, points: testPoints.points))
}

benchmark.addSimple(title: "Array<CGPoint> append",
              input: TestPoints.self) { testPoints in
  var array: [CGPoint] = []
  for point in testPoints.points {
    array.append(point)
  }
}

benchmark.addSimple(title: "Array<CGPoint> append (reserveCapacity)",
                    input: TestPoints.self) { testPoints in
  var array: [CGPoint] = []
  array.reserveCapacity(testPoints.points.count)
  for point in testPoints.points {
    array.append(point)
  }
}

benchmark.main()
