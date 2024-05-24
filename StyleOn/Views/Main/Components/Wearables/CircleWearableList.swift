//
//  CircleWearableList.swift
//  StyleOn
//
//  Created by Darren Thiores on 23/05/24.
//

import SwiftUI
import SnapPagerCarousel

struct CircleWearableList: View {
    @Binding var wearables: [Wearable]
    @Binding var selectedWearable: Wearable?
    @Binding var selectedIndex: Int
    
    let onWearableClick: () -> Void
    let onSearchClick: () -> Void
    
    private let width = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            SnapPager(
                items: $wearables,
                selection: $selectedWearable,
                currentIndex: $selectedIndex,
                edgesOverlap: width / 2 - 84
            ) { index, wearable in
                ZStack {
                    if wearable.id == Wearable.searchWearable.id {
                        CircleIconButton(
                            icon: "sparkle.magnifyingglass",
                            onClick: onSearchClick,
                            size: 100,
                            fontWeight: .largeTitle,
                            color: .yellow,
                            bgColor: .white
                        )
                    } else {
                        CircleWearable(
                            wearable: wearable,
                            onClick: {
                                onWearableClick()
                            }
                        )
                    }
                }
            }
            .frame(height: 100)
            
            Circle()
                .stroke(lineWidth: 10)
                .frame(width: 130, height: 130)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    CircleWearableList(
        wearables: .constant(Wearable.getAllWearables()),
        selectedWearable: .constant(nil),
        selectedIndex: .constant(0),
        onWearableClick: {  },
        onSearchClick: {  }
    )
    .background(.red)
}
