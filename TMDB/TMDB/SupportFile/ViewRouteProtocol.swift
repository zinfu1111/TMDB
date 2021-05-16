//
//  ViewRouteProtocol.swift
//  TMDB
//
//  Created by 連振甫 on 2021/5/16.
//

import UIKit
import Foundation

protocol ViewRouteProtocol:UIViewController {
    func showDetailViewController(viewModel:DetailViewModel)
    func showMessageBox(title:String, msg:String, action:Void?)
}

extension ViewRouteProtocol {
    
    func showDetailViewController(viewModel:DetailViewModel) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailViewController.viewModel = viewModel
        detailViewController.modalPresentationStyle = .fullScreen
        present(detailViewController, animated: true, completion: nil)
    }
    
    func showMessageBox(title:String, msg:String, action:Void?) {
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let checkAction = UIAlertAction(title: "確認", style: .default,handler: {(action: UIAlertAction!) -> Void in
            action
        })
        alertVC.addAction(checkAction)
        present(alertVC, animated: true, completion: nil)
    }
}
