//
//  FirebaseWatch.swift
//  DeadlineMgr_watch Watch App
//
//  Created by Tianjun Mo on 2022/11/17.
//

import Foundation

import FirebaseAuth
import FirebaseCore
import Foundation
import SwiftyJSON

class FirebaseWatch {
    static let shared: FirebaseWatch = .init()
    var user: User?
    var token: String?
    var initCallbacks: [() -> Void] = []
//    var user
    private init() {
        Task {
            do {
                FirebaseApp.configure()
                let auth = Auth.auth()
                auth.shareAuthStateAcrossDevices = true
                let accessGroup = Bundle.main.infoDictionary!["KeychainAccessGroup"] as! String
                print("Access Group: ", accessGroup)
                try auth.useUserAccessGroup(accessGroup)
                let user = auth.currentUser
                print("user", user?.uid ?? "")
                self.user = user
                for callback in initCallbacks {
                    DispatchQueue.main.async {
                        callback()
                    }
                }
            }
            catch {
                print(error)
            }
        }
    }

    func onInitCompleted(callback: @escaping () -> Void) {
        initCallbacks.append(callback)
    }

    func getUser() -> User? {
        return user
    }

    func getEvents() async -> [String: Event] {
        guard self.user != nil else {
            print("Firebase no user")
            return [:]
        }
        let user = user!
        let token = try! await user.getIDToken()

        let (data, _, err) = await HTTP.request("https://firestore.googleapis.com/v1/projects/duke-deadlinemgr/databases/(default)/documents/events/\(user.uid)", .GET, ["Authorization": "Bearer \(token)"])
        if err != nil {
            debugPrint("getEvents HTTP.request error")
            return [:]
        }

        let json = try! JSON(data: data!)

        let dataJson = json["fields"]["json"]["stringValue"].string!
        let res = try! JSONDecoder().decode([String: Event].self, from: dataJson.data(using: .utf8)!)

        return res
    }
}
