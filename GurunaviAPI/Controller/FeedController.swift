//
//  FeedController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/07.
//

import UIKit
import Alamofire
import SwiftyJSON


private let reuseIdentifier = "ShopInfoCell"
private let reuseHeaderIdentifier = "ShopInfoHeader"

final class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var actionSheetLauncher: ActionSheetLauncher!
    
    var nameArray = [String]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
//        GurunaviService.shared.fetchData()
        configureUI()
        collectionView.reloadData()
        print("DEBUG: \(self.nameArray)")
    }
    
    // MARK: - API
    
    func fetchData() {
        
        let apiKey = "fe1a8ac3175a337ab4abe8bf940837fa"
        var text = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=\(apiKey)&name="
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print("DEBUG: Into method fetching data..")
        
        AF.request(url as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            let fetchingDataMax = 10
            
            print("DEBUG: requesting .GET...")
            
            switch response.result {
            case .success:
                for order in 0...fetchingDataMax {
                    
//                    var nameArray = [String]()
//                    var categoryArray = [String]()
//                    var opentimeArray = [String]()
//                    var mobileUrlArray = [String]()
                    
                    let json: JSON = JSON(response.data as Any)
                    
                    guard let shopName = json["rest"][order]["name"].string else { return }
                    guard let shopCategory = json["rest"][order]["category"].string else { return }
                    guard let shopOpentime = json["rest"][order]["opentime"].string else { return }
                    guard let mobileUrl = json["rest"][order]["url_mobile"].string else { return }
                    self.nameArray.append(shopName)
//                    categoryArray.append(shopCategory)
//                    opentimeArray.append(shopOpentime)
//                    mobileUrlArray.append(mobileUrl)
                    print(self.nameArray)
                }
            case .failure(let error):
                print(error)
                break
            }
            
        }
        
    }
    
    
    // MARK: - Helper
    
    func configureUI() {
        view.backgroundColor = .red
        
        collectionView.register(ShopInfoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ShopInfoHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        
        collectionView.backgroundColor = .white
        collectionView.collectionViewLayout = layout()
        
        navigationController?.title = "Shop"
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.title = "Gurunavi API"
    }
    
    func layout() -> UICollectionViewCompositionalLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalWidth(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitem: item, count: 1)
            containerGroup.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.interGroupSpacing = 10
            
            let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(60))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: "header", alignment: .top)
            sectionHeader.pinToVisibleBounds = true
            
            section.boundarySupplementaryItems = [sectionHeader]
        
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        
        return layout
    }
    
    fileprivate func utilizeActionSheetLauncher() {
        actionSheetLauncher = ActionSheetLauncher()
//        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }

}

// MARK: - UICollectionViewDelegate/DataSource

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShopInfoCell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! ShopInfoHeader
        sectionHeader.delegate = self
        if nameArray != [] {
            sectionHeader.setUpContents(name: self.nameArray[indexPath.section])
        }
        
        return sectionHeader
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let webController = WebController()
        navigationController?.pushViewController(webController, animated: true)
    }
}

// MARK: - ShopInfoCellDelegate

extension FeedController: ShopInfoCellDelegate {
    func showActionSheet() {
        utilizeActionSheetLauncher()
    }
}
