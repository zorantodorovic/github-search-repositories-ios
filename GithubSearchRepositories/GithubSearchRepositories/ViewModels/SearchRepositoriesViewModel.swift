//
//  SearchRepositoriesViewModel.swift
//  GithubSearchRepositories
//
//  Created by Zoran Todorovic on 28/05/2017.
//  Copyright © 2017 Zoran Todorovic. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum SortOptions {
    case starsASC
    case starsDESC
    case forksASC
    case forksDESC
    case updatedASC
    case updatedDESC
    
    func getSortString() -> String {
        switch self {
        case .starsASC, .starsDESC:
            return "stars"
        case .forksASC, .forksDESC:
            return "forks"
        case .updatedASC, .updatedDESC:
            return "updated"
        }
    }
    
    func getOrderString() -> String {
        switch self {
        case .starsASC, .forksASC, .updatedASC:
            return "asc"
        case .starsDESC, .forksDESC, .updatedDESC:
            return "desc"
        }
    }
}

fileprivate struct SearchParametes {
    var page: Int = 1
    var perPage: Int = 30
    var query: String? = ""
    var sort: String? = ""
    var order: String? = ""
}

protocol SearchRepositoriesViewModelDelegate: class {
    func didFetchRepositories() -> Void
    func repositoryFetchFailed() -> Void
    func didSortRepositories() -> Void
}

class SearchRepositoriesViewModel {
    private let urlString = "https://api.github.com/search/repositories"
    
    var hasMoreItemsToFetch: Bool = false
    var repositoriesArray = [Repository]()
    fileprivate var searchParams = SearchParametes()
    
    weak var delegate: SearchRepositoriesViewModelDelegate?
    
    
    // Public methods. Available for viewcontroller
    
    func searchQuery(query: String?) -> Void {
        guard let query = query else {
            return
        }
        searchParams = SearchParametes()
        searchParams.query = query
        self.resetData()
        self.fetchData()
    }
    
    func handleSort(option: SortOptions) -> Void {
        self.resetData()
        searchParams.sort = option.getSortString()
        searchParams.order = option.getOrderString()
        searchParams.page = 1
        self.delegate?.didSortRepositories()
        self.fetchData()
    }
    
    func loadMoreData() -> Void {
        if self.hasMoreItemsToFetch {
            searchParams.page += 1
            self.fetchData()
        }
    }
    
    // Private methods. Available just for viewmodel
    
    private func resetData() -> Void {
        repositoriesArray = [Repository]()
    }
    
    private func getSearchParametersAsDictionary() -> [String: Any] {
        return [
            "per_page" : searchParams.perPage,
            "q" : searchParams.query!,
            "page" : searchParams.page,
            "sort" : searchParams.sort!,
            "order" : searchParams.order!
        ]
    }
    
    private func fetchData() -> Void {
        let searchParameters = self.getSearchParametersAsDictionary()
        dump(searchParameters)
        Alamofire.request(urlString, parameters: searchParameters).responseJSON { [weak self] (response) in
            switch response.result {
            case .success:
                if response.result.value != nil {
                    let json = JSON(response.result.value!)
                    if let totalItems = json["total_count"].int {
                        self?.calculateTotalPages(totalItems: totalItems)
                    }
                    if let reposArray = self?.mapJSONToModel(json: json["items"]) {
                        self?.repositoriesArray.append(contentsOf: reposArray)
                        self?.delegate?.didFetchRepositories()
                    }
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                self?.delegate?.repositoryFetchFailed()
            }
        }
    }
    
    
    private func calculateTotalPages(totalItems: Int) -> Void {
        let alreadyListed = searchParams.page * searchParams.perPage
        
        if alreadyListed < totalItems {
            self.hasMoreItemsToFetch = true
        } else {
            self.hasMoreItemsToFetch = false
        }
    }
    
    
    private func mapJSONToModel(json: JSON) -> [Repository] {
        var repositoriesArray = [Repository]()
        
        for (_, subJSON) in json {
            do {
                let details = try RepositoryDetails(json: subJSON)
                let owner = try Owner(json: subJSON["owner"])
                let repo = Repository(repositoryDetails: details, owner: owner)
                repositoriesArray.append(repo)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        return repositoriesArray
        
    }
    
    
}




