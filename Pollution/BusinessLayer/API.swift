//
//  API.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 7/20/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ParametersEncoding {
    case url
    case json
}

class SessionProvider {
    private var session: URLSession
    private let baseURL = URL(string: "https://api.waqi.info")!

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func request<T: Decodable>(_ path: String,
                               parameters: [String: Any] = [:],
                               method: HTTPMethod = .get,
                               parametersEncoding: ParametersEncoding = .url,
                               headers: [String: String] = [:],
                               completion: @escaping (Result<T, Error>) -> Void) {
        let url = baseURL.appendingPathComponent(path)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        if parametersEncoding == .url {
            urlComponents.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
            let token = URLQueryItem(name: "token", value: "79e8b2070a25a21adfe0d7c13da50875b89ffc50")
            urlComponents.queryItems?.append(token)
        }

        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = method.rawValue
        headers.forEach {
            urlRequest.addValue($0.key, forHTTPHeaderField: $0.value)
        }
        if parametersEncoding == .json {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }

        let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            let httpResponse = response as? HTTPURLResponse
            self?.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
        }
        task.resume()
    }

    private func handleDataResponse<T: Decodable>(data: Data?,
                                                  response: HTTPURLResponse?,
                                                  error: Error?,
                                                  completion: (Result<T, Error>) -> Void) {
        guard error == nil else { return completion(.failure(NetworkError.unknown)) }
        guard let response = response else { return completion(.failure(NetworkError.unknown)) }

        switch response.statusCode {
        case 200 ... 299:
            guard let data = data, let model = try? data.decoded() as T else {
                completion(.failure(NetworkError.unknown))
                return
            }
            completion(.success(model))
        default:
            completion(.failure(NetworkError.unknown))
        }
    }
}

enum NetworkError: Error {
    case unknown
}

private extension Data {
    func decoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}
