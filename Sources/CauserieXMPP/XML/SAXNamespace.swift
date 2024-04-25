//
//  SAXModel.swift
//
//
//  Created by Guillaume on 14/12/2023.
//

import Foundation

public struct SAXNamespace: CustomStringConvertible, Equatable {
    let prefix: String?
    let URI: String

    public init(prefix: String? = nil, URI: String) {
        self.prefix = prefix
        self.URI = URI
    }

    public var description: String {
        var description = "Namespace[xmlns"
        if let prefix {
            description += ":\(prefix)"
        }

        description += "=\(URI)]"

        return description
    }

    public static func == (lhs: SAXNamespace, rhs: SAXNamespace) -> Bool {
        lhs.prefix == rhs.prefix
            && lhs.URI == rhs.URI
    }
}

extension [SAXNamespace] {
    public func get(_ prefix: String? = nil) -> SAXNamespace? {
        first(where: { $0.prefix == prefix })
    }
}
