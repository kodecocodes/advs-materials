/// Sample code from the book, Advanced Swift, published at raywenderlich.com, Copyright 2021.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation
import CoreData

class CoreDataManager {
  static var shared = CoreDataManager()
  var context: NSManagedObjectContext {
    persistentContainer.viewContext
  }

  // MARK: - Core Data stack

  private lazy var persistentContainer: NSPersistentContainer = {
    preloadDatabaseIfNeeded()

    let container = NSPersistentContainer(name: "Countries")
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()

  private func preloadDatabaseIfNeeded() {
    let path = NSPersistentContainer.defaultDirectoryURL().relativePath + "/Countries.sqlite"
    guard !FileManager.default.fileExists(atPath: path) else {
      return
    }

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
      fatalError("Unresolved error \(error)")
    }
  }

  // MARK: - Core Data Saving support

  func allCountries() -> [Country] {
    let request: NSFetchRequest<Country> = Country.fetchRequest()
    request.relationshipKeyPathsForPrefetching = ["languages", "continent"]
    request.sortDescriptors = [.init(key: "name", ascending: true)]
    return (try? context.fetch(request)) ?? []
  }

  func clearMemory() {
    context.refreshAllObjects()
  }
}
