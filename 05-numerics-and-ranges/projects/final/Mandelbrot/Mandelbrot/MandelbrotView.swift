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
import Numerics

struct SizeKey: PreferenceKey {
  static let defaultValue: CGSize? = nil
  static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
    value = value ?? nextValue()
  }
}

struct MandelbrotView: View {
  @ObservedObject var model: MandelbrotViewModel

  func mandelbrotPoints<RealType: Real & CGFloatConvertable>(for type: RealType.Type) -> [CGPoint] {
    let start = Complex(RealType(model.testPoint.x), RealType(model.testPoint.y))
    let points = MandelbrotMath.points(start: start, maxIterations: Int(model.maxIterations))
    return points.map { CGPoint(x: $0.real.cgFloat, y: $0.imaginary.cgFloat) }
  }

  func coordinateGrid(transforms: ModelTransforms) -> some View {
    Group {
      GridLines(modelToDisplay: transforms.modelToDisplay, pitch: model.gridPitch)
        .stroke(lineWidth: 1)
      AxisLines(modelToDisplay: transforms.modelToDisplay)
        .stroke(lineWidth: 3)
    }.foregroundColor(.gray)
  }

  func testPointLines(modelToDisplay: CGAffineTransform) -> some View {
    Group {
      PolyLineShape(
        modelToDisplay: modelToDisplay,
        points: mandelbrotPoints(for: Float64.self))
        .stroke(.float64)

      #if arch(x86_64)
      PolyLineShape(
        modelToDisplay: modelToDisplay,
        points: mandelbrotPoints(for: Float80.self))
        .stroke(.float80)
      #endif

      PolyLineShape(
        modelToDisplay: modelToDisplay,
        points: mandelbrotPoints(for: Float32.self))
        .stroke(.float32)

      PolyLineShape(
        modelToDisplay: modelToDisplay,
        points: mandelbrotPoints(for: Float16.self))
        .stroke(.float16)

      DragHandle(
        modelToDisplay: modelToDisplay,
        location: $model.testPoint)
        .foregroundColor(Color.red.opacity(0.5))
    }
  }

  var body: some View {
    ZStack(alignment: .topLeading) {
      ModelTransformsReader(center: model.center, scale: model.scale) { transforms in
        Color.white
          .preference(key: SizeKey.self, value: transforms.size)

        coordinateGrid(transforms: transforms)

        if model.showImage, let image = model.image {
          Image(uiImage: UIImage(cgImage: image))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .opacity(0.8)
        } else {
          Circle()
            .stroke(lineWidth: 3)
            .position(
              x: CGPoint.zero.applying(transforms.modelToDisplay).x,
              y: CGPoint.zero.applying(transforms.modelToDisplay).y)
            .frame(width: model.scale * 4, height: model.scale * 4, alignment: .center)
            .foregroundColor(.red)
        }

        PanZoomScaleTracker(pan: $model.center, zoom: $model.scale)

        if model.showTestPoint {
          testPointLines(modelToDisplay: transforms.modelToDisplay)
        }
      }.onPreferenceChange(SizeKey.self) { size in
        model.imageSize = size
        model.scale = (size?.width ?? 500) / 4.5
      }
    }
  }
}
