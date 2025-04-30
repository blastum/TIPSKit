//
//  DateFormatterExtensions.swift
//  TIPSKit
//
//  Created by James Blasius on 4/29/25.
//

import Foundation

public extension DateFormatter {
    nonisolated(unsafe) static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
}
