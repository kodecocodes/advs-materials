import SwiftUI

class Node<Element> {
  let next: Node<Element>?
  let value: Element

  init(_ value: Element, next: Node<Element>? = nil) {
    self.value = value
    self.next = next
  }
}

let firstNode = Node(1, next: Node(2))
let secondNode = firstNode.next

class LinkedList<Element> {
  let head: Node<Element>

  init?<C: RandomAccessCollection>(contentsOf array: C) where C.Element == Element {
    guard let lastElement = array.last else {
      return nil
    }

    var currentNode = Node(lastElement)
    for element in array.dropLast().reversed() {
      currentNode = Node(element, next: currentNode)
    }
    head = currentNode
  }
}

extension LinkedList: CustomStringConvertible {
  var description: String {
    var allItems = [head.value]
    var currentItem = head
    while let next = currentItem.next {
      allItems.append(next.value)
      currentItem = next
    }
    return allItems.description
  }
}

func getValue<T>(forKey key: String) -> T? {
  UserDefaults.standard.value(forKey: key) as? T
}

struct User {
  let name: String
}

UserDefaults.standard.setValue(User(name: "Marin"), forKey: "user")

let user: User? = getValue(forKey: "user")
print(user)
