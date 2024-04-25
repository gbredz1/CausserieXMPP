import XCTest

@testable import CauserieXMPP

final class SAXParserLibXML2Tests: XCTestCase {
    class MockSAXParserDelegate: SAXParserDelegate {
        var mStart: (_ element: CauserieXMPP.SAXElement) -> Void = { _ in }
        func start(_ element: CauserieXMPP.SAXElement) { mStart(element) }

        var mCharacters: (String) -> Void = { _ in }
        func characters(_ value: String) { mCharacters(value) }

        var mEnd: (_ element: CauserieXMPP.SAXElement) -> Void = { _ in }
        func end(_ element: CauserieXMPP.SAXElement) { mEnd(element) }
    }

    let parser = SAXParserLibXML2()
    let mockDelegate = MockSAXParserDelegate()

    override func setUpWithError() throws {
        parser.delegate = mockDelegate
    }

    func testParseExemple() throws {
        let expectation = XCTestExpectation(description: "Wait for response")

        var elementStarted = false
        var body = ""
        var id: String?
        var lang: String?
        var langPrefix: String?
        var langURI: String?
        var namespacePrefix: String?
        var namespaceURI: String?

        mockDelegate.mStart = { elt in
            debugPrint("\(elt)")
            guard elt.name == "root", elt.prefix == "xx" else { return }

            elementStarted = true

            id = elt.attributes?.get("id")?.value
            if let attr = elt.attributes?.get("lang") {
                lang = attr.value
                langPrefix = attr.prefix
                langURI = attr.URI
            }

            if let namespace = elt.namespaces?.get() {
                namespaceURI = namespace.URI
                namespacePrefix = namespace.prefix
            }
        }
        mockDelegate.mCharacters = { value in
            guard elementStarted else { return }
            body.append(value)
        }
        mockDelegate.mEnd = { elt in
            guard elt.name == "root", elt.prefix == "xx" else { return }
            elementStarted = false
            expectation.fulfill()
        }

        parser.feed(
            """
            <?xml version="1.0"?>
            <root xmlns:xx="http://local.dev">
                <xx:root id="123" xx:lang="en" xmlns='app:client'>data</xx:root>
            </root>
            """)

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual("data", body)
        XCTAssertEqual("123", id)
        XCTAssertEqual("en", lang)
        XCTAssertEqual("xx", langPrefix)
        XCTAssertEqual("http://local.dev", langURI)
        XCTAssertEqual("app:client", namespaceURI)
        XCTAssertEqual(nil, namespacePrefix)
    }

    func testParseMultipleFeed() throws {
        let expectation = XCTestExpectation(description: "Wait for response")

        var elementStarted = false
        var body = ""
        var id: String?
        var lang: String?
        var langPrefix: String?
        var langURI: String?

        mockDelegate.mStart = { elt in
            debugPrint("\(elt)")
            guard elt.name == "root", elt.prefix == "xx" else { return }

            elementStarted = true

            id = elt.attributes?.get("id")?.value
            if let attr = elt.attributes?.get("lang") {
                lang = attr.value
                langPrefix = attr.prefix
                langURI = attr.URI
            }
        }
        mockDelegate.mCharacters = { value in
            guard elementStarted else { return }
            body.append(value)
        }
        mockDelegate.mEnd = { elt in
            guard elt.name == "root", elt.prefix == "xx" else { return }
            elementStarted = false
            expectation.fulfill()
        }

        parser.feed("<?xml version='1.0'?>")
        parser.feed("<root xmlns:xx='http://lo")
        parser.feed("cal.dev'><xx:root id='1")
        parser.feed("23' xx:lang='en'>data ")
        parser.feed("123456789 da")
        parser.feed("ta</xx:root></root>")

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual("data 123456789 data", body)
        XCTAssertEqual("123", id)
        XCTAssertEqual("en", lang)
        XCTAssertEqual("xx", langPrefix)
        XCTAssertEqual("http://local.dev", langURI)
    }

    func testResponseStreamHeader() throws {
        let expectation = XCTestExpectation(description: "Wait for response")

        var element: SAXElement?
        mockDelegate.mStart = { elt in
            element = elt
            expectation.fulfill()
        }

        parser.feed(Constants.streamHeaderResponseXML)

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(Constants.streamHeaderResponse, element)
    }
}
