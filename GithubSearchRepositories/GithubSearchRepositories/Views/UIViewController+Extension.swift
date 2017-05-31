//
//  UIViewController+Extension.swift
//  GithubSearchRepositories
//
//  Created by Zoran Todorovic on 31/05/2017.
//  Copyright © 2017 Zoran Todorovic. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showActionSheet(viewModel handler: SearchRepositoriesViewModel) -> Void {
        let actionSheetController = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheetController.addAction(cancelActionButton)
        
        let starsASC = UIAlertAction(title: "Stars ASC", style: .default) { _ in
            handler.handleSort(option: SortOptions.starsASC)
        }
        actionSheetController.addAction(starsASC)
        
        let starsDESC = UIAlertAction(title: "Stars DESC", style: .default) { _ in
            handler.handleSort(option: SortOptions.starsDESC)
        }
        actionSheetController.addAction(starsDESC)
        
        let forksASC = UIAlertAction(title: "Forks ASC", style: .default) { _ in
            handler.handleSort(option: SortOptions.forksASC)
        }
        actionSheetController.addAction(forksASC)
        
        let forksDESC = UIAlertAction(title: "Forks DESC", style: .default) { _ in
            handler.handleSort(option: SortOptions.forksDESC)
        }
        actionSheetController.addAction(forksDESC)
        
        let updatedASC = UIAlertAction(title: "Updated ASC", style: .default) { _ in
            handler.handleSort(option: SortOptions.updatedASC)
        }
        actionSheetController.addAction(updatedASC)
        
        let updatedDESC = UIAlertAction(title: "Updated DESC", style: .default) { _ in
            handler.handleSort(option: SortOptions.updatedDESC)
        }
        actionSheetController.addAction(updatedDESC)
    
        self.present(actionSheetController, animated: true, completion: nil)
    }
}
