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
//    private let usersURL = URL(string: "https://jsonplaceholder.typicode.com/users")!
    private let usersURL = URL(string: "http://127.0.0.1:5000/users")!

    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }

    func getUsers() -> AnyPublisher<[User], Error> {
        return client.fetch(usersURL)
    }

    // 定時更新 users。訂閱時會先立即抓一次，之後按照 interval 觸發。
    // 若上一個請求尚未完成就到下一次間隔，會取消前一個請求以避免重疊（switchToLatest）。
    func observeUsers(every interval: TimeInterval, on scheduler: RunLoop) -> AnyPublisher<[User], Error> {
        let timer = Timer.publish(every: interval, on: scheduler, in: .common).autoconnect()

        // 先立即觸發一次，再由計時器持續觸發
        let immediate = Just(Date()).setFailureType(to: Error.self)

        return Publishers.Merge(immediate, timer.map { _ in Date() }.setFailureType(to: Error.self))
            .map { _ in
                // 每次觸發都建立一次 API 呼叫的 Publisher
                self.client.fetch(self.usersURL) as AnyPublisher<[User], Error>
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}
