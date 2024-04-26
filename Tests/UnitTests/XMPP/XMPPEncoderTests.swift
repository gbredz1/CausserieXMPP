//
//  XMPPEncoderTests.swift
//
//
//  Created by Guillaume on 25/04/2024.
//

import XCTest

@testable import CauserieXMPP

final class XMPPEncoderTests: XCTestCase {
    let arrays = [
        (
            """
            <iq id="bind_1" type="set">
                <bind xmlns="urn:ietf:params:xml:ns:xmpp-bind"/>
            </iq>
            """,
            XMPPElement(
                "iq",
                attributes: [
                    XMPPElement.Attribute("id", value: "bind_1"),
                    XMPPElement.Attribute("type", value: "set"),
                ],
                childs: [
                    XMPPElement(
                        "bind",
                        namespaces: [XMPPElement.Namespace("urn:ietf:params:xml:ns:xmpp-bind")])
                ]
            )
        ),
        (
            """
            <iq type="set" id="bind_1">
                <bind xmlns="urn:ietf:params:xml:ns:xmpp-bind">
                    <resource>swift</resource>
                </bind>
            </iq>
            """,
            XMPPElement(
                "iq",
                attributes: [
                    XMPPElement.Attribute("type", value: "set"),
                    XMPPElement.Attribute("id", value: "bind_1"),
                ],
                childs: [
                    XMPPElement(
                        "bind",
                        namespaces: [XMPPElement.Namespace("urn:ietf:params:xml:ns:xmpp-bind")],
                        childs: [
                            XMPPElement("resource", text: "swift")
                        ])
                ])
        ),
        (
            """
            <stream:stream
                 from="im.example.com"
                 id="++TR84Sm6A3hnt3Q065SnAbbk3Y="
                 to="juliet@im.example.com"
                 version="1.0"
                 xml:lang="en"
                 xmlns="jabber:client"
                 xmlns:stream="http://etherx.jabber.org/streams">
            """,
            XMPPElement(
                "stream", prefix: "stream",
                namespaces: [
                    XMPPElement.Namespace("jabber:client"),
                    XMPPElement.Namespace(prefix: "stream", "http://etherx.jabber.org/streams"),
                ],
                attributes: [
                    XMPPElement.Attribute("from", value: "im.example.com"),
                    XMPPElement.Attribute("id", value: "++TR84Sm6A3hnt3Q065SnAbbk3Y="),
                    XMPPElement.Attribute("to", value: "juliet@im.example.com"),
                    XMPPElement.Attribute("version", value: "1.0"),
                    XMPPElement.Attribute("lang", prefix: "xml", value: "en"),
                ],
                omitClosingTag: true)
        ),
    ]

    func testEncodeStanza() throws {
        let encoder = XMPPElementEncoder()

        for (xmlString, stanza) in arrays {
            let result = encoder.encode(stanza)
            let expected = xmlString.xmlStringMinify()
            XCTAssertEqual(result, expected, "Not equals:\n\(result)\n\(expected)")
        }

    }
}
