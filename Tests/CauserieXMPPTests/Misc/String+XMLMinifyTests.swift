//
//  StringXMLMinifyTests.swift
//
//
//  Created by Guillaume on 25/04/2024.
//
import XCTest

@testable import CauserieXMPP

final class StringXMLMinifyTests: XCTestCase {
    let array = [
        (
            """
            <iq type="set" id="bind_1">
                <bind xmlns="urn:ietf:params:xml:ns:xmpp-bind">
                    <resource>swift</resource>
                </bind>
            </iq>
            """,
            "<iq type=\"set\" id=\"bind_1\">"
                + "<bind xmlns=\"urn:ietf:params:xml:ns:xmpp-bind\">"
                + "<resource>swift</resource></bind></iq>"
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
            "<stream:stream from=\"im.example.com\" id=\"++TR84Sm6A3hnt3Q065SnAbbk3Y=\" "
                + "to=\"juliet@im.example.com\" version=\"1.0\" xml:lang=\"en\" "
                + "xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\">"
        ),
    ]

    func testMinify() {

        for (xmlString, expected) in array {
            let result = xmlString.xmlStringMinify()
            XCTAssertEqual(result, expected, "Not equals:\n\(result)\n\(expected)")
        }
    }
}
