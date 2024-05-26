//
//  PhotoResultSheetView.swift
//  StyleOn
//
//  Created by Darren Thiores on 26/05/24.
//

import SwiftUI

struct PhotoResultSheetView: View {
    let result: UIImage?
    let onSave: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if let result = result {
                Image(uiImage: result)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .frame(minWidth: 300, maxWidth: .infinity)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
                .frame(height: 32)
            
            Button {
                onSave()
            } label: {
                Text("Save")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(minWidth: 300, maxWidth: .infinity, minHeight: 54)
                    .background(.lightBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
            
            Spacer()
                .frame(height: 8)
            
            Button {
                onDismiss()
            } label: {
                Text("Return")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(minWidth: 300, maxWidth: .infinity, minHeight: 54)
                    .background(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
        }
        .padding(32)
    }
}

#Preview {
    PhotoResultSheetView(
        result: nil,
        onSave: {  },
        onDismiss: {  }
    )
}
