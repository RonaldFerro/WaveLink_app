//
//  Profile.swift
//  WaveLinkApp
//
//  Created by Ronald Ferro on 5/15/24.
//

import Foundation
import SwiftUI



class Profile: ObservableObject {
    @AppStorage("name") var name: String = ""
    @AppStorage("username") var username: String = ""
    @AppStorage("id") var id: String = ""
    @AppStorage("profilePic") private var profilePic: Data?
    
    var image: Image? {
        if let profilePic {
            Image(uiImage: UIImage(data: profilePic)!)
        } else {
            nil
        }
    }
    func setPfp(image: Image){
        profilePic = image.asUIImage().pngData()
    }
}
