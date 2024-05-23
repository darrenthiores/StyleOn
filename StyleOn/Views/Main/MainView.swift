//
//  MainView.swift
//  StyleOn
//
//  Created by Darren Thiores on 23/05/24.
//

import SwiftUI

struct MainView: View {
    @State private var shirts: [Wearable] = []
    @State private var pants: [Wearable] = []
    @State private var selectedShirt: Wearable? = nil
    @State private var selectedPant: Wearable? = nil
    @State private var selectedShirtIndex: Int = 0
    @State private var selectedPantIndex: Int = 0
    
    @State private var timerOn: Bool = false
    @State private var selectedType: WearableType = .Shirts
    
    private var wearables: Binding<[Wearable]> {
        switch selectedType {
        case .Pants:
            return $pants
        default:
            return $shirts
        }
    }
    
    private var selectedWearable: Binding<Wearable?> {
        switch selectedType {
        case .Pants:
            return $selectedPant
        default:
            return $selectedShirt
        }
    }
    
    private var selectedIndex: Binding<Int> {
        switch selectedType {
        case .Pants:
            return $selectedPantIndex
        default:
            return $selectedShirtIndex
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ARViewContainer()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Using ZStack because of Bug on SnapPagerCarousel
                    // If using switch or if/else, the carousel always go to item 0 everytime state changes
                    ZStack {
                        MixMatchRow(
                            selectedShirt: selectedShirt,
                            selectedPant: selectedPant,
                            onShirtClick: {  },
                            onPantClick: {  },
                            onCameraClick: {  }
                        )
                        .opacity(
                            selectedType != .MixMatch ? 0 : 1
                        )
                        
                        CircleWearableList(
                            wearables: wearables,
                            selectedWearable: selectedWearable,
                            selectedIndex: selectedIndex,
                            onSearchClick: {
                                
                            }
                        )
                        .opacity(
                            selectedType != .MixMatch ? 1 : 0
                        )
                    }
                    
                    Spacer()
                        .frame(height: 64)
                }
            }
            
            MainBottomView(
                timerOn: $timerOn,
                selectedType: $selectedType
            )
        }
        .onAppear {
            shirts = Wearable.getShirts()
            pants = Wearable.getPants()
            
            updateShirt()
            updatePant()
        }
        .onChange(of: selectedType) {
            if selectedType == .MixMatch {
                if selectedShirt?.id == Wearable.searchWearable.id {
                    selectedShirt = shirts[selectedShirtIndex-1]
                }
                
                if selectedPant?.id == Wearable.searchWearable.id {
                    selectedPant = pants[selectedPantIndex-1]
                }
            }
        }
    }
    
    private func updateShirt() {
        selectedShirt = nil
        
        let midIndex = shirts.count/2
        selectedShirt = shirts[midIndex]
        selectedShirtIndex = midIndex
    }
    
    private func updatePant() {
        selectedPant = nil
        
        let midIndex = pants.count/2
        selectedPant = pants[midIndex]
        selectedPantIndex = midIndex
    }
}

#Preview {
    MainView()
}
