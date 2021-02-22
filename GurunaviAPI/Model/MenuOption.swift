//
//  MenuOption.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/02/21.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    case Info
    case Inbox
    case Notifications
    case Settings
    
    var description: String {
        switch self {
        case .Info:
            return "nealについて"
        case .Inbox:
            return "お気に入り"
        case .Notifications:
            return "ご意見・ご要望"
        case .Settings:
            return "設定"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Info:
            return UIImage(systemName: "info.circle") ?? UIImage()
        case .Inbox:
            return UIImage(systemName: "star") ?? UIImage()
        case .Notifications:
            return UIImage(systemName: "rectangle.and.pencil.and.ellipsis") ?? UIImage()
        case .Settings:
            return UIImage(systemName: "gearshape") ?? UIImage()
        }
    }
}
