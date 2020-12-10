//
//  FeedController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/07.
//

import UIKit


private let reuseIdentifier = "ShopInfoCell"

class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var actionSheetLauncher: ActionSheetLauncher!
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - API
    
    
    // MARK: - Helper
    
    func configureUI() {
        view.backgroundColor = .red
        
        collectionView.register(ShopInfoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        navigationController?.title = "Shop"
        navigationItem.title = "Grunavi API"
    }
    
    fileprivate func utilizeActionSheetLauncher() {
        actionSheetLauncher = ActionSheetLauncher()
//        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }

}

// MARK: - UICollectionViewDelegate/DataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShopInfoCell
        cell.delegate = self
        return cell
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 300)
        
    }
}

extension FeedController: ShopInfoCellDelegate {
    func showActionSheet() {
        utilizeActionSheetLauncher()
    }
}
