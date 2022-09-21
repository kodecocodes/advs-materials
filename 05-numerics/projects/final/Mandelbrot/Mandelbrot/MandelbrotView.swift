/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

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
      #if arch(x86_64)
      PolyLineShape(
        modelToDisplay: modelToDisplay,
        points: mandelbrotPoints(for: Float80.self))
        .stroke(.float80)
      #endif

      PolyLineShape(
        modelToDisplay: modelToDisplay,
        points: mandelbrotPoints(for: Float64.self))
        .stroke(.float64)

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
