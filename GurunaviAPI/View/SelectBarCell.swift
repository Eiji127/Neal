//
//  SelectBarCell.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/03/19.
//
import UIKit


protocol SelectBarCellDelegate: class {
    func presentDetailWebView(indexPath row: Int)
    func saveFavoriteShop(indexPath row: Int)
    func deleteFavoriteShop(indexPath row: Int)
}

class SelectBarCell: UICollectionViewCell {
    // MARK: - Properties
    
    weak var delegate: SelectBarCellDelegate?
    
    var indexPath = IndexPath()
    
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
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 120, height: 100)
        imageView.layer.cornerRadius = 50 / 6
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "noImage_color")
        imageView.tintColor = .red
        return imageView
    }()
    
    lazy var registerShopButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.addTarget(self, action: #selector(registerFavoriteShop), for: .touchUpInside)
        button.setDimensions(width: 40, height: 40)
        return button
    }()
    
    lazy var detailInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemRed
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.addTarget(self, action: #selector(presentDetailWebView), for: .touchUpInside)
        button.setDimensions(width: 40, height: 40)
        return button
    }()
    
    var didRegisterd = false
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .nealBack
        
        let infoStack = UIStackView(arrangedSubviews: [nameLabel, categoryLabel, opentimeLabel])
        infoStack.axis = .vertical
        infoStack.distribution = .fill
        infoStack.spacing = 4
        
        let buttonStack = UIStackView(arrangedSubviews: [registerShopButton, detailInfoButton])
        buttonStack.axis = .vertical
        buttonStack.distribution = .fillEqually
        
        let stack = UIStackView(arrangedSubviews: [imageView, infoStack, buttonStack])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 10
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        registerShopButton.setImage(UIImage(systemName: "star"), for: .normal)
        registerShopButton.tintColor = .lightGray
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    @objc func presentDetailWebView() {
        delegate?.presentDetailWebView(indexPath: indexPath.row)
    }
    
    @objc func registerFavoriteShop() {
        didRegisterd.toggle()
        if didRegisterd {
            registerShopButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            registerShopButton.tintColor = .systemYellow
            delegate?.saveFavoriteShop(indexPath: indexPath.row)
        } else {
            registerShopButton.setImage(UIImage(systemName: "star"), for: .normal)
            registerShopButton.tintColor = .lightGray
            delegate?.deleteFavoriteShop(indexPath: indexPath.row)
        }
    }
    
    func setUpContents(name: String, category: String, opentime: String){
        nameLabel.text = name
        categoryLabel.text = category
        opentimeLabel.text = opentime
    }
    
    func setUpImageView(imageUrl: URL) {
        imageView.sd_setImage(with: imageUrl, completed: nil)
    }
    
    func setUpImage() {
        imageView.image = UIImage(named: "noImage_color")
        imageView.tintColor = .red
    }
}

