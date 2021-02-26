//
//  FavoriteShopsController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/02/23.
//

import UIKit
import RealmSwift

private let favoriteShopCellIdentifier = "FavoriteShopsCell"

class FavoriteShopsController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let realm = try! Realm()
    var data = [FavoriteShopData]()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .nealBack
        
        collectionView.register(FavoriteShopsCell.self, forCellWithReuseIdentifier: favoriteShopCellIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .nealBack
        
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.title = "お気に入り"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(dismissController))
        
        data = realm.objects(FavoriteShopData.self).map({ $0 })
    }
    
    // MARK: - Handlers
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    func refresh() {
        data = realm.objects(FavoriteShopData.self).map({ $0 })
        collectionView.reloadData()
    }
    
}

extension FavoriteShopsController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoriteShopCellIdentifier, for: indexPath) as! FavoriteShopsCell
        cell.nameLabel.text = data[indexPath.row].name
        cell.categoryLabel.text = data[indexPath.row].category
        cell.opentimeLabel.text = data[indexPath.row].opentime
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let webController = WebController()
        webController.mobileUrl = "https://www.google.com/?hl=ja"
        navigationController?.pushViewController(webController, animated: true)
        
    }
}

extension FavoriteShopsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = Int( UIScreen.main.bounds.size.width)
        let screenHeight = Int(UIScreen.main.bounds.size.height / 6)
        return CGSize(width: screenWidth, height: screenHeight)
    }
    
}

