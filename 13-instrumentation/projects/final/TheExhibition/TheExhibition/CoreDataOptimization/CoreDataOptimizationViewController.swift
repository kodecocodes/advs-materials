/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import UIKit

let shouldShowLanguages = true

class CoreDataOptimizationViewController: UITableViewController {
  var countries: [Country] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    countries = CoreDataManager.shared.allCountries()

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      CoreDataManager.shared.clearMemory()
    }
  }
}

// MARK: - UICollectionViewDataSource
extension CoreDataOptimizationViewController {
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return countries.count
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "CountryCell",
      for: indexPath) as? CountryCell else {
      return UITableViewCell()
    }
    cell.country = countries[indexPath.row]
    return cell
  }
}
