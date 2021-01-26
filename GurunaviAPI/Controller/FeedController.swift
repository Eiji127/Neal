//
//  FeedController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/07.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit


private let reuseIdentifier = "ShopInfoCell"
private let reuseHeaderIdentifier = "ShopInfoHeader"

final class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var shopData = ShopData() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let itemCount: Int = 2
    
    private var freeword: String = "&freeword="
    private var longitude: String = "&longitude="
    private var latitude: String = "&latitude="

    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchTextField.backgroundColor = .white
        search.textField?.layer.cornerRadius = (search.textField?.bounds.height)! / 2.0
        search.textField?.layer.masksToBounds = true
        search.placeholder = "Search"
        search.textField?.attributedPlaceholder = NSAttributedString(string: search.placeholder ?? "",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        return search
    }()
    
    private lazy var researchImageView: UIImageView = {
        let research = UIImageView()
        research.image = UIImage(systemName: "magnifyingglass")
        research.tintColor = .white
        research.setDimensions(width: 27, height: 27)
        research.layer.masksToBounds = true
        research.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(researchImageTapped))
        research.addGestureRecognizer(tap)
        
        return research
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicateShopInformation()
        
        configureUI()
        configureRightBarButton()
        collectionView.reloadData()
        
    }
    
    // MARK: - API
    
    func fetchData() {
        collectionView.refreshControl?.beginRefreshing()
        
        do {
            GurunaviService.shared.fetchData(latitude: latitude, longitude: longitude, freeword: freeword) { shopData in
                self.shopData = shopData
            }
            latitude = "&langitude="
            longitude = "&longitude="
            freeword = "&freeword="
        } catch {
            showAlert()
        }
        collectionView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Helper
    
    func indicateShopInformation(){
        
        LocationManager.shared.fetchUserLocation { latitude, longitude in
            
            self.latitude += latitude
            self.longitude += longitude
            
            self.fetchData()
        }
    }
    
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
        navigationItem.title = "お店リスト"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    func configureRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: researchImageView)
    }
    
    func showAlert(){
        let alertController = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
        let dimissAlert = UIAlertAction(title: "OK", style: .cancel){
            action -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(dimissAlert)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleRefresh() {
        indicateShopInformation()
        collectionView.reloadData()
    }
    
    @objc func researchImageTapped() {
        showSearchBar()
    }
    
    func showSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
}

// MARK: UICollectionViewCompositionalLayout

extension FeedController {
    func layout() -> UICollectionViewCompositionalLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalWidth(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitem: item, count: 1)
            containerGroup.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .continuous
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
    
}

// MARK: - UICollectionViewDelegate/DataSource

extension FeedController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return shopData.nameArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShopInfoCell
        if shopData.shopsImageArray != [] {
            if let shopImage = URL(string: shopData.shopsImageArray[indexPath.section][indexPath.row]) {
                cell.setUpImageView(imageUrl: shopImage)
            } else if shopData.shopsImageArray[indexPath.section][indexPath.row] == "" {
                cell.setUpImage()
            }
        } else {
            cell.setUpImage()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! ShopInfoHeader
        if shopData.nameArray != [] {
            sectionHeader.setUpContents(
                name: shopData.nameArray[indexPath.section],
                category: shopData.categoryArray[indexPath.section],
                opentime: shopData.opentimeArray[indexPath.section]
            )
        }
        return sectionHeader
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let webController = WebController()
        webController.mobileUrl = shopData.mobileUrlArray[indexPath.section]
        navigationController?.pushViewController(webController, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension FeedController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchText = searchBar.text else {
            return
        }
        
        longitude = "&longitude="
        latitude = "&latitude="
        
        freeword += searchText
        
        indicateShopInformation()
        collectionView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !searchBar.showsCancelButton {
            researchImageView.isHidden = true
            searchBar.setShowsCancelButton(true, animated: true)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        researchImageView.isHidden = false
        searchBar.endEditing(true)
    }
    
}

