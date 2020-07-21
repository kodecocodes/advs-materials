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
