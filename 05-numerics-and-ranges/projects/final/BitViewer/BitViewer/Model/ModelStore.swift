/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Combine        // ObservableObject, @Published
import CoreGraphics   // CGFloat

/// The data model for the app that keeps the selection and backing store for each numeric type.
final class ModelStore: ObservableObject {
  @Published var selection: TypeSelection = .int8

  @Published var int8: Int8 = 10
  @Published var uint8: UInt8 = 10
  @Published var int16: Int16 = 10
  @Published var uint16: UInt16 = 10
  @Published var int32: Int32 = 10
  @Published var uint32: UInt32 = 10
  @Published var int64: Int64 = 10
  @Published var uint64: UInt64 = 10
  @Published var int: Int = 10
  @Published var uint: UInt = 10

  @Published var float16: Float16 = 1.0
  @Published var float32: Float32 = 1.0
  @Published var float64: Float64 = 1.0
  @Published var float: Float = 1.0
  @Published var double: Double = 1.0
  @Published var cgFloat: CGFloat = 1.0
}

final class Preferences: ObservableObject {
  @Published var displayBitsStacked = false
}
