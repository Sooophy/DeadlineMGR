//
//  Firebase.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/11/17.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Foundation

class Firebase {
    static let shared: Firebase = .init()
    var user: User?
    var token: String?
//    var user
    private init() {
        debugPrint("init firebase")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Task {
                do {
                    FirebaseApp.configure()
                    let auth = Auth.auth()
                    auth.shareAuthStateAcrossDevices = true
                    let accessGroup = Bundle.main.infoDictionary!["KeychainAccessGroup"] as! String
                    print("Access Group: ", accessGroup)
                    try auth.useUserAccessGroup(accessGroup)
                    let result = try await auth.signInAnonymously()
                    let user = result.user

                    self.user = user
                    print("user uid:", user.uid)
                    let res = Firestore.firestore().collection("users").addDocument(data: ["user": user.uid, "last_login": Date()])

                } catch {
                    print(error)
                }
            }
        }
    }

    func getUser() -> User {
        return self.user!
    }

    func saveDocument(data: Data) async {}
}
