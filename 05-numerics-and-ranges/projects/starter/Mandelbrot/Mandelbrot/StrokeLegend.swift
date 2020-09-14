/// Copyright (c) 2020 Razeware LLC
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

import SwiftUI

extension Shape {
  func stroke(_ floatSize: FloatSize) -> some View {
    switch floatSize {
    case .float16:
      return stroke(Color.red, style: .init(lineWidth: 1))
    case .float32:
      return stroke(Color.green, style: .init(lineWidth: 3))
    case .float64, .simd8Float64:
      return stroke(Color.blue, style: .init(lineWidth: 7))
    case .float80:
      return stroke(Color.orange, style: .init(lineWidth: 9))
    }
  }
}

private struct HorizontalLine: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: rect.minX, y: rect.midY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
    return path
  }
}

struct StrokeLegend: View {
  var body: some View {
    VStack {
      ForEach(FloatSize.pathSizes, id: \.self.rawValue) { floatType in
        HStack {
          HorizontalLine().stroke(floatType)
          Text(floatType.name)
        }
      }
    }
    .frame(width: 150, height: 100)
    .padding(30)
    .background(Color.black.opacity(0.1))
    .border(Color.black)
  }
}
