//
//  RepositoryDetails.swift
//  GithubSearchRepositories
//
//  Created by Zoran Todorovic on 31/05/2017.
//  Copyright © 2017 Zoran Todorovic. All rights reserved.
//

import Foundation
import SwiftyJSON

class RepositoryDetails {
    var id: Int
    var name: String
    var createdDateString: String
    var htmlURLString: String?
    var description: String?
    var numberOfForks: Int?
    var numberOfStars: Int?
    var numberOfWatchers: Int?
    var numberOfIssues: Int?
    var updatedDateString: String?
    var language: String?
    
    init(json: JSON) throws {
        guard let id = json["id"].int,
            let name = json["full_name"].string,
            let createdAt = json["created_at"].string
            else {
                throw json.error!
        }
        
        self.id = id
        self.name = name
        self.createdDateString = createdAt
        self.htmlURLString = json["html_url"].string
        self.description = json["description"].string
        self.numberOfForks = json["forks_count"].int
        self.numberOfStars = json["stargazers_count"].int
        self.numberOfIssues = json["open_issues_count"].int
        self.numberOfWatchers = json["watchers_count"].int
        self.updatedDateString = json["updated_at"].string
        self.language = json["language"].string ?? ""
    }
    
}

extension RepositoryDetails {
    
    var repoURL: URL? {
        guard let url = URL(string: self.htmlURLString!) else {
            return nil
        }
        return url
    }
    
}
