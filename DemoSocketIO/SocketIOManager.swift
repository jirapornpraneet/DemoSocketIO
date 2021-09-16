//
//  SocketIOManager.swift
//  DemoSocketIO
//
//  Created by Donut on 16/9/2564 BE.
//

import Foundation
import SocketIO

class SocketIOManager {
    
    static let sharedInstance = SocketIOManager()
    var socket: SocketIOClient!
    var manager: SocketManager!
    
    func connectSocket() {
        manager = SocketManager(socketURL: URL(string: "")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }

        socket.on("force_logout") {data, ack in
            self.logout()
        }
        socket.connect()
    }
    
    func sendDataToSocketIO() {
        socket.emit("logout_other_sessions", SocketIOUserInfo(username: "", uuid: ""))
    }
    
    func disConnectSocketIO() {
        socket.disconnect()
    }
    
    struct SocketIOUserInfo : SocketData {
       let username: String
       let uuid: String

       func socketRepresentation() -> SocketData {
           return ["username": username, "uuid": uuid]
       }
    }
    
    func logout() {
        disConnectSocketIO()
    }
    
    func autoAuthenticate() {
        connectSocket()
        //login service
        //แล้วทำการเช็คว่ามี uuid มั้ย ถ้ามีก็จะเป็นการ logout service user อื่นออกให้หมด
        sendDataToSocketIO()
        //แล้วทำการ  login service  อีกที
    }
    
}
