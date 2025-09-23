//
//  UserListViewController.swift
//  SwiftUserApiDemo
//
//  Created by C-Tom Chen on 2025/9/17.
//


import UIKit
import Combine

final class UserListViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let viewModel: UserListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // 右上角 Refresh 按鈕
    private lazy var refreshButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTapped))
    }()

    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupNavigationBar()
        bindViewModel()
        viewModel.fetchUsers()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = refreshButton
    }

    private func bindViewModel() {
        viewModel.$users
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .sink { [weak self] loading in
                guard let self = self else { return }
                if loading {
                    let indicator = UIActivityIndicatorView(style: .medium)
                    indicator.startAnimating()
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: indicator)
                } else {
                    // 載入結束時恢復 Refresh 按鈕
                    self.navigationItem.rightBarButtonItem = self.refreshButton
                }
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .sink { [weak self] message in
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }
    
    @objc private func refreshTapped() {
        viewModel.fetchUsers()
    }
}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = viewModel.users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = viewModel.users[indexPath.row]
        let selectedId = user.id
        
        // 建立「該使用者」的更新流，Detail 停留期間會持續收到最新值
        let userUpdates = viewModel.$users
            .compactMap { users in users.first(where: { $0.id == selectedId }) }
            .eraseToAnyPublisher()
        
        let detailVC = UserDetailViewController(
            initialUser: user,
            userUpdates: userUpdates
        )
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
