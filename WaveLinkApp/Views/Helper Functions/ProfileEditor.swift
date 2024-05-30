import SwiftUI


struct ProfileEditor: View {
    @EnvironmentObject var profile: Profile
    
    var body: some View {
        NavigationView{
            List {
                Section("Name"){
                    TextField("Name", text: $profile.name)
                }
                Section("Username"){
                    TextField("Username", text: $profile.username)
                }
                Section("ID"){
                    TextField("ID", text: $profile.id)
                }
        
                    Section("Upload Image"){
                        NavigationLink("Pick an Image"){
                             ImagePicked()
                                .environmentObject(profile)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }


#Preview {
    ProfileEditor()
        .environmentObject(Profile())
}
