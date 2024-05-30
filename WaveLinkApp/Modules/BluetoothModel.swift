//  BluetoothModel.swift
import SwiftUI
import Foundation
import CoreBluetooth

class BluetoothModel: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var ledState = false
    @Published var ledCom1: Bool = false
    @Published var ledCom2 = false
    @Published var ledCom3 = false
    @Published var ledCom4 = false
    @Published var ledCom5 = false
    @Published var ledCom6 = false
    @Published var connected: Bool = false
    @Published var loaded: Bool = false

    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    var characteristics: [String: CBCharacteristic] = [:]

    let SERVICE_UUID = CBUUID(string: "bc616d36-925b-46c1-a52d-39c78d207fd4") // ESP UUID
    let characteristicKey: [CBUUID: String] = [
        CBUUID(string: "909257b2-2a38-482a-abd7-865afa057229"): "ledState",
        CBUUID(string: "906a632f-25be-491e-800b-595016987b97"): "ledCom1",
        CBUUID(string: "2a403154-f25d-4328-9965-8576a3a1e89e"): "ledCom2",
        CBUUID(string: "bddb2fd1-98b1-4c02-a2df-322bc420847a"): "ledCom3",
        CBUUID(string: "82ccdc27-a3db-479f-a06d-99898e2a4928"): "ledCom4",
        CBUUID(string: "e5fe0bb3-4893-4c2f-9a5e-dd062d691a10"): "ledCom5",
        CBUUID(string: "50472f08-9c9e-4431-83c4-275836514ceb"): "ledCom6"
    ]

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    // Helper methods
    func startScanning() {
        print("Started scanning for peripherals")
        centralManager.scanForPeripherals(withServices: [SERVICE_UUID], options: nil)
    }

    func stopScanning() {
        print("Stopped scanning for peripherals")
        centralManager.stopScan()
    }
    
    // CBCentralManagerDelegate methods
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("Bluetooth is Powered Off")
        case .poweredOn:
            print("Bluetooth is Powered On")
            startScanning()
        case .unsupported:
            print("Bluetooth is Unsupported")
        case .unauthorized:
            print("Bluetooth is Unauthorized")
        case .unknown:
            print("Bluetooth state is Unknown")
        case .resetting:
            print("Bluetooth is Resetting")
        @unknown default:
            print("Unknown Bluetooth state")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("Discovered Peripheral: \(peripheral)")
        if self.peripheral == nil {
            self.peripheral = peripheral
            centralManager.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown")")
        self.peripheral?.delegate = self
        self.peripheral?.discoverServices([SERVICE_UUID])
        stopScanning()
        withAnimation {
            connected = true
        }
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "Unknown")")
        self.peripheral = nil
        withAnimation {
            connected = false
            loaded = false
        }
        startScanning()
    }

    // CBPeripheralDelegate methods
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        guard let services = peripheral.services else { return }
        print("Discovered services: \(services)")
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        guard let characteristics = service.characteristics else { return }
        print("Discovered characteristics for service \(service): \(characteristics)")
        for characteristic in characteristics {
            if let name = characteristicKey[characteristic.uuid] {
                self.characteristics[name] = characteristic
                peripheral.readValue(for: characteristic)
            }
        }
        if characteristics.count == characteristicKey.count {
            withAnimation {
                loaded = true
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        updateLedState(for: characteristic, with: data)
        objectWillChange.send()
    }

    

    func updateLedState(for characteristic: CBCharacteristic, with data: Data) {
        guard let key = characteristicKey[characteristic.uuid] else { return }
        let state = data.withUnsafeBytes { $0.load(as: Bool.self) }
        switch key {
        case "ledState": ledState = state
        case "ledCom1": ledCom1 = state
        case "ledCom2": ledCom2 = state
        case "ledCom3": ledCom3 = state
        case "ledCom4": ledCom4 = state
        case "ledCom5": ledCom5 = state
        case "ledCom6": ledCom6 = state
        default: print("Unknown characteristic key: \(key)")
        }
    }

    func sendLedState(_ value: String) {
        writeValue(value, for: "ledState")
    }

    func sendCom1State(_ value: String) {
        writeValue(value, for: "ledCom1")
    }

    func sendCom2State(_ value: String) {
        writeValue(value, for: "ledCom2")
    }

    func sendCom3State(_ value: String) {
        writeValue(value, for: "ledCom3")
    }

    func sendCom4State(_ value: String) {
        writeValue(value, for: "ledCom4")
    }

    func sendCom5State(_ value: String) {
        writeValue(value, for: "ledCom5")
    }

    func sendCom6State(_ value: String) {
        writeValue(value, for: "ledCom6")
    }

    func writeValue(_ value: String, for key: String) {
        guard let characteristic = characteristics[key] else { return }
        
        // Define the structure
        let startToken: UInt8 = 0x02 // Example start token, you can change this as needed
        let messageId: UInt8 = 0x01 // Example ID, you can change this as needed
        let messageBytes = Array(value.utf8)
        let messageLength: UInt8 = UInt8(min(messageBytes.count, 10))
        let messageHash: UInt8 = UInt8(value.hash & 0xFF)
        
        // Create the packet
        var packet = [UInt8]()
        packet.append(startToken)
        packet.append(messageId)
        packet.append(messageHash)
        packet.append(messageLength)
        packet.append(contentsOf: messageBytes.prefix(10))
        
        // Ensure the packet is exactly 14 bytes (1 + 1 + 1 + 1 + 10)
        while packet.count < 14 {
            packet.append(0) // Padding with zeros if the message is shorter than 10 bytes
        }
        
        let packetData = Data(packet)
        
        // Send the packet 5 times to ensure correctness
        for _ in 0..<5 {
            for byte in packetData {
                peripheral?.writeValue(Data([byte]), for: characteristics[key]!, type: .withResponse)
            }
        }
    }
}


//import SwiftUI
//import Foundation
//import CoreBluetooth
//
//class BluetoothModel: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate{
//    @Published var ledState = false
//    @Published var ledCom1 = false
//    @Published var ledCom2 = false
//    @Published var ledCom3 = false
//    @Published var ledCom4 = false
//    @Published var ledCom5 = false
//    @Published var ledCom6 = false
//    var centralManager: CBCentralManager!
//    var peripheral: CBPeripheral?
////    @AppStorage("Favorite") var favorite: UUID?
////    @AppStorage("autoconnect") var autoConnect: Bool = true
//    /*@AppStorage("FavoriteWatch")*/ var identifierForWatch: UUID? = nil
//    let SERVICE_UUID: CBUUID = CBUUID(string: "bc616d36-925b-46c1-a52d-39c78d207fd4") //ESP UUID
//    var characteristics: [String: CBCharacteristic] = [:]
//    let characteristic_key: [CBUUID: String] = [
//        CBUUID(string: "909257b2-2a38-482a-abd7-865afa057229"): "ledState",
//        CBUUID(string: "906a632f-25be-491e-800b-595016987b97"): "ledCom1",
//        CBUUID(string: "2a403154-f25d-4328-9965-8576a3a1e89e"): "ledCom2",
//        CBUUID(string: "bddb2fd1-98b1-4c02-a2df-322bc420847a"): "ledCom3",
//        CBUUID(string: "82ccdc27-a3db-479f-a06d-99898e2a4928"): "ledCom4",
//        CBUUID(string: "e5fe0bb3-4893-4c2f-9a5e-dd062d691a10"): "ledCom5",
//        CBUUID(string: "50472f08-9c9e-4431-83c4-275836514ceb"): "ledCom6",
//    ]
//    
//    
//    @Published var connected: Bool = false
//    @Published var loaded: Bool = false
//    
//    override init(){
//        super.init()
//        centralManager = CBCentralManager(delegate: self, queue: nil)
//    }
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        switch central.state {
//        case .poweredOff:
//            print("Is Powered Off")
//        case .poweredOn:
//            print("Is Powered On")
//            startScanning()
//        case .unsupported:
//            print("Is Unsupported")
//        case .unauthorized:
//            print("Is Unauthorized")
//        case .unknown:
//            print("Is Unknown")
//        case .resetting:
//            print("Is Resetting")
//        @unknown default:
//            print("Error")
//        }
//    }
//    func centralManager(_ central: CBCentralManager,didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber){
//        //check if alr known
//        if let identifierForWatch {
//            if identifierForWatch == peripheral.identifier {
//                print("Discovered Peripheral: \(peripheral)")
//                self.peripheral = peripheral
//                centralManager.connect(self.peripheral!)
//            }
//        }else{
//            print("Discovered Peripheral: \(peripheral)")
//            self.peripheral = peripheral
//            centralManager.connect(self.peripheral!)
//        }
//    
//    }
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print("Connected!")
//        self.peripheral!.delegate = self
//        self.peripheral!.discoverServices([SERVICE_UUID])
//        stopScanning()
//        // inform UI
//        withAnimation {
//            connected = true
//        }
//    }
//    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        print("Disconnected.")
//        self.peripheral = nil
//        
//        withAnimation {
//            connected = false
//            loaded = false
//        }
//        startScanning()
//    }
//    func startScanning(){
//        print("Scanning")
//        centralManager.scanForPeripherals(withServices: [SERVICE_UUID])
//    }
//    func stopScanning() {
//        centralManager.stopScan()
//    }
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        guard let services = peripheral.services else { return }
//        
//        print("Discovering services...")
//        
//        for service in services {
//            print("Service: \(service)")
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
//    }
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        guard let characteristics = service.characteristics else { return }
//        
//        print("Discovering characteristics for service: \(service)")
//        
//        for characteristic in characteristics {
//            print("Characteristic: \(characteristic)")
//            print("\t- R/W: \(characteristic.properties.contains(.read))/\(characteristic.properties.contains(.write))")
//            
//            if let name = characteristic_key[characteristic.uuid] {
//                print("\t- Characteristic key: \(name)")
//                self.characteristics[name] = characteristic
//                
//                self.peripheral?.readValue(for: characteristic)
//            }
//        }
//        
//        if characteristics.count == characteristic_key.count { // discovered all expected characteristics
//            // inform UI
//            withAnimation {
//                loaded = true
//            }
//        }
//    }
//    
//    func sendLedState() {
//        peripheral?.writeValue(Data([ledState ? 1 : 0]), for: characteristics["ledState"]!, type: .withResponse)
//    } 
//    func sendCom1State() {
//        peripheral?.writeValue(Data([ledCom1 ? 1 : 0]), for: characteristics["ledCom1"]!, type: .withResponse)
//    }
//    func sendCom2State() {
//        peripheral?.writeValue(Data([ledCom2 ? 1 : 0]), for: characteristics["ledCom2"]!, type: .withResponse)
//    }
//    func sendCom3State() {
//        peripheral?.writeValue(Data([ledCom3 ? 1 : 0]), for: characteristics["ledCom3"]!, type: .withResponse)
//    }
//    func sendCom4State() {
//        peripheral?.writeValue(Data([ledCom4 ? 1 : 0]), for: characteristics["ledCom4"]!, type: .withResponse)
//    }
//    func sendCom5State() {
//        peripheral?.writeValue(Data([ledCom5 ? 1 : 0]), for: characteristics["ledCom5"]!, type: .withResponse)
//    }
//    func sendCom6State() {
//        peripheral?.writeValue(Data([ledCom6 ? 1 : 0]), for: characteristics["ledCom6"]!, type: .withResponse)
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        guard let data = characteristic.value else { return }
//        
//        ledState = data.withUnsafeBytes { bytes in
//            bytes.load(as: Bool.self)
//        }
//        ledCom1 = data.withUnsafeBytes { bytes in
//            bytes.load(as: Bool.self)
//        }
//        ledCom2 = data.withUnsafeBytes { bytes in
//            bytes.load(as: Bool.self)
//        }
//        ledCom3 = data.withUnsafeBytes { bytes in
//            bytes.load(as: Bool.self)
//        }
//        ledCom4 = data.withUnsafeBytes { bytes in
//            bytes.load(as: Bool.self)
//        }
//        ledCom5 = data.withUnsafeBytes { bytes in
//            bytes.load(as: Bool.self)
//        }
//        ledCom6 = data.withUnsafeBytes { bytes in
//            bytes.load(as: Bool.self)
//        }
//        
//        
////        switch characteristic_key[characteristic.uuid] {
////        case "LedState":
////            ON = LED_Button(ledState: true)
////        case "LedState":
////            OFF = LED_Button(ledState: false)
////
////        default:
////            print("Updated value for invalid characteristic.")
////        }
//        
//        // inform UI to update to reflect computed property (color) change
//        objectWillChange.send()
//    }
//
//}
