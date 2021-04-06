final class Printer {
  var value: Int
  init(value: Int) { self.value = value }
  func print() { Swift.print(value) }
}

func printTest() {
  var printer: Printer
  if .random() {
    printer = Printer(value: 1)
  }
  else {
    printer = Printer(value: 2)
  }
  printer.print()
}

printTest()
