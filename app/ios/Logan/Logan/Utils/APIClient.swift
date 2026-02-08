//
//  APIClient.swift
//  Logan
//
//  Created by jon on 2/7/26.
//

import Foundation


enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .httpStatus(let code):
            return "Server returned HTTP \(code)."
        case .decoding(let err):
            return "Failed to decode response: \(err.localizedDescription)"
        }
    }
}

final class APIClient {
    static let shared = APIClient(
        baseURL: URL(string: "")!
    )

    private let baseURL: URL
    private let session: URLSession

    private init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    // MARK: - Get request helper
    // T is the type we want to be decoded
    func get<T: Decodable>(_ path: String) async throws -> T {
        // build full url
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw APIError.invalidURL
        }
        
        // create url request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // perform request
        let (data, response) = try await session.data(for: request)
        
        // validate
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            throw APIError.httpStatus(http.statusCode)
        }
        
        // Decode JSON into T
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Raw response: \(String(data: data, encoding: .utf8) ?? "<non-utf8>")")
            throw APIError.decoding(error)
        }
    }
}

struct APIResponse<Item: Decodable>: Decodable {
    let ok: Bool
    let item: Item?
    let error: String?
}

extension APIClient {
    /// GETs `{ ok, item }` and returns the decoded `item`.
    func getItem<T: Decodable>(_ path: String) async throws -> T {
        let response: APIResponse<T> = try await get(path)
        guard response.ok, let item = response.item else {
            throw APIError.invalidResponse
        }
        return item
    }
}
