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

    // Output
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init(fetchUseCase: FetchUsersUseCaseProtocol) {
        self.fetchUseCase = fetchUseCase
    }

    func fetchUsers() {
        isLoading = true
        errorMessage = nil

        fetchUseCase.execute()
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