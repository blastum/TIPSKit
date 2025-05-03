//
//  Test.swift
//  TIPSKit
//
//  Created by James Blasius on 4/29/25.
//

import FetchKit
import Testing
import TIPSKit

struct TestTIPSRequestForSummary {
    enum Err: Error {
        case badResult
    }

    @Test func testRequestForSummary() async throws {
        let service = NetworkService()
        let request = TIPSRequest.summary2()

        let result = await service.fetch(request)

        if case let .summary2(tips) = try result.get() {
            #expect(!tips.isEmpty)
            print(tips)
        } else {
            throw Err.badResult
        }
    }

    @Test func testRequestForDetail() async throws {
        let service = NetworkService()
        let request = TIPSRequest.detail2()

        let result = await service.fetch(request)

        if case let .detail2(details) = try result.get() {
            #expect(!details.isEmpty)
            print(details)
        } else {
            throw Err.badResult
        }
    }

    @Test func testSummaryRequestWithFilter() async throws {
        let service = NetworkService()
        let filter: Filter<TIPSSummary.CodingKeys> = .equal(._cusip, "912810RA8")
        let request = TIPSRequest.summary2(filters: [filter])

        let result = await service.fetch(request)

        if case let .summary2(tips) = try result.get() {
            #expect(!tips.isEmpty)
            #expect(tips.allSatisfy { $0.cusip == "912810RA8" })
            print(tips)
        } else {
            throw Err.badResult
        }
    }

    @Test func testSummaryRequestWithSort() async throws {
        let service = NetworkService()
        let sort: Sort<TIPSSummary.CodingKeys> = .desc(._maturityDate)
        let request = TIPSRequest.summary2(sort: [sort], pageSize: 10)

        let result = await service.fetch(request)

        if case let .summary2(tips) = try result.get() {
            #expect(!tips.isEmpty)
            let dates = tips.compactMap(\.maturityDate)
            #expect(dates == dates.sorted(by: >))
            print(dates)
        } else {
            throw Err.badResult
        }
    }
}
