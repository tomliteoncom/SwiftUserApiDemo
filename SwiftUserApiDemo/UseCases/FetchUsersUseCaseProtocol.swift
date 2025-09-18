//
//  FetchUsersUseCaseProtocol.swift
//  SwiftUserApiDemo
//
//  Created by C-Tom Chen on 2025/9/17.
//


import Foundation
import Combine

protocol FetchUsersUseCaseProtocol {
    func execute() -> AnyPublisher<[User], Error>
}

final class FetchUsersUseCase: FetchUsersUseCaseProtocol {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[User], Error> {
        return repository.getUsers()
    }
}