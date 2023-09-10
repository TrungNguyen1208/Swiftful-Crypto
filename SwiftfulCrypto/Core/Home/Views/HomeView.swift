//
//  HomeView.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 25/07/2023.
//

import SwiftUI

struct HomeView: View {
  
  @EnvironmentObject private var homeVM: HomeViewModel
  @State private var showPortfolio = false // animate right
  @State private var showPortfolioView = false // show sheet
  
  var body: some View {
    ZStack {
      Color.theme.background.ignoresSafeArea()
        .ignoresSafeArea()
        .sheet(isPresented: $showPortfolioView) {
          PortfolioView()
            .environmentObject(homeVM)
        }
      
      VStack {
        homeHeader
        HomeStatsView(showPortfolio: $showPortfolio)
        SearchBarView(searchText: $homeVM.searchText)
        
        columnTitles
        
        if !showPortfolio {
          allCoinsList
            .transition(.move(edge: .leading))
        } else {
          portfolioCoinsList
            .transition(.move(edge: .trailing))
        }
        
        Spacer(minLength: 0)
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      HomeView()
        .navigationBarHidden(true)
    }
    .environmentObject(dev.homeVM)
  }
}

private extension HomeView {
  var homeHeader: some View {
    HStack {
      CircleButtonView(iconImage: showPortfolio ? "plus" : "info")
        .animation(.none, value: showPortfolio)
        .onTapGesture {
          if showPortfolio {
            showPortfolioView.toggle()
          }
        }
        .background(
          CircleButtonAnimationView(animate: $showPortfolio)
        )
      Spacer()
      Text(showPortfolio ? "Portfolio" : "Live Prices")
        .font(.headline)
        .fontWeight(.heavy)
        .foregroundColor(Color.theme.accent)
        .animation(.none, value: showPortfolio)
      Spacer()
      CircleButtonView(iconImage: "chevron.right")
        .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
        .onTapGesture {
          withAnimation(.spring()) {
            showPortfolio.toggle()
          }
        }
    }
    .padding(.horizontal)
  }
  
  var columnTitles: some View {
    HStack {
      Text("Coin")
      Spacer()
      if showPortfolio {
        Text("Holdings")
      }
      Text("Price")
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
      
      Button {
        withAnimation(.linear(duration: 2)) {
          homeVM.reloadData()
        }
      } label: {
        Image(systemName: "goforward")
      }
      .rotationEffect(
        Angle(degrees: homeVM.isLoading ? 360 : 0), anchor: .center
      )
    }
    .font(.caption)
    .foregroundColor(Color.theme.secondaryText)
    .padding(.horizontal)
  }
  
  var allCoinsList: some View {
    List {
      ForEach(homeVM.allCoins) { coin in
        CoinRowView(coin: coin, showHoldingsColumn: false)
          .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
      }
    }
    .listStyle(PlainListStyle())
  }
  
  var portfolioCoinsList: some View {
    List {
      ForEach(homeVM.portfolioCoins) { coin in
        CoinRowView(coin: coin, showHoldingsColumn: true)
          .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
      }
    }
    .listStyle(PlainListStyle())
  }
}
