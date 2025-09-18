//
//  APIClient.swift
//  SwiftUserApiDemo
//
//  Created by C-Tom Chen on 2025/9/17.
//
import Foundation
import Combine

protocol APIClientProtocol {
    func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error>
}

final class APIClient: APIClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
