//
//  StatisticModel.swift
//  SwiftfulCrypto
//
//  Created by Nguyen Thanh Trung on 15/08/2023.
//

import Foundation

struct StatisticModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(
        title: String,
        value: String,
        percentageChange: Double? = nil
    ) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}

extension StatisticModel {
    var isPositive: Bool {
        percentageChange.orZero >= 0
    }
}
