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
    
    lazy var realm = try! Realm()

//    lazy var results: Results<FavoriteShopData> = {
//
//        self.realm.objects(FavoriteShopData.self)
//
//    }()
    
    var data = [FavoriteShopData]()
    
//    var notificationToken: NotificationToken? = nil
    
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
        
//        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
//            guard let collectionView = self?.collectionView else { return }
//            switch changes {
//            case .initial:
//                print("DEBUG: initial...")
//                collectionView.reloadData()
//                break
//            case .update(_, let deletions, let insertions, let modifications):
//                print("DEBUG: update...")
//                collectionView.performBatchUpdates({
//                    collectionView.insertItems(at: insertions.map { NSIndexPath(row: $0, section: 0) as IndexPath })
//                    collectionView.deleteItems(at: deletions.map { NSIndexPath(row: $0, section: 0) as IndexPath })
//                    collectionView.reloadItems(at: modifications.map { NSIndexPath(row: $0, section: 0) as IndexPath })
//                }, completion: { _ in })
//                break
//            case .error(let error):
//                fatalError("DEBUG: \(error)")
//                break
//            }
//        }
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongTapped))
        longPressRecognizer.allowableMovement = 10
        longPressRecognizer.minimumPressDuration = 0.5
        self.collectionView.addGestureRecognizer(longPressRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemRed
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    // MARK: - Handlers
    @objc func cellLongTapped(sender: UILongPressGestureRecognizer) {
        let point: CGPoint = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            switch sender.state {
            case .began:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
                AlertManager.shared.showFavoriteShopRegistration(viewContoller: self) { _ in
                    try! self.realm.write {
                        let favoriteShops = self.realm.objects(FavoriteShopData.self)
                        self.realm.delete(favoriteShops[indexPath.row])
                    }
                    self.loadView()
                    self.viewDidLoad()
                }
            case .ended: break
            default:
                break
            }
        }
    }
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
//    func objectAtIndexPath(indexPath: NSIndexPath) -> FavoriteShopData {
//        return results[indexPath.row]
//    }
    
//    func refresh() {
//        data = realm.objects(FavoriteShopData.self).map({ $0 })
//        collectionView.reloadData()
//    }
    
}

// MARK: - UICollectionView Delegate/DataSorce

extension FavoriteShopsController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoriteShopCellIdentifier, for: indexPath) as! FavoriteShopsCell
        cell.nameLabel.text = data[indexPath.row].name
        cell.categoryLabel.text = data[indexPath.row].category
        cell.opentimeLabel.text = data[indexPath.row].opentime
        if let shopImage = URL(string: data[indexPath.row].imageUrl) {
            cell.setUpImageView(imageUrl: shopImage)
        } else {
            cell.setUpImage()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let webController = WebController()
        webController.mobileUrl = data[indexPath.row].mobileUrl
        navigationController?.pushViewController(webController, animated: true)
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoriteShopsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = Int( UIScreen.main.bounds.size.width)
        let screenHeight = Int(UIScreen.main.bounds.size.height / 6)
        return CGSize(width: screenWidth, height: screenHeight)
    }
    
}

