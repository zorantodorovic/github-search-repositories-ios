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
    func didFetchRepositories(repositories: [Repository]) -> Void
    func repositoryFetchFailed() -> Void
}

class SearchRepositoriesViewModel {
    
    private let urlString = "https://api.github.com/search/repositories"
    
    var page: Int = 0
    var query: String? = ""
    var sort: String? = ""
    var order: String? = ""
    var perPage: Int? = 20
    
    weak var delegate: SearchRepositoriesViewModelDelegate?
    
    
    func searchQuery(query: String? = "") -> Void {
        
        guard let que = query else {
            return
        }
        self.query = que
        
        self.fetchData()
    }
    
    func order(order: String? = "") -> Void {
        
        guard let ord = order else {
            return
        }
        
        self.order = ord
    }
    
    func sort(sortOption: String? = "") -> Void {
        
        guard let option = sortOption else {
            return
        }
        
        self.sort = option
    }
    
    private func getSearchParameters() -> [String: Any] {
        return [
            "per_page" : self.perPage!,
            "q" : self.query!,
            "page" : self.page,
            "sort" : self.sort!,
            "order" : self.order!
        ]
    }
    
    private func fetchData() -> Void {
        
        let searchParameters = self.getSearchParameters()
        Alamofire.request(urlString, parameters: searchParameters).responseJSON { response in
            
            switch response.result {
            case .success:
                if response.result.value != nil {
                    let swiftyJSON = JSON(response.result.value!)
                    let reposArray = self.mapJSONToModel(json: swiftyJSON["items"])
                    self.delegate?.didFetchRepositories(repositories: reposArray)
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                self.delegate?.repositoryFetchFailed()
            }
        }
    }
    
    private func mapJSONToModel(json: JSON) -> [Repository] {
        var repositoriesArray = [Repository]()
        
        for (_, subJSON) in json {
            do {
                let repo = try Repository(json: subJSON)
                repositoriesArray.append(repo)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        return repositoriesArray
        
    }
    
    
}




