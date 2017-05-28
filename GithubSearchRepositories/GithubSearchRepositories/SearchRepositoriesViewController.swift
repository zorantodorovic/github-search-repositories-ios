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
    
    fileprivate let viewModel = SearchRepositoriesViewModel()
    
    fileprivate var searchQuery: String?
    var data = ["Lala", "Lolo", "Lila"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavBar()
        self.setupSearchBar()
        self.setupTableView()
        viewModel.delegate = self
        searchBar.delegate = self
    }
    
    private func setupNavBar() {
        view.backgroundColor = UIColor.white
        navigationItem.title = Constants.searchScreenNavBarTitle
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.keyboardDismissMode = .onDrag
    }
    
}

extension SearchRepositoriesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    
}

extension SearchRepositoriesViewController: SearchRepositoriesViewModelDelegate {
    
    func didFetchRepositories(repositories: [Repository]) {
        print("did get in VC")
    }
    
    func repositoryFetchFailed() {
        // #TODO handle failure
    }
    
}

