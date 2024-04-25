//
//  TCPSocketConnection.swift
//
//
//  Created by Guillaume on 13/12/2023.
//

import Foundation
import Network

public protocol TCPSocketConnectionDelegate: AnyObject {
    func connectionReady()
    func dataReceived(_ data: Data)
}

public protocol TCPSocketConnection {
    var delegate: TCPSocketConnectionDelegate? { get set }
    func open()
    func close()
    func send(_ data: Data?)
    func send(_ string: String?)
}

extension TCPSocketConnection {
    public func send(_ string: String?) {
        send(string?.data(using: .utf8))
    }
}
