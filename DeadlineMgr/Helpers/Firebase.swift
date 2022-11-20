//
//  Firebase.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/11/17.
//

import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FirebaseDatabaseSwift
import Foundation

class Firebase {
    static let shared: Firebase = .init()
    var user: User?
    var initCallbacks: [() -> Void] = []
    var databaseRef: DatabaseReference?
    var eventsRef: DatabaseReference?

    private init() {
        DispatchQueue.main.async {
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
                    self.databaseRef = Database.database().reference(fromURL: "https://duke-deadlinemgr-default-rtdb.firebaseio.com/")
                    self.eventsRef = self.databaseRef?.child("events").child(user.uid)
                    class UserLoginData: Encodable {
                        var uid: String
                        var last_login: Date
                        init(uid: String, last_login: Date) {
                            self.uid = uid
                            self.last_login = last_login
                        }
                    }
                    let data = UserLoginData(uid: user.uid, last_login: Date())
                    try self.databaseRef?.child("users").child(user.uid).setValue(from: data)
                    for callback in self.initCallbacks {
                        DispatchQueue.main.async {
                            callback()
                        }
                    }

                } catch {
                    print(error)
                }
            }
        }
    }

    func onInitCompleted(callback: @escaping () -> Void) {
        initCallbacks.append(callback)
    }

    func getUser() -> User? {
        return user
    }

    class FirebaseEventData: Codable {
        var data: [String: Event]
        var lastUpdate: Date

        init(_ data: [String: Event]) {
            self.data = data
            self.lastUpdate = .now
        }
    }

    func saveEvents(events: [String: Event]) async {
        guard user != nil else {
            debugPrint("user is nil")
            return
        }
        do {
            try eventsRef?.setValue(from: FirebaseEventData(events))
        } catch {
            print(error)
        }
    }

    func fetchEvents() async -> (Date, [String: Event]) {
        do {
            let data = try await eventsRef?.getData().data(as: FirebaseEventData.self)
            return (data!.lastUpdate, data!.data)
        } catch {
            print("fetchEvents error: ", error)
            return (Date.distantPast, [:])
        }
    }
}
