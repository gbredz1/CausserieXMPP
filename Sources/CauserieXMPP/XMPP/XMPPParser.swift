//
//  XMPPParser.swift
//
//
//  Created by Guillaume on 20/12/2023.
//

import Foundation

public protocol XMPPParserDelegate: AnyObject {
    func event(_ event: XMPPEvent)
}

public enum XMPPEvent {
    case openStream(from: String)
}

public class XMPPParser {
    let logger = Logger(for: XMPPParser.self)

    var delegate: XMPPParserDelegate?

    init() {}

    func streamOpened(with element: SAXElement) {
        let from = element.attributes?.get("from")?.value ?? "nop"
        delegate?.event(.openStream(from: from))
    }
}

extension XMPPParser: SAXParserDelegate {
    public func start(_ element: SAXElement) {
        switch (element.name, element.prefix) {
        case ("stream", "stream"):
            streamOpened(with: element)
        case (let name, .none):
            logger.warning("Unknow: \(name)")
        case (let name, .some(let prefix)):
            logger.warning("Unknow: \(prefix):\(name)")
        }
    }

    public func end(_: SAXElement) {}

    public func characters(_: String) {}
}
