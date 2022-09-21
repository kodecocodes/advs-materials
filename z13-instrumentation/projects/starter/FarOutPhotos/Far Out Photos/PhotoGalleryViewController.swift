/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import UIKit
import Nuke
import ImagePublisher

class PhotoGalleryViewController: UICollectionViewController {
  var photoURLs: [URL] = []

  let cellSpacing: CGFloat = 1
  let columns: CGFloat = 3
  var cellSize: CGFloat = 0

  var pixelSize: CGFloat {
    return cellSize * UIScreen.main.scale
  }

  var resizedImageProcessors: [ImageProcessing] {
    let imageSize = CGSize(width: pixelSize, height: pixelSize)
    return [ImageProcessors.Resize(size: imageSize, contentMode: .aspectFill)]
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.navigationBar.topItem?.title = "NASA Photos"

    guard
      let plist = Bundle.main.url(forResource: "NASAPhotos", withExtension: "plist"),
      let contents = try? Data(contentsOf: plist),
      let plistSerialized = try? PropertyListSerialization.propertyList(from: contents, options: [], format: nil),
      let urlPaths = plistSerialized as? [String]
      else {
        return
    }

    photoURLs = urlPaths.compactMap { URL(string: $0) }

    let contentModes = ImageLoadingOptions.ContentModes(
      success: .scaleAspectFill,
      failure: .scaleAspectFit,
      placeholder: .scaleAspectFit)

    ImageLoadingOptions.shared.placeholder = UIImage(named: "dark-moon")
    ImageLoadingOptions.shared.failureImage = UIImage(named: "annoyed")
    ImageLoadingOptions.shared.transition = .fadeIn(duration: 0.5)
    ImageLoadingOptions.shared.contentModes = contentModes

    DataLoader.sharedUrlCache.diskCapacity = 0

    let pipeline = ImagePipeline {
      let dataCache = try? DataCache(name: "com.razeware.Far-Out-Photos.datacache")
      dataCache?.sizeLimit = 200 * 1024 * 1024
      $0.dataCache = dataCache
    }
    ImagePipeline.shared = pipeline
    pipeline.observer = self
  }
}

// MARK: Collection View Data Source Methods
extension PhotoGalleryViewController {
  override func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return photoURLs.count
  }

  override func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "PhotoCell",
      for: indexPath) as? PhotoCell else {
        return UICollectionViewCell()
    }

    let request = ImageRequest(
      url: photoURLs[indexPath.row],
      processors: [])

    Nuke.loadImage(with: request, into: cell.imageView)

    return cell
  }
}

// MARK: Collection View Delegate Flow Layout Methods
extension PhotoGalleryViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
      let emptySpace = layout.sectionInset.left + layout.sectionInset.right + (columns * cellSpacing - 1)
      cellSize = (view.frame.size.width - emptySpace) / columns
      return CGSize(width: cellSize, height: cellSize)
    }

    return CGSize()
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return cellSpacing
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return cellSpacing
  }
}

// MARK: Collection View Delegate Methods
extension PhotoGalleryViewController {
  override func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let photoViewController = PhotoViewController.instantiate() else {
      return
    }

    photoViewController.imageURL = photoURLs[indexPath.row]
    photoViewController.resizedImageProcessors = resizedImageProcessors

    navigationController?.pushViewController(photoViewController, animated: true)
  }
}

extension PhotoGalleryViewController: ImagePipelineObserving {
  func pipeline(
    _ pipeline: ImagePipeline,
    imageTask: ImageTask,
    didReceiveEvent event: ImageTaskEvent
  ) {
    let imageName = imageTask.request.urlRequest.url?.lastPathComponent ?? ""

    switch event {
    case .started:
      print("started " + imageName)
    case .cancelled:
      print("cancelled " + imageName)
    case .completed(result: _):
      print("completed " + imageName)
    case .progressUpdated(
          completedUnitCount: let completed,
          totalUnitCount: let total
    ):
      let percent = completed * 100 / total
      print("progress for \(imageName): \(percent)")
    default:
      print("default")
    }
  }
}
