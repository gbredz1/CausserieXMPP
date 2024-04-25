//
//  String+base64.swift
//
//
//  Created by Guillaume on 21/12/2023.
//

import Foundation

extension String {
    public func base64Encoded() -> String? {
        data(using: .utf8)?.base64EncodedString()
    }

    public func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
