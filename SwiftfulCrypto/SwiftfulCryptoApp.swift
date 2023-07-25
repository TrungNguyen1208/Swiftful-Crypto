//
//  SwiftfulCryptoApp.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 21/07/2023.
//

import SwiftUI

@main
struct SwiftfulCryptoApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        HomeView()
          .navigationBarHidden(true)
      }
    }
  }
}
