/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

let count = 4

let pointer = UnsafeMutablePointer<Int>.allocate(capacity: count)
pointer.initialize(repeating: 0, count: count)
defer {
  pointer.deinitialize(count: count)
  pointer.deallocate()
}

pointer.pointee = 10001
pointer.advanced(by: 1).pointee = 10002
(pointer+2).pointee = 10003
pointer.advanced(by: 3).pointee = 10004

pointer.pointee
pointer.advanced(by: 1).pointee
(pointer+1).pointee
pointer.advanced(by: 2).pointee
(pointer+3).pointee

let bufferPointer = UnsafeBufferPointer(start: pointer, count: count)
for (offset, value) in bufferPointer.enumerated() {
  print("value \(offset): \(value)")
}
