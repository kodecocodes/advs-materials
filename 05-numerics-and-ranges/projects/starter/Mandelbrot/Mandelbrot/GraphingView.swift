/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI
import Numerics

extension CGAffineTransform {
  static func makeModelToDisplay(
    displaySize: CGSize,
    center: CGPoint,
    pointsPerModelUnit: CGFloat
  ) -> Self {
    Self(
      a: pointsPerModelUnit,
      b: 0,
      c: 0,
      d: -pointsPerModelUnit,
      tx: displaySize.width / 2 - center.x * pointsPerModelUnit,
      ty: displaySize.height / 2 + center.y * pointsPerModelUnit)
  }
}

/// The size of the display area and transforms to a user defined model space.
struct ModelTransforms: Equatable {
  /// Size of the display area passed along from a `GeometryReader`
  let size: CGSize
  /// A transform mapping model space to display space
  let modelToDisplay: CGAffineTransform
  /// A transform mapping display space to model space
  let displayToModel: CGAffineTransform
  ///The  display rectangle
  var rect: CGRect { CGRect(origin: .zero, size: size) }
}

/// Create a user defined right-handed model space where the model space point
/// appears at the `center` of the display window and has scales one unit
/// to `scale` points in the display.
///
/// Used in a similar to `GeometryReader`.
///
///     ModelTranformReader(center: .zero, scale: 100) { transforms in
///
///     }
///
struct ModelTransformsReader<Content: View>: View {
  /// The display's center point corresponds to this model point.
  let center: CGPoint

  /// One unit in model space is this many display points.
  let scale: CGFloat

  /// A view builder that is passed the `ModelTransformProxy`.
  let content: (ModelTransforms) -> Content

  init(center: CGPoint, scale: CGFloat, @ViewBuilder content: @escaping (ModelTransforms) -> Content) {
    self.center = center
    self.scale = scale
    self.content = content
  }

  func modelTransformProxy(size: CGSize) -> ModelTransforms {
    let modelToDisplay = CGAffineTransform
      .makeModelToDisplay(displaySize: size, center: center, pointsPerModelUnit: scale)
    let displayToModel = modelToDisplay.inverted()
    return ModelTransforms(
      size: size,
      modelToDisplay: modelToDisplay,
      displayToModel: displayToModel)
  }
  var body: some View {
    GeometryReader { proxy in
      content(modelTransformProxy(size: proxy.size))
    }
  }
}

/// A view that draws the coordinate access of model coordinates
struct AxisLines: Shape {
  let modelToDisplay: CGAffineTransform

  func path(in displayRect: CGRect) -> Path {
    let displayToModel = modelToDisplay.inverted()
    let extents = displayRect.applying(displayToModel)

    var path = Path()
    if extents.contains(CGPoint.zero) {
      path.move(to: CGPoint(x: extents.minX, y: 0).applying(modelToDisplay))
      path.addLine(to: CGPoint(x: extents.maxX, y: 0).applying(modelToDisplay))
      path.move(to: CGPoint(x: 0, y: extents.minY).applying(modelToDisplay))
      path.addLine(to: CGPoint(x: 0, y: extents.maxY).applying(modelToDisplay))
    }
    return path
  }
}

/// A view that draws gridlines for a given pitch
struct GridLines: Shape {
  let modelToDisplay: CGAffineTransform
  let pitch: CGFloat

  func path(in displayRect: CGRect) -> Path {
    let displayToModel = modelToDisplay.inverted()
    let extents = displayRect.applying(displayToModel)

    var path = Path()
    let verticalLines = stride(
      from: (extents.minX / pitch).rounded(.awayFromZero) * pitch,
      through: (extents.maxX / pitch).rounded(.awayFromZero) * pitch,
      by: pitch)

    let horizontalLines = stride(
      from: (extents.minY / pitch).rounded(.awayFromZero) * pitch,
      through: (extents.maxY / pitch).rounded(.awayFromZero) * pitch,
      by: pitch)

    for x in verticalLines {
      path.move(to: CGPoint(x: x, y: extents.minY).applying(modelToDisplay))
      path.addLine(to: CGPoint(x: x, y: extents.maxY).applying(modelToDisplay))
    }

    for y in horizontalLines {
      path.move(to: CGPoint(x: extents.minX, y: y).applying(modelToDisplay))
      path.addLine(to: CGPoint(x: extents.maxX, y: y).applying(modelToDisplay))
    }

    return path
  }
}

/// A connected line in model space coordinates
struct PolyLineShape: Shape {
  let modelToDisplay: CGAffineTransform
  var points: [CGPoint]

  func path(in displayRect: CGRect) -> Path {
    var path = Path()
    let displayPoints = points.map { $0.applying(modelToDisplay) }

    guard let boundingRect = displayPoints.boundingRect(),
      boundingRect.size.width > 0.1, boundingRect.size.height > 0.1 else {
      return path
    }

    displayPoints.first.map {
      path.move(to: $0)
    }

    displayPoints.dropFirst().forEach {
      path.addLine(to: $0)
    }

    return path
  }
}

// A draggable point in model coordinates.
struct DragHandle: View {
  let modelToDisplay: CGAffineTransform
  @Binding var location: CGPoint
  @State var startLocation: CGPoint?

  var body: some View {
    Circle()
      .position(location.applying(modelToDisplay))
      .frame(width: 30, height: 30)
      .gesture(
        DragGesture()
          .onChanged { gesture in
            let displayToModel = modelToDisplay.inverted()
            let translationSize = gesture.translation.applying(displayToModel)
            let translation = CGPoint(x: translationSize.width, y: translationSize.height)
            if let startLocation = startLocation {
              location = startLocation + translation
            } else {
              startLocation = location
            }
          }
          .onEnded { _ in
            startLocation = nil
          }
      )
  }
}
