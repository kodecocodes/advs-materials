/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

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
