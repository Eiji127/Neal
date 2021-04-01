//
//  Protocols.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/02/21.
//

// MARK: - ContainerControllerDelegate

protocol  HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?)
}

// MARK: - TabBarControllerDelegate

protocol TabBarDelegate: class {
    func configureSideMenuBar()
}

protocol TabBarDelegateForFeedController {
    func moveTopView()
}

// MARK: - shopInfoHeaderDelegate

protocol shopInfoHeaderDelegate: class {
    func saveFavoriteShop(indexPath section: Int)
    func deleteFavoriteShop(indexPath section: Int)
}


// MARK: - SelectBarCellDelegate

protocol SelectBarCellDelegate: class {
    func presentDetailWebView(indexPath row: Int)
    func saveFavoriteShop(indexPath row: Int)
    func deleteFavoriteShop(indexPath row: Int)
}

