//
//  CoinImageService.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 06/08/2023.
//

import Foundation
import SwiftUI
import Combine

final class CoinImageService {
  
  @Published var image: UIImage? = nil
  
  private var imageSubcription: AnyCancellable?
  private let coin: CoinModel
  
  init(coin: CoinModel) {
    self.coin = coin
    getCoinImages(urlString: coin.image)
  }
  
  private func getCoinImages(urlString: String) {
    guard let url = URL(string: urlString) else {
      return
    }
    
    imageSubcription = NetworkingManager.download(url: url)
      .tryMap({ data in
        return UIImage(data: data)
      })
      .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnImage in
        self?.image = returnImage
        self?.imageSubcription?.cancel()
      })
  }
}
