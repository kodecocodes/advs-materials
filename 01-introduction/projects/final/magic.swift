class Magic {
  func number() -> Int { return 0 }
}

final class SpecialMagic: Magic {
  override func number() -> Int { return 42 }
}

public var number: Int = -1

func magicTest() {
  let specialMagic = SpecialMagic()
  let magic: Magic = specialMagic
  number = magic.number()
}
