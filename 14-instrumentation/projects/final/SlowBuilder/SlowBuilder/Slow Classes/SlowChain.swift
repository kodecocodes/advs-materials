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

struct SlowStruct {
  var name: String = ""
  var phone: String = ""
  var email: String = ""
  var country: String = ""
  var city: String = ""
  var address: String = ""
  var job: String = ""

  func withName(_ value: String) -> SlowStruct {
    var copy = self
    copy.name = value
    return copy
  }

  func withPhone(_ value: String) -> SlowStruct {
    var copy = self
    copy.phone = value
    return copy
  }

  func withEmail(_ value: String) -> SlowStruct {
    var copy = self
    copy.email = value
    return copy
  }

  func withCountry(_ value: String) -> SlowStruct {
    var copy = self
    copy.country = value
    return copy
  }

  func withCity(_ value: String) -> SlowStruct {
    var copy = self
    copy.city = value
    return copy
  }

  func withAddress(_ value: String) -> SlowStruct {
    var copy = self
    copy.address = value
    return copy
  }

  func withJob(_ value: String) -> SlowStruct {
    var copy = self
    copy.job = value
    return copy
  }

  static func getSlowStruct() -> SlowStruct {
    SlowStruct()
      .withName("SomeName")
      .withPhone("0123456789")
      .withEmail("email@somewhere.com")
      .withCountry("Earth-Country")
      .withCity("Earth-Country-City")
      .withAddress("A place on earth, beside that shop")
      .withJob("Super-Duper iOS Developer")
  }
}
