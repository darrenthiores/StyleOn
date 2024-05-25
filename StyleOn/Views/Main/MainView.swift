//
//  MainView.swift
//  StyleOn
//
//  Created by Darren Thiores on 23/05/24.
//

import SwiftUI

struct MainView: View {
    private var arDelegate: ARViewDelegate = ARViewDelegate()
    
    @State private var shirts: [Wearable] = []
    @State private var displayShirts: [Wearable] = []
    @State private var pants: [Wearable] = []
    @State private var displayPants: [Wearable] = []
    @State private var selectedShirt: Wearable? = nil
    @State private var selectedPant: Wearable? = nil
    @State private var selectedShirtIndex: Int = 0
    @State private var selectedPantIndex: Int = 0
    
    @State private var selectedType: WearableType = .Shirts
    @State private var sheetType: WearableSheet? = nil
    
    @State private var timerOn: Bool = false
    @State private var receiveTimer: Bool = false
    @State private var timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()
    @State private var currentSecond = 3
    
    private var wearables: Binding<[Wearable]> {
        switch selectedType {
        case .Pants:
            return $displayPants
        default:
            return $displayShirts
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
                ARViewContainer(
                    arDelegate: arDelegate
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Using ZStack because of Bug on SnapPagerCarousel
                    // If using switch or if/else, the carousel always go to item 0 everytime state changes
                    ZStack {
                        MixMatchRow(
                            selectedShirt: selectedShirt,
                            selectedPant: selectedPant,
                            onShirtClick: {
                                sheetType = .Shirt
                            },
                            onPantClick: {
                                sheetType = .Pant
                            },
                            onCameraClick: {
                                if timerOn {
                                    receiveTimer = true
                                } else {
                                    takePicture()
                                }
                            }
                        )
                        .opacity(
                            selectedType != .MixMatch ? 0 : 1
                        )
                        
                        CircleWearableList(
                            wearables: wearables,
                            selectedWearable: selectedWearable,
                            selectedIndex: selectedIndex,
                            onWearableClick: {
                                if timerOn {
                                    receiveTimer = true
                                } else {
                                    takePicture()
                                }
                            },
                            onSearchClick: {
                                switch selectedType {
                                case .Pants:
                                    sheetType = .Pant
                                default:
                                    sheetType = .Shirt
                                }
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
                selectedType: $selectedType,
                onSwitchCamera: {
                    arDelegate.switchCamera()
                }
            )
        }
        .onAppear {
            shirts = Wearable.getShirts()
            pants = Wearable.getPants()
            
            displayShirts = shirts.suffix(4).map { $0}
            displayPants = pants.suffix(4).map { $0}
            
            updateShirt()
            updatePant()
            
            setWearables()
        }
        .onChange(of: selectedType) {
            setWearables()
        }
        .onChange(of: selectedShirt) {
            setWearables()
        }
        .onChange(of: selectedPant) {
            setWearables()
        }
        .sheet(item: $sheetType) { currentSheet in
            var wearablesBySheet: [Wearable] {
                switch currentSheet {
                case .Shirt:
                    return shirts
                case .Pant:
                    return pants
                }
            }
            
            var title: String {
                switch currentSheet {
                case .Shirt:
                    return "Select Shirt"
                case .Pant:
                    return "Select Pant"
                }
            }
            
            WearableSheetView(
                title: title,
                wearables: wearablesBySheet,
                onClick: { wearable in
                    switch currentSheet {
                    case .Shirt:
                        if !displayShirts.contains(wearable) {
                            displayShirts.insert(wearable, at: selectedShirtIndex)
                        }
                        
                        selectedShirt = wearable
                    case .Pant:
                        if !displayPants.contains(wearable) {
                            displayPants.insert(wearable, at: selectedPantIndex)
                        }
                        
                        selectedPant = wearable
                    }
                    
                    sheetType = nil
                },
                onDismiss: {
                    sheetType = nil
                }
            )
        }
        .onReceive(timer) { _ in
            if receiveTimer {
                currentSecond -= 1
                
                if currentSecond == 0 {
                    receiveTimer = false
                    currentSecond = 3
                    
                    takePicture()
                }
            }
        }
        .overlay {
            if receiveTimer {
                ZStack {
                    Color.black.opacity(0.4)
                    
                    ZStack {
                        Circle()
                            .trim(
                                from: 0.0,
                                to: CGFloat(currentSecond) / 3
                            )
                            .stroke(
                                .white,
                                style: StrokeStyle(
                                    lineWidth: 20,
                                    lineCap: .round
                                )
                            )
                            .frame(width: 200, height: 200)
                            .rotation3DEffect(Angle(degrees: 270), axis: (x: 0, y: 0, z: 1))
                            .animation(.linear, value: currentSecond)
                        
                        Text("\(currentSecond)")
                            .font(.system(size: 96))
                            .bold()
                            .foregroundStyle(.white)
                    }
                }
                .ignoresSafeArea()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func updateShirt() {
        selectedShirt = nil
        
        let midIndex = shirts.count/2
        
        if midIndex == shirts.count - 1 && midIndex > 0 {
            selectedShirt = shirts[midIndex-1]
            selectedShirtIndex = midIndex-1
            
            return
        }
        
        selectedShirt = shirts[midIndex]
        selectedShirtIndex = midIndex
    }
    
    private func updatePant() {
        selectedPant = nil
        
        let midIndex = pants.count/2
        
        if midIndex == pants.count - 1 && midIndex > 0 {
            selectedPant = pants[midIndex-1]
            selectedPantIndex = midIndex-1
            
            return
        }
        
        selectedPant = pants[midIndex]
        selectedPantIndex = midIndex
    }
    
    private func takePicture() {
        ARVariables.arView.snapshot(saveToHDR: false) { (image) in
            // Compress the image
            let compressedImage = UIImage(data: (image?.pngData())!)
            // Save in the photo album
            UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
        }
    }
    
    private func setWearables() {
        switch selectedType {
        case .Pants:
            arDelegate.setupWearables(shirt: nil, pant: selectedPant)
        case .Shirts:
            arDelegate.setupWearables(shirt: selectedShirt, pant: nil)
        case .MixMatch:
            if selectedShirt?.id == Wearable.searchWearable.id {
                selectedShirt = shirts[selectedShirtIndex-1]
            }
            
            if selectedPant?.id == Wearable.searchWearable.id {
                selectedPant = pants[selectedPantIndex-1]
            }
            
            arDelegate.setupWearables(shirt: selectedShirt, pant: selectedPant)
        }
    }
}

#Preview {
    MainView()
}
