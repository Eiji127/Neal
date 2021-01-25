//
//  ActionSheetLauncher.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/10.
//

import UIKit


private let reuseIdentifier = "ActionSheetCell"

//protocol ActionSheetLauncherDelegate: class{
//    func didSelect(option: ActionSheetOpitions)
//}

class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties
    private var window: UIWindow?
//    weak var delegate: ActionSheetLauncherDelegate?
    private var contentsViewHeight: CGFloat?
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [researchButton, cancelButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(left: view.leftAnchor,bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 12, paddingBottom: 50, paddingRight: 12)
        stack.centerY(inView: view)
        
        return view
    }()
    
//    private let pickerView: UIPickerView = {
//        let picker = UIPickerView()
//    }()
    
    private lazy var researchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Research", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.layer.cornerRadius = 30 / 2
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.layer.cornerRadius = 30 / 2
        return button
    }()
    
    // MARK: - Lifecycles
    override init() {
        super.init()
    }
    
    // MARK: - Selectors
    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.contentsView.frame.origin.y += 700
        }
    }
    
    // MARK: - Helpers
    func showTableView(_ shouldShow: Bool) {
        guard let window = window else { return }
        guard let height = contentsViewHeight else { return }
        let contentsViewHeight = shouldShow ? window.frame.height - height : window.frame.height
        contentsView.frame.origin.y = contentsViewHeight
    }
    
    func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        self.window = window
        
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(contentsView)
        let height = window.frame.height * 7 / 10
        self.contentsViewHeight = CGFloat(height)
        contentsView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: CGFloat(height))
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.showTableView(true)
        }
    }
}

