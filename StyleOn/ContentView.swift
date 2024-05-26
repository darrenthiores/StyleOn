//
//  ContentView.swift
//  StyleOn
//
//  Created by Darren Thiores on 21/05/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("showBoarding") private var showBoarding: Bool = true
    
    var body: some View {
        if showBoarding {
            BoardingView()
        } else {
            NavigationStack {
                TiltPadView()
            }
        }
    }
}

#Preview {
    ContentView()
}
