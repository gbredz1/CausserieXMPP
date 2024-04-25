//
//  Stanza.swift
//
//
//  Created by Guillaume on 25/04/2024.
//

import Foundation

/// XMPP base element to create Stanza
public struct XMPPElement {
    public struct Namespace {
        let prefix: String?
        let URI: String

        init(prefix: String? = nil, _ URI: String) {
            self.prefix = prefix
            self.URI = URI
        }
    }

    public struct Attribute {
        let localname: String
        let prefix: String?
        let URI: String?
        let value: String

        init(
            _ localname: String,
            prefix: String? = nil,
            URI: String? = nil,
            value: String
        ) {
            self.localname = localname
            self.prefix = prefix
            self.URI = URI
            self.value = value
        }
    }

    let name: String
    let prefix: String?
    let URI: String?
    let namespaces: [Namespace]?
    let attributes: [Attribute]?
    let childs: [XMPPElement]?
    let text: String?
    let omitClosingTag: Bool

    var isEmpty: Bool {
        text == nil && (childs == nil || childs?.isEmpty ?? true)
    }

    init(
        _ name: String,
        prefix: String? = nil,
        URI: String? = nil,
        namespaces: [Namespace]? = nil,
        attributes: [Attribute]? = nil,
        childs: [XMPPElement]? = nil,
        text: String? = nil,
        omitClosingTag: Bool = false
    ) {
        self.name = name
        self.prefix = prefix
        self.URI = URI
        self.namespaces = namespaces
        self.attributes = attributes
        self.childs = childs
        self.text = text
        self.omitClosingTag = omitClosingTag
    }
}
