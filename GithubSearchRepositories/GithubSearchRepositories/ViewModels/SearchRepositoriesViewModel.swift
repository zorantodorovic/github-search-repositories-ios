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

protocol SearchRepositoriesViewModelDelegate: class {
    func didFetchRepositories() -> Void
    func repositoryFetchFailed() -> Void
}

fileprivate struct SearchParametes {
    var page: Int = 0
    var perPage: Int = 30
    var query: String? = ""
    var sort: String? = ""
    var order: String? = ""
}

class SearchRepositoriesViewModel {
    private let urlString = "https://api.github.com/search/repositories"
    
    var hasMoreItemsToFetch: Bool = false
    var repositoriesArray = [Repository]()
    fileprivate var searchParams = SearchParametes()
    
    weak var delegate: SearchRepositoriesViewModelDelegate?
    
    func searchQuery(query: String?) -> Void {
        guard let query = query else {
            return
        }
        searchParams = SearchParametes()
        repositoriesArray = [Repository]()
        searchParams.query = query
        self.fetchData()
    }
    
    
    func order(order: String?) -> Void {
        guard let order = order else {
            return
        }
        searchParams.order = order
    }
    
    
    func sort(sortOption: String?) -> Void {
        guard let sort = sortOption else {
            return
        }
        searchParams.sort = sort
    }
    
    
    func loadMoreData() -> Void {
        if self.hasMoreItemsToFetch {
            searchParams.page += 1
            self.fetchData()
        }
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




