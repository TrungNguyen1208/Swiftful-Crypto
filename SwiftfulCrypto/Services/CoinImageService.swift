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
  private let fileManager = LocalFileManager.instance
  private let folderName = "coin_images"
  private let imageImage: String
  
  init(coin: CoinModel) {
    self.coin = coin
    imageImage = coin.id
    getCoinImage()
  }
  
  private func getCoinImage() {
    if let savedImage = fileManager.getImage(imageName: imageImage, folderName: folderName) {
      image = savedImage
    } else {
      downloadCoinImages()
    }
  }
  
  private func downloadCoinImages() {
    guard let url = URL(string: coin.image) else {
      return
    }
    
    imageSubcription = NetworkingManager.download(url: url)
      .tryMap({ data in
        return UIImage(data: data)
      })
      .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] downloadImage in
        guard let self = self, let downloadImage = downloadImage else { return }
        self.image = downloadImage
        self.imageSubcription?.cancel()
        self.fileManager.saveImage(image: downloadImage, imageName: self.imageImage, folderName: self.folderName)
      })
  }
}
