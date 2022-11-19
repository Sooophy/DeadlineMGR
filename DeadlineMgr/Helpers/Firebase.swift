//
//  Firebase.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/11/17.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class Firebase {
    static let shared: Firebase = .init()
    var user: User?

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
                    try await Firestore.firestore().collection("users").document(user.uid).setData(["uid": user.uid, "last_login": Date()], merge: true)
                } catch {
                    print(error)
                }
            }
        }
    }

    func getUser() -> User? {
        return user
    }

    class FirebaseEventData: Codable {
        var json: String
        var data: [String: Event]
        var lastUpdate: Date

        init(_ data: [String: Event]) {
            self.data = data
            self.json = String(data: try! JSONEncoder().encode(data), encoding: .utf8)!
            self.lastUpdate = .now
        }
    }

    func saveEvents(events: [String: Event]) async {
        guard user != nil else {
            debugPrint("user is nil")
            return
        }
        do {
            try Firestore.firestore().collection("events").document(user?.uid ?? "undefined").setData(from: FirebaseEventData(events))
        } catch {
            print(error)
        }
    }

    func fetchEvents() async -> (Date, [String: Event]) {
        do {
            let data = try await Firestore.firestore().collection("events").document(user!.uid).getDocument().data(as: FirebaseEventData.self)
            return (data.lastUpdate, data.data)
        } catch {
            print("fetchEvents error: ", error)
            return (Date.distantPast, [:])
        }
    }
}
