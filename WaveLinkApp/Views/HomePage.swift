//
//  HomePage.swift
//  WaveLinkApp
//
//  Created by Ronald Ferro on 5/15/24.
//

import SwiftUI
import Foundation

func setAlternateIconName(_ alternateIconName: String?) async throws {
    let alternateIconName = "ICON1"
}

struct HomePage: View {
    @StateObject var profile = Profile()
    var body: some View {
        NavigationSplitView {
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
            }            
            .navigationTitle("Welcome to WaveLink")
            HomePicture()
        } detail: {
            Text("")
        }
        
    }
}

#Preview {
    HomePage()
}
