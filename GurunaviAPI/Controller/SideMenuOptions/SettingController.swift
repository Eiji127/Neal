//
//  SettingController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/02/25.
//

import UIKit


private let reuseIdentifier = "SettingCell"

//protocol ActionSheetLauncherDelegate: class{
//    func didSelect(option: ActionSheetOpitions)
//}

class SettingController: UITableViewController {
    
    // MARK: - Properties
    
    private lazy var cancelButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
        
    }()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .nealBack
        
        configureNavigationBar()
        
        tableView.register(SettingCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        
    }
    
    // MARK: - Selectors
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Helpers
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .nealBack
        navigationController?.navigationBar.tintColor = .systemRed
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "設定"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(handleDismissal))
    }
}

extension SettingController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingCell
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height - 200
    }
}



