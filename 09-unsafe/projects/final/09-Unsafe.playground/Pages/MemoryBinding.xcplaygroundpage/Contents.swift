//: [Previous](@previous)

//Type Punning
let rawPointer = UnsafeMutableRawPointer.allocate(byteCount: 2, alignment: 2)
defer {
    rawPointer.deallocate()
}

let float16Pointer = rawPointer.bindMemory(to: Float16.self, capacity: 1)
let uint8Pointer = rawPointer.bindMemory(to: UInt8.self, capacity: 2)

float16Pointer.pointee = 0xABC0 // 43968

uint8Pointer.pointee // 0x5E
uint8Pointer.advanced(by: 1).pointee // 0x79

uint8Pointer.pointee -= 1

float16Pointer.pointee // 43936


