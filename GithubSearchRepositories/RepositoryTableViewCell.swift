//
//  RepositoryTableViewCell.swift
//  GithubSearchRepositories
//
//  Created by Zoran Todorovic on 28/05/2017.
//  Copyright © 2017 Zoran Todorovic. All rights reserved.
//

import UIKit
import PureLayout
import Kingfisher

class RepositoryTableViewCell: UITableViewCell {
    
    let userImageView = UIImageView()
    let repoNameLabel = UILabel()
    let statsLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        contentView.addSubview(userImageView)
        userImageView.autoSetDimensions(to: CGSize(width: 50, height: 50))
        userImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        userImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        userImageView.backgroundColor = UIColor.black
        userImageView.layer.cornerRadius = 25
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        
        contentView.addSubview(repoNameLabel)
        repoNameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        repoNameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        repoNameLabel.autoPinEdge(.left, to: .right, of: userImageView, withOffset: 10)
        repoNameLabel.numberOfLines = 0
        
        contentView.addSubview(statsLabel)
        statsLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        statsLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        statsLabel.autoPinEdge(.top, to: .bottom, of: repoNameLabel, withOffset: 10)
        statsLabel.autoPinEdge(.left, to: .right, of: userImageView, withOffset: 10)
        statsLabel.numberOfLines = 0
        statsLabel.textAlignment = .left
    }
    
    func bindModelToCell(repository: Repository) -> Void {
        if let imageURL = repository.ownerThumbURLString {
            let url = URL(string: imageURL)
            userImageView.kf.setImage(with: url)
        }

        repoNameLabel.text = repository.name
        statsLabel.text = "Stars: \(repository.numberOfStars ?? 0), Forks: \(repository.numberOfForks ?? 0), Watchers: \(repository.numberOfWatchers ?? 0)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
