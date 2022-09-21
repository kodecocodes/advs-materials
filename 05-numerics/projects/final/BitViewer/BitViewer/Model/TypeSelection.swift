/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

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
