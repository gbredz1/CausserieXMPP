//
//  XMPPListener.swift
//
//
//  Created by Guillaume on 26/04/2024.
//
import Foundation

public protocol XMPPListenerObserver: AnyObject {
    func event(fired event: XMPPListener.Event)
}

public class XMPPListener {
    public enum Event {
        case tcpReady
    }

    private let logger = Logger(for: XMPPParser.self)
    private var tcp: TCPSocketConnection
    private var sax: SAXParser
    private lazy var observers = [XMPPListenerObserver]()

    public convenience init(hostname: String) {
        let tcp = NWTCPSocketConnection(hostname)
        let sax = SAXParserLibXML2()

        self.init(tcpConnection: tcp, saxParser: sax)
    }

    public init(tcpConnection: TCPSocketConnection, saxParser: SAXParser) {
        self.tcp = tcpConnection
        self.sax = saxParser
        self.tcp.delegate = TCPDelegate(self)
        self.sax.delegate = SAXDelegate(self)
    }

    public func attach(_ observer: XMPPListenerObserver) {
        observers.append(observer)
    }

    public func detach(_ observer: XMPPListenerObserver) {
        observers.removeAll(where: { $0 === observer })
    }

    public func listen() { tcp.open() }

    func fire(event: Event) {
        observers.forEach { $0.event(fired: event) }
    }

    class TCPDelegate: TCPSocketConnectionDelegate {
        let listener: XMPPListener
        init(_ listener: XMPPListener) { self.listener = listener }
        func dataReceived(_ data: Data) { listener.sax.feed(data) }
        func connectionReady() {
            listener.fire(event: .tcpReady)
        }
    }

    class SAXDelegate: SAXParserDelegate {
        let listener: XMPPListener
        init(_ listener: XMPPListener) { self.listener = listener }

        func start(_ element: SAXElement) {

        }
        func end(_ element: SAXElement) {

        }
        func characters(_ value: String) {

        }
    }
}
