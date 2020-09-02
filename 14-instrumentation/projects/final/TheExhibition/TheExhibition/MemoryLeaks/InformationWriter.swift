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

import Foundation
import UIKit
import Combine

class InformationWriter {
  var writeOperation: (String) -> Void
  var cancellable: AnyCancellable?
  init(writer: WriterProtocol) {
    writeOperation = { [weak writer] info in
      writer?.writeText("\(info)")
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
      .tryMap { element -> Data in
        guard let httpResponse = element.response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
          self.writeOperation("Failed to get joke")
          throw URLError(.badServerResponse)
        }
        return element.data
      }
      .decode(type: Joke.self, decoder: JSONDecoder())
      .sink(receiveCompletion: { print("Received completion: \($0).") },
            receiveValue: { joke in
              DispatchQueue.main.async {
                completion(joke.joke)
              }
            })
  }
}

struct Joke: Codable {
  let id: String
  let joke: String
}
