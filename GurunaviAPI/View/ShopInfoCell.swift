//
//  ShopInfoCell.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/07.
//

import UIKit
import SDWebImage

class ShopInfoCell: UICollectionViewCell {
    // MARK: - Properties
    
    private let underlineView: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        line.alpha = 0.5
        return line
    }()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 200, height: 200)
        imageView.layer.cornerRadius = 200 / 6
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "noImage_color")
        imageView.tintColor = .red
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .nealBack
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10)
        
        addSubview(underlineView)
        underlineView.anchor(top: imageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,paddingTop: 10, paddingLeft: 30, paddingRight: 30, height: 2)
        
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
