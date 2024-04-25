//
//  SAXParser.swift
//
//
//  Created by Guillaume on 13/12/2023.
//

import Foundation
import libxml2

public protocol SAXParserDelegate: AnyObject {
    func start(_ element: SAXElement)
    func end(_ element: SAXElement)
    func characters(_ value: String)
}

public protocol SAXParser {
    var delegate: SAXParserDelegate? { get set }
    func feed(_ data: Data)
    func feed(_ string: String)
    func reset()
}

extension SAXParser {
    public func feed(_ string: String) {
        feed(Data(string.utf8))
    }
}
