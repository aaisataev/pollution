//
//  SearchViewContoller.swift
//  Pollution
//
//  Created by Assylbek Issatayev on 8/11/19.
//  Copyright © 2019 aaisataev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    private let viewModel: SearchViewModel

    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    private let tableViewManager = TableViewManager()
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    private let stateView = StateView()

    init(viewModel: SearchViewModel = .init()) {
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
        searchController.isActive = true
    }

    private func setupViews() {
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController

        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true

        view.backgroundColor = .white

        view.addSubview(tableView)
        tableViewManager.configure(tableView: tableView, delegate: self)

        view.addSubview(activityIndicator)

        view.addSubview(stateView)
        stateView.delegate = self
    }

    private func setInitial() {
        stateView.isHidden = true
        tableView.isHidden = tableViewManager.dataSource.isEmpty
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
        }

        viewModel.dataSource.bind { [weak self] items in
            self?.stateView.isHidden = !items.isEmpty
            self?.tableView.isHidden = items.isEmpty
            self?.tableView.register(with: items)
            self?.tableViewManager.dataSource = items
            self?.activityIndicator.stopAnimating()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        viewModel.textDidChange(searchText: searchText)
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        navigationController?.dismiss(animated: true)
    }
}

extension SearchViewController: TableViewManagerDelegate {
    func didSelect(at index: Int) {
        searchController.isActive = false
        viewModel.didSelect(at: index)
        navigationController?.dismiss(animated: true)
    }
}

extension SearchViewController: Reloadable {
    func reload() {
        stateView.isHidden = true
        activityIndicator.startAnimating()
    }
}
