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
import CoreLocation
import RealmSwift


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
    
    var homeDelegate: HomeControllerDelegate?

    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchTextField.backgroundColor = .white
        search.textField?.layer.cornerRadius = (search.textField?.bounds.height)! / 2.0
        search.textField?.layer.masksToBounds = true
        search.placeholder = "ジャンル・料理名を検索"
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
    
    private let noShopLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.tintColor = .lightGray
        label.numberOfLines = 0
        label.text = "近くには飲食店がないようです...\n移動して再検索してみましょう！！"
        return label
    }()
    
    lazy var realm = try! Realm()
    
    var name = String()
    var category = String()
    var opentime = String()
    var url = String()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServiceCondition()
        indicateShopInformation()
        
        configureUI()
        configureRightBarButton()
        
        if shopData.hit_count == 0 {
            collectionView.addSubview(noShopLabel)
            noShopLabel.centerX(inView: collectionView)
            noShopLabel.centerY(inView: collectionView)
        }
        
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationServiceCondition()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: - API
    
    func fetchData() {
        collectionView.refreshControl?.beginRefreshing()
        
        GurunaviService.shared.fetchData(latitude: latitude, longitude: longitude, freeword: freeword) { shopData in
            self.shopData = shopData
            self.latitude = "&latitude="
            self.longitude = "&longitude="
            if self.shopData.hit_count == 0 {
                AlertManager.shared.showNoHitAlert(viewContoller: self) { alert in
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        freeword = "&freeword="
        collectionView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Selectors
    
    @objc func willEnterForeground() {
        checkLocationServiceCondition()
        dismiss(animated: true, completion: nil)
    }

    @objc func handleRefresh() {
        indicateShopInformation()
    }
    
    @objc func researchImageTapped() {
        showSearchBar()
        searchBar.isHidden = false
    }
    
    @objc func handleMenuToggle() {
        homeDelegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    // MARK: - Handlers
    
    private func indicateShopInformation(){
        LocationManager.shared.fetchUserLocation { latitude, longitude in
            
            self.latitude += latitude
            self.longitude += longitude
            self.fetchData()
        }
    }
    
    private func checkLocationServiceCondition() {
        if CLLocationManager.locationServicesEnabled() {
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .denied:
                AlertManager.shared.showAllowingFetchLocationAlert(viewContoller: self) { (_) in
                    self.showOSSettingView()
                }
            default:
                break
            }
        } else {
            AlertManager.shared.showAllowingFetchLocationAlert(viewContoller: self)
        }
    }
    
    private func showOSSettingView() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        
        collectionView.backgroundColor = .nealBack
        collectionView.collectionViewLayout = layout()
        
        configureNavigationBar()
        registerComponentOfCollectionView()
        addRefreshControl()
    }
    
    private func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func configureNavigationBar() {
        navigationController?.title = "Shop"
        navigationController?.navigationBar.barTintColor = .systemRed
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.title = "近辺の店舗"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.left"), style: .plain, target: self, action: #selector(handleMenuToggle))
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemRed
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.monospacedSystemFont(ofSize: 28, weight: .black)
        ]
        
        appearance.largeTitleTextAttributes = attrs
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    private func registerComponentOfCollectionView() {
        collectionView.register(ShopInfoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ShopInfoHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
    }
    
    private func configureRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: researchImageView)
    }
    
    private func showSearchBar() {
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
        config.interSectionSpacing = 0
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        
        return layout
    }
    
}

// MARK: - UICollectionViewDelegate/DataSource

extension FeedController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sectionsCount = shopData.hit_count
        return sectionsCount
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
        sectionHeader.indexPath = indexPath
        if shopData.nameArray != [] {
            sectionHeader.setUpContents(
                name: shopData.nameArray[indexPath.section],
                category: shopData.categoryArray[indexPath.section],
                opentime: shopData.opentimeArray[indexPath.section]
            )
            
            let favoriteShops = realm.objects(FavoriteShopData.self)
            for data in favoriteShops {
                if data.name ==  shopData.nameArray[indexPath.section] {
                    sectionHeader.didRegisterd = true
                    sectionHeader.registerShopButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    sectionHeader.registerShopButton.tintColor = .systemYellow
                }
            }
            
        }
        
        sectionHeader.delegate = self
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
        searchBar.isHidden = true
    }
    
}

extension FeedController: shopInfoHeaderDelegate {
    func saveFavoriteShop(indexPath section: Int) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        try! realm.write {
            let favoriteShopData = FavoriteShopData()
            favoriteShopData.name = shopData.nameArray[section]
            favoriteShopData.category = shopData.categoryArray[section]
            favoriteShopData.opentime = shopData.opentimeArray[section]
            favoriteShopData.mobileUrl = shopData.mobileUrlArray[section]
            favoriteShopData.imageUrl = shopData.shopsImageArray[section][0]
            realm.add(favoriteShopData)
        }
    }
    
    func deleteFavoriteShop(indexPath section: Int) {
        let favoriteShops = realm.objects(FavoriteShopData.self)
        try! realm.write {
            for data in favoriteShops {
                if data.name ==  shopData.nameArray[section] {
                    realm.delete(data)
                }
            }
        }
    }
}

