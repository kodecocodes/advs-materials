/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

// Previous attempts

//func ifelse(condition: Bool, valueIfTrue: Int, valueIfFalse: Int) -> Int {
//  if condition {
//    return valueIfTrue
//  } else {
//    return valueIfFalse
//  }
//}
//let value = ifelse(condition: Bool.random(), valueIfTrue: 100, valueIfFalse: 0)


//func ifelse(_ condition: Bool, _ `valueIfTrue`: Int, _ valueIfFalse: Int) -> Int {
//  if condition {
//    return valueIfTrue
//  } else {
//    return valueIfFalse
//  }
//}

//func ifelse(_ condition: Bool,
//            _ valueTrue: Int,
//            _ valueFalse: Int) -> Int {
//  condition ? valueTrue : valueFalse
//}
//func ifelse(_ condition: Bool,
//            _ valueTrue: String,
//            _ valueFalse: String) -> String {
//  condition ? valueTrue : valueFalse
//}
//func ifelse(_ condition: Bool,
//            _ valueTrue: Double,
//            _ valueFalse: Double) -> Double {
//  condition ? valueTrue : valueFalse
//}
//func ifelse(_ condition: Bool,
//            _ valueTrue: [Int],
//            _ valueFalse: [Int]) -> [Int] {
//  condition ? valueTrue : valueFalse
//}

//func ifelse(_ condition: Bool,
//            _ valueTrue: Any,
//            _ valueFalse: Any) -> Any {
//  condition ? valueTrue : valueFalse
//}

//func ifelse<V>(_ condition: Bool,
//               _ valueTrue: @autoclosure () -> V,
//               _ valueFalse: @autoclosure () -> V) -> V {
//  condition ? valueTrue() : valueFalse()
//}
//func ifelseThrows<V>(_ condition: Bool,
//               _ valueTrue: @autoclosure () throws -> V,
//               _ valueFalse: @autoclosure () throws -> V) throws -> V {
//  condition ? try valueTrue() : try valueFalse()
//}

// Final version

@inlinable
func ifelse<V>(_ condition: Bool,
               _ valueTrue: @autoclosure () throws -> V,
               _ valueFalse: @autoclosure () throws -> V) rethrows -> V {
  condition ? try valueTrue() : try valueFalse()
}

// Usage examples:

func expensiveValue1() -> Int {
  print("side-effect-1")
  return 2
}

func expensiveValue2() -> Int {
  print("side-effect-2")
  return 1729
}

func expensiveFailingValue1() throws -> Int {
  print("side-effect-1")
  return 2
}

func expensiveFailingValue2() throws -> Int {
  print("side-effect-2")
  return 1729
}

let value = ifelse(.random(), 100, 0 )

let taxicab = ifelse(.random(),
                     expensiveValue1(),
                     expensiveValue2())

let taxicab2 = try ifelse(.random(),
                          try expensiveFailingValue1(),
                          try expensiveFailingValue2())
let taxicab3 = try ifelse(.random(),
                          expensiveValue1(),
                          try expensiveFailingValue2())
let taxicab4 = try ifelse(.random(),
                          try expensiveFailingValue1(),
                          expensiveValue2())
