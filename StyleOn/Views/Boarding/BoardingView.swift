//
//  BoardingView.swift
//  StyleOn
//
//  Created by Darren Thiores on 23/05/24.
//

import SwiftUI

struct BoardingView: View {
    var body: some View {
        VStack(alignment: .center,spacing: 64) {
            Image("Boarding")
            
            Text("Make sure your body is fully seen in\nthe camera and stand up straight")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            NavigationLink {
                MainView()
            } label: {
                Text("Start")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 300, height: 54)
                    .background(.lightBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    NavigationStack {
        BoardingView()
    }
}
