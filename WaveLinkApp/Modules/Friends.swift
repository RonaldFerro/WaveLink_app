//
//  Friends.swift
//  WaveLinkApp
//
//  Created by Ronald Ferro on 5/15/24.
//

import Foundation
import SwiftUI
import NearbyInteraction


class Friends: ObservableObject, Identifiable{
    @AppStorage ("fUsername") var fName: String = ""
    @AppStorage ("fUsername") var fUsername: String = " "
    @AppStorage ("fId") var fId: String = " "
    @AppStorage("friendPic") var friendPic: Data?
    var fImage: Image? {
        if let friendPic {
            Image(uiImage: UIImage(data: friendPic)!)
        } else {
            nil
        }
    }
//    init(fName: String, fUsername: String, fId: String, friendPic: Data) {
//        self.fName = fName
//        self.fUsername = fUsername
//        self.fId = fId
//        self.friendPic = friendPic
//    }
    
}
