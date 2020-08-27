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

enum TypeSelection: CaseIterable {
  case int8, uint8, int16, uint16, int32, uint32, int64, uint64, int, uint
  case float16, float32, float64, float, double, cgfloat

  var isUnsigned: Bool {
    switch self {
    case .uint8, .uint16, .uint32, .uint64, .uint:
      return true
    default:
      return false
    }
  }

  var isInteger: Bool {
    switch self {
    case .int8, .uint8, .int16, .uint16, .int32, .uint32, .int64, .uint64, .int, .uint:
      return true
    case .float16, .float32, .float64, .float, .double, .cgfloat:
      return false
    }
  }

  var isFloatingPoint: Bool {
    !isInteger
  }

  var title: String {
    switch self {
    case .int8:
      return "Int8"
    case .uint8:
      return "UInt8"
    case .int16:
      return "Int16"
    case .uint16:
      return "UInt16"
    case .int32:
      return "Int32"
    case .uint32:
      return "UInt32"
    case .int64:
      return "Int64"
    case .uint64:
      return "UInt64"
    case .int:
      return "Int"
    case .uint:
      return "UInt"
    case .float16:
      return "Float16"
    case .float32:
      return "Float32"
    case .float64:
      return "Float64"
    case .float:
      return "Float"
    case .double:
      return "Double"
    case .cgfloat:
      return "CGFloat"
    }
  }
}
