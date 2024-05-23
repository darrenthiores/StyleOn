//
//  CircleWearable.swift
//  StyleOn
//
//  Created by Darren Thiores on 23/05/24.
//

import SwiftUI

struct CircleWearable: View {
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
            .clipShape(Circle())
        }
    }
}

#Preview {
    CircleWearable(
        wearable: Wearable.defaultWearable,
        onClick: {  }
    )
    .background(.black)
}
