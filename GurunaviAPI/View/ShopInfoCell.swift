//
//  ShopInfoCell.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/07.
//

import UIKit

class ShopInfoCell: UICollectionViewCell {
    // MARK: - Properties
    
    private let underlineView: UIView = {
        let line = UIView()
        line.backgroundColor = .systemGroupedBackground
        return line
    }()
    
    private lazy var imageScrollView = UIScrollView()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 200, height: 200)
        imageView.image = #imageLiteral(resourceName: "Image")
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10)
        
        addSubview(underlineView)
        underlineView.anchor(top: imageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,paddingTop: 10, paddingLeft: 5, paddingRight: 5, height: 3)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
}
