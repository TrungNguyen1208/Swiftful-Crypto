//
//  CoinRowView.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 27/07/2023.
//

import SwiftUI

struct CoinRowView: View {
  
  let coin: CoinModel
  let showHoldingsColumn: Bool
  
  var body: some View {
    HStack(spacing: 0.0) {
      leftColumn
      
      Spacer()
      
      if showHoldingsColumn {
        centerColumn
      }
      
      trailingColumn
    }
    .font(.subheadline)
  }
}

struct CoinRowView_Previews: PreviewProvider {
  static var previews: some View {
    CoinRowView(coin: dev.coin, showHoldingsColumn: true)
      .previewLayout(.sizeThatFits)
  }
}

private extension CoinRowView {
  var leftColumn: some View {
    HStack(spacing: 0.0) {
      Text("\(coin.rank)")
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .frame(minWidth: 30)
      
      Circle()
        .frame(width: 30, height: 30)
      
      Text(coin.symbol.uppercased())
        .font(.headline)
        .padding(.leading, 6)
        .foregroundColor(Color.theme.accent)
    }
  }
  
  var centerColumn: some View {
    VStack(alignment: .trailing) {
      Text(coin.currentHoldingsValue.asCurrencyWith6Decimals())
      Text(coin.currentHoldings.orZero.asNumberString())
    }
  }
  
  var trailingColumn: some View {
    VStack(alignment: .trailing) {
      Text(coin.currentPrice.asCurrencyWith6Decimals())
        .bold()
        .foregroundColor(Color.theme.accent)
      Text(coin.priceChangePercentage24H.orZero.asNumberString())
        .foregroundColor(
          coin.priceChangePercentage24H.orZero >= 0 ? Color.theme.green : Color.theme.red
        )
    }
    .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
  }
}
