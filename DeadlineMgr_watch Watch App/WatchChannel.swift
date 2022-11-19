//
//  WatchChannel.swift
//  ece564tm326
//
//  Created by Tianjun Mo on 2022/10/15.
//

import Foundation
import WatchConnectivity

class WatchChannel: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchChannel()
    
    var buffer: [([String: Any], (([String: Any]) -> Void)?)] = []
    var errBuffer: [([String: Any], Error)] = []
    var onReceive: [Action: ([String: Any], (([String: Any]) -> Void)?) -> Void] = [:]
    var isAvailable: Bool = false
    
    enum Action: String {
        case update
        case update_complete_status
        case hello
        case sync
    }
    
    override private init() {
        super.init()
        guard WCSession.isSupported() else {
            return
        }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        let actionStr = message["action"]! as! String
        let action = Action(rawValue: actionStr)!
        DispatchQueue.main.async {
            self.onReceive[action] != nil ? self.onReceive[action]!(message, nil) : nil
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        let actionStr = message["action"]! as! String
        let action = Action(rawValue: actionStr)!
        DispatchQueue.main.async {
            self.onReceive[action] != nil ? self.onReceive[action]!(message, replyHandler) : nil
        }
    }
    
    #if os(iOS)
        func sessionDidBecomeInactive(_ session: WCSession) {
            isAvailable = false
        }
    
        func sessionDidDeactivate(_ session: WCSession) {
            WCSession.default.activate()
        }
    #endif
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        isAvailable = true
        sendMessages()
    }
    
    func sendMessages() {
        guard isAvailable else {
            return
        }
        while !buffer.isEmpty {
            let (message, replyHandler) = buffer.removeFirst()
            #if os(watchOS)
                guard WCSession.default.isCompanionAppInstalled else {
                    debugPrint("WatchChannel: Companion App Not Installed")
                    continue
                }
            #else
                guard WCSession.default.isWatchAppInstalled else {
                    debugPrint("WatchChannel: Watch App Not Installed")
                    continue
                }
            #endif
            guard WCSession.default.isReachable else {
                debugPrint("WatchChannel: Not Reachable")
                continue
            }

            WCSession.default.sendMessage(message, replyHandler: replyHandler) {
                err in
                let wcerror = err as! WCError
                debugPrint("WatchChannel", wcerror.userInfo["NSLocalizedDescription"]!)
                self.errBuffer.append((message, err))
            }
        }
    }
    
    public func registerReceiver(receiveAction: Action, onReceive: (([String: Any], (([String: Any]) -> Void)?) -> Void)?) {
        self.onReceive[receiveAction] = onReceive
    }
    
    public func push(action: Action, message: [String: Any] = [:], replyHandler: (([String: Any]) -> Void)? = nil) {
        var newMsg = message
        newMsg["action"] = action.rawValue
        buffer.append((newMsg, replyHandler))
        if isAvailable {
            sendMessages()
        }
    }
}
