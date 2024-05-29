//
//  NearbyInteraction.swift
//  WaveLinkApp
//
//  Created by Ronald Ferro on 5/29/24.
//

import Foundation
import NearbyInteraction
import SwiftUI


protocol NISessionDelegate{
    
}

protocol NIDeviceCapability{
    var supportsPreciseDistanceMeasurement: Bool { get }
    var supportsDirectionMeasurement: Bool { get }
    var supportsCameraAssistance: Bool { get }
    var supportsExtendedDistanceMeasurement: Bool { get }
}
//class NISession: NSObject{
//    class var deviceCapabilities: any NIDeviceCapability { get }
//    
//   
//}
