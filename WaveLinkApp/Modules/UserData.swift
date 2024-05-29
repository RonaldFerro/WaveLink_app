//
//  UserData.swift
//  WaveLinkApp
//
//  Created by Ronald Ferro on 5/15/24.
//

import Foundation

class UserData: ObservableObject{
    var myself: Profile
    var friends: [Friends]
    
    init(myself: Profile, friends: [Friends]) {
        self.myself = myself
        self.friends = friends
    }
}
