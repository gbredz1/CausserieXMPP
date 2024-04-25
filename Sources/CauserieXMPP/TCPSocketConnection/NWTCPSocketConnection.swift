//
//  NWTCPSocketConnection.swift
//
//
//  Created by Guillaume on 20/12/2023.
//

import Foundation
import Network

public class NWTCPSocketConnection: TCPSocketConnection {
    private let logger = Logger(for: TCPSocketConnection.self)
    private let connection: NWConnection
    private let queue: DispatchQueue
    public var delegate: TCPSocketConnectionDelegate?

    public init(_ host: String) {
        logger.info("init")
        connection = NWConnection(
            host: NWEndpoint.Host(host),
            port: 5222,
            using: .tcp)
        queue = DispatchQueue(label: "NWTCPSocket", qos: .background)
    }

    private func stateUpdateHandler(_ state: NWConnection.State) {
        logger.info("stateUpdateHandler: \(String(describing: state))")

        if state == .ready {
            receiveNextMessage()  //  start receiving messages

            delegate?.connectionReady()
        }
    }

    private func receiveNextMessage() {
        connection.receive(
            minimumIncompleteLength: 1,
            maximumLength: 2048
        ) { [weak self] content, _, isComplete, error in
            if let error {
                debugPrint("Error: \(error)")
                return
            }

            if let data = content, !data.isEmpty {
                self?.logger.trace(
                    "[] <= \(String(describing: String(data: data, encoding: .utf8)))")
                self?.delegate?.dataReceived(data)
            }

            if !isComplete {  // -> end of stream
                self?.receiveNextMessage()
            }
        }
    }

    public func open() {
        connection.stateUpdateHandler = stateUpdateHandler
        connection.start(queue: queue)
    }

    public func close() {
        connection.cancel()
    }

    public func send(_ data: Data?) {
        if let data {
            logger.trace("[] => \(String(describing: String(data: data, encoding: .utf8)))")
        }

        connection.send(
            content: data,
            contentContext: .defaultMessage,
            isComplete: false,
            completion: .idempotent)
    }
}
