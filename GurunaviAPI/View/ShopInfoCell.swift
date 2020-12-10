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
    
    private lazy var imageScrollView = UIScrollView()
    
//    private let imageView : UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.setDimensions(width: 300, height: 200)
//        imageView.image = #imageLiteral(resourceName: "854F4A80-24D7-4532-B1CE-0846B097E07E")
//        imageView.backgroundColor = .blue
//        return imageView
//    }()
    
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
        
        imageScrollView.backgroundColor = .red
        
        let customImageView = createSomeImageView()
        
        imageScrollView.addSubview(customImageView)
        imageScrollView.contentSize = customImageView.frame.size
        imageScrollView.isScrollEnabled = true
        imageScrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        addSubview(imageScrollView)
        imageScrollView.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingRight: 4, height: 230)
        
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
        delegate?.showActionSheet()
    }
    
    // MARK: - Helpers
    
    func createSomeImageView() -> UIImageView {
        let imageView = UIImageView()
        let pageWidth = 250
        let pageHeight = 230
        let pageViewRect = CGRect(x:0,y:0,width:pageWidth,height:pageHeight)
        
        for i in 0...4 {
            let iv = UIImageView(frame: pageViewRect)
            let left = pageViewRect.width * CGFloat(i)
            let xy = CGPoint(x:left,y:0)
            
            iv.image = #imageLiteral(resourceName: "Image")
            iv.frame = CGRect(origin: xy, size: pageViewRect.size)
            imageView.addSubview(iv)
        }
        
        return imageView
    }
}
