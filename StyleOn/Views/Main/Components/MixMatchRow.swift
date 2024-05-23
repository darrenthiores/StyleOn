//
//  MixMatchRow.swift
//  StyleOn
//
//  Created by Darren Thiores on 24/05/24.
//

import SwiftUI

struct MixMatchRow: View {
    let selectedShirt: Wearable?
    let selectedPant: Wearable?
    let onShirtClick: () -> Void
    let onPantClick: () -> Void
    let onCameraClick: () -> Void
    
    var body: some View {
        HStack(spacing: 64) {
            Spacer()
            
            if let selectedShirt = selectedShirt {
                SmallSquareWearable(
                    wearable: selectedShirt,
                    onClick: onShirtClick
                )
            }
            
            CameraButton(
                onClick: onCameraClick
            )
            
            if let selectedPant = selectedPant {
                SmallSquareWearable(
                    wearable: selectedPant,
                    onClick: onPantClick
                )
            }
            
            Spacer()
        }
    }
}

#Preview {
    MixMatchRow(
        selectedShirt: .defaultWearable,
        selectedPant: .defaultWearable,
        onShirtClick: {  },
        onPantClick: {  },
        onCameraClick: {  }
    )
    .background(.red)
}
