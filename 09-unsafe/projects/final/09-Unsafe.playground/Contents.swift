import Foundation

var safeString: String? = nil

//print(safeString!)

var unsafeString: String? = nil

//print(unsafeString.unsafelyUnwrapped)

MemoryLayout<Int>.size          // returns 8 (on 64-bit)
MemoryLayout<Int>.alignment     // returns 8 (on 64-bit)
MemoryLayout<Int>.stride        // returns 8 (on 64-bit)

MemoryLayout<Int16>.size        // returns 2
MemoryLayout<Int16>.alignment   // returns 2
MemoryLayout<Int16>.stride      // returns 2

MemoryLayout<Bool>.size         // returns 1
MemoryLayout<Bool>.alignment    // returns 1
MemoryLayout<Bool>.stride       // returns 1

MemoryLayout<Float>.size        // returns 4
MemoryLayout<Float>.alignment   // returns 4
MemoryLayout<Float>.stride      // returns 4

MemoryLayout<Double>.size       // returns 8
MemoryLayout<Double>.alignment  // returns 8
MemoryLayout<Double>.stride     // returns 8

let zero = 0.0
MemoryLayout.size(ofValue: zero) // returns 8

struct IntBoolStruct {
    var intValue: Int
    var boolValue: Bool
}

MemoryLayout<IntBoolStruct>.size       // returns 9
MemoryLayout<IntBoolStruct>.alignment  // returns 8
MemoryLayout<IntBoolStruct>.stride     // returns 16

struct BoolIntStruct {
    var boolValue: Bool
    var intValue: Int
}

MemoryLayout<BoolIntStruct>.size       // returns 16
MemoryLayout<BoolIntStruct>.alignment  // returns 8
MemoryLayout<BoolIntStruct>.stride     // returns 16

struct EmptyStruct {}

MemoryLayout<EmptyStruct>.size       // returns 0
MemoryLayout<EmptyStruct>.alignment  // returns 1
MemoryLayout<EmptyStruct>.stride     // returns 1

class IntBoolClass {
    var intValue: Int = 0
    var boolValue: Bool = false
}

MemoryLayout<IntBoolClass>.size       // returns 8
MemoryLayout<IntBoolClass>.alignment  // returns 8
MemoryLayout<IntBoolClass>.stride     // returns 8

class BoolIntClass {
    var boolValue: Bool = false
    var intValue: Int = 0
}

MemoryLayout<BoolIntClass>.size       // returns 8
MemoryLayout<BoolIntClass>.alignment  // returns 8
MemoryLayout<BoolIntClass>.stride     // returns 8

class EmptyClass {}

MemoryLayout<EmptyClass>.size       // returns 8
MemoryLayout<EmptyClass>.alignment  // returns 8
MemoryLayout<EmptyClass>.stride     // returns 8
