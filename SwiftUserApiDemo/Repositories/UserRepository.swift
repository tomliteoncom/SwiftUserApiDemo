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

    // 以指定間隔定時取得最新 users。建議呼叫端保留 AnyCancellable 以便取消輪詢。
    func observeUsers(every interval: TimeInterval, on scheduler: RunLoop) -> AnyPublisher<[User], Error>
}

extension UserRepository {
    // 方便呼叫的預設排程（Main RunLoop）
    func observeUsers(every interval: TimeInterval) -> AnyPublisher<[User], Error> {
        observeUsers(every: interval, on: .main)
    }
}
