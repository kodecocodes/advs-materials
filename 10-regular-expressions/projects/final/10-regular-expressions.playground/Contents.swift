let testingString1 = "abcdef ABCDEF 12345 abc123 ABC 123 123ABC 123abc abcABC"
let lettersAndNumbers = /[a-z]+[0-9]+/

for match in testingString1.matches(of: lettersAndNumbers) {
  print(String(match.output))
}

print("------------------")

let possibleLettersAndPossibleNumbers = /[a-z]*[0-9]*/

for match in testingString1.matches(of: possibleLettersAndPossibleNumbers) {
  print(String(match.output))
}

print("------------------")

let emptyString = ""
let count =  emptyString.matches(of: possibleLettersAndPossibleNumbers).count

let fixedPossibleLettersAndPossibleNumbers = /[a-z]+[0-9]*|[a-z]*[0-9]+/

for match in testingString1.matches(of: fixedPossibleLettersAndPossibleNumbers) {
  print(String(match.output))
}

print("------------------")

let fixedWithBoundaries = /\b[a-z]+[0-9]*\b|\b[a-z]*[0-9]+\b/

for match in testingString1.matches(of: fixedWithBoundaries) {
  print(String(match.output))
}

print("------------------ LookAhead")

let testingString2 = "a1b2c3d4ee55fff666"

let lookAhead = /\d(?=[a-z])/

for match in testingString2.matches(of: lookAhead) {
  print(String(match.output))
}

print("------------------ NegativeLookAhead")

let negativeLookAhead = /\d(?![a-z])/

for match in testingString2.matches(of: negativeLookAhead) {
  print(String(match.output))
}

print("------ Section 2 --------")

import RegexBuilder

let newlettersAndNumbers = Regex {
  OneOrMore {
    "a"..."z"
  }
  OneOrMore {
    CharacterClass.digit
  }
}

for match in testingString1.matches(of: newlettersAndNumbers) {
  print(String(match.output))
}

print("------------------")

let newFixedRegex = Regex {
  Anchor.wordBoundary
  ChoiceOf {
    Regex {
      OneOrMore {
        "a"..."z"
      }
      ZeroOrMore {
        CharacterClass.digit
      }
    }
    Regex {
      ZeroOrMore {
        "a"..."z"
      }
      OneOrMore {
        CharacterClass.digit
      }
    }
  }
  Anchor.wordBoundary
}

for match in testingString1.matches(of: newFixedRegex) {
  print(String(match.output))
}

print("------ Section 3 --------")

let expressionWithCapture = /[a-z]+(\d+)[a-z]+/
let regexWithCapture = Regex {
  OneOrMore {
    "a"..."z"
  }
  Capture {
    OneOrMore {
      CharacterClass.digit
    }
  }
  OneOrMore {
    "a"..."z"
  }
}

let testingString4 = "welc0me to chap7er 10 in exp3r7 sw1ft. " +
  "th1s chap7er c0vers regu1ar express1ons and regexbu1lder"

for match in testingString4.matches(of: regexWithCapture) {
  print(match.output)
}

print("------------------")

let repetition = "123abc456def789ghi"

let repeatedCaptures = Regex {
  OneOrMore {
    Capture {
      OneOrMore {
        CharacterClass.digit
      }
    }
    OneOrMore {
      "a"..."z"
    }
  }
}

for match in repetition.matches(of: repeatedCaptures) {
  print(match.output)
}

print("------------------")

let expressionWithNamedCapture = /[a-z]+(?<digits>\d+)[a-z]+/

for match in testingString4.matches(of: expressionWithNamedCapture) {
  print(match.output.digits)
}

print("------------------")

let digitsReference = Reference(Substring.self)
let regexWithNamedCapture = Regex {
  OneOrMore {
    "a"..."z"
  }
    Capture(as: digitsReference) {
    OneOrMore {
      CharacterClass.digit
    }
  }
  OneOrMore {
    "a"..."z"
  }
}

for match in testingString4.matches(of: regexWithNamedCapture) {
  print(match[digitsReference])
}

print("------------------")

let transformedDigitsReference = Reference(Int.self)
let regexWithNamedTransformedCapture = Regex {
  OneOrMore {
    "a"..."z"
  }
    TryCapture(as: transformedDigitsReference) {
        OneOrMore {
            CharacterClass.digit
        }
    } transform: {
        Int(String($0)) ?? -1
    }
  OneOrMore {
    "a"..."z"
  }
}

var sum = 0
for match in testingString4.matches(of: regexWithNamedTransformedCapture) {
  sum += match[transformedDigitsReference]
}
print(sum)

print("------------------")

let fieldData = "BookName: Expert Swift"

let wholeMatchRegex = Regex {
  Capture {
    OneOrMore { CharacterClass.word }
  }
  /\:\s/
  Capture {
    OneOrMore { CharacterClass.any }
  }
}

if let match = fieldData.wholeMatch(of: wholeMatchRegex) {
  print("FieldName  = " + match.output.1)
  print("FieldValue = " + match.output.2)
}

print("------------------")

let invalidFieldData = "The Book name is Expert Swift"

if let match = invalidFieldData.wholeMatch(of: wholeMatchRegex) {
  print("FieldName  = " + match.output.1)
  print("FieldValue = " + match.output.2)
} else {
  print("It doesn't match")
}
