//
//  CircleIconButton.swift
//  StyleOn
//
//  Created by Darren Thiores on 23/05/24.
//

import SwiftUI

struct CircleIconButton: View {
    let icon: String
    let onClick: () -> Void
    var isSelected: Bool = false
    var size: CGFloat = 64
    var fontWeight: Font = .title
    var color: Color? = nil
    var bgColor: Color = Color.gray.opacity(0.24)
    
    var body: some View {
        Button {
            onClick()
        } label: {
            ZStack {
                Image(systemName: icon)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        color ?? (isSelected ? .lightBlue : .black)
                    )
            }
            .frame(width: size, height: size)
            .background(bgColor)
            .clipShape(Circle())
        }
    }
}

#Preview {
    CircleIconButton(
        icon: "timer",
        onClick: {  }
    )
}
