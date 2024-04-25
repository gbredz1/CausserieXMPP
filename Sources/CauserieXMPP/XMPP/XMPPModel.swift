//
//  XMPPModel.swift
//
//
//  Created by Guillaume on 20/12/2023.
//

import Foundation

struct XMLNode {
    let attributes: [XMLAttribute]?
    let value: String
}

struct XMLAttribute {
    let name: String
    let prefix: String?
    let URI: String?
    let value: String
}

struct XMLNamespace {
    let prefix: String
    let URI: String
}

struct XMPPStream {
    let attributes: [XMLAttribute]?
    let namespaces: [XMLNamespace]?
}
