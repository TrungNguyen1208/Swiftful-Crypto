//
//  PortfolioView.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 01/09/2023.
//

import SwiftUI

struct PortfolioView: View {
  
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject private var vm: HomeViewModel
  
  @State private var selectedCoin: CoinModel? = nil
  @State private var quantilyText: String = ""
  @State private var showCheckmark: Bool = false
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 0.0) {
          SearchBarView(searchText: $vm.searchText)
          coinLogoList
          portfolioInputSection
        }
      }
      .navigationTitle("Edit Portfolio")
      .toolbar(content: {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: {
            dismiss()
          }, label: {
            Image(systemName: "xmark").font(.headline)
          })
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          trailingNavBarButton
        }
      })
      .onChange(of: vm.searchText) { newValue in
        if newValue.isEmpty {
          removeSelectedCoin()
        }
      }
    }
  }
}

struct PortfolioView_Previews: PreviewProvider {
  static var previews: some View {
    PortfolioView()
      .environmentObject(dev.homeVM)
  }
}

private extension PortfolioView {
  var coinLogoList: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 10) {
        ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
          CoinLogoView(coin: coin)
            .frame(width: 75)
            .padding(4)
            .onTapGesture {
              withAnimation(.easeIn) {
                updateSelectedCoin(coin: coin)
              }
            }
            .background(
              RoundedRectangle(cornerRadius: 10)
                .stroke(
                  selectedCoin == coin ? Color.theme.green : Color.clear,
                  lineWidth: 1
                )
            )
        }
      }
      .frame(height: 120)
      .padding(.leading)
    }
  }
  
  var portfolioInputSection: some View {
    Group {
      if let coin = selectedCoin {
        VStack(spacing: 20) {
          HStack {
            let text = coin.symbol.uppercased()
            let value = coin.currentPrice.asCurrencyWith6Decimals()
            Text("Current price of \(text):")
            Spacer()
            Text(value)
          }
          
          Divider()
          
          HStack {
            Text("Amount holding:")
            Spacer()
            TextField("Ex: 1.4", text: $quantilyText)
              .multilineTextAlignment(.trailing)
              .keyboardType(.decimalPad)
          }
          
          Divider()
          
          HStack {
            Text("Current value:")
            Spacer()
            Text(getCurrentValue(coin: coin).asCurrencyWith2Decimals())
          }
        }
        .animation(.none, value: selectedCoin)
        .padding()
        .font(.headline)
      } else {
        EmptyView()
      }
    }
  }
  
  var trailingNavBarButton: some View {
    HStack(spacing: 10) {
      Image(systemName: "checkmark")
        .opacity(showCheckmark ? 1 : 0)
      
      Button {
        saveButtonPressed()
      } label: {
        Text("Save".uppercased())
      }
      .opacity(didChangeCoinQuantily ? 1 : 0)
    }
    .font(.headline)
  }
  
  var didChangeCoinQuantily: Bool {
    selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantilyText)
  }
  
  func getCurrentValue(coin: CoinModel) -> Double {
    if let quantily = Double(quantilyText) {
      return quantily * coin.currentPrice
    }
    return 0
  }
  
  func saveButtonPressed() {
    guard let coin = selectedCoin, let quantily = Double(quantilyText) else { return }
    
    vm.updateProfilio(coin: coin, amount: quantily)
    
    withAnimation(.easeIn) {
      showCheckmark = true
      removeSelectedCoin()
    }
    
    UIApplication.shared.endEditing()
    
    // Hide checkmark
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      withAnimation(.easeOut) {
        showCheckmark = false
      }
    }
  }
  
  func removeSelectedCoin() {
    selectedCoin = nil
    vm.searchText = ""
  }
  
  func updateSelectedCoin(coin: CoinModel) {
    selectedCoin = coin
    if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }) {
      let amount = (portfolioCoin.currentHoldings).orZero
      quantilyText = "\(amount)"
    } else {
      quantilyText = ""
    }
  }
}
