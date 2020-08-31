//: [Previous](@previous)

import Foundation

extension String {
    func hasCharacter(in characterSet: CharacterSet) -> Bool {
        characterSet.isDisjoint(with: CharacterSet(charactersIn: self)) == false
    }
}

func generateDiacriticText() {

    var foldedParagraphs: [String]!
    var diacriticParagraphs: [String]!
    var foldedDiacriticParagraphs: [String]!
    let diacriticSearchTerm = "M̲a͌ur̉ȉs et̕ el͙em̗en͂t̕um̗ a͌r̉c͝u"

    let characters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    let paragraphs = ["Hello World!"]//String(data: data, encoding: .utf8)!.components(separatedBy: .newlines)

    let diacriticCharacters: [Character] = characters
        .map { c in
            guard Bool.random() else { return c }
            let i = (0x0300...0x036F).randomElement()!
            let diacritic = UnicodeScalar(i)
            var string = String(c)
            string.append(String(diacritic!))
            return Character(string)
        }

    diacriticParagraphs = paragraphs
        .reduce([String]()) { result, next in
            let words: [Character] = next
                .map { c in
                    guard let i = characters.firstIndex(of: c) else { return c }
                    return diacriticCharacters[i]
                }

            return result + [String(words)]
        }

    let textWithDiacritics = diacriticParagraphs.joined(separator: "\n")
    print("textWithDiacritics = \(textWithDiacritics)")

    let diacriticCharacterSet = CharacterSet(charactersIn: diacriticCharacters.map(String.init).joined())

    let searchTerm = diacriticParagraphs
        .first { $0.hasCharacter(in: diacriticCharacterSet) }!
        .components(separatedBy: .whitespacesAndNewlines)
        .filter { $0.hasCharacter(in: diacriticCharacterSet) }
        .randomElement()!

    print("searchTerm = \(searchTerm)")
}

generateDiacriticText()
//He̠l̛l̛o Worl̛d̏!
//Hel͘l͘ò W͛òr̠l͘d͐!
//H̾e͜llo Wor͂ld!
//H̾e͜l͘l͘ò W͛òr̠l͘d͐!
