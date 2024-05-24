//
//  SquareWearable.swift
//  StyleOn
//
//  Created by Darren Thiores on 24/05/24.
//

import SwiftUI

struct SquareWearable: View {
    let wearable: Wearable
    let onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            ZStack {
                Image(wearable.id)
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 200, height: 200)
            .background(.lightGray)
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )
            .shadow(radius: 1)
        }
    }
}

#Preview {
    SquareWearable(
        wearable: Wearable.defaultWearable,
        onClick: {  }
    )
}
