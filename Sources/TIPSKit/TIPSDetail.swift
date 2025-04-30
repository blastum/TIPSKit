//
//  File.swift
//  TIPSKit
//
//  Created by James Blasius on 4/29/25.
//

import Foundation

@available(macOS 12.0, *)
public struct TIPSDetail: Decodable {
    private let _cusip: String
    private let _originalIssueDate: String?
    private let _indexRatioDate: String?
    private let _referenceCpi: String?
    private let _dailyIndexRatio: String?
    private let _pdfLink: String?
    private let _xmlLink: String?

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case _cusip = "cusip"
        case _originalIssueDate = "original_issue_date"
        case _indexRatioDate = "index_date"
        case _referenceCpi = "ref_cpi"
        case _dailyIndexRatio = "index_ratio"
        case _pdfLink = "pdf_link"
        case _xmlLink = "xml_link"
    }

    public var cusip: String { _cusip }
    public var originalIssueDate: Date? { _originalIssueDate?.date }
    public var indexRatioDate: Date? { _indexRatioDate?.date }
    public var referenceCpi: Double? { _referenceCpi?.double }
    public var dailyIndexRatio: Double? { _dailyIndexRatio?.double }
    public var pdfLink: String? { _pdfLink }
    public var xmlLink: String? { _xmlLink }
}
