/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

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
