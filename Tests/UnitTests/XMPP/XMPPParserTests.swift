import XCTest

@testable import CauserieXMPP

final class XMPPParserTests: XCTestCase {
    class MockXMPPParserDelegate: XMPPParserDelegate {
        var mEvent: (_ event: XMPPEvent) -> Void = { _ in }
        func event(_ event: XMPPEvent) { mEvent(event) }
    }

    let parser = XMPPParser()
    let mockDelegate = MockXMPPParserDelegate()

    override func setUpWithError() throws {
        parser.delegate = mockDelegate
    }

    func testResponseStreamHeader() {
        let expectation = XCTestExpectation(description: "Wait for response")

        mockDelegate.mEvent = { event in
            debugPrint("\(event)")

            expectation.fulfill()
        }

        parser.start(Constants.streamHeaderResponse)

        wait(for: [expectation], timeout: 0.1)
    }
}
