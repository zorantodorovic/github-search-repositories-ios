//
//  ViewController.swift
//  GithubSearchRepositories
//
//  Created by Zoran Todorovic on 27/05/2017.
//  Copyright © 2017 Zoran Todorovic. All rights reserved.
//

import UIKit

// This is the root for the app. If you need to add menu or TabBar use this VC to instantiate it.
// You can have multiple navigation controllers within this VC to preserve navigation stacks.

class RootViewController: UIViewController {
    
    static let shared = RootViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationVC = NavigationViewController(rootViewController: SearchRepositoriesViewController())
        self.addChildViewController(navigationVC)
    }


}

