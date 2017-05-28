//
//  RepositoryDetailsViewController.swift
//  GithubSearchRepositories
//
//  Created by Zoran Todorovic on 28/05/2017.
//  Copyright © 2017 Zoran Todorovic. All rights reserved.
//

import UIKit

class RepositoryDetailsViewController: UIViewController {
    
    let nameLabel = UILabel()
    let userImageView = UIImageView()
    
    var repository: Repository?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(userImageView)
        userImageView.autoSetDimensions(to: CGSize(width: 60, height: 60))
        userImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        userImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 100)
        
    }

}
