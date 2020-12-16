/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import SwiftUI
import Combine

/// Model object for Conway's Game of Life
final class LifeSimulation: ObservableObject {

  /// Controls if the simulation is running.
  @Published var isRunning: Bool = false

  /// Track the epoch (step) of the simulation.
  @Published var epoch = 0

  /// The cellular automata being simulated.  Use a 2D Bitmap
  @Published var cells: Bitmap<Bool>

  /// Support automatic simulation halting.  This will catch a patterns with
  /// a periodicity of two.
  var previous = RingMemory<Bitmap<Bool>>(capacity: 2)

  /// Subscriptions set to keep the timer.
  var subscriptions: Set<AnyCancellable> = []

  /// Define the colors for the cells.
  static var none = ColorPixel(red: 0xda, green: 0xda, blue: 0xda)
  static var live = ColorPixel(red: 0x21, green: 0x96, blue: 0xf3)

  /// Create a simulation for a given width and height of cells.  Begin with the simulation
  /// paused.
  init(size: Int) {
    isRunning = false
    cells = Bitmap(width: size, height: size, fill: false)

    Timer.publish(every: 0.1, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        self?.evolve()
      }
      .store(in: &subscriptions)
  }

  /// Count the number of live cells around a given position.
  func neighborCount(around index: Bitmap<Bool>.Index) -> Int {
    var count = 0
    for rowOffset in -1...1 {
      for columnOffset in -1...1 {
        guard rowOffset != 0 || columnOffset != 0 else {
          continue
        }
        let probe = cells.index(of: index, rowOffset: rowOffset,
                                columnOffset: columnOffset)
        count += cells.contains(index: probe) ?
          (cells[probe] ? 1 : 0) : 0
      }
    }
    return count
  }

  /// Advance one step (epoch) in the simulation.
  func evolve() {
    guard isRunning else {
      return
    }

    epoch += 1

    let neighbors = cells.indices.map(neighborCount(around:))

    // The core rules of life.
    zip(cells.indices, neighbors).forEach { index, count in
      switch (cells[index], count) {
      case (true, 0...1):
        cells[index] = false // death by starvation
      case (true, 2...3):
        cells[index] = true  // live on
      case (true, 4...):
        cells[index] = false // death by overcrowding
      case (false, 3):
        cells[index] = true  // birth
      default:
        break // no change
      }
    }

    // automatically stop the simulation if stability is reached
    if previous.contains(cells) {
      isRunning = false
    }
    previous.add(cells)
  }

  /// Turn cells into a displayable, color bitmap.
  var cellImage: UIImage {
    let pixels = cells.map { $0 ? Self.live : Self.none }
    return UIImage(cgImage: Bitmap(pixels: pixels, width: cells.width).cgImage!)
  }

  /// Set positions to live cells.
  func setLive(row: Int, column: Int) {
    let position = Bitmap<Bool>.Index(row: row, column: column)
    if cells.contains(index: position) {
      cells[position] = true
      previous.reset() // forget everything previous
    }
  }

  /// Clear all of the cells, stop the simulation and forget everything.
  func clear() {
    cells.set(false)
    epoch = 0
    isRunning = false
    previous.reset()
  }
}
