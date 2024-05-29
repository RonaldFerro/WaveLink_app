//
//  FriendsProfile.swift
//  WaveLinkApp
//
//  Created by Ronald Ferro on 5/20/24.
//

import SwiftUI

struct FriendsProfile: View {
    var friend: [Friends]
    var body: some View {
        VStack {
            HStack {
                Spacer()
                EditButton()
                    .offset(x:-25)
            }
//            Image(friend.fImage)
                .offset(y: -150)
                .frame(height:700)
            Spacer()
            
            Text(" ___  Profile")
                .bold()
                .font(.title)
                .offset(y:-320)
                .underline()
            Text("Their ID:  ___ ")
                .offset(x:-100, y:-300)
                .font(.title2)
                .frame(alignment: .leadingFirstTextBaseline)
        }
    }
}
//#Preview {
//    FriendsProfile()
//}
