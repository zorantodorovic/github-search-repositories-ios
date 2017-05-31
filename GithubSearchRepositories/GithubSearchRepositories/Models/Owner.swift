//
//  Owner.swift
//  GithubSearchRepositories
//
//  Created by Zoran Todorovic on 28/05/2017.
//  Copyright © 2017 Zoran Todorovic. All rights reserved.
//

import Foundation
import SwiftyJSON

class Owner {
    var id: Int
    var userName: String
    var type: String
    var htmlURLString: String
    
    var avatarURLString: String?
    
    init(json: JSON) throws {
        guard let id = json["id"].int,
            let username = json["login"].string,
            let type = json["type"].string,
            let urlString = json["html_url"].string
        else {
            throw json.error!
        }
        
        self.id = id
        self.userName = username
        self.type = type
        self.htmlURLString = urlString
        
        self.avatarURLString = json["avatar_url"].string
    }
}

extension Owner {
    
    var ownerURL: URL? {
        guard let url = URL(string: self.htmlURLString) else {
            return nil
        }
        return url
    }
    
}
