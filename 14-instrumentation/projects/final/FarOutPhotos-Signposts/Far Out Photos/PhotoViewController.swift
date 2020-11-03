/// Sample code from the book, Advanced Swift, published at raywenderlich.com, Copyright 2020.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import UIKit
import Nuke
import Combine
import ImagePublisher

class PhotoViewController: UIViewController {
  var imageURL: URL?
  var cancellable: AnyCancellable?
  var resizedImageProcessors: [ImageProcessing] = []

  @IBOutlet weak var imageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    imageView.image = ImageLoadingOptions.shared.placeholder
    imageView.contentMode = .scaleAspectFit

    guard let imageURL = imageURL else { return }

    loadImage(url: imageURL)
  }

  func loadImage(url: URL) {
    let resizedImageRequest = ImageRequest(
      url: url,
      processors: resizedImageProcessors)
    let resizedImagePublisher = ImagePipeline.shared.imagePublisher(with: resizedImageRequest)
    let originalImagePublisher = ImagePipeline.shared.imagePublisher(with: url)

    guard let failedImage = ImageLoadingOptions.shared.failureImage else {
      return
    }

    cancellable = resizedImagePublisher.append(
      originalImagePublisher)
      .map {
        ($0.image, UIView.ContentMode.scaleAspectFill )
      }
      .catch { _ in
        Just((failedImage, .scaleAspectFit))
      }
      .sink {
        self.imageView.image = $0
        self.imageView.contentMode = $1
      }
  }

  static func instantiate() -> PhotoViewController? {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(
      withIdentifier: "PhotoViewController") as? PhotoViewController
  }
}
