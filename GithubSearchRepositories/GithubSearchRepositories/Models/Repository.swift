//
//  Repository.swift
//  GithubSearchRepositories
//
//  Created by Zoran Todorovic on 28/05/2017.
//  Copyright © 2017 Zoran Todorovic. All rights reserved.
//

import Foundation
import SwiftyJSON

class Repository {
    
    var repositoryDetails: RepositoryDetails
    var owner: Owner
    
    init(repositoryDetails: RepositoryDetails, owner: Owner) {
        self.repositoryDetails = repositoryDetails
        self.owner = owner
    }
}

