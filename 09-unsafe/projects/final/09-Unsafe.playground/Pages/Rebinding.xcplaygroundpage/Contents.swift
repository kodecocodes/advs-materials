//: [Previous](@previous)

let count = 3
let size = MemoryLayout<Int16>.size
let stride = MemoryLayout<Int16>.stride
let alignment = MemoryLayout<Int16>.alignment
let byteCount =  count * stride

let rawPointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
defer {
    rawPointer.deallocate()
}

let typedPointer1 = rawPointer.bindMemory(to: UInt16.self, capacity: count)

typedPointer1.withMemoryRebound(to: Bool.self, capacity: count * size) {
  (boolPointer: UnsafeMutablePointer<Bool>) in
  print(boolPointer.pointee)
}

//let typedPointer2 = rawPointer.assumingMemoryBound(to: UInt16.self)

