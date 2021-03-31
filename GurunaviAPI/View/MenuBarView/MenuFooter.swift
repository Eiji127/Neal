//
//  MenuFooter.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/02/22.
//

import UIKit

class MenuFooter: UICollectionReusableView {
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Version 1.0"
        return label
    }()
    
    private let underlineView: UIView = {
        let line = UIView()
        line.backgroundColor = .white
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemRed
        
//        addSubview(versionLabel)
//        versionLabel.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 10, paddingRight: 180)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
