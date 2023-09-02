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
  
  @Published var statistics: [StatisticModel] = []
  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  
  @Published var searchText: String = ""
  
  private let coinDataService = CoinDataService()
  private let marketDataService = MarketDataService()
  private let protfolioDataService = ProtfolioDataService()
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    addSubscribers()
  }
  
  func addSubscribers() {
    $searchText
      .combineLatest(coinDataService.$allCoins)
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterCoins)
      .sink { [weak self] coins in
        self?.allCoins = coins
      }
      .store(in: &cancellables)
    
    marketDataService.$marketData
      .map(mapGlobalMarketData)
      .sink { [weak self] stats in
        self?.statistics = stats
      }
      .store(in: &cancellables)
    
    $allCoins
      .combineLatest(protfolioDataService.$savedEnities)
      .map { coinModels, protfolioEntities -> [CoinModel] in
        coinModels.compactMap { coin -> CoinModel? in
          guard let entity = protfolioEntities.first(where: { $0.coinID == coin.id }) else {
            return nil
          }
          return coin.updateHoldings(amount: entity.amount)
        }
      }
      .sink { [weak self] coins in
        self?.portfolioCoins = coins
      }
      .store(in: &cancellables)
  }
  
  func updateProfilio(coin: CoinModel, amount: Double) {
    protfolioDataService.updateProtfolio(coin: coin, amount: amount)
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
  
  func mapGlobalMarketData(data: MarketDataModel?) -> [StatisticModel] {
    var stats: [StatisticModel] = []
    guard let data = data else { return stats }
    
    let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
    let volume = StatisticModel(title: "24h Volumn", value: data.volume)
    let btcDominace = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
    let profile = StatisticModel(title: "Protfolio Value", value: "$0.00", percentageChange: 0)
    
    stats.append(contentsOf: [marketCap, volume, btcDominace, profile])
    return stats
  }
}
