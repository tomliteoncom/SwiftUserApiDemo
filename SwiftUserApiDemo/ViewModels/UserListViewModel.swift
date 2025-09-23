//
//  UserListViewModel.swift
//  SwiftUserApiDemo
//
//  Created by C-Tom Chen on 2025/9/17.
//


import Foundation
import Combine

final class UserListViewModel {
    // Input
    private let fetchUseCase: FetchUsersUseCaseProtocol
    // 保持對 repository 的強引用，確保 observeUsers 的計時/串流存活
    private let repository: UserRepository

    // Output
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init(fetchUseCase: FetchUsersUseCaseProtocol) {
        self.fetchUseCase = fetchUseCase
        self.repository = UserRepositoryImpl()
        
        // 每 30 秒更新一次，並且會在訂閱當下先抓一次
        repository.observeUsers(every: 30)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                // 若發生錯誤，串流會結束；需要的話可以在這裡重新訂閱
                print("observeUsers completion:", completion)
            }, receiveValue: { [weak self] users in
                // 指派到 Published，觸發 UI 更新
                self?.users = users
                print("latest users:", users.count)
            })
            .store(in: &cancellables)
        
        // 需要停止時，取消 cancellable 即可
    }

    func fetchUsers() {
        isLoading = true
        errorMessage = nil

        fetchUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] users in
                self?.users = users
            })
            .store(in: &cancellables)
    }
}
