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

class CoreDataManager {
  static var shared = CoreDataManager()
  var context: NSManagedObjectContext {
    persistentContainer.viewContext
  }

  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentContainer = {
    if !FileManager.default.fileExists(
      atPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Countries.sqlite"
      ) {
      let sqlFileURL = Bundle.main.url(forResource: "Countries", withExtension: ".sqlite")
      let shmFileURL = Bundle.main.url(forResource: "Countries", withExtension: ".sqlite-shm")
      let walFileURL = Bundle.main.url(forResource: "Countries", withExtension: ".sqlite-wal")

      let sqlFileDest = NSPersistentContainer.defaultDirectoryURL().relativePath + "/Countries.sqlite"
      let shmFileDest = NSPersistentContainer.defaultDirectoryURL().relativePath + "/Countries.sqlite-shm"
      let walFileDest = NSPersistentContainer.defaultDirectoryURL().relativePath + "/Countries.sqlite-wal"

      do {
        try FileManager.default.copyItem(atPath: sqlFileURL?.path ?? "", toPath: sqlFileDest)
        try FileManager.default.copyItem(atPath: shmFileURL?.path ?? "", toPath: shmFileDest)
        try FileManager.default.copyItem(atPath: walFileURL?.path ?? "", toPath: walFileDest)
      } catch {
        print("Error: \(error)")
      }
    }


    let container = NSPersistentContainer(name: "Countries")
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()

  // MARK: - Core Data Saving support
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }

  func continent(code: String) -> Continents? {
    let request: NSFetchRequest<Continents> = Continents.fetchRequest()
    request.predicate = NSPredicate(format: "code == %@", code)
    request.fetchLimit = 1
    guard let results = try? context.fetch(request) else {
      return nil
    }
    return results.first
  }

  func language(code: String) -> Languages? {
    let request: NSFetchRequest<Languages> = Languages.fetchRequest()
    request.predicate = NSPredicate(format: "code == %@", code)
    request.fetchLimit = 1
    guard let results = try? context.fetch(request) else {
      return nil
    }
    return results.first
  }

  func allCountries() -> [Countries] {
    let request: NSFetchRequest<Countries> = Countries.fetchRequest()
    guard let results = try? context.fetch(request) else {
      return []
    }
    return results
  }

  func isEmpty() -> Bool {
    let request: NSFetchRequest<Languages> = Languages.fetchRequest()
    guard let results = try? context.fetch(request) else {
      return true
    }
    return results.isEmpty
  }
}

extension Countries {
  var languagesArray: [Languages] {
    guard let array = languages?.allObjects as? [Languages] else {
      return []
    }
    return array
  }
}
