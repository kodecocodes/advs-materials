/// Sample code from the book, Advanced Swift, published at raywenderlich.com, Copyright 2020.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

//let typedPointer2 = rawPointer.assumingMemoryBound(to: UInt16.self)

func initRawAB() -> UnsafeMutableRawPointer {
    let rawPtr = UnsafeMutableRawPointer.allocate(
        byteCount: 2 * MemoryLayout<UInt16>.stride,
        alignment: MemoryLayout<UInt16>.alignment)

    let boundP1 = rawPtr.bindMemory(to: UInt16.self, capacity: 1)
    boundP1.pointee = 101

    let boundP2 = rawPtr.advanced(by: 2).bindMemory(to: Float16.self, capacity: 1)
    boundP2.pointee = 202.5

    return rawPtr
}

let rawPtr = initRawAB()

let assumedP1 = rawPtr
    .assumingMemoryBound(to: UInt16.self)
assumedP1.pointee // 101

let assumedP2 = rawPtr
    .advanced(by: 2)
    .assumingMemoryBound(to: Float16.self)
assumedP2.pointee // 202.5
