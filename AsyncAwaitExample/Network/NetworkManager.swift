//
//  NetworkManager.swift
//  AsyncAwaitExample
//
//  Created by SeungMin on 12/31/23.
//

import Foundation

enum TargetType {
    case getUsers
    case getPosts
    
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case update = "UPDATE"
        case delete = "DELETE"
    }
    
    var urlString: String {
        switch self {
        case .getUsers:
            return "https://koreanjson.com/users"
        case .getPosts:
            return "https://koreanjson.com/posts"
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .getUsers:
            return .get
        case .getPosts:
            return .get
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case badConnection
    case invalidResponse
    case requestFailed
    case requestTimeout
    case noData
    case decodingError
    case unknown
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .badConnection:
            return "Bad Connection"
        case .invalidResponse:
            return "Invalid Response"
        case .requestFailed:
            return "Network request failed"
        case .requestTimeout:
            return "Request timed out."
        case .noData:
            return "No data received"
        case .decodingError:
            return "Error decoding data"
        default:
            return "Unknown Error"
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func request<T: Decodable>(requestType: TargetType, completion: @escaping (Result<[T], NetworkError>) -> ()) async throws {
        guard let url = URL(string: requestType.urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let headers = [
            "Accept": "application/json",
            "Authorization": "Test"
        ]
        
        let request = NSMutableURLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = requestType.httpMethod.rawValue
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await URLSession.shared.data(for: request as URLRequest)
        
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            completion(.failure(.invalidResponse))
            return
        }
        
        guard !data.isEmpty else {
            completion(.failure(.noData))
            return
        }
        
        do {
            let data = try JSONDecoder().decode([T].self, from: data)
            completion(.success(data))
        } catch {
            completion(.failure(.decodingError))
        }
    }
}
