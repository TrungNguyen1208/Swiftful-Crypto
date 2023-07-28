//
//  HomeViewModel.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 28/07/2023.
//

import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
  
  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  
  init() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
      self?.allCoins.append(DeveloperPreview.instance.coin)
      self?.portfolioCoins.append(DeveloperPreview.instance.coin)
    }
  }
}
