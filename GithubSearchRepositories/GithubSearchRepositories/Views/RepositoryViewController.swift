//
//  RepositoryViewController.swift
//  GithubSearchRepositories
//
//  Created by Zoran Todorovic on 28/05/2017.
//  Copyright © 2017 Zoran Todorovic. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController {
    
    let stackView = UIStackView()
    let userImageView = UIImageView()
    let ownerNameLabel = UILabel()
    let ownerTypeLabel = UILabel()
    let repoNameLabel = UILabel()
    let descLabel = UILabel()
    let statsLabel = UILabel()
    let languageLabel = UILabel()
    let createdLabel = UILabel()
    let updatedLabel = UILabel()
    let openprofileButton = UIButton()
    let openRepoButton = UIButton()
    
    fileprivate var viewModel: RepositoryViewModel
    
    init(viewModel: RepositoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.bindDataToView()
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(userImageView)
        userImageView.autoSetDimensions(to: CGSize(width: 60, height: 60))
        userImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        userImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 100)
        userImageView.backgroundColor = UIColor.black
        
        view.addSubview(ownerNameLabel)
        ownerNameLabel.autoPinEdge(.left, to: .right, of: userImageView, withOffset: 15)
        ownerNameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 115)
        ownerNameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        
        view.addSubview(ownerTypeLabel)
        ownerTypeLabel.autoPinEdge(.left, to: .right, of: ownerNameLabel, withOffset: 15)
        ownerTypeLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        ownerTypeLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        
        view.addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsetsMake(0, 15, 15, 15), excludingEdge: .top)
        stackView.autoPinEdge(.top, to: .bottom, of: userImageView, withOffset: 10)
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        stackView.addArrangedSubview(repoNameLabel)
        stackView.addArrangedSubview(languageLabel)
        stackView.addArrangedSubview(descLabel)
        stackView.addArrangedSubview(statsLabel)
        stackView.addArrangedSubview(createdLabel)
        stackView.addArrangedSubview(updatedLabel)
        stackView.addArrangedSubview(openprofileButton)
        stackView.addArrangedSubview(openRepoButton)
        
        repoNameLabel.numberOfLines = 0
        descLabel.numberOfLines = 0
        
        openprofileButton.setTitle("Open user profile", for: .normal)
        openprofileButton.setTitleColor(UIColor.blue, for: .normal)
        
        openRepoButton.setTitle("Open repository", for: .normal)
        openRepoButton.setTitleColor(UIColor.blue, for: .normal)
    }
    
    func bindDataToView() {
        userImageView.image = viewModel.getUserImage()
        ownerNameLabel.text = viewModel.ownerName
        ownerTypeLabel.text = viewModel.ownerType
        repoNameLabel.text = viewModel.repoName
        languageLabel.text = viewModel.language
        descLabel.text = viewModel.repoDesc
        statsLabel.text = viewModel.statistics
        createdLabel.text = viewModel.getCreatedDateString()
        updatedLabel.text = viewModel.getUpdatedDateString()
        openprofileButton.addTarget(self, action: #selector(openLinkInBrowser(sender:)), for: .touchUpInside)
        openRepoButton.addTarget(self, action: #selector(openLinkInBrowser(sender:)), for: .touchUpInside)
    }
    
    func openLinkInBrowser(sender: UIButton) {
        var url: URL
        if sender == openprofileButton {
            url = viewModel.getUserProfileURL()!
        } else {
            url = viewModel.getUserProfileURL()!
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}



