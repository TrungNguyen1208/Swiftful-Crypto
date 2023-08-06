//
//  CoinImageViewModel.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 06/08/2023.
//

import Foundation
import SwiftUI
import Combine

final class CoinImageViewModel: ObservableObject {
  @Published var image: UIImage? = nil
  @Published var isLoading: Bool = false
  
  private let coin: CoinModel
  private let dataService: CoinImageService
  private var cancellables = Set<AnyCancellable>()
  
  init(coin: CoinModel) {
    self.coin = coin
    dataService = CoinImageService(coin: coin)
    addSubscribers()
    isLoading = true
  }
  
  private func addSubscribers() {
    dataService.$image
      .sink { [weak self] _ in
        self?.isLoading = false
      } receiveValue: { [weak self] returnImage in
        self?.image = returnImage
      }
      .store(in: &cancellables)
  }
}
