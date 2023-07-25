//
//  HomeView.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 25/07/2023.
//

import SwiftUI

struct HomeView: View {
  
  @State private var showPortfolio: Bool = false
  
  var body: some View {
    ZStack {
      Color.theme.background.ignoresSafeArea()
      
      VStack {
        homeHeader
        
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
  }
}

private extension HomeView {
  var homeHeader: some View {
    HStack {
      CircleButtonView(iconImage: showPortfolio ? "plus" : "info")
        .animation(.none, value: showPortfolio)
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
}
