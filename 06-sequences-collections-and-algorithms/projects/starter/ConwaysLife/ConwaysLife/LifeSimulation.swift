/// Sample code from the book, Expert Swift,
/// published at kodeco.com, Copyright (c) 2025 Kodeco Inc.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.kodeco.com/books/expert-swift

import SwiftUI
import Combine

/// Model object for Conway's Game of Life
@Observable
final class LifeSimulation {
  /// Controls if the simulation is running.
  var isRunning: Bool = false

  /// Track the generation (tick) of the simulation.
  var generation = 0

  /// The cellular automata being simulated.  Use a 2D Bitmap
  var cells: Bitmap<Bool>

  /// Support automatic simulation halting.  This will catch a patterns with
  /// a periodicity of two.
  @ObservationIgnored var previous = RingMemory<Bitmap<Bool>>(capacity: 2)

  /// Subscriptions set to keep the timer.
  @ObservationIgnored var subscriptions: Set<AnyCancellable> = []

  /// Define the colors for the cells.
  static var none = ColorPixel(red: 0xda, green: 0xda, blue: 0xda)
  static var live = ColorPixel(red: 0x21, green: 0x96, blue: 0xf3)

  /// Create a simulation for a given width and height of cells.  Begin with the simulation
  /// paused.
  init(size: Int) {
    isRunning = false
    cells = Bitmap(width: size, height: size, fill: false)
  }
  
  var cellImage: UIImage {
    UIImage() // TODO: implement
  }
  
  func setLive(row: Int, column: Int) {
    // TODO: implement
  }

  /// Clear all of the cells, stop the simulation and forget everything.
  func clear() {
    cells.set(false)
    generation = 0
    isRunning = false
    previous.reset()
  }
}
