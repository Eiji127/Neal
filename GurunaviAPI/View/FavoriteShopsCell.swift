//
//  FavoriteShopsCell.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/02/23.
//

import UIKit
import SDWebImage

class FavoriteShopsCell: UICollectionViewCell {
    // MARK: - Properties
    
    private let underlineView: UIView = {
        let line = UIView()
        line.backgroundColor = .systemYellow
        return line
    }()
    
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
        imageView.setDimensions(width: 100, height: 100)
        imageView.layer.cornerRadius = 50 / 6
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "noImage_color")
        imageView.tintColor = .red
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .nealBack
        
        let infoStack = UIStackView(arrangedSubviews: [nameLabel, categoryLabel, opentimeLabel])
        infoStack.axis = .vertical
        infoStack.distribution = .fill
        infoStack.spacing = 4
        
        let stack = UIStackView(arrangedSubviews: [imageView, infoStack])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 10
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func setUpImageView(imageUrl: URL) {
        imageView.sd_setImage(with: imageUrl, completed: nil)
    }
    
    func setUpImage() {
        imageView.image = UIImage(named: "noImage_color")
        imageView.tintColor = .red
    }
}
