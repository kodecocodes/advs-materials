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

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationView {
      List {
        Section(header: Text("A: Memory")) {
          NavigationLink(destination: Text("Link")) {
            Text("A-1: Optimize Usage").padding()
          }
          NavigationLink(destination: Text("Link")) {
            Text("A-2: Leaks").padding()
          }
        }
        Section(header: Text("B: Performace")) {
          NavigationLink(destination: Text("Link")) {
            Text("B-1: Time Profiler").padding()
          }
          NavigationLink(destination: Text("Link")) {
            Text("B-2: Collection Scrolling").padding()
          }
        }
        Section(header: Text("C: CoreData")) {
          NavigationLink(destination: Text("Link")) {
            Text("C-1: CoreData Optimization").padding()
          }
        }
        Section(header: Text("D: Static Analyzer")) {
          NavigationLink(destination: Text("Link")) {
            Text("D-1: ").padding()
          }
        }
      }.navigationTitle("The Exhibition")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
