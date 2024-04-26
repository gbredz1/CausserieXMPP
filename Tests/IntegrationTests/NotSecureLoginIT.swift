//
//  NotSecureLoginIT.swift
//
//
//  Created by Guillaume on 26/04/2024.
//

import XCTest

final class NotSecureLoginIT: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testConnectionSuccess() throws {
        throw XCTSkip("Not ready")

        // 1 - Open socket connection -> wait for connection ready event
        // 2 - C: XMPP <stream:stream>
        // 3 - S: XMPP <stream:stream>
        // 4 - S: XMPP <stream:features/>
        // 5 - C: XMPP <auth/> with PLAIN mechanism
        // 6 - S: XMPP <success/>
        // 7 - C: XMPP <stream:stream>
        // 8 - S: XMPP <stream:stream>
        // 9 - S: XMPP <stream:features/>
    }
}
