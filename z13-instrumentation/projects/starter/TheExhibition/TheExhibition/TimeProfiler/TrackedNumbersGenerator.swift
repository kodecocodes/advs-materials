/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

class TrackedNumbersGenerator {
  private static var shared = TrackedNumbersGenerator()

  private let maxValue = 10000
  private let shouldAlwaysSave = true
  private var trackedNumbers: [Int: Int] = [:]

  private let trackedNumbersURL = URL(
    fileURLWithPath: "TrackedNumbers",
    relativeTo: FileManager.documentsDirectoryURL
  ).appendingPathExtension("plist")

  class func saveTrackedNumbers() {
    shared.saveTrackedNumbers()
  }

  class func generate() -> (Int, Int) {
    return shared.generate()
  }

  private init() {
    loadTrackedNumbers()
    // load some numbers so the file is not empty
    if trackedNumbers.isEmpty {
      (0...1000).forEach { _ in
        generate()
      }
    }
  }

  private func loadTrackedNumbers() {
    guard FileManager.default.fileExists(atPath: trackedNumbersURL.path) else {
      return
    }

    let decoder = PropertyListDecoder()

    do {
      let tasksData = try Data(contentsOf: trackedNumbersURL)
      trackedNumbers = try decoder.decode([Int: Int].self, from: tasksData)
    } catch let error {
      print(error)
    }
  }

  private func saveTrackedNumbers() {
    let encoder = PropertyListEncoder()
    do {
      let tasksData = try encoder.encode(trackedNumbers)
      try tasksData.write(to: trackedNumbersURL, options: .atomicWrite)
    } catch let error {
      print(error)
    }
  }

  @discardableResult
  private func generate() -> (Int, Int) {
    let value = Int.random(in: 0...maxValue)

    let count = trackedNumbers[value] ?? 0
    trackedNumbers[value] = count + 1
    if shouldAlwaysSave {
      saveTrackedNumbers()
    }

    return (value, count + 1)
  }
}
