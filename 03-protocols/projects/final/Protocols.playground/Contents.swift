import UIKit
import SwiftUI

enum Language {
  case english, german, croatian
}

protocol Localizable {
  static var supportedLanguages: [Language] { get }
}

protocol ImmutableLocalizable: Localizable {
  func changed(to language: Language) -> Self
}

protocol MutableLocalizable: Localizable {
  mutating func change(to language: Language)
}

struct Text: ImmutableLocalizable {
  static let supportedLanguages: [Language] = [.english, .croatian]

  var content = "Help"

  func changed(to language: Language) -> Self {
    let newContent: String
    switch language {
    case .english: newContent = "Help"
    case .german: newContent = "Hilfe"
    case .croatian: newContent = "Pomoć"
    }
    return Text(content: newContent)
  }
}

// Conforming to a protocol with an extension
extension UILabel: MutableLocalizable {
  static let supportedLanguages: [Language] = [.english, .german]

  func change(to language: Language) {
    switch language {
    case .english: text = "Help"
    case .german: text = "Hilfe"
    case .croatian: text = "Pomoć"
    }
  }
}

// Default implementation with extensions
extension Localizable {
  static var supportedLanguages: [Language] {
    return [.english]
  }
}

struct Image: Localizable {
  // no need to add `supportedLanguages` here
}

// can only be implemented by classes
protocol UIKitLocalizable: AnyObject, Localizable {
  // no need for `mutating` since classes use reference semantics
  func change(to language: Language)
}

protocol LocalizableViewController where Self: UIViewController {
  func showLocalizedAlert(text: String)
}

func localize(_ localizables: inout [MutableLocalizable], to language: Language) {
  for var localizable in localizables {
    localizable.change(to: language)
  }
}

func localizeViews(_ views: [UIView & MutableLocalizable], to language: Language) {
  for var view in views {
    view.change(to: language)
  }
}

protocol Greetable {
  func greet() -> String
}

extension Greetable {
  func greet() -> String {
    return "Hello"
  }

  func leave() -> String {
    return "Goodbye"
  }
}

struct GermanGreeter: Greetable {
  func greet() -> String {
    return "Hallo"
  }

  func leave() -> String {
    return "Tschüss"
  }
}

let greeter: Greetable = GermanGreeter()
print(greeter.greet())

print(greeter.leave())

extension UITableViewDelegate where Self: UIViewController {
  func showAlertForSelectedCell(at index: IndexPath) {
    // ...
  }
}

extension Array where Element: Greetable {
  var allGreetings: String {
    self.map { $0.greet() }.joined()
  }
}

extension Array: Localizable where Element: Localizable {
  static var supportedLanguages: [Language] {
    Element.supportedLanguages
  }
}

struct User: Hashable {
  let name: String
  let email: String
  let id: UUID
}
