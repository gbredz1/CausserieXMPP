//
//  Logger+Label.swift
//
//
//  Created by Guillaume on 20/12/2023.
//

import Foundation
@_exported import os

extension Logger {
    public static let subsystem = "fr.gbredz1.CauserieXMPP"

    public init(label: String) {
        self.init(subsystem: Logger.subsystem, category: label)
    }

    public init(for type: (some Any).Type) {
        self.init(label: String(describing: type))
    }
}
