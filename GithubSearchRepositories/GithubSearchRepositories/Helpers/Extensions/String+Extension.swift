//
//  String+Extension.swift
//  GithubSearchRepositories
//
//  Created by Zoran Todorovic on 31/05/2017.
//  Copyright © 2017 Zoran Todorovic. All rights reserved.
//

import Foundation

extension String {
    
    func getDateFromString() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        return date
    }
}
