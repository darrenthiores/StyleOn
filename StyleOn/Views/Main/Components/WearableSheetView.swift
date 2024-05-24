//
//  WearableSheet.swift
//  StyleOn
//
//  Created by Darren Thiores on 25/05/24.
//

import SwiftUI

struct WearableSheetView: View {
    let title: String
    let wearables: [Wearable]
    let onClick: (Wearable) -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button {
                        onDismiss()
                    } label: {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundStyle(.lightBlue)
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
            }
            .padding()
            
            Divider()
            
            WearableGrid(
                wearables: wearables,
                onClick: onClick,
                spaceToTop: 32,
                spaceToBottom: 32
            )
        }
    }
}

#Preview {
    WearableSheetView(
        title: "Select Shirt",
        wearables: Wearable.getAllWearables(),
        onClick: { _ in },
        onDismiss: {  }
    )
}
