//
//  ShopInfoHeader.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/24.
//

import UIKit
import RealmSwift

protocol shopInfoHeaderDelegate: class {
    func saveFavoriteShop(indexPath section: Int)
    func deleteFavoriteShop()
}


class ShopInfoHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Shop Name"
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Category"
        return label
    }()
    
    let opentimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Opentime: 10:00 ~ 21:00"
        return label
    }()
    
    
    lazy var registerShopButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.addTarget(self, action: #selector(registerFavoriteShop), for: .touchUpInside)
        return button
    }()
    
    var didRegisterd = false
    var favoriteModel = FavoriteModel()
    
    var indexPath = IndexPath()
    
    weak var delegate: shopInfoHeaderDelegate?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .nealBack
        
        let infoStack = UIStackView(arrangedSubviews: [categoryLabel, opentimeLabel])
        infoStack.axis = .horizontal
        infoStack.distribution = .fillProportionally
        infoStack.spacing = 6
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, infoStack])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 30, paddingRight: 50)
        
        addSubview(registerShopButton)
        registerShopButton.centerY(inView: stack)
        registerShopButton.anchor(right: rightAnchor, paddingRight: 20)
        
        registerShopButton.tintColor = didRegisterd ? UIColor.systemYellow : UIColor.lightGray
        
//        registerShopButton.tintColor = favoriteModel.favoriteButtonTintColor
//        registerShopButton.setImage(favoriteModel.favoriteButtonImage, for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func setUpContents(name: String, category: String, opentime: String){
        nameLabel.text = name
        categoryLabel.text = category
        opentimeLabel.text = " / " + opentime
    }
    
    @objc func registerFavoriteShop() {
        
        didRegisterd.toggle()
        if didRegisterd {
            registerShopButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            registerShopButton.tintColor = .systemYellow
            delegate?.saveFavoriteShop(indexPath: indexPath.section)
        } else {
            registerShopButton.setImage(UIImage(systemName: "star"), for: .normal)
            registerShopButton.tintColor = .lightGray
            delegate?.deleteFavoriteShop()
        }
    }
    
}
