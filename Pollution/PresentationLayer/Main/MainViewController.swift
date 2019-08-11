//
//  MainViewController.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 7/20/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private let viewModel: MainViewModel

    private let tableView = UITableView()
    private let tableViewManager = TableViewManager()
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    private let refreshControl = UIRefreshControl()
    private let stateView = StateView()

    init(viewModel: MainViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setInitial()
        setupConstraints()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setInitial()
        viewModel.viewDidLoad()
    }

    private func setupViews() {
        navigationItem.title = "Pollution"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonDidPressed))
        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.allowsSelection = false
        tableViewManager.configure(tableView: tableView, delegate: self)

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(tableViewDidPulled), for: .valueChanged)

        view.addSubview(activityIndicator)

        view.addSubview(stateView)
        stateView.delegate = self
    }

    private func setInitial() {
        stateView.isHidden = true
        tableView.isHidden = tableViewManager.dataSource.isEmpty
        tableViewManager.dataSource.isEmpty ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        stateView.translatesAutoresizingMaskIntoConstraints = false
        stateView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stateView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stateView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func bind() {
        viewModel.viewState.bind { [weak self] state in
            self?.stateView.state = state
            self?.activityIndicator.stopAnimating()
            self?.refreshControl.endRefreshing()
        }

        viewModel.dataSource.bind { [weak self] items in
            self?.stateView.isHidden = !items.isEmpty
            self?.tableView.isHidden = items.isEmpty
            self?.tableView.register(with: items)
            self?.tableViewManager.dataSource = items
            self?.activityIndicator.stopAnimating()
            self?.refreshControl.endRefreshing()
        }
    }

    @objc private func tableViewDidPulled() {
        viewModel.tableViewDidPulled()
    }

    @objc private func buttonDidPressed() {
        let viewController = SearchViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}

extension MainViewController: TableViewManagerDelegate {
    func delete(at index: Int) {
        viewModel.delete(at: index)
    }
}

extension MainViewController: Reloadable {
    func reload() {
        stateView.isHidden = true
        activityIndicator.startAnimating()
        viewModel.tableViewDidPulled()
    }
}
