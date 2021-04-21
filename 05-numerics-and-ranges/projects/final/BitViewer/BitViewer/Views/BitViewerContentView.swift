/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import SwiftUI

struct BitViewerContentView: View {
  @ObservedObject var model: ModelStore

  var body: some View {
    NavigationView {
      Sidebar(model: model)
      typeErasedOperationsView()
      ScrollView {
        typeErasedNumericView()
      }
    }
  }

  // swiftlint:disable:next cyclomatic_complexity
  func typeErasedOperationsView() -> AnyView {
    switch model.selection {
    case .int8:
      return AnyView(IntegerOperationsView(value: $model.int8))
    case .uint8:
      return AnyView(IntegerOperationsView(value: $model.uint8))
    case .int16:
      return AnyView(IntegerOperationsView(value: $model.int16))
    case .uint16:
      return AnyView(IntegerOperationsView(value: $model.uint16))
    case .int32:
      return AnyView(IntegerOperationsView(value: $model.int32))
    case .uint32:
      return AnyView(IntegerOperationsView(value: $model.uint32))
    case .int64:
      return AnyView(IntegerOperationsView(value: $model.int64))
    case .uint64:
      return AnyView(IntegerOperationsView(value: $model.uint64))
    case .int:
      return AnyView(IntegerOperationsView(value: $model.int))
    case .uint:
      return AnyView(IntegerOperationsView(value: $model.uint))
    case .float16:
      return AnyView(FloatingPointOperationsView(value: $model.float16))
    case .float32:
      return AnyView(FloatingPointOperationsView(value: $model.float32))
    case .float64:
      return AnyView(FloatingPointOperationsView(value: $model.float64))
    case .float:
      return AnyView(FloatingPointOperationsView(value: $model.float))
    case .double:
      return AnyView(FloatingPointOperationsView(value: $model.double))
    case .cgfloat:
      return AnyView(FloatingPointOperationsView(value: $model.cgFloat))
    }
  }

  // swiftlint:disable:next cyclomatic_complexity
  private func typeErasedNumericView() -> AnyView {
    switch model.selection {
    case .int8:
      return AnyView(IntegerView(value: $model.int8))
    case .uint8:
      return AnyView(IntegerView(value: $model.uint8))
    case .int16:
      return AnyView(IntegerView(value: $model.int16))
    case .uint16:
      return AnyView(IntegerView(value: $model.uint16))
    case .int32:
      return AnyView(IntegerView(value: $model.int32))
    case .uint32:
      return AnyView(IntegerView(value: $model.uint32))
    case .int64:
      return AnyView(IntegerView(value: $model.int64))
    case .uint64:
      return AnyView(IntegerView(value: $model.uint64))
    case .int:
      return AnyView(IntegerView(value: $model.int))
    case .uint:
      return AnyView(IntegerView(value: $model.uint))
    case .float16:
      return AnyView(FloatingPointView(value: $model.float16))
    case .float32:
      return AnyView(FloatingPointView(value: $model.float32))
    case .float64:
      return AnyView(FloatingPointView(value: $model.float64))
    case .float:
      return AnyView(FloatingPointView(value: $model.float))
    case .double:
      return AnyView(FloatingPointView(value: $model.double))
    case .cgfloat:
      return AnyView(FloatingPointView(value: $model.cgFloat))
    }
  }
}
