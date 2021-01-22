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
    
    private var actionSheetLauncher: ActionSheetLauncher!
    
    var nameArray = [String]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var categoryArray = [String]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var opentimeArray = [String]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var mobileUrlArray = [String]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var shopsImageArray = [[String]]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var itemCount: Int = 2
    
    var locationManager: CLLocationManager? = nil
    var freeword: String = "&freeword="
    var longitude: String = "&longitude=139.775018"
    var latitude: String = "&latitude=35.695861"
    var range: String = "&range=1"
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchTextField.backgroundColor = .white
        search.textField?.layer.cornerRadius = (search.textField?.bounds.height)! / 2.0
        search.textField?.layer.masksToBounds = true
        search.placeholder = "Search"
        search.textField?.attributedPlaceholder = NSAttributedString(string: search.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
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
        fetchData()
        configureUI()
        configureRightBarButton()
        locationManager?.startUpdatingLocation()
        collectionView.reloadData()
        
        hideCurrentLocationButton()
        
    }
    
    // MARK: - API
    
    func fetchData() {
        
        var imageUrlArray = [String]()
        
        guard let apiKey = APIKeyManager().getValue(key: "apiKey") else {
            return
        }
        var text = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=\(apiKey)&area=AREA120" + freeword
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
//        let params:Parameters = [
//            "keyid":apiKey,
//            "format":"json",
//            "freeword":freeword,
//            "latitude":latitude,
//            "longitude":longitude,
//            "range":range,
//            "hit_per_page":10
//        ]
        
        print("DEBUG: Into method fetching data..")
        
        AF.request(url as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            
            let fetchingDataMax = 0...9
            
            print("DEBUG: requesting .GET...")
            
            switch response.result {
            case .success:
                for order in fetchingDataMax {
                    
                    let json: JSON = JSON(response.data as Any)
                    
                    guard let shopName = json["rest"][order]["name"].string else { return }
                    guard let shopCategory = json["rest"][order]["category"].string else { return }
                    guard let shopOpentime = json["rest"][order]["opentime"].string else { return }
                    guard let mobileUrl = json["rest"][order]["url"].string else { return }
                    guard let imageUrl1 = json["rest"][order]["image_url"]["shop_image1"].string else { return }
                    guard let imageUrl2 = json["rest"][order]["image_url"]["shop_image2"].string else { return }
                    self.nameArray.append(shopName)
                    self.categoryArray.append(shopCategory)
                    self.opentimeArray.append(shopOpentime)
                    self.mobileUrlArray.append(mobileUrl)
                    imageUrlArray.append(imageUrl1)
                    if imageUrl2 != "" {
                        imageUrlArray.append(imageUrl2)
                    }
                    self.shopsImageArray.append(imageUrlArray)
                    imageUrlArray.removeAll()
                    print("\(self.mobileUrlArray)")
                }
            case .failure(let error):
                print(error)
                break
            }
            
        }
        
    }
    
    
    // MARK: - Helper
    
    
    func hideCurrentLocationButton() {
        let tab = TabController()
        
    }
    
    func removeAllElementsInArray() {
        nameArray.removeAll()
        categoryArray.removeAll()
        opentimeArray.removeAll()
        mobileUrlArray.removeAll()
        shopsImageArray.removeAll()
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
        navigationItem.title = "Gurunavi API"
    }
    
    func configureRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: researchImageView)
    }
    
    @objc func researchImageTapped() {
        if navigationItem.titleView != searchBar {
            showSearchBar()
            
        } else {
           
        }
        
    }
    
    func showSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    
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
        return itemCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShopInfoCell
        if shopsImageArray != [] {
            if let shopImage = URL(string: shopsImageArray[indexPath.section][indexPath.row]) {
                cell.setUpImageView(imageUrl: shopImage)
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! ShopInfoHeader
        if nameArray != [] {
            sectionHeader.setUpContents(name: self.nameArray[indexPath.section], category: self.categoryArray[indexPath.section], opentime: self.opentimeArray[indexPath.section])
        }
        sectionHeader.delegate = self
        return sectionHeader
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let webController = WebController()
        webController.mobileUrl = mobileUrlArray[indexPath.section]
        navigationController?.pushViewController(webController, animated: true)
    }
}

extension FeedController: shopInfoHeaderDelegate {
    func showMapView() {
        let map = MapController()
        let rootVC = UIApplication.shared.windows.first?.rootViewController as? TabController
        let navigationController = rootVC?.children as? UINavigationController
        rootVC?.selectedIndex = 1
        navigationController?.pushViewController(map, animated: true)
        addAnnotation()
    }
    
    func addAnnotation() {
        let map = MapController()
        map.addAnnotation(latitude: 35.6800494, longitude: 139.7609786)
    }
}

extension FeedController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else {
            return
        }
        freeword += searchText
        removeAllElementsInArray()
        fetchData()
        collectionView.reloadData()
        freeword = "&freeword="
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

