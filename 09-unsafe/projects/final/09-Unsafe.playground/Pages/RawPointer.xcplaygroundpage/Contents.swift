/// Sample code from the book, Advanced Swift, published at raywenderlich.com, Copyright 2020.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import Foundation

var int16Value: UInt16 = 0x1122 // 4386
MemoryLayout.size(ofValue: int16Value) // 2
MemoryLayout.stride(ofValue: int16Value) // 2
MemoryLayout.alignment(ofValue: int16Value) // 2


let int16bytesPointer = UnsafeMutableRawPointer.allocate(byteCount: 2, alignment: 2)
defer {
    int16bytesPointer.deallocate()
}
int16bytesPointer.storeBytes(of: 0x1122, as: UInt16.self)

print(int16bytesPointer)

let firstByte = int16bytesPointer.load(as: UInt8.self)       // 34

let offsetPointer = int16bytesPointer + 1
let secondByte = offsetPointer.load(as: UInt8.self)     // 17


let offsetPointer2 = int16bytesPointer + 2
let thirdByte = offsetPointer2.load(as: UInt8.self)     // Undefined

offsetPointer2.storeBytes(of: 0x3344, as: UInt16.self)

let invalidUInt16 = int16bytesPointer.load(as: UInt32.self)

//let misalignedUInt16 = offsetPointer.load(as: UInt16.self)
