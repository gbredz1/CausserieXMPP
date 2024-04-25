//
//  SAXElement.swift
//
//
//  Created by Guillaume on 20/12/2023.
//

import Foundation

public struct SAXElement: Equatable {
    public let name: String
    public let prefix: String?
    public let URI: String?
    public let namespaces: [SAXNamespace]?
    public let attributes: [SAXAttribute]?

    public static func == (lhs: SAXElement, rhs: SAXElement) -> Bool {
        lhs.name == rhs.name
            && lhs.prefix == rhs.prefix
            && lhs.URI == rhs.URI
            && lhs.namespaces == rhs.namespaces
            && lhs.attributes == rhs.attributes
    }
}

extension SAXElement: CustomStringConvertible {
    public var description: String {
        var description = "Element["

        if let prefix {
            description += "\(prefix):"
        }
        description += "\(name)"

        if let URI {
            description += "(\(URI))"
        }
        if let namespaces {
            description += "{\(namespaces)}"
        }
        if let attributes {
            description += "{\(attributes)}"
        }

        return description + "]"
    }
}
