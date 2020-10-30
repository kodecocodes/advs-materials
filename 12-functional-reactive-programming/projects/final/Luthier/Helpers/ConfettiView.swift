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
import UIKit

public struct ConfettiView: UIViewRepresentable {
  public func makeUIView(context: Context) -> UIConfettiView {
    let view = UIConfettiView()
    view.start()
    return view
  }

  public func updateUIView(_ uiView: UIConfettiView, context: Context) {
  }
}

/// The UIView Confetti Emitter
public final class UIConfettiView: UIView {
  func start() {
    let layer = CAEmitterLayer()
    let characters = ["🎸", "🎉"]
    layer.emitterCells = characters.map { character -> CAEmitterCell in
      let attr = NSAttributedString(string: character,
                                    attributes: [.font: UIFont.systemFont(ofSize: 16.0)])
      let icon = UIGraphicsImageRenderer(size: attr.size()).image { _ in attr.draw(at: .zero) }

      let cell = CAEmitterCell()

      cell.birthRate = 12.5
      cell.lifetime = 15
      cell.velocity = CGFloat(cell.birthRate * cell.lifetime)
      cell.velocityRange = cell.velocity / 2
      cell.emissionLongitude = .pi
      cell.emissionRange = .pi / 4
      cell.spinRange = .pi * 4
      cell.scaleRange = 0.25
      cell.scale = 1.0 - cell.scaleRange
      cell.contents = icon.cgImage

      return cell
    }

    let screenSize = UIScreen.main.bounds
    layer.frame = self.bounds
    layer.needsDisplayOnBoundsChange = true
    layer.position = CGPoint(x: screenSize.width / 2,
                             y: -screenSize.height)
    layer.emitterShape = .line
    self.layer.addSublayer(layer)
  }
}
