/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import UIKit

class TimeProfilerViewController: UIViewController {
  let totalCells = 10000
  @IBOutlet var collectionView: UICollectionView!
}

// MARK: - UICollectionViewDataSource
extension TimeProfilerViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return totalCells
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let timer = MachineTimer()
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "NumberCollectionViewCell",
      for: indexPath
    ) as? NumberCollectionViewCell else {
      return UICollectionViewCell()
    }
    cell.number = TrackedNumbersGenerator.generate()
    cell.time = "\(timer.mark())μs"
    return cell
  }
}
