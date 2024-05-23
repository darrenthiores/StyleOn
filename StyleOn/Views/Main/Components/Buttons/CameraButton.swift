//
//  CameraButton.swift
//  StyleOn
//
//  Created by Darren Thiores on 24/05/24.
//

import SwiftUI

struct CameraButton: View {
    let onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            ZStack {
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.white)
                
                Circle()
                    .stroke(lineWidth: 10)
                    .frame(width: 130, height: 130)
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CameraButton(
        onClick: {  }
    )
    .background(.red)
}
