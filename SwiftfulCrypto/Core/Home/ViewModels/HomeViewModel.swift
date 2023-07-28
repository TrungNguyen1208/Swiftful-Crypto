//
//  HomeViewModel.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 28/07/2023.
//

import Foundation
import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
  
  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  
  private let dataService = CoinDataService()
  private var cancellables = Set<AnyCancellable>()
  
  
  init() {
    addSubscribers()
  }
  
  func addSubscribers() {
    dataService.$allCoins.sink { [weak self] coins in
      self?.allCoins = coins
    }
    .store(in: &cancellables)
  }
}
