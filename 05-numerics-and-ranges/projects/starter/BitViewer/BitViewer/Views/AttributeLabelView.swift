/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI

struct AttributeLabelView: View {
  let labelText: String
  let isOn: Bool
  let color: Color

  init(_ labelText: String, isOn: Bool, color: Color = .black) {
    self.labelText = labelText
    self.isOn = isOn
    self.color = color
  }

  var body: some View {
    Text(labelText)
      .padding(6)
      .background(
        ZStack {
          RoundedRectangle(cornerRadius: cornerRadius).fill(backgroundColor)
          RoundedRectangle(cornerRadius: cornerRadius).stroke(foregroundColor, lineWidth: 1)
        })
      .foregroundColor(foregroundColor)
  }

  // MARK: - View constants

  let cornerRadius: CGFloat = 5
  let deselectColor = Color.gray.opacity(0.3)
  let deselectBackground = Color.gray.opacity(0.01)
  var backgroundColor: Color { isOn ? color.opacity(0.1) : deselectBackground }
  var foregroundColor: Color { isOn ? color : deselectColor }
}

struct AttributeLabelView_Previews: PreviewProvider {
  static var previews: some View {
    AttributeLabelView("Normalized", isOn: true, color: .red)
  }
}
