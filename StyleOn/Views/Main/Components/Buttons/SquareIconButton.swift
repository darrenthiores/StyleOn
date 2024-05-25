//
//  SquareIconButton.swift
//  StyleOn
//
//  Created by Darren Thiores on 26/05/24.
//

import SwiftUI

struct SquareIconButton: View {
    let icon: String
    let onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            ZStack {
                Image(systemName: icon)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .frame(width: 100, height: 100)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    SquareIconButton(
        icon: "timer",
        onClick: {  }
    )
    .background(.red)
}
