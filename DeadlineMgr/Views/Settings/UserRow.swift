//
//  UserRow.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/11/21.
//

import FirebaseAuth
import SwiftUI

struct UserRow: View {
    var user: User?
    var body: some View {
        HStack {
            Image(systemName: "person.circle").resizable().frame(width: 48, height: 48).padding(.trailing, 2)
            if user == nil {
                VStack(alignment: .leading) {
                    Text("Log in")
                }

            } else if user?.isAnonymous != nil {
                VStack(alignment: .leading) {
                    Text("Anonymous User").multilineTextAlignment(.leading).font(.title)
                    Text("\(user!.uid)").font(.caption).fontWeight(.thin)
                }

            } else {
                VStack(alignment: .leading) {
                    Text(String(describing: user!.displayName))
                    Text("\(user!.uid)").font(.caption2).fontWeight(.thin)
                }
            }
        }
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            UserRow(user: FirebaseStore.shared.user)
            UserRow(user: nil)
        }
    }
}
