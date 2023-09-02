//
//  ProtfolioDataService.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 02/09/2023.
//

import Foundation
import CoreData

final class ProtfolioDataService {
  
  private let container: NSPersistentContainer
  private let containerName: String = "ProtfolioContainer"
  private let enityName: String = "ProtfolioEntity"
  
  @Published var savedEnities: [ProtfolioEntity] = []
  
  init() {
    container = NSPersistentContainer(name: containerName)
    container.loadPersistentStores { [weak self] _, error in
      if let error = error {
        print("Error loading Core Data! \(error)")
      } else {
        self?.getProtfolio()
      }
    }
  }
  
  func updateProtfolio(coin: CoinModel, amount: Double) {
    if let entity = savedEnities.first(where: { $0.coinID == coin.id }) {
      if amount > 0 {
        update(enity: entity, amount: amount)
      } else {
        delete(enity: entity)
      }
    } else {
      add(coin: coin, amount: amount)
    }
  }
}

private extension ProtfolioDataService {
  func getProtfolio() {
    let request = NSFetchRequest<ProtfolioEntity>(entityName: enityName)
    do {
      savedEnities = try container.viewContext.fetch(request)
    } catch let error {
      print("Error fetching enity. \(error)")
    }
  }
  
  func add(coin: CoinModel, amount: Double) {
    let enity = ProtfolioEntity(context: container.viewContext)
    enity.coinID = coin.id
    enity.amount = amount
    applyChanges()
  }
  
  func update(enity: ProtfolioEntity, amount: Double) {
    enity.amount = amount
    applyChanges()
  }
  
  func delete(enity: ProtfolioEntity) {
    container.viewContext.delete(enity)
    applyChanges()
  }
  
  func save() {
    do {
      try container.viewContext.save()
    } catch let error {
      print("Error saving to Core Data. \(error)")
    }
  }
  
  func applyChanges() {
    save()
    getProtfolio()
  }
}
