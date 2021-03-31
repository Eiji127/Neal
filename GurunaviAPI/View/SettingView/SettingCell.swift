//
//  SettingCell.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/02/25.
//

import UIKit


class SettingCell: UITableViewCell {
    
    // MARK: - Properties

    private let optionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "neal-Logo")
        return iv
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.tintColor = .lightGray
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cofigureCellUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func cofigureCellUI() {
        
        backgroundColor = .nealBack
        
        addSubview(versionLabel)
        versionLabel.centerX(inView: self)
        versionLabel.anchor(bottom: bottomAnchor, paddingBottom: 20)
        fetchAppVersionData()
        
    }
    
    func fetchAppVersionData() {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        versionLabel.text = "Version " + version
    }
    
}


