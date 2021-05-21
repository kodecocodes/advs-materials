/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI

struct PanZoomScaleTracker: UIViewRepresentable {
  @Binding var pan: CGPoint
  @Binding var zoom: CGFloat

  func makeCoordinator() -> Coordinator {
    return Coordinator(pan: $pan, zoomScale: $zoom)
  }

  final class Coordinator: NSObject {
    // swiftlint:disable:next nesting
    typealias UIViewType = UIView

    var pan: Binding<CGPoint>
    var zoomScale: Binding<CGFloat>
    weak var view: UIView?
    private var startPan: CGPoint?
    private var startZoomScale: CGFloat?
    private var zoomCenter: CGPoint?

    init(pan: Binding<CGPoint>, zoomScale: Binding<CGFloat>) {
      self.pan = pan
      self.zoomScale = zoomScale
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
      guard let view = view else {
        return
      }
      switch gesture.state {
      case .began:
        startPan = pan.wrappedValue
      case .changed:
        guard let startPan = startPan else { break }
        let displayChange = gesture.translation(in: view)
        let displayToModel = CGAffineTransform.makeModelToDisplay(
          displaySize: view.bounds.size,
          center: startPan,
          pointsPerModelUnit: zoomScale.wrappedValue)
          .inverted()
        let modelChange = displayChange.applying(displayToModel) - CGPoint.zero.applying(displayToModel)
        pan.wrappedValue = startPan - modelChange
      case .cancelled, .failed:
        startPan.map { pan.wrappedValue = $0 }
      default:
        break
      }
    }

    @objc func handleZoomScale(_ gesture: UIPinchGestureRecognizer) {
      guard let view = view else {
        return
      }
      switch gesture.state {
      case .began:
        startPan = pan.wrappedValue
        startZoomScale = zoomScale.wrappedValue
        let displayToModel = CGAffineTransform.makeModelToDisplay(
          displaySize: view.bounds.size,
          center: pan.wrappedValue,
          pointsPerModelUnit: zoomScale.wrappedValue)
          .inverted()
        let zoomCenterDisplay = gesture.location(in: view)
        zoomCenter = zoomCenterDisplay.applying(displayToModel)
      case .changed:
        guard let startZoomScale = startZoomScale,
          let startPan = startPan,
          let zoomCenter = zoomCenter else { return }
        zoomScale.wrappedValue = startZoomScale * gesture.scale
        pan.wrappedValue = (startPan - zoomCenter) * CGFloat(1 / gesture.scale) + zoomCenter
      case .cancelled, .failed:
        startPan.map { pan.wrappedValue = $0 }
        startZoomScale.map { zoomScale.wrappedValue = $0 }
      default:
        break
      }
    }
  }

  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    let pan = UIPanGestureRecognizer(
      target: context.coordinator,
      action: #selector(Coordinator.handlePan(_:)))
    view.addGestureRecognizer(pan)

    let zoomScale = UIPinchGestureRecognizer(
      target: context.coordinator,
      action: #selector(Coordinator.handleZoomScale(_:)))
    view.addGestureRecognizer(zoomScale)

    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) {
    context.coordinator.view = uiView
  }
}
