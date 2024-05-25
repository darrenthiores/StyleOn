//
//  MainBottomView.swift
//  StyleOn
//
//  Created by Darren Thiores on 23/05/24.
//

import SwiftUI

struct MainBottomView: View {
    @Binding var timerOn: Bool
    @Binding var selectedType: WearableType
    let onSwitchCamera: () -> Void
    
    var body: some View {
        HStack(spacing: 32) {
            CircleIconButton(
                icon: "timer",
                onClick: { 
                    timerOn.toggle()
                },
                isSelected: timerOn
            )
            
            Spacer()
            
            ForEach(WearableType.allCases, id: \.rawValue) { wearable in
                Button {
                    selectedType = wearable
                } label: {
                    Text(wearable.rawValue.uppercased())
                        .font(.title)
                        .foregroundStyle(
                            selectedType == wearable ? .black : .gray
                        )
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
            
            CircleIconButton(
                icon: "arrow.triangle.2.circlepath.camera",
                onClick: onSwitchCamera,
                isSelected: false
            )
        }
        .padding(.horizontal, 32)
        .frame(height: 100)
        .background(.white)
    }
}

#Preview {
    MainBottomView(
        timerOn: .constant(false),
        selectedType: .constant(.Shirts),
        onSwitchCamera: {  }
    )
}
