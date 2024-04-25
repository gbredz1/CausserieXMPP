//
//  SAXAttribute.swift
//
//
//  Created by Guillaume on 25/04/2024.
//

import Foundation

public struct SAXAttribute: CustomStringConvertible, Equatable {
    public let localname: String
    public let prefix: String?
    public let URI: String?
    public let value: String

    public init(localname: String, prefix: String? = nil, URI: String? = nil, value: String) {
        self.localname = localname
        self.prefix = prefix
        self.URI = URI
        self.value = value
    }

    public var description: String {
        var description = "Attribute["
        if let prefix {
            description += "\(prefix):"
        }
        description += "\(localname)=\(value)"

        if let URI {
            description += " (\(URI))"
        }

        return description + "]"
    }

    public static func == (lhs: SAXAttribute, rhs: SAXAttribute) -> Bool {
        lhs.localname == rhs.localname
            && lhs.prefix == rhs.prefix
            && lhs.URI == rhs.URI
            && lhs.value == rhs.value
    }
}

extension [SAXAttribute] {
    public func get(_ localname: String) -> SAXAttribute? {
        first(where: { $0.localname == localname })
    }
}
