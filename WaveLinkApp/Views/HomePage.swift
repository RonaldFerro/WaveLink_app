//
//  HomePage.swift
//  WaveLinkApp
//
//  Created by Ronald Ferro on 5/15/24.
//

import SwiftUI
import Foundation

func setAlternateIconName(_ alternateIconName: String?) async throws {
}

struct HomePage: View {
    @StateObject var profile = Profile()
    var body: some View {
        NavigationView {
            List{
                NavigationLink {
                    ProfileHost()
                        .environmentObject(profile)
                } label:{
                    HStack{
                        Text("Manage your Profile")
                    }
                }
                NavigationLink{
                    BLeList()
                } label: {
                    Text("Bluetooth Connection")
                }
                NavigationLink{
                    Features()
                } label: {
                    Text("Watch Features")
                }
                NavigationLink{
                    ProfileHost()
                        .environmentObject(profile)
                } label: {
                    Text("Friends")
                }
                HomePicture()
            }
            .navigationTitle("Welcome to WaveLink")
           
        
        }
        
    }
}

#Preview {
    HomePage()
}
