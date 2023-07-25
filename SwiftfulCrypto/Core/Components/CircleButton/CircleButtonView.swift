//
//  CircleButtonView.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 25/07/2023.
//

import SwiftUI

struct CircleButtonView: View {
  
  let iconImage: String
  
  var body: some View {
    Image(systemName: iconImage)
      .font(.headline)
      .foregroundColor(Color.theme.accent)
      .frame(width: 50, height: 50)
      .background(
        Circle()
          .foregroundColor(Color.theme.background)
      )
      .shadow(
        color: Color.theme.accent.opacity(0.25),
        radius: 10, x: 0, y: 0
      )
      .padding()
  }
}

struct CircleButtonView_Previews: PreviewProvider {
  static var previews: some View {
    CircleButtonView(iconImage: "heart.fill")
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
