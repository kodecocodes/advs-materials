/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2020 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import CoreGraphics

protocol CGFloatConvertable {
  init(_: CGFloat)
  var cgFloat: CGFloat { get }
}

extension Float16: CGFloatConvertable {
  var cgFloat: CGFloat {
    CGFloat(self)
  }
}

extension Float32: CGFloatConvertable {
  var cgFloat: CGFloat {
    CGFloat(self)
  }
}

extension Float64: CGFloatConvertable {
  var cgFloat: CGFloat {
    CGFloat(self)
  }
}

#if arch(x86_64)
extension Float80: CGFloatConvertable {
  var cgFloat: CGFloat {
    CGFloat(self)
  }
}
#endif
