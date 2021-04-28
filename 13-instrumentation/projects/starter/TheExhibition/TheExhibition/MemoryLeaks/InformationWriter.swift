/// Sample code from the book, Advanced Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/advanced-swift

import UIKit
import Combine

class InformationWriter {
  var writeOperation: (String) -> Void
  var cancellable: AnyCancellable?

  init(writer: WriterProtocol) {
    writeOperation = { info in
      writer.writeText(info)
    }
  }

  func doSomething() {
    fetchJoke { jokeText in
      self.writeOperation(jokeText)
    }
  }

  func fetchJoke(completion: @escaping (String) -> Void) {
    guard let url = URL(string: "https://icanhazdadjoke.com/") else {
      return
    }
    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "accept")
    writeOperation("Loading awesome joke, please hold!")
    cancellable = URLSession.shared
      .dataTaskPublisher(for: request)
      .tryMap { element in
        guard
          let httpResponse = element.response as? HTTPURLResponse,
          httpResponse.statusCode == 200
          else {
            self.writeOperation("Failed to get joke")
            throw URLError(.badServerResponse)
        }
        return element.data
      }
      .decode(type: Joke.self, decoder: JSONDecoder())
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { print("Received completion: \($0).") },
        receiveValue: { joke in
        completion(joke.joke)
        })
  }
}

struct Joke: Codable {
  let id: String
  let joke: String
}
