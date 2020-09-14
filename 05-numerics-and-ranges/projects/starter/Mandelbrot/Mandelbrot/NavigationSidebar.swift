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

struct NavigationSidebar: View {
  @ObservedObject var model: MandelbrotViewModel

  private var maxIterations: some View {
    Group {
      Text("Maximum Iterations")
      HStack {
        Slider(value: $model.maxIterations, in: 3...255)
        Text(String(Int(model.maxIterations)))
      }
    }
  }

  var body: some View {
    List {
      Text("Grid Pitch: \(model.gridPitch)")
        .font(.system(size: 15, weight: .bold, design: .monospaced))
      HStack {
        Text("Test Point").font(.title)
        Toggle("", isOn: $model.showTestPoint)
      }
      if model.showTestPoint {
        Text("(\(model.testPoint.x), \(model.testPoint.y))")
          .font(.system(size: 15, weight: .bold, design: .monospaced))
        StrokeLegend()
        Text("Landmarks").font(.title)
        NavigationLink(destination: EmptyView() ) {
          Label("Center", systemImage: "mappin.and.ellipse")
        }.onTapGesture {
          if let imageSize = model.imageSize {
            let displayToModel = CGAffineTransform.makeModelToDisplay(
              displaySize: imageSize,
              center: model.center,
              pointsPerModelUnit: model.scale)
            .inverted()

            model.testPoint =
              (CGPoint(x: imageSize.width, y: imageSize.height) * 0.5)
              .applying(displayToModel)
          }
        }
        ForEach(model.landmarks, id: \.self.0) { landmark in
          NavigationLink(destination: EmptyView() ) {
            Label(landmark.0, systemImage: "mappin.and.ellipse")
          }.onTapGesture {
            model.testPoint = landmark.1
          }
        }
      }
      maxIterations
      HStack {
        Text("Image").font(.title)
        Toggle("", isOn: $model.showImage)
      }
      if model.showImage {
        Text("Float Size")
        Picker(model.floatSize.rawValue.capitalized, selection: $model.floatSize) {
          ForEach(FloatSize.imageSizes, id: \.self.rawValue) { size in
            Text(size.name).tag(size)
          }
        }.pickerStyle(SegmentedPickerStyle())

        Text("Color Palette")
        Picker(model.paletteName.name, selection: $model.paletteName) {
          ForEach(PixelPaletteName.allCases, id: \.self.name) { palette in
            Text(palette.name).tag(palette)
          }
        }.pickerStyle(SegmentedPickerStyle())

        if model.isComputingImage {
          HStack {
            Text("Calculating...")
            Spacer()
            ProgressView()
          }
        } else if let computationTime = model.computationTime {
          Text("Time: \(Int(computationTime * 1000)) ms")
        }
      }
    }
    .listStyle(SidebarListStyle())
    .navigationBarTitle("Mandelbrot", displayMode: .inline)
  }
}
