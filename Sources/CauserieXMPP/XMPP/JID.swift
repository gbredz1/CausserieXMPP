//
//  JID.swift
//
//
//  Created by Guillaume on 26/04/2024.
//

import Foundation

// https://datatracker.ietf.org/doc/html/rfc7622

struct JID: CustomStringConvertible, Equatable {
    static let invalidChar = ["\"", "&", "'", "//", ":", "<", ">", "@"]

    let local: String?  // size: 1..1023 - invalid: "&'/:<>@
    let domain: String  // size 1..1023
    let resource: String?  // size 1..1023

    var description: String {
        switch (local, resource) {
        case (.some(let local), .some(let resource)):
            "\(local)@\(domain)/\(resource)"
        case (.some(let local), .none):
            "\(local)@\(domain)"
        case (.none, .some(let resource)):
            "\(domain)/\(resource)"
        case (.none, .none):
            "\(domain)"
        }
    }

    init?(local: String? = nil, domain: String, resource: String? = nil) {
        self.local = local
        self.domain = domain
        self.resource = resource

        if !validate() { return nil }
    }

    init?(_ string: String) {
        let resourceIndexStart = string.firstIndex(of: "/")
        self.resource =
            if let start = resourceIndexStart {
                String(string[string.index(after: start)...])
            } else { nil }

        let string =
            if let start = resourceIndexStart {
                String(string[..<start])
            } else { string }

        let domainIndexStart = string.firstIndex(of: "@")
        if let start = domainIndexStart {
            self.domain = String(string[string.index(after: start)...])
            self.local = String(string[..<start])
        } else {
            self.domain = string
            self.local = nil
        }

        if !validate() { return nil }
    }

    func validate() -> Bool {
        if let local = self.local {
            if local.isEmpty { return false }
            if local.hasPrefix(" ") { return false }
            if local.hasSuffix(" ") { return false }
            for c in JID.invalidChar {
                if local.contains(c) { return false }
            }
            for c in local {
                if c.isSymbol { return false }
                if c.isWholeNumber { return false }
            }
        }

        if self.domain.isEmpty { return false }

        if let resource = self.resource {
            if resource.isEmpty { return false }
            if resource.hasPrefix(" ") { return false }
            if resource.hasSuffix(" ") { return false }
        }

        return true
    }

}
