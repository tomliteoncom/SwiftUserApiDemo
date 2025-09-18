//
//  SceneFactory.swift
//  SwiftUserApiDemo
//
//  Created by C-Tom Chen on 2025/9/17.
//


import Foundation
import UIKit

struct SceneFactory {
    static func makeUserListScene() -> UIViewController {
        let repository = UserRepositoryImpl()
        let useCase = FetchUsersUseCase(repository: repository)
        let viewModel = UserListViewModel(fetchUseCase: useCase)
        let listVC = UserListViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: listVC)
        return nav
    }
}
