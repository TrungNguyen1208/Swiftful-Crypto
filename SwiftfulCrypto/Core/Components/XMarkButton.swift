//
//  XMarkButton.swift
//  SwiftfulCrypto
//
//  Created by Trung Nguyen on 01/09/2023.
//

import SwiftUI

struct XMarkButton: View {
  
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    Button(action: {
      dismiss()
    }, label: {
      Image(systemName: "xmark")
        .font(.headline)
    })
  }
}

struct XMarkButton_Previews: PreviewProvider {
  static var previews: some View {
    XMarkButton()
  }
}
