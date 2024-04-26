//
//  StringXMLMinify.swift
//
//
//  Created by Guillaume on 25/04/2024.
//

import Foundation

extension String {

    /// buggy only for testing
    public func xmlStringMinify() -> String {
        self.components(separatedBy: .newlines).map {
            $0.trimmingCharacters(in: .whitespaces).appending(" ")
        }.joined()
            .replacingOccurrences(of: "> <", with: "><")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
