/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import SwiftUI
import PhotosUI
import BabyKit

struct AddMomentView: UIViewControllerRepresentable {
  let feed: Feed
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

      result.itemProvider
        .loadObject(ofClass: UIImage.self) { [weak self] obj, err in
        defer { self?.parent.isPresented = false }

        guard let image = obj as? UIImage,
              let parent = self?.parent else { return }

        if let err = err {
          print("Error in picked image: \(err)")
          return
        }

        guard let attachmentId = parent.feed.storeImage(image) else {
          print("Failed storing, no UUID")
          return
        }

        DispatchQueue.main.async {
          parent.feed.addMoment(with: attachmentId)
        }
      }
    }
  }
}
