//
//  File.swift
//  TIPSKit
//
//  Created by James Blasius on 4/29/25.
//

import Foundation

extension String {
    var date: Date? {
        DateFormatter.iso8601.date(from: self)
    }

    var double: Double? {
        Double(self)
    }

    var int: Int? {
        Int(self)
    }
}
