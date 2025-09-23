//
//  UserDetailViewController.swift
//  SwiftUserApiDemo
//
//  Created by C-Tom Chen on 2025/9/17.
//


import UIKit
import Combine

final class UserDetailViewController: UIViewController {
    private var user: User
    private let userUpdates: AnyPublisher<User, Never>
    private var cancellables = Set<AnyCancellable>()
    
    // 讓我們可以在需要時重畫內容
    private let stack = UIStackView()

    init(initialUser: User, userUpdates: AnyPublisher<User, Never>) {
        self.user = initialUser
        self.userUpdates = userUpdates
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = user.username
        setupUI()
        render(with: user)
        
        // 訂閱使用者更新，停留期間即時更新畫面
        userUpdates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] latest in
                guard let self = self else { return }
                self.user = latest
                self.title = latest.username
                self.render(with: latest)
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func render(with user: User) {
        // 清空舊內容
        for v in stack.arrangedSubviews {
            stack.removeArrangedSubview(v)
            v.removeFromSuperview()
        }
        
        let lines: [String] = [
            "Name: \(user.name)",
            "Username: \(user.username)",
            "Email: \(user.email)",
            "Phone: \(user.phone)",
            "Website: \(user.website)",
            "\nAddress:",
            "  \(user.address.street) \(user.address.suite)",
            "  \(user.address.city) \(user.address.zipcode)",
            "\nCompany:",
            "  \(user.company.name)",
            "  \(user.company.catchPhrase)",
            "  \(user.company.bs)"
        ]

        for l in lines {
            let label = UILabel()
            label.numberOfLines = 0
            label.text = l
            stack.addArrangedSubview(label)
        }
    }
}
