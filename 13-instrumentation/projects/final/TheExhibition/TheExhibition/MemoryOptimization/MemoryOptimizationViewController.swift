/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import UIKit

class MemoryOptimizationViewController: UICollectionViewController {
  let totalImages = 12
  var photosList: [UIImage] = []

  let cellSpacing: CGFloat = 1
  let columns: CGFloat = 3
  var cellSize: CGFloat = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    for i in 1 ... totalImages {
      guard let image = UIImage(named: "Image\(i)") else {
        continue
      }
      photosList.append(image)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension MemoryOptimizationViewController {
  override func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return photosList.count
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

    cell.imageView.image = photosList[indexPath.row]

    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MemoryOptimizationViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
      return CGSize()
    }

    let emptySpace =
      layout.sectionInset.left + layout.sectionInset.right + (columns * cellSpacing - 1)
    cellSize = (view.frame.size.width - emptySpace) / columns
    return CGSize(width: cellSize, height: cellSize)
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
