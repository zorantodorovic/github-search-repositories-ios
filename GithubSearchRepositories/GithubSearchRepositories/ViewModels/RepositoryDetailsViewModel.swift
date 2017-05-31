//
//  RepositoryDetailsViewModel.swift
//  GithubSearchRepositories
//
//  Created by Zoran Todorovic on 31/05/2017.
//  Copyright © 2017 Zoran Todorovic. All rights reserved.
//

import Foundation
import UIKit

class RepositoryDetailsViewModel {
    
    private var repository: Repository
    
    var ownerName: String
    var repoName: String
    var createdDateString: String
    var ownerType: String
    
    var userImageString: String?
    var repoDesc: String?
    var language: String?
    var statistics: String?
    var updatedDateString: String?
    var repoURL: URL?
    var userURL: URL?
    
    init(repository: Repository) {
        self.repository = repository
        
        self.ownerName = "Owner: \(repository.owner.userName)"
        self.repoName = repository.repositoryDetails.name
        self.createdDateString = repository.repositoryDetails.createdDateString
        self.ownerType = "Owner type: \(repository.owner.type)"
        
        self.userImageString = repository.owner.avatarURLString ?? ""
        self.repoDesc = repository.repositoryDetails.description ?? ""
        self.language = "Language: \(repository.repositoryDetails.language ?? "")"
        self.statistics = "Forks: \(repository.repositoryDetails.numberOfForks ?? 0), Stars: \(repository.repositoryDetails.numberOfForks ?? 0), Watchers: \(repository.repositoryDetails.numberOfWatchers ?? 0)"
        self.updatedDateString = repository.repositoryDetails.updatedDateString ?? ""
        self.repoURL = repository.repositoryDetails.repoURL
        self.userURL = repository.owner.ownerURL
    }
    
    func getUserImage() -> UIImage? {
        guard let url = URL(string: repository.owner.avatarURLString!) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
    
    func getCreatedDateString() -> String {
        let dateString = self.getFormattedDateString(dateString: self.createdDateString)
        return "Created date: \(dateString)"
    }
    
    func getUpdatedDateString() -> String {
        let dateString = self.getFormattedDateString(dateString: self.updatedDateString!)
        return "Updated date: \(dateString)"
    }
    
    func getUserProfileURL() -> URL? {
        guard let url = self.userURL else {
            return nil
        }
        return url
    }
    
    func getRepoURL() -> URL? {
        guard let url = self.repoURL else {
            return nil
        }
        return url
    }
    
}


extension RepositoryDetailsViewModel {
    
    func getFormattedDateString(dateString: String) -> String {
        if let date = dateString.getDateFromString() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
}





