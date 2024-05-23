//
//  SquareWearableButton.swift
//  StyleOn
//
//  Created by Darren Thiores on 24/05/24.
//

import SwiftUI

struct SmallSquareWearable: View {
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
            .frame(width: 100, height: 100)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    SmallSquareWearable(
        wearable: Wearable.defaultWearable,
        onClick: {  }
    )
    .background(.red)
}
