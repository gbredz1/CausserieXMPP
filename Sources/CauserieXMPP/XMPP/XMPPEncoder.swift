//
//  XMPPEncoder.swift
//
//
//  Created by Guillaume on 25/04/2024.
//

import Foundation

/// Encode XMPPElement to XML
public class XMPPElementEncoder {
    let logger = Logger(for: XMPPElementEncoder.self)
    let quote = "\""

    public func encode(_ stanza: XMPPElement) -> String {
        let prefix = if let prefix = stanza.prefix { prefix + ":" } else { "" }
        var string = "<\(prefix + stanza.name)"

        stanza.attributes?.forEach({ attribute in
            let prefix = if let prefix = attribute.prefix { prefix + ":" } else { "" }
            string += " \(prefix + attribute.localname)=\(addQuote(attribute.value))"
        })

        stanza.namespaces?.forEach({ namespace in
            let prefix = if let prefix = namespace.prefix { ":" + prefix } else { "" }
            string += " xmlns\(prefix)=\(addQuote(namespace.URI))"
        })

        if stanza.isEmpty && !stanza.omitClosingTag {
            string += "/>"
        } else {
            string += ">"

            stanza.childs?.forEach({ child in
                string += encode(child)
            })

            if let text = stanza.text {
                string += text
            }

            if !stanza.omitClosingTag {
                string += "</\(stanza.name)>"
            }
        }

        return string
    }

    private func addQuote(_ string: String) -> String { quote + string + quote }
}
