//
//  UserRepository.swift
//  SwiftUserApiDemo
//
//  Created by C-Tom Chen on 2025/9/17.
//

import Foundation
import Combine

protocol UserRepository {
    func getUsers() -> AnyPublisher<[User], Error>
}
