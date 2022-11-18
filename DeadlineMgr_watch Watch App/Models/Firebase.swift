//
//  Firebase.swift
//  DeadlineMgr_watch Watch App
//
//  Created by Tianjun Mo on 2022/11/17.
//

import Foundation

import FirebaseAuth
import FirebaseCore
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
                    let user = auth.currentUser
                    print("user", user?.uid)
                    self.user = user
                }
                catch {
                    print(error)
                }
            }
        }
    }

    func getUser() -> User? {
        return self.user
    }
}
