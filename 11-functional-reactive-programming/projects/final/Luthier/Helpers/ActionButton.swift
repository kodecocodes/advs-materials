/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI

struct ActionButton: View {
  let title: String
  let isLoading: Bool
  let color: Color
  let action: () -> Void

  init(_ title: String,
       isLoading: Bool = false,
       color: Color = .green,
       action: @escaping () -> Void) {
    self.title = title
    self.isLoading = isLoading
    self.color = color
    self.action = action
  }

  var body: some View {
    if isLoading {
      ZStack {
        color
          .edgesIgnoringSafeArea(.bottom)
          .frame(maxWidth: .infinity, maxHeight: 64, alignment: .bottom)

        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: .white))
      }
    } else {
      Button(title, action: action)
        .foregroundColor(.white)
        .font(.system(size: 28,
                      weight: .semibold,
                      design: .rounded))
        .frame(maxWidth: .infinity,
               maxHeight: 64)
        .background(color.edgesIgnoringSafeArea(.bottom))
    }
  }
}
