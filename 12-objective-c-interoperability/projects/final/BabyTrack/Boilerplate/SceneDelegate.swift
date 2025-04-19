/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    self.window = (scene as? UIWindowScene).map(UIWindow.init)
    startNewApp()
  }

  private func startLegacyApp() {
    let navigation = UINavigationController(rootViewController: ViewController())
    navigation.navigationBar.prefersLargeTitles = true

    self.window?.rootViewController = navigation
    self.window?.makeKeyAndVisible()
  }

  private func startNewApp() {
    self.window?.rootViewController = UIHostingController(
      rootView: FeedView()
    )
    self.window?.makeKeyAndVisible()
  }
}
