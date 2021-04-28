/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import UIKit

class CountryCell: UITableViewCell {
  var country: Country? {
    didSet {
      guard let country = country else {
        return
      }
      countryName.text = country.name
      continentName.text = country.continent?.name

      guard shouldShowLanguages else {
        languageNames.isHidden = true
        return
      }

      languageNames.isHidden = false

      let names = country.languagesArray
        .map {
          $0.name
        }
        .compactMap {
          $0
        }
      languageNames.text = names.joined(separator: " ▪︎ ")
    }
  }

  @IBOutlet var countryName: UILabel!
  @IBOutlet var continentName: UILabel!
  @IBOutlet weak var languageNames: UILabel!
}

extension Country {
  var languagesArray: [Language] {
    return (languages?.allObjects as? [Language]) ?? []
  }
}
