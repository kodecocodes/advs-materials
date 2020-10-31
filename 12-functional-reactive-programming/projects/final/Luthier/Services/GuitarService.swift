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
import Combine

final class GuitarService {
  func order(_ guitar: Guitar) -> AnyPublisher<Void, Never> {
    Deferred {
      Just(()).delay(for: .init(.random(in: 1.0...2.0)), scheduler: RunLoop.main)
    }
    .eraseToAnyPublisher()
  }

  func getShipmentOptions() -> AnyPublisher<[ShippingOption], Never> {
    let mockOptions = [("Pickup", "As soon as ready", 0),
                       ("Ground", "2-6 weeks", 100),
                       ("Express", "1 week", 250)]
      .map(ShippingOption.init).self

    return Deferred {
      Just(mockOptions)
        .delay(for: .init(.random(in: 0.3...1)), scheduler: RunLoop.main)
    }
    .eraseToAnyPublisher()
  }

  func getBuildTimeEstimate(for guitar: Guitar) -> AnyPublisher<String, Never> {
    Deferred {
      Just("About \([3, 6, 9, 12, 14, 18].randomElement() ?? "") months")
        .delay(for: .init(.random(in: 0.7...1.5)), scheduler: RunLoop.main)
    }
    .eraseToAnyPublisher()
  }

  func ensureAvailability(for guitar: Guitar) -> AnyPublisher<Bool, Never> {
    Deferred {
      // 20% chance for not-availables
      Just([true, true, true, true, false].randomElement() ?? false)
        .delay(for: .init(.random(in: 1...2.0)), scheduler: RunLoop.main)
    }
    .eraseToAnyPublisher()
  }
}
