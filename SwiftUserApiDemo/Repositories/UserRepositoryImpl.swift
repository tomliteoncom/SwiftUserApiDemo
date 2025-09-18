//
//  UserRepositoryImpl.swift
//  SwiftUserApiDemo
//
//  Created by C-Tom Chen on 2025/9/17.
//

// UserRepositoryImpl.swift
import Foundation
import Combine

final class UserRepositoryImpl: UserRepository {
    private let client: APIClientProtocol
    private let usersURL = URL(string: "https://jsonplaceholder.typicode.com/users")!

    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }

    func getUsers() -> AnyPublisher<[User], Error> {
        return client.fetch(usersURL)
    }
}
