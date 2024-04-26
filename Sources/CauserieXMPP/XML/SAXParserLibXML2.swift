//
//  SAXParserLibXML2.swift
//
//
//  Created by Guillaume on 20/12/2023.
//

import Foundation
import libxml2

/// SAXParser implementation with LibXML2 wrapper
public class SAXParserLibXML2 {
    private let logger = Logger(for: SAXParser.self)

    private var saxHandler: xmlSAXHandler
    private var ctxt: xmlParserCtxtPtr?
    public var delegate: SAXParserDelegate?

    public init() {
        saxHandler = xmlSAXHandler(
            internalSubset: nil,
            isStandalone: nil,
            hasInternalSubset: nil,
            hasExternalSubset: nil,
            resolveEntity: nil,
            getEntity: nil,
            entityDecl: nil,
            notationDecl: nil,
            attributeDecl: nil,
            elementDecl: nil,
            unparsedEntityDecl: nil,
            setDocumentLocator: nil,
            startDocument: nil,
            endDocument: nil,
            startElement: nil,
            endElement: nil,
            reference: nil,
            characters: libxml2Characters,
            ignorableWhitespace: nil,
            processingInstruction: nil,
            comment: nil,
            warning: nil,
            error: nil,
            fatalError: nil,
            getParameterEntity: nil,
            cdataBlock: nil,
            externalSubset: nil,
            initialized: XML_SAX2_MAGIC,
            _private: nil,
            startElementNs: libxml2StartElementNs,
            endElementNs: libxml2EndElementNs,
            serror: nil)

        ctxt = xmlCreatePushParserCtxt(
            &saxHandler, Unmanaged.passUnretained(self).toOpaque(), nil, 0, nil)
    }

    deinit {
        xmlFreeParserCtxt(ctxt)
        ctxt = nil
    }

    private let libxml2Characters: charactersSAXFunc = { ctx, value, len in
        let myself = unsafeBitCast(ctx, to: SAXParserLibXML2.self)

        if let value = value?.toString(len: len) {
            myself.delegate?.characters(value)
        }
    }

    private let libxml2StartElementNs: startElementNsSAX2Func =
        { ctx, localname, prefix, URI, nbNamespaces, namespaces, nbAttributes, _, attributes in
            // swiftlint:disable:previous opening_brace
            let myself = unsafeBitCast(ctx, to: SAXParserLibXML2.self)
            let element = SAXElement(
                name: localname?.toString() ?? "",
                prefix: prefix?.toString(),
                URI: URI?.toString(),
                namespaces: namespaces?.toNamespaces(count: nbNamespaces),
                attributes: attributes?.toAttributes(count: nbAttributes))
            myself.delegate?.start(element)
        }

    private let libxml2EndElementNs: endElementNsSAX2Func = { ctx, localname, prefix, URI in
        let myself = unsafeBitCast(ctx, to: SAXParserLibXML2.self)
        let element = SAXElement(
            name: localname?.toString() ?? "",
            prefix: prefix?.toString(),
            URI: URI?.toString(),
            namespaces: nil,
            attributes: nil)
        myself.delegate?.end(element)
    }
}

extension SAXParserLibXML2: SAXParser {
    public func feed(_ data: Data) {
        data.withUnsafeBytes {
            let res = xmlParseChunk(ctxt, $0.baseAddress, Int32(data.count), 0)

            logger.debug("feed(\(data.count)) -> res:\(res)")
        }
    }

    public func reset() {
        xmlFreeParserCtxt(ctxt)
        ctxt = xmlCreatePushParserCtxt(
            &saxHandler, Unmanaged.passUnretained(self).toOpaque(), nil, 0, nil)
    }
}

extension UnsafePointer<xmlChar> {
    func toString() -> String {
        String(cString: self)
    }

    func toString(end: UnsafePointer<xmlChar>?) -> String {
        if let end {
            let string = toString()
            return String(string.prefix(string.count - end.toString().count))
        }

        return toString()
    }

    func toString(len: Int32) -> String {
        String(decoding: Data(bytes: UnsafePointer<UInt8>(self), count: Int(len)), as: UTF8.self)
    }
}

extension UnsafeMutablePointer<UnsafePointer<xmlChar>?> {
    private struct Libxml2Attribute {
        let localname: UnsafePointer<xmlChar>?
        let prefix: UnsafePointer<xmlChar>?
        let URI: UnsafePointer<xmlChar>?
        let value: UnsafePointer<xmlChar>?
        let end: UnsafePointer<xmlChar>?
    }

    func toAttributes(count: Int32) -> [SAXAttribute]? {
        let count = Int(count)
        var result = [SAXAttribute]()

        withMemoryRebound(to: Libxml2Attribute.self, capacity: count) { pointer in
            for idx in 0..<count {
                let ptr = (pointer + idx).pointee

                let localname = ptr.localname?.toString() ?? ""
                let prefix = ptr.prefix?.toString()
                let URI = ptr.URI?.toString()
                let value = ptr.value?.toString(end: ptr.end) ?? ""

                result.append(
                    SAXAttribute(
                        localname: localname,
                        prefix: prefix,
                        URI: URI,
                        value: value))
            }
        }
        return result.isEmpty ? nil : result
    }

    struct Libxml2Namespace {
        let prefix: UnsafePointer<xmlChar>?
        let URI: UnsafePointer<xmlChar>?
    }

    func toNamespaces(count: Int32) -> [SAXNamespace]? {
        let count = Int(count)
        var result = [SAXNamespace]()

        withMemoryRebound(to: Libxml2Namespace.self, capacity: count) { pointer in
            for idx in 0..<count {
                let ptr = (pointer + idx).pointee

                let prefix = ptr.prefix?.toString()
                let URI = ptr.URI?.toString() ?? ""

                result.append(SAXNamespace(prefix: prefix, URI: URI))
            }
        }
        return result.isEmpty ? nil : result
    }
}
