//
//  MapController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/07.
//
import UIKit
import SwiftyJSON
import Alamofire
import MapKit
import RealmSwift
import CoreLocation


private let selectBarReuseIndentifier = "SelectBarCell"

class MapController: UIViewController {
    
    // MARK: - Properties
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.userTrackingMode = .followWithHeading
        return map
    }()
    
    private var selectBar: UICollectionView!
    
    private var shopData = ShopData() {
        didSet {
            selectBar.reloadData()
        }
    }
    
    private var longitude: String = "&longitude="
    private var latitude: String = "&latitude="
    
    lazy var realm = try! Realm()
    
    private var mobileUrl: String = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.getUserLocation()
        
        configureMapView()
        configureNavigationBar()
        configureNavigationBarRightButton()
        
        self.overrideUserInterfaceStyle = .light
        
        configurePinOnMap()
        
        configureSelectBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationServiceCondition()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectBar.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemRed
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    
    // MARK: - API
    
    func fetchData() {
        GurunaviService.shared.fetchData(latitude: latitude, longitude: longitude) { shopData in
            self.shopData = shopData
            if self.shopData.hit_count == 0 {
                AlertManager.shared.showNoHitAlert(viewContoller: self)
            }
        }
    }
    
    // MARK: - Helpers
    
    @objc func willEnterForeground() {
        checkLocationServiceCondition()
        dismiss(animated: true, completion: nil)
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
    
    private func configureSelectBar() {
        
        let backView = UIView()
        backView.backgroundColor = .clear
        mapView.addSubview(backView)
        backView.anchor(left: mapView.leftAnchor, bottom: mapView.bottomAnchor, right: mapView.rightAnchor, height: 300)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        selectBar = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        selectBar.delegate = self
        selectBar.dataSource = self

        selectBar.register(SelectBarCell.self, forCellWithReuseIdentifier: selectBarReuseIndentifier)

        selectBar.backgroundColor = .clear
        
        backView.addSubview(selectBar)
        selectBar.translatesAutoresizingMaskIntoConstraints = false
        selectBar.anchor(top: backView.topAnchor, left: backView.leftAnchor, bottom: backView.bottomAnchor, right: backView.rightAnchor, paddingTop: 10, paddingBottom: UITabBarController().tabBar.frame.size.height + 10)
    }

    
    private func configureMapView() {
        view.addSubview(mapView)
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate,
                                        span: MKCoordinateSpan(
                                            latitudeDelta: 0.005,
                                            longitudeDelta: 0.005
                                        )
        )
        mapView.setRegion(region, animated:true)
    }
    
    private func configureNavigationBar() {
        navigationController?.title = "Map"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.title = "近辺のお店"
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.isHidden = false
    }
    
    private func configureNavigationBarRightButton() {
        let setCenterButton = UIImageView()
        setCenterButton.image = UIImage(systemName: "location")
        setCenterButton.tintColor = .white
        setCenterButton.setDimensions(width: 27, height: 27)
        setCenterButton.layer.masksToBounds = true
        setCenterButton.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(setCenterButtonTapped))
        setCenterButton.addGestureRecognizer(tap)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: setCenterButton)
    }
    
    private func configurePinOnMap() {
        self.longitude = "&longitude="
        self.latitude = "&latitude="
        
        fetchUserLocation { latitude, longitude in
            
            self.latitude += latitude
            self.longitude += longitude
            
            self.fetchData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.addMapPins(locations: self.shopData.locationCoordinatesArray)
            }
        }
    }
    
    @objc func setCenterButtonTapped() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        mapView.removeAnnotations(shopData.locationCoordinatesArray)
        configurePinOnMap()
    }
    
    private func fetchUserLocation(copletion: @escaping (_ latitude: String, _ longitude: String) -> Void) {
        LocationManager.shared.getUserLocation { location in
            
            let locationLatitude = String(CLLocationDegrees(location.coordinate.latitude))
            let locationLongitude = String(CLLocationDegrees(location.coordinate.longitude))
            
            copletion(locationLatitude, locationLongitude)
            
        }
    }
    
    private func fetchUserLocation() {
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.addMapPin(with: location)
            }
        }
    }
    
    private func addMapPins(locations: [MKPointAnnotation]) {
        mapView.setRegion(MKCoordinateRegion(
            center: mapView.userLocation.coordinate, span: MKCoordinateSpan(
                latitudeDelta: 0.005,
                longitudeDelta: 0.005
            )
        ),
        animated: true)
        mapView.delegate = self
        mapView.addAnnotations(locations)
    }
    
    private func addMapPin(with location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate,
                                             span: MKCoordinateSpan(
                                                latitudeDelta: 0.005,
                                                longitudeDelta: 0.005
                                             )
        ),
        animated: true)
        mapView.delegate = self
        mapView.addAnnotation(pin)
    }
    
    private func setCenterUserLocation() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
}

// MARK: - MKMapViewDelegate

extension MapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

//        let annotationView = MKPinAnnotationView()
//        annotationView.annotation = annotation
//        let mapPinImage = UIImage(named: "mapPin")
//        let resizedImage = mapPinImage?.resized(toWidth: 50)
//        annotationView.image = resizedImage
//        annotationView.canShowCallout = true
//
//        return annotationView
        
        if annotation is MKUserLocation {
            return nil
        }

        let pinID = "PIN"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pinID) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView()
            annotationView?.annotation = annotation
            let mapPinImage = UIImage(named: "mapPin")
            let resizedImage = mapPinImage?.resized(toWidth: 40)
            annotationView?.image = resizedImage
            annotationView?.canShowCallout = true

//            self.mobileUrl = annotation.subtitle! ?? ""

//            let gesture = UITapGestureRecognizer()
//            gesture.addTarget(self, action: #selector(moveToWebsite))

//            annotationView?.addGestureRecognizer(gesture)
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
}

// MARK: - UICollectionViewDelegate/DataSource

extension MapController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = shopData.hit_count
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = selectBar.dequeueReusableCell(withReuseIdentifier: selectBarReuseIndentifier, for: indexPath) as! SelectBarCell
        
        cell.setUpContents(name: shopData.nameArray[indexPath.row],
                           category: shopData.categoryArray[indexPath.row],
                           opentime: shopData.opentimeArray[indexPath.row])
        if let shopImage = URL(string: shopData.shopsImageArray[indexPath.row][0]) {
            cell.setUpImageView(imageUrl: shopImage)
        } else {
            cell.setUpImage()
        }
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        let favoriteShops = realm.objects(FavoriteShopData.self)
        for data in favoriteShops {
            if data.name ==  shopData.nameArray[indexPath.row] {
                cell.didRegisterd = true
                cell.registerShopButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.registerShopButton.tintColor = .systemYellow
            }
        }
        cell.layer.cornerRadius = 150 / 6
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.6
        cell.layer.masksToBounds = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        mapView.delegate = self
        
        let annotation = shopData.locationCoordinatesArray[indexPath.row]
        annotation.title = shopData.nameArray[indexPath.row]
        
        mapView.addAnnotation(annotation)
        mapView.setCenter(shopData.locationCoordinatesArray[indexPath.row].coordinate, animated: true)
        mapView.selectAnnotation(annotation, animated: true)
        
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MapController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 30
        let height = CGFloat(150)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width: CGFloat = 10
        return CGSize(width: width, height: selectBar.layer.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        let width: CGFloat = 10
        return CGSize(width: width, height: selectBar.layer.frame.height)
    }
}

extension MapController: SelectBarCellDelegate {
    func presentDetailWebView(indexPath row: Int) {
        let webController = WebController()
        webController.mobileUrl = shopData.mobileUrlArray[row]
        navigationController?.pushViewController(webController, animated: true)
    }
    
    func saveFavoriteShop(indexPath row: Int) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        try! realm.write {
            let favoriteShopData = FavoriteShopData()
            favoriteShopData.name = shopData.nameArray[row]
            favoriteShopData.category = shopData.categoryArray[row]
            favoriteShopData.opentime = shopData.opentimeArray[row]
            favoriteShopData.mobileUrl = shopData.mobileUrlArray[row]
            favoriteShopData.imageUrl = shopData.shopsImageArray[row][0]
            realm.add(favoriteShopData)
        }
    }
    
    func deleteFavoriteShop(indexPath row: Int) {
        let favoriteShops = realm.objects(FavoriteShopData.self)
        try! realm.write {
            for data in favoriteShops {
                if data.name ==  shopData.nameArray[row] {
                    realm.delete(data)
                }
            }
        }
    }
}



