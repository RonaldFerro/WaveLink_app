//
//  ProfilePicture.swift
//  WaveLinkApp
//
//  Created by Ronald Ferro on 5/15/24.
//

import SwiftUI

struct ProfilePicture: View {
    @EnvironmentObject var profile: Profile
    
    var body: some View {
       Image("Website-Header")
            .imageScale(.small)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.black, lineWidth: 4)
                    .shadow(radius: 10)
            }
    }
}
#Preview {
    ProfilePicture()
}
