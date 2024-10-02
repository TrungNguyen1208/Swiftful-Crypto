//
//  HomeViewModel.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 28/07/2023.
//

import Foundation
import SwiftUI
import Combine

enum HomeSortOption {
  case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
}

final class HomeViewModel: ObservableObject {
  
  @Published var statistics: [StatisticModel] = []
  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  
  @Published var isLoading: Bool = false
  @Published var searchText: String = ""
  @Published var sortOption: HomeSortOption = .holdings
  
  private let coinDataService = CoinDataService()
  private let marketDataService = MarketDataService()
  private let protfolioDataService = ProtfolioDataService()
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    addSubscribers()
  }
  
  func addSubscribers() {
    $searchText
      .combineLatest(coinDataService.$allCoins, $sortOption)
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterAndSortCoins)
      .sink { [weak self] coins in
        self?.allCoins = coins
      }
      .store(in: &cancellables)
    
    $allCoins
      .combineLatest(protfolioDataService.$savedEnities)
      .map(mapAllCoinsToPortfolioCoins)
      .sink { [weak self] coins in
        guard let self = self else { return }
        self.portfolioCoins = sortPorfolioCoinsIfNeeded(coins: coins)
      }
      .store(in: &cancellables)
    
    marketDataService.$marketData
      .combineLatest($portfolioCoins)
      .map(mapGlobalMarketData)
      .sink { [weak self] stats in
        self?.statistics = stats
        self?.isLoading = false
      }
      .store(in: &cancellables)
  }
  
  func updateProfilio(coin: CoinModel, amount: Double) {
    protfolioDataService.updateProtfolio(coin: coin, amount: amount)
  }
  
  func reloadData() {
    isLoading = true
    coinDataService.getCoins()
    marketDataService.getMarketData()
    HapticManager.notification(type: .success)
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
  
  func filterAndSortCoins(text: String, coins: [CoinModel], sort: HomeSortOption) -> [CoinModel] {
    var updatedCoins = filterCoins(text: text, coins: coins)
    sortCoins(sort: sort, coins: &updatedCoins)
    return updatedCoins
  }
  
  func sortCoins(sort: HomeSortOption, coins: inout [CoinModel]) {
    switch sort {
    case .rank, .holdings:
      coins.sort { $0.rank < $1.rank}
    case .rankReversed, .holdingsReversed:
      coins.sort { $0.rank > $1.rank}
    case .price:
      coins.sort { $0.currentPrice < $1.currentPrice}
    case .priceReversed:
      coins.sort { $0.currentPrice > $1.currentPrice}
    }
  }
  
  func sortPorfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
    switch sortOption {
    case .holdings:
      return coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
    case .holdingsReversed:
      return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
    default:
      return coins
    }
  }
  
  func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], protfolioEntities: [ProtfolioEntity]) -> [CoinModel] {
    allCoins.compactMap { coin -> CoinModel? in
      guard let entity = protfolioEntities.first(where: { $0.coinID == coin.id }) else {
        return nil
      }
      return coin.updateHoldings(amount: entity.amount)
    }
  }
  
  func mapGlobalMarketData(data: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
    var stats: [StatisticModel] = []
    guard let data = data else { return stats }
    
    let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
    let volume = StatisticModel(title: "24h Volumn", value: data.volume)
    let btcDominace = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
    
    let profileValue = portfolioCoins.map { $0.currentHoldingsValue }.reduce(0, +)
    let previousValue = portfolioCoins.map{ coin -> Double in
      let currentValue = coin.currentHoldingsValue
      let percentChange = coin.priceChangePercentage24H.orZero / 100
      return currentValue / (1 + percentChange)
    }.reduce(0, +)
    let percentageChange = ((profileValue - previousValue) / previousValue) * 100
    let profile = StatisticModel(title: "Protfolio Value", value: profileValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
    
    stats.append(contentsOf: [marketCap, volume, btcDominace, profile])
    return stats
  }
}
