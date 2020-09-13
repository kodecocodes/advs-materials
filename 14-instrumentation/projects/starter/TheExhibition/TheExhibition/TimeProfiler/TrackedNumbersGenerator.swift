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
