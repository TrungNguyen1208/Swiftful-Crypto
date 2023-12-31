//
//  StatisticView.swift
//  SwiftfulCrypto
//
//  Created by Nguyen Thanh Trung on 15/08/2023.
//

import SwiftUI

struct StatisticView: View {
    
    let stat: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack(spacing: 4.0) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: stat.isPositive ? 0 : 180)
                    )
                
                Text(stat.percentageChange.orZero.asPercentString())
                    .font(.caption)
                .bold()
            }
            .foregroundColor(
                stat.isPositive ? Color.theme.green : Color.theme.red
            )
            .opacity(stat.percentageChange == nil ? 0 : 1)
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(stat: dev.stat1)
                .previewLayout(.sizeThatFits)
            
            StatisticView(stat: dev.stat2)
                .previewLayout(.sizeThatFits)
            
            StatisticView(stat: dev.stat3)
                .previewLayout(.sizeThatFits)
        }
    }
}
