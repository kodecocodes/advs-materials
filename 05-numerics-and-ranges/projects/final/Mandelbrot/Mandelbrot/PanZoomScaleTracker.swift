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
