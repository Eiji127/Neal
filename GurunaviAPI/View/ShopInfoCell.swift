//
//  ShopInfoCell.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/07.
//

import UIKit

protocol ShopInfoCellDelegate: class {
    func showActionSheet()
}

class ShopInfoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    weak var delegate: ShopInfoCellDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Shop Name"
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "category"
        return label
    }()
    
    private let opentimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "opentime: 10:00 ~ 21:00"
        return label
    }()
    
    private let underlineView: UIView = {
        let line = UIView()
        line.backgroundColor = .systemGroupedBackground
        return line
    }()
    
    private let imageScrollView = UIScrollView()
    
    private var images = [UIImageView]()
    
    private let imageViewBlue : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 200, height: 250)
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    private let imageViewRed : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 200, height: 250)
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private let imageViewYellow : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 200, height: 250)
        imageView.backgroundColor = .yellow
        return imageView
    }()
    
    private lazy var optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let infoStack = UIStackView(arrangedSubviews: [categoryLabel, opentimeLabel])
        infoStack.axis = .horizontal
        infoStack.distribution = .fillProportionally
        infoStack.spacing = 6
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, infoStack])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 5)
        
        imageScrollView.addSubview(imageViewBlue)
        imageScrollView.addSubview(imageViewRed)
        imageScrollView.addSubview(imageViewYellow)
        
        imageScrollView.backgroundColor = .red
        addSubview(imageScrollView)
        imageScrollView.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingRight: 4, width: 250, height: 200)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
        
        addSubview(optionButton)
        optionButton.centerY(inView: stack)
        optionButton.anchor(right: rightAnchor, paddingRight: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func showActionSheet() {
        print("DEBUG: Show actionsheet..")
        delegate?.showActionSheet()
    }
    
    // MARK: - Helpers
    
}
