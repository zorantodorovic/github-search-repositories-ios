//
//  SearchRepositoriesViewController.swift
//  GithubSearchRepositories
//
//  Created by Zoran Todorovic on 27/05/2017.
//  Copyright © 2017 Zoran Todorovic. All rights reserved.
//

import UIKit
import PureLayout

class SearchRepositoriesViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    let cellId = "cellId"
    
    fileprivate var searchQuery: String?
    fileprivate var viewModel: SearchRepositoriesViewModel
    
    init(viewModel: SearchRepositoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAllViews()
        viewModel.delegate = self
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.repositoriesArray.count == 0 {
            tableView.tableFooterView?.isHidden = true
        }
    }
    
    private func setAllViews() {
        view.backgroundColor = UIColor.white
        self.setupNavBar()
        self.setupSearchBar()
        self.setupTableView()
        self.setupTableFooterView()
    }
    
    private func setupNavBar() {
        navigationItem.title = Constants.searchScreenNavBarTitle
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: nil, action: nil)
        self.navigationItem.setRightBarButton(button, animated: false)
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.autoPinEdgesToSuperviewEdges(with: UIEdgeInsetsMake(64, 0, 0, 0), excludingEdge: .bottom)
        searchBar.placeholder = Constants.searchBarPlaceholder
        searchBar.enablesReturnKeyAutomatically = false
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsetsMake(0, 0, 0, 0), excludingEdge: .top)
        tableView.autoPinEdge(.top, to: .bottom, of: searchBar)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.keyboardDismissMode = .onDrag
    }
    
    func setupTableFooterView() {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        activity.startAnimating()
        activity.hidesWhenStopped = true
        self.tableView.tableFooterView = activity
        self.tableView.tableFooterView?.isHidden = true
    }
    
}

extension SearchRepositoriesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
        self.searchQuery = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getRepositories), object: nil)
        self.perform(#selector(getRepositories), with: nil, afterDelay: 0.5)
    }
    
    func getRepositories() -> Void {
        if self.searchQuery != "" {
            self.viewModel.searchQuery(query: self.searchQuery)
        }
    }
    
}

extension SearchRepositoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RepositoryTableViewCell
        cell.bindModelToCell(repository: self.viewModel.repositoriesArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRepository = self.viewModel.repositoriesArray[indexPath.row]
        let repositoryVM = RepositoryViewModel(repository: selectedRepository)
        let repositoryVC = RepositoryViewController(viewModel: repositoryVM)
        self.navigationController?.pushViewController(repositoryVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex && viewModel.hasMoreItemsToFetch {
            tableView.tableFooterView?.isHidden = false
            viewModel.loadMoreData()
        } else {
            tableView.tableFooterView?.isHidden = true
        }
    }
    
}

extension SearchRepositoriesViewController: SearchRepositoriesViewModelDelegate {
    
    func didFetchRepositories() {
        self.tableView.reloadData()
    }
    
    func repositoryFetchFailed() {
        // #TODO handle failure => present UIAlertViewController
    }
    
}

