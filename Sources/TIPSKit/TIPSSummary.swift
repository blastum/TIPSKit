//
//  TipsSummary.swift
//  TIPSKit
//
//  Created by James Blasius on 4/29/25.
//

import Foundation

public struct TIPSSummary: Decodable {
    private let _additionalIssueDate: String?
    private let _cusip: String
    private let _datedDate: String?
    private let _interestRate: String?
    private let _maturityDate: String?
    private let _originalAuctionDate: String?
    private let _originalIssueDate: String?
    private let _refCpiOnDatedDate: String?
    private let _securityTerm: String?
    private let _series: String?

    public var additionalIssueDate: Date? { _additionalIssueDate?.date }
    public var cusip: String { _cusip }
    public var datedDate: Date? { _datedDate?.date }
    public var interestRate: Double? { _interestRate?.double }
    public var maturityDate: Date? { _maturityDate?.date }
    public var originalAuctionDate: Date? { _originalAuctionDate?.date }
    public var originalIssueDate: Date? { _originalIssueDate?.date }
    public var refCpiOnDatedDate: Double? { _refCpiOnDatedDate?.double }
    public var securityTerm: Int? { _securityTerm?.int }
    public var series: String? { _series }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case _additionalIssueDate = "additional_issue_date"
        case _cusip = "cusip"
        case _datedDate = "dated_date"
        case _interestRate = "interest_rate"
        case _maturityDate = "maturity_date"
        case _originalAuctionDate = "original_auction_date"
        case _originalIssueDate = "original_issue_date"
        case _refCpiOnDatedDate = "ref_cpi_on_dated_date"
        case _securityTerm = "security_term"
        case _series = "series"
    }
}
