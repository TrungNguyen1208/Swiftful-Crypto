import SwiftUI

struct DetailView: View {
  
  let coin: CoinModel
  
  init(coin: CoinModel) {
    self.coin = coin
  }
  
  var body: some View {
    Text(coin.name)
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(coin: dev.coin)
  }
}
