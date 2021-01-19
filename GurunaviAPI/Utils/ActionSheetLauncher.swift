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
    private let tableView = UITableView()
    private var window: UIWindow?
//    weak var delegate: ActionSheetLauncherDelegate?
    private var tableViewHeight: CGFloat?
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        let stack = UIStackView(arrangedSubviews: [researchButton, cancelButton])
        stack.axis = .vertical
        view.addSubview(stack)
//        stack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stack.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12)
        stack.centerY(inView: view)
        stack.spacing = 20
        return view
    }()
    
//    private let pickerView: UIPickerView = {
//        let picker = UIPickerView()
//    }
    
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
        configureTableView()
    }
    
    // MARK: - Selectors
    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 700
        }
    }
    
    // MARK: - Helpers
    func showTableView(_ shouldShow: Bool) {
        guard let window = window else { return }
        guard let height = tableViewHeight else { return }
        let tableViewHeight = shouldShow ? window.frame.height - height : window.frame.height
        tableView.frame.origin.y = tableViewHeight
    }
    
    func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        self.window = window
        
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(tableView)
        let height = window.frame.height * 7 / 10
        self.tableViewHeight = CGFloat(height)
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: CGFloat(height))
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.showTableView(true)
        }
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}
// MARK: - UITableViewDataSource
extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ActionSheetLauncher: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            self.showTableView(false)
        }) { _ in
//            self.delegate?.didSelect(option: option)
        }
    }
}

