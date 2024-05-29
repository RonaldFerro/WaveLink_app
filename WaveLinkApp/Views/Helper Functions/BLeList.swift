//
//  BLeList.swift
//  WaveLinkApp
//
//  Created by Ronald Ferro on 5/15/24.
//

import SwiftUI
import Foundation
import CoreBluetooth


struct BLeList: View {
    @StateObject var model = BluetoothModel()
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Have watch near and press both outside buttons to start scanning. Make sure no other devices are nearby. The watch should pair automatically.")
                    .baselineOffset(10)
                    .frame(width: 350)
                    .offset(y:-200)
                Text("Toggle Switch to check if Watch is paired")
                    .padding()
                    .offset(y:-180)
                Toggle("LED", isOn: $model.ledState)
                    .onChange(of: model.ledState) { oldValue, newValue in
                        model.sendLedState()
                    }.offset(y:-160)
                    .frame(width: 150)
                Text("Middle LED on watch will turn on/off with toggle")
                    .offset(y:-120)
            }
            .navigationTitle("How to Connect")
            .navigationBarTitleDisplayMode(.large)
            .offset(y:50)
        }
    }
}

#Preview {
    BLeList()
}
