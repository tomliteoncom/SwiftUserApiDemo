//
//  UserDetailViewController.swift
//  SwiftUserApiDemo
//
//  Created by C-Tom Chen on 2025/9/17.
//


import UIKit

final class UserDetailViewController: UIViewController {
    private let user: User

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = user.username
        setupUI()
    }

    private func setupUI() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false

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

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}