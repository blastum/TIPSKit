//
//  TIPSRequest.swift
//  TIPSKit
//
//  Created by James Blasius on 4/29/25.
//

import FetchKit
import Foundation

// MARK: - Filter

public enum Filter<Field: CodingKey> {
    case lt(Field, String)
    case lte(Field, String)
    case gt(Field, String)
    case gte(Field, String)
    case equal(Field, String)
    case `in`(Field, any Collection<String>)

    public func asQueryComponent() -> String {
        switch self {
        case let .lt(field, value): return "\(field.stringValue):lt:\(value)"
        case let .lte(field, value): return "\(field.stringValue):lte:\(value)"
        case let .gt(field, value): return "\(field.stringValue):gt:\(value)"
        case let .gte(field, value): return "\(field.stringValue):gte:\(value)"
        case let .equal(field, value): return "\(field.stringValue):eq:\(value)"
        case let .in(field, values): return "\(field.stringValue):in:(\(values.joined(separator: ",")))"
        }
    }
}

// MARK: - Sort

public enum Sort<Field: CodingKey> {
    case asc(Field)
    case desc(Field)

    public func asQueryComponent() -> String {
        switch self {
        case let .asc(field): return field.stringValue
        case let .desc(field): return "-\(field.stringValue)"
        }
    }
}

// MARK: - TIPSRequest

// documentation at https://fiscaldata.treasury.gov/api-documentation/#endpoints

@available(macOS 12.0, *)
public enum TIPSRequest: Endpoint {
    public typealias Output = TIPSResponse

    public typealias Failure = Error

    case summary(
        filters: (any Collection<Filter<TIPSSummary.CodingKeys>>)? = nil,
        sort: (any Collection<Sort<TIPSSummary.CodingKeys>>)? = nil,
        pageSize: Int? = nil,
        pageNumber: Int? = nil
    )

    case detail(
        filters: (any Collection<Filter<TIPSDetail.CodingKeys>>)? = nil,
        sort: (any Collection<Sort<TIPSDetail.CodingKeys>>)? = nil,
        pageSize: Int? = nil,
        pageNumber: Int? = nil
    )

    // MARK: Endpoint

    public var urlRequest: URLRequest {
        var components = URLComponents(url: Self.baseURL.appendingPathComponent(path),
                                       resolvingAgainstBaseURL: false)!
        components.queryItems = queryItems
        let url = components.url!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        return request
    }

    public func decode(_ result: Result<(Data, URLResponse), any Error>) -> Result<TIPSResponse, any Failure> {
        result.flatMap { data, _ in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return switch self {
            case .summary:
                decoder.decodeResult(ResponseWrapper<TIPSSummary>.self, from: data)
                    .map { .summary($0.data) }
            case .detail:
                decoder.decodeResult(ResponseWrapper<TIPSDetail>.self, from: data)
                    .map { .detail($0.data) }
            }
        }
    }

    // MARK: Plumbing

    private static let baseURL = URL(string: "https://api.fiscaldata.treasury.gov/services/api/fiscal_service")!
    private var path: String {
        switch self {
        case .summary:
            return "/v1/accounting/od/tips_cpi_data_summary"
        case .detail:
            return "/v1/accounting/od/tips_cpi_data_detail"
        }
    }

    private var queryItems: [URLQueryItem]? {
        let filtersItem: URLQueryItem? = {
            switch self {
            case let .summary(filters, _, _, _):
                filters
                    .map { $0.map { $0.asQueryComponent() }.joined(separator: ",") }
                    .flatMap { $0.isEmpty ? nil : URLQueryItem(name: "filter", value: $0) }

            case let .detail(filters, _, _, _):
                filters
                    .map { $0.map { $0.asQueryComponent() }.joined(separator: ",") }
                    .flatMap { $0.isEmpty ? nil : URLQueryItem(name: "filter", value: $0) }
            }
        }()

        let sortItem: URLQueryItem? = {
            switch self {
            case let .summary(_, sort, _, _):
                sort
                    .map { $0.map { $0.asQueryComponent() }.joined(separator: ",") }
                    .flatMap { $0.isEmpty ? nil : URLQueryItem(name: "sort", value: $0) }

            case let .detail(_, sort, _, _):
                sort
                    .map { $0.map { $0.asQueryComponent() }.joined(separator: ",") }
                    .flatMap { $0.isEmpty ? nil : URLQueryItem(name: "sort", value: $0) }
            }
        }()

        let pageSizeItem: URLQueryItem? = {
            switch self {
            case let .summary(_, _, pageSize, _),
                 let .detail(_, _, pageSize, _):
                pageSize.map { URLQueryItem(name: "page[size]", value: "\($0)") }
            }
        }()

        let pageNumberItem: URLQueryItem? = {
            switch self {
            case let .summary(_, _, _, pageNumber),
                 let .detail(_, _, _, pageNumber):
                return pageNumber.map { URLQueryItem(name: "page[number]", value: "\($0)") }
            }
        }()

        let allItems = [filtersItem, sortItem, pageSizeItem, pageNumberItem].compactMap { $0 }
        return allItems.isEmpty ? nil : allItems
    }
}

// MARK: - ResponseWrapper

private struct ResponseWrapper<T: Decodable>: Decodable {
    let data: [T]
}

// MARK: - JSONDecoder extension

private extension JSONDecoder {
    func decodeResult<T: Decodable>(_ type: T.Type, from data: Data) -> Result<T, Error> {
        Result { try self.decode(T.self, from: data) }
    }
}
