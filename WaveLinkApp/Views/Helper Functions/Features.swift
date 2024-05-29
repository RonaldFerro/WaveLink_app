//
//  Features.swift
//  WaveLinkApp
//
//  Created by Ronald Ferro on 5/15/24.
//

import SwiftUI
import CoreBluetooth
import Foundation

struct Features: View {
    @StateObject var model =  BluetoothModel()
    var body: some View {
        NavigationStack{
            VStack{
                VStack {
                    Text("You must only pick 3")
                        .bold()
                        .underline()
                        .font(.title)
                    Text("TURN OFF ALL UNWANTED CHOICES")
                        .bold()
                        .foregroundStyle(Color.red)
                }
                    .offset(y:-125)
                VStack {
                    Section("1) Going In"){
                        Toggle("1", isOn: $model.ledCom1)
                            .onChange(of: model.ledCom1) { oldValue, newValue in
                                model.sendCom1State()
                            }.frame(width: 70)
                    }
                    Section("2) Going Out"){
                        Toggle("2", isOn: $model.ledCom2)
                            .onChange(of: model.ledCom2) { oldValue, newValue in
                                model.sendCom2State()
                            }.frame(width: 70)
                    }
                    Section("3) 5Min Left"){
                        Toggle("3", isOn: $model.ledCom3)
                            .onChange(of: model.ledCom3) { oldValue, newValue in
                                model.sendCom3State()
                            }.frame(width: 70)
                    }
                    Section("4) 10Min Left"){
                        Toggle("4", isOn: $model.ledCom4)
                            .onChange(of: model.ledCom4) { oldValue, newValue in
                                model.sendCom4State()
                            }.frame(width: 70)
                    }
                    Section("5) Leaving now"){
                        Toggle("5", isOn: $model.ledCom5)
                            .onChange(of: model.ledCom5) { oldValue, newValue in
                                model.sendCom5State()
                            }.frame(width: 70)
                    }
                    Section("6) Leaving now"){
                        Toggle("6", isOn: $model.ledCom6)
                            .onChange(of: model.ledCom6) { oldValue, newValue in
                                model.sendCom6State()
                            }.frame(width: 70)
                    }
                }.offset(y:-70)
            }.navigationTitle("Select 3 Communication Options")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    Features()
}
