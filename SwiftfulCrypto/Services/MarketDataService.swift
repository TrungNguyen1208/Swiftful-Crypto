//
//  MarketDataService.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 26/08/2023.
//

import Foundation
import Combine

final class MarketDataService {
  @Published var marketData: MarketDataModel? = nil
  
  var marketDataSubcription: AnyCancellable?
  
  init() {
    getMarketData()
  }
  
  func getMarketData() {
    guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {
      return
    }
    
    marketDataSubcription = NetworkingManager.download(url: url)
      .decode(type: GlobalData.self, decoder: JSONDecoder())
      .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] globalData in
        self?.marketData = globalData.data
        self?.marketDataSubcription?.cancel()
      })
  }
}
