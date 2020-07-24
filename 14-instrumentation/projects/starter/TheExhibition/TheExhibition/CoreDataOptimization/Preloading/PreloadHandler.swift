/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import CoreData
class PreloadHandler {
  var context: NSManagedObjectContext {
    CoreDataManager.shared.context
  }

  var continents: [String: String] = [:]
  var languages: [String: PreLanguages] = [:]
  var countries: [String: PreCountries] = [:]

  init() {
    if CoreDataManager.shared.isEmpty() {
      loadContients()
      loadLanguages()
      loadCountries()

      saveContinents()
      saveLanguages()
      saveCountries()
    }
  }

  func loadContients() {
    guard let fileURL = Bundle.main.url(forResource: "continents", withExtension: "json") else {
      return
    }
    let decoder = JSONDecoder()
    guard let data = try? Data(contentsOf: fileURL) else {
      return
    }
    continents = (try? decoder.decode([String: String].self, from: data)) ?? [:]
  }

  func loadLanguages() {
    guard let fileURL = Bundle.main.url(forResource: "languages", withExtension: "json") else {
      return
    }
    let decoder = JSONDecoder()
    guard let data = try? Data(contentsOf: fileURL) else {
      return
    }
    languages = (try? decoder.decode([String: PreLanguages].self, from: data)) ?? [:]
  }

  func loadCountries() {
    guard let fileURL = Bundle.main.url(forResource: "countries", withExtension: "json") else {
      return
    }
    let decoder = JSONDecoder()
    guard let data = try? Data(contentsOf: fileURL) else {
      return
    }
    countries = (try? decoder.decode([String: PreCountries].self, from: data)) ?? [:]
  }

  func saveContinents() {
    for (key, value) in continents {
      let newContinent = Continents(context: context)
      newContinent.code = key
      newContinent.name = value
    }
    save()
  }

  func saveLanguages() {
    for (key, value) in languages {
      let newLanguage = Languages(context: context)
      newLanguage.code = key
      newLanguage.name = value.name
      newLanguage.nativeName = value.native
    }
    save()
  }

  func saveCountries() {
    for (key, value) in countries {
      let newCountry = Countries(context: context)
      newCountry.code = key
      newCountry.name = value.name
      newCountry.nativeName = value.name
      newCountry.phone = value.phone
      newCountry.currency = value.currency
      newCountry.capital = value.capital

      newCountry.continent = CoreDataManager.shared.continent(code: value.continent)

      for languageCode in value.languages {
        guard let language = CoreDataManager.shared.language(code: languageCode) else {
          continue
        }
        newCountry.addToLanguages(language)
      }
    }
    save()
  }

  func save() {
    do {
      try context.save()
    } catch {
      print("Error Saving: \(error)")
    }
  }
}
