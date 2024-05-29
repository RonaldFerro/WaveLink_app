//
//  ProfileHost.swift
//  WaveLinkApp
//
//  Created by Ronald Ferro on 5/15/24.
//

import SwiftUI

struct ProfileHost:  View {
    @EnvironmentObject var profile: Profile
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink("Edit Profile") {
                            ProfileEditor()
                                .environmentObject(profile)
                    }.padding()
                }
                ProfilePicture()
                List {
                    LabeledContent("Name:", value: profile.name)
                    LabeledContent("Username:", value: profile.username)
                    LabeledContent("ID:", value: profile.id)
                }
            }
        }
    }
}

#Preview {
    ProfileHost()
        .environmentObject(Profile())
}

