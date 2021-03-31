//
//  MenuHeader.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/02/21.
//

import UIKit

class MenuHeader: UICollectionReusableView {
    
    private let nealImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 150, height: 50)
//        imageView.backgroundColor = .black
        imageView.image = UIImage(named: "nealIcon")
        return imageView
    }()
    
    private let underlineView: UIView = {
        let line = UIView()
        line.backgroundColor = .white
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemRed
        
        addSubview(nealImage)
        nealImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: 10, paddingRight: 150)
        
        
        addSubview(underlineView)
        underlineView.anchor(top: nealImage.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,paddingTop: 10, paddingLeft: 5, paddingRight: 5, height: 3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
