//
//  SwiftfulCryptoApp.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 21/07/2023.
//

import SwiftUI

@main
struct SwiftfulCryptoApp: App {
  
  @StateObject private var homeVM = HomeViewModel()
  
  init() {
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
  }
  
  var body: some Scene {
    WindowGroup {
      NavigationView {
        HomeView()
          .navigationBarHidden(true)
      }
      .environmentObject(homeVM)
    }
  }
}
