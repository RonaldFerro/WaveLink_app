//
//  ImagePicker.swift
//  WaveLinkApp
//
//  Created by Ronald Ferro on 5/20/24.
//

import SwiftUI

struct ImagePicked:  View {
    @State var showImagePicker: Bool = false
    @State var selectedImage: Image? = nil
    @EnvironmentObject var pfp: Profile

    var body: some View {
        VStack{
            Button(action: {
                self.showImagePicker.toggle()
            }, label: {
                Text("Select Image")
            })
            self.selectedImage?.resizable().scaledToFit()
            Button("Upload Image"){
                pfp.setPfp(image: selectedImage!)
            }
//            Button(action: {
//                let uiImage: UIImage = (self.selectedImage?.asUIImage())!
//            }, label: {
//                Text("Upload Image")
//            })
        }
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(image: self.$selectedImage)
        })
    }
    
}

#Preview {
    ImagePicked()
}
