//
//  WearableGrid.swift
//  StyleOn
//
//  Created by Darren Thiores on 24/05/24.
//

import SwiftUI

struct WearableGrid: View {
    let wearables: [Wearable]
    let onClick: (Wearable) -> Void
    var spaceToTop: CGFloat = 0
    var spaceToBottom: CGFloat = 0
    
    private var columns: [GridItem] {
       [
            GridItem(.fixed(216)),
            GridItem(.fixed(216)),
            GridItem(.fixed(216))
       ]
    }
    
    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: spaceToTop)
            
            LazyVGrid(
                columns: columns,
                spacing: 16
            ) {
                ForEach(wearables) { wearable in
                    if wearable.id != Wearable.searchWearable.id {
                        SquareWearable(
                            wearable: wearable,
                            onClick: {
                                onClick(wearable)
                            }
                        )
                    }
                }
            }
            
            Spacer()
                .frame(height: spaceToBottom)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 16)
    }
}

#Preview {
    WearableGrid(
        wearables: Wearable.getAllWearables(),
        onClick: { _ in }
    )
}
