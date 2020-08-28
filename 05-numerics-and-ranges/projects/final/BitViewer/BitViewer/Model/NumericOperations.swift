/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

private extension UInt8 {
  mutating func reverseBits() {
    self = (0b11110000 & self) >> 4 | (0b00001111 & self) << 4
    self = (0b11001100 & self) >> 2 | (0b00110011 & self) << 2
    self = (0b10101010 & self) >> 1 | (0b01010101 & self) << 1
  }
}

extension FixedWidthInteger {
  var bitReversedV1: Self {
    var reversed = byteSwapped
    withUnsafeMutableBytes(of: &reversed) { buffer in
      buffer.indices.forEach { buffer[$0].reverseBits() }
    }
    return reversed
  }

  var bitReversed: Self {
    precondition(MemoryLayout<Self>.size <= MemoryLayout<UInt64>.size)
    var reversed = UInt64(truncatingIfNeeded: self.byteSwapped)
    reversed = (reversed & 0xf0f0f0f0f0f0f0f0) >> 4 | (reversed & 0x0f0f0f0f0f0f0f0f) << 4
    reversed = (reversed & 0xcccccccccccccccc) >> 2 | (reversed & 0x3333333333333333) << 2
    reversed = (reversed & 0xaaaaaaaaaaaaaaaa) >> 1 | (reversed & 0x5555555555555555) << 1
    return Self(truncatingIfNeeded: reversed)
  }
}

enum IntegerOperation<IntType: FixedWidthInteger> {
  // 1
  typealias Operation = (IntType) -> IntType

  // 2
  struct Section {
    let title: String
    let items: [Item]
  }

  // 3
  struct Item {
    let name: String
    let operation: Operation
  }
}

extension IntegerOperation {
  static var menu: [Section] {
    [
      Section(title: "Set Value", items:
      [
        Item(name: "value = 0") { _ in 0 },
        Item(name: "value = 1") { _ in 1 },
        Item(name: "all ones") { _ in ~IntType.zero },
        Item(name: "value = -1") { _ in -1 },
        Item(name: "max") { _ in IntType.max },
        Item(name: "min") { _ in IntType.min },
        Item(name: "random") { _ in IntType.random(in: IntType.min...IntType.max) }
      ]),
      Section(title: "Endian", items:
      [
        Item(name: "bigEndian") { value in value.bigEndian },
        Item(name: "littleEndian") { value in value.littleEndian },
        Item(name: "byteSwapped") { value in value.byteSwapped }
      ]),
      Section(title: "Bit Manipulation", items:
      [
        Item(name: "value << 1") { value in value << 1 },
        Item(name: "value >> 1") { value in value >> 1 },
        Item(name: "toggle") { value in ~value },
        Item(name: "reverse") { value in value.bitReversed }
      ]),
      Section(title: "Arithmetic", items:
      [
        Item(name: "value + 1") { value in value &+ 1 },
        Item(name: "value - 1") { value in value &- 1 },
        Item(name: "negate") { value in ~value &+ 1 }
      ])
    ]
  }
}

enum FloatingPointOperation<FloatType: BinaryFloatingPoint> {
  typealias Operation = (FloatType) -> FloatType

  struct Section {
    let title: String
    let items: [Item]
  }

  struct Item {
    let name: String
    let operation: Operation
  }

  static var menu: [Section] {
    [
      Section(title: "Set Value", items:
      [
        Item(name: "value = 0") { _ in 0 },
        Item(name: "value = 0.1") { _ in FloatType(0.1) },
        Item(name: "value = 0.2") { _ in FloatType(0.2) },
        Item(name: "value = 0.5") { _ in FloatType(0.5) },
        Item(name: "value = 1") { _ in 1 },
        Item(name: "value = -1") { _ in -1 },
        Item(name: "value = pi") { _ in FloatType.pi },
        Item(name: "value = 100") { _ in 100 },
        Item(name: "infinity") { _ in FloatType.infinity },
        Item(name: "NaN") { _ in FloatType.nan },
        Item(name: "Signaling NaN") { _ in FloatType.signalingNaN },
        Item(name: "greatestFiniteMagnitude") { _ in FloatType.greatestFiniteMagnitude },
        Item(name: "leastNormalMagnitude") { _ in FloatType.leastNormalMagnitude },
        Item(name: "ulpOfOne") { _ in FloatType.ulpOfOne }
      ]),
      Section(title: "Stepping", items:
      [
        Item(name: ".nextUp") { $0.nextUp },
        Item(name: ".nextDown") { $0.nextDown },
        Item(name: ".ulp") { $0.ulp },
        Item(name: "add 0.1") { $0 + 0.1 },
        Item(name: "subtract 0.1") { $0 - 0.1 }
      ]),
      Section(title: "Functions", items:
      [
        Item(name: ".squareRoot()") { $0.squareRoot() },
        Item(name: "1/value") { 1/$0 }
      ])
    ]
  }
}
