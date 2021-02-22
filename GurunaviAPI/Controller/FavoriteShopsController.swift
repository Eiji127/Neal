//
//  FavoriteShopsController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/02/23.
//

import UIKit

class FavoriteShopsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.title = "お気に入り"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(dismissController))
    }
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}
