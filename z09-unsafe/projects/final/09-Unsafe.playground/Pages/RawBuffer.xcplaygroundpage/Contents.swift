/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation

let size = MemoryLayout<UInt>.size
let alignment = MemoryLayout<UInt>.alignment

let bytesPointer = UnsafeMutableRawPointer.allocate(
  byteCount: size,
  alignment: alignment)
defer {
  bytesPointer.deallocate()
}
bytesPointer.storeBytes(of: 0x0102030405060708, as: UInt.self)

let bufferPointer = UnsafeRawBufferPointer(start: bytesPointer, count: size)
for (offset, byte) in bufferPointer.enumerated() {
  print("byte \(offset): \(byte)")
}
