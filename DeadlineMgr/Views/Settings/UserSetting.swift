//
//  UserSetting.swift
//  DeadlineMgr
//
//  Created by Sophie on 11/22/22.
//

import SwiftUI

struct UserSetting: View {
    @State var username = "ECE564 User"
    @State var email = "Example@duke.edu"
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile information")) {
                    HStack {
                        Text("Username:")
                        TextField("Username", text: $username)
                    }
                    HStack {
                        Text("Email:")
                        TextField("Email", text: $email)
                    }
                    HStack {
                        Text("Remind before:")
                        TextField("Remind before", text: $remindBefore)
                    }
                }
            }
            .navigationTitle("Settings")
    //        .navigationBarItems(leading: cancelButton,trailing: saveButton)
        }
    }
}

struct UserSetting_Previews: PreviewProvider {
    static var previews: some View {
        UserSetting()
    }
}
