//: [Previous](@previous)

import Foundation

struct Customer: Encodable {
  var name: String
  var accessKey: String
  var atmCode: String
  var street: String
  var city: String
  var zip: Int
  var homePhone: String
  var cellularPhone: String
  var email: String
  let website: String
  let addedOn = Date()
}

let customer = Customer(
  name: "Shai Mishali",
  accessKey: "S|_|p3rs3cr37",
  atmCode: "1132",
  street: "3828 Piermont Drive",
  city: "Albuquerque",
  zip: 87112,
  homePhone: "+1 212-741-4695",
  cellularPhone: "+972 542-288-482",
  email: "freak4pc@gmail.com",
  website: "http://github.com/freak4pc"
)

do {
  let encoder = JSONEncoder()

  let data = try encoder.encode(customer)
  print(String(data: data, encoding: .utf8) ?? "")
} catch {
  print("Something went wrong: \(error)")
}

//: [Next](@next)

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
