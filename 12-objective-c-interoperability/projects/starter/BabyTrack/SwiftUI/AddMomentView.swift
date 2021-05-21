/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import SwiftUI
import PhotosUI
import BabyKit

struct AddMomentView: UIViewControllerRepresentable {
  @Binding var isPresented: Bool

  func makeUIViewController(context: Context) -> PHPickerViewController {
    var configuration = PHPickerConfiguration()
    configuration.selectionLimit = 1
    configuration.filter = .images

    let controller = PHPickerViewController(configuration: configuration)
    controller.delegate = context.coordinator
    return controller
  }

  func updateUIViewController(_ uiViewController: PHPickerViewController,
                              context: Context) {
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: PHPickerViewControllerDelegate {
    private let parent: AddMomentView

    init(_ parent: AddMomentView) {
      self.parent = parent
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) { 
      guard let result = results.first,
            result.itemProvider.canLoadObject(ofClass: UIImage.self) else {
        return
      }
    }
  }
}
