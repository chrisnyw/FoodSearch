//
//  WebRepository.swift
//  FoodSearchSwiftUI
//
//  Created by Chris Ng on 2025-01-31.
//  Copyright © 2025 Chris Ng. All rights reserved.
//

import Foundation
import Combine

enum ApiModel { }

protocol WebRepository {
    var session: URLSession { get }
    var baseURL: String { get }
}

extension WebRepository {
    func call<Value, Decoder>(
        endpoint: APICall,
        decoder: Decoder = JSONDecoder(),
        httpCodes: HTTPCodes = .success
    ) async throws -> Value
    where Value: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {

        let request = try endpoint.urlRequest(baseURL: baseURL)
        print("Full request: \(request)")
        let (data, response) = try await self.session.data(for: request)

        guard let code = (response as? HTTPURLResponse)?.statusCode else {
            print("Full response: \(response)")
            throw APIError.unexpectedResponse
        }
        guard httpCodes.contains(code) else {
            print("request body: \(String(describing: request.httpBody?.prettyPrintedJSONString))")
            print("Full response: \(response)")
            throw APIError.httpCode(code)
        }
        do {
            print("response data: \(data.prettyPrintedJSONString)")
            return try decoder.decode(Value.self, from: data)
        } catch {
            print("Failed to decode: \(error)")
            throw APIError.unexpectedResponse
        }
    }
}

// MARK: - APICall

protocol APICall {
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    func body() throws -> Data?
}

enum APIError: Swift.Error, Equatable {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageDeserialization
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server"
        case .imageDeserialization: return "Cannot deserialize image from Data"
        }
    }
}

extension APICall {
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        return request
    }
    
    func dictionaryToQueryString(dictionary: [String: Any]) -> String {
        var components: [String] = []
        
        for (key, value) in dictionary {
            if let stringValue = value as? String {
                let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
                let encodedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? stringValue
                components.append("\(encodedKey)=\(encodedValue)")
            } else if let intValue = value as? Int {
                let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
                components.append("\(encodedKey)=\(intValue)")
            }
        }
        
        return components.joined(separator: "&")
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}
