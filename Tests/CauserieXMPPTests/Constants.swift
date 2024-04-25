//
//  Constants.swift
//
//
//  Created by Guillaume on 21/12/2023.
//

import Foundation

@testable import CauserieXMPP

public enum Constants {
    static let streamHeaderResponseXML = """
        <?xml version='1.0'?>
        <stream:stream
             from='im.example.com'
             id='++TR84Sm6A3hnt3Q065SnAbbk3Y='
             to='juliet@im.example.com'
             version='1.0'
             xml:lang='en'
             xmlns='jabber:client'
             xmlns:stream='http://etherx.jabber.org/streams'>
        """

    static let streamHeaderResponse = SAXElement(
        name: "stream",
        prefix: "stream",
        URI: "http://etherx.jabber.org/streams",
        namespaces: [
            SAXNamespace(URI: "jabber:client"),
            SAXNamespace(prefix: "stream", URI: "http://etherx.jabber.org/streams"),
        ],
        attributes: [
            SAXAttribute(localname: "from", value: "im.example.com"),
            SAXAttribute(localname: "id", value: "++TR84Sm6A3hnt3Q065SnAbbk3Y="),
            SAXAttribute(localname: "to", value: "juliet@im.example.com"),
            SAXAttribute(localname: "version", value: "1.0"),
            SAXAttribute(
                localname: "lang",
                prefix: "xml",
                URI: "http://www.w3.org/XML/1998/namespace",
                value: "en"
            ),
        ]
    )

    static let serverFeaturesString = """
        <stream:features>
            <mechanisms xmlns='urn:ietf:params:xml:ns:xmpp-sasl'>
                <mechanism>DIGEST-MD5</mechanism>
                <mechanism>PLAIN</mechanism>
                <mechanism>SCRAM-SHA-512</mechanism>
                <mechanism>SCRAM-SHA-256</mechanism>
                <mechanism>SCRAM-SHA-1</mechanism>
                <mechanism>X-OAUTH2</mechanism>
            </mechanisms>
        </stream:features>
        """
}
