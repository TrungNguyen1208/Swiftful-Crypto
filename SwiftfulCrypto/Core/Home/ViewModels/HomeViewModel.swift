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
  
  @Published var statistics: [StatisticModel] = [
    StatisticModel(title: "Market Cap", value: "$12.58n", percentageChange: 1),
    StatisticModel(title: "Market Cap", value: "$12.58n"),
    StatisticModel(title: "Market Cap", value: "$12.58n"),
    StatisticModel(title: "Market Cap", value: "$12.58n", percentageChange: -7)
  ]
  
  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  
  @Published var searchText: String = ""
  
  private let dataService = CoinDataService()
  private var cancellables = Set<AnyCancellable>()
  
  
  init() {
    addSubscribers()
  }
  
  func addSubscribers() {
    $searchText
      .combineLatest(dataService.$allCoins)
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterCoins)
      .sink { [weak self] coins in
        self?.allCoins = coins
      }
      .store(in: &cancellables)
  }
}

private extension HomeViewModel {
  
  func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
    guard text.isNotEmpty else {
      return coins
    }
    let lowercasedText = text.lowercased()
    return coins.filter {
      $0.name.lowercased().contains(lowercasedText) ||
      $0.symbol.lowercased().contains(lowercasedText) ||
      $0.id.lowercased().contains(lowercasedText)
    }
  }
  
}
