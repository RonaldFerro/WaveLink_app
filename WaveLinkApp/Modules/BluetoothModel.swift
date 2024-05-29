//  BluetoothModel.swift

import SwiftUI
import Foundation
import CoreBluetooth

class BluetoothModel: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate{
    @Published var ledState = false
    @Published var ledCom1 = false
    @Published var ledCom2 = false
    @Published var ledCom3 = false
    @Published var ledCom4 = false
    @Published var ledCom5 = false
    @Published var ledCom6 = false
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
//    @AppStorage("Favorite") var favorite: UUID?
//    @AppStorage("autoconnect") var autoConnect: Bool = true
    /*@AppStorage("FavoriteWatch")*/ var identifierForWatch: UUID? = nil
    let SERVICE_UUID: CBUUID = CBUUID(string: "bc616d36-925b-46c1-a52d-39c78d207fd4") //ESP UUID
    var characteristics: [String: CBCharacteristic] = [:]
    let characteristic_key: [CBUUID: String] = [
        CBUUID(string: "909257b2-2a38-482a-abd7-865afa057229"): "ledState",
        CBUUID(string: "906a632f-25be-491e-800b-595016987b97"): "ledCom1",
        CBUUID(string: "2a403154-f25d-4328-9965-8576a3a1e89e"): "ledCom2",
        CBUUID(string: "bddb2fd1-98b1-4c02-a2df-322bc420847a"): "ledCom3",
        CBUUID(string: "82ccdc27-a3db-479f-a06d-99898e2a4928"): "ledCom4",
        CBUUID(string: "e5fe0bb3-4893-4c2f-9a5e-dd062d691a10"): "ledCom5",
        CBUUID(string: "50472f08-9c9e-4431-83c4-275836514ceb"): "ledCom6",
    ]
    
    
    @Published var connected: Bool = false
    @Published var loaded: Bool = false
    
    override init(){
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("Is Powered Off")
        case .poweredOn:
            print("Is Powered On")
            startScanning()
        case .unsupported:
            print("Is Unsupported")
        case .unauthorized:
            print("Is Unauthorized")
        case .unknown:
            print("Is Unknown")
        case .resetting:
            print("Is Resetting")
        @unknown default:
            print("Error")
        }
    }
    func centralManager(_ central: CBCentralManager,didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber){
        //check if alr known
        if let identifierForWatch {
            if identifierForWatch == peripheral.identifier {
                print("Discovered Peripheral: \(peripheral)")
                self.peripheral = peripheral
                centralManager.connect(self.peripheral!)
            }
        }else{
            print("Discovered Peripheral: \(peripheral)")
            self.peripheral = peripheral
            centralManager.connect(self.peripheral!)
        }
    
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        self.peripheral!.delegate = self
        self.peripheral!.discoverServices([SERVICE_UUID])
        stopScanning()
        // inform UI
        withAnimation {
            connected = true
        }
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected.")
        self.peripheral = nil
        
        withAnimation {
            connected = false
            loaded = false
        }
        startScanning()
    }
    func startScanning(){
        print("Scanning")
        centralManager.scanForPeripherals(withServices: [SERVICE_UUID])
    }
    func stopScanning() {
        centralManager.stopScan()
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        print("Discovering services...")
        
        for service in services {
            print("Service: \(service)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        print("Discovering characteristics for service: \(service)")
        
        for characteristic in characteristics {
            print("Characteristic: \(characteristic)")
            print("\t- R/W: \(characteristic.properties.contains(.read))/\(characteristic.properties.contains(.write))")
            
            if let name = characteristic_key[characteristic.uuid] {
                print("\t- Characteristic key: \(name)")
                self.characteristics[name] = characteristic
                
                self.peripheral?.readValue(for: characteristic)
            }
        }
        
        if characteristics.count == characteristic_key.count { // discovered all expected characteristics
            // inform UI
            withAnimation {
                loaded = true
            }
        }
    }
    
    func sendLedState() {
        peripheral?.writeValue(Data([ledState ? 1 : 0]), for: characteristics["ledState"]!, type: .withResponse)
    } 
    func sendCom1State() {
        peripheral?.writeValue(Data([ledCom1 ? 1 : 0]), for: characteristics["ledCom1"]!, type: .withResponse)
    }
    func sendCom2State() {
        peripheral?.writeValue(Data([ledCom2 ? 1 : 0]), for: characteristics["ledCom2"]!, type: .withResponse)
    }
    func sendCom3State() {
        peripheral?.writeValue(Data([ledCom3 ? 1 : 0]), for: characteristics["ledCom3"]!, type: .withResponse)
    }
    func sendCom4State() {
        peripheral?.writeValue(Data([ledCom4 ? 1 : 0]), for: characteristics["ledCom4"]!, type: .withResponse)
    }
    func sendCom5State() {
        peripheral?.writeValue(Data([ledCom5 ? 1 : 0]), for: characteristics["ledCom5"]!, type: .withResponse)
    }
    func sendCom6State() {
        peripheral?.writeValue(Data([ledCom6 ? 1 : 0]), for: characteristics["ledCom6"]!, type: .withResponse)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        
        ledState = data.withUnsafeBytes { bytes in
            bytes.load(as: Bool.self)
        }
        ledCom1 = data.withUnsafeBytes { bytes in
            bytes.load(as: Bool.self)
        }
        ledCom2 = data.withUnsafeBytes { bytes in
            bytes.load(as: Bool.self)
        }
        ledCom3 = data.withUnsafeBytes { bytes in
            bytes.load(as: Bool.self)
        }
        ledCom4 = data.withUnsafeBytes { bytes in
            bytes.load(as: Bool.self)
        }
        ledCom5 = data.withUnsafeBytes { bytes in
            bytes.load(as: Bool.self)
        }
        ledCom6 = data.withUnsafeBytes { bytes in
            bytes.load(as: Bool.self)
        }
        
        
//        switch characteristic_key[characteristic.uuid] {
//        case "LedState":
//            ON = LED_Button(ledState: true)
//        case "LedState":
//            OFF = LED_Button(ledState: false)
//
//        default:
//            print("Updated value for invalid characteristic.")
//        }
        
        // inform UI to update to reflect computed property (color) change
        objectWillChange.send()
    }

}
