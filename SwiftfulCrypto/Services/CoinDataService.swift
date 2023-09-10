//
//  CoinDataService.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 28/07/2023.
//

import Foundation
import Combine

final class CoinDataService {
  @Published var allCoins: [CoinModel] = []
  
  var coinSubcription: AnyCancellable?
  
  init() {
    getCoins()
  }
  
  func getCoins() {
    guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en") else {
      return
    }
    
    coinSubcription = NetworkingManager.download(url: url)
      .decode(type: [CoinModel].self, decoder: JSONDecoder())
      .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] coins in
        self?.allCoins = coins
        self?.coinSubcription?.cancel()
      })
  }
}
