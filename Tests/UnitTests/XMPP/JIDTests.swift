//
//  JIDTests.swift
//
//
//  Created by Guillaume on 26/04/2024.
//

import XCTest

@testable import CauserieXMPP

final class JIDTests: XCTestCase {

    func testParseValideJid() {
        let array = [
            (#"juliet@example.com"#, JID(local: "juliet", domain: "example.com")),
            (#"juliet@example.com/foo"#, JID(local: "juliet", domain: "example.com", resource: "foo")),
            (#"juliet@example.com/foo bar"#, JID(local: "juliet", domain: "example.com", resource: "foo bar")),
            (#"juliet@example.com/foo@bar"#, JID(local: "juliet", domain: "example.com", resource: "foo@bar")),
            (#"foo bar@example.com"#, JID(local: #"foo bar"#, domain: "example.com")),
            (#"fussball@example.com"#, JID(local: "fussball", domain: "example.com")),
            (#"fußball@example.com"#, JID(local: "fußball", domain: "example.com")),
            (#"π@example.com"#, JID(local: "π", domain: "example.com")),
            (#"Σ@example.com/foo"#, JID(local: "Σ", domain: "example.com", resource: "foo")),
            (#"σ@example.com/foo"#, JID(local: "σ", domain: "example.com", resource: "foo")),
            (#"ς@example.com/foo"#, JID(local: "ς", domain: "example.com", resource: "foo")),
            (#"king@example.com/♚"#, JID(local: "king", domain: "example.com", resource: "♚")),
            (#"example.com"#, JID(domain: "example.com")),
            (#"example.com/foobar"#, JID(domain: "example.com", resource: "foobar")),
            (#"a.example.com/b@example.net"#, JID(domain: "a.example.com", resource: "b@example.net")),
        ]

        for (str, jid) in array {
            XCTAssertEqual(JID(str), jid)
        }
    }

    func testValideJid() {
        let array = [
            #"juliet@example.com"#,
            #"juliet@example.com/foo"#,
            #"juliet@example.com/foo bar"#,
            #"juliet@example.com/foo@bar"#,
            #"foo bar@example.com"#,
            #"fussball@example.com"#,
            #"fußball@example.com"#,
            #"π@example.com"#,
            #"Σ@example.com/foo"#,
            #"σ@example.com/foo"#,
            #"ς@example.com/foo"#,
            #"king@example.com/♚"#,
            #"example.com"#,
            #"example.com/foobar"#,
            #"a.example.com/b@example.net"#,
        ]

        for str in array {
            XCTAssertNotNil(JID(str), "\(str) is a valid JID")
        }
    }

    func testInvalidJid() {
        let character: Character = "П"
        print("\(character.isSymbol)")
        
        let array = [
            #"juliet"@example.com"#,
            #"juliet@example.com/ foo"#,
            #"@example.com/"#,
            #"henriⅣ@example.com"#,
            #"♚@example.com"#,
            #"juliet@"#,
            #"/foobar"#,
        ]

        for str in array {
            XCTAssertNil(JID(str), "\(str) is not a valid JID")
        }
    }
}
