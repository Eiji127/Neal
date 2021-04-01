//
//  AlertManager.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/01/29.
//

import UIKit

class AlertManager {
    
    static let shared = AlertManager()
    
    func showErrorAlert(viewContoller: UIViewController, handler: ((UIAlertAction) -> Void)? = nil){
        let alertController = UIAlertController(title: "エラーが発生しました.\n再度更新して下さい.", message: nil, preferredStyle: .alert)
        let dimissAlert = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alertController.addAction(dimissAlert)
        viewContoller.present(alertController, animated: true, completion: nil)
    }
    
    func showNoHitAlert(viewContoller: UIViewController, handler: ((UIAlertAction) -> Void)? = nil){
        let alertController = UIAlertController(title: "検索結果：0件", message: "近辺に該当する店舗はありません", preferredStyle: .alert)
        let dimissAlert = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alertController.addAction(dimissAlert)
        viewContoller.present(alertController, animated: true, completion: nil)
    }
    
    func showAllowingFetchLocationAlert(viewContoller: UIViewController, handler: ((UIAlertAction) -> Void)? = nil){
        let alertController = UIAlertController(title: "位置情報サービスを\nオンにしてください", message: "「設定」 ⇒「プライバシー」⇒「位置情報サービス」からオンにできます", preferredStyle: .alert)
        let dimissAlert = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(dimissAlert)
        viewContoller.present(alertController, animated: true, completion: nil)
    }
    
    func showFavoriteShopRegistration(viewContoller: UIViewController, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "この店舗をお気に入りから\n削除しますか？", message: nil, preferredStyle: .alert)
        let dimissAlert = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        let  deleteAlert = UIAlertAction(title: "キャンセル", style: .default)
        alertController.addAction(dimissAlert)
        alertController.addAction(deleteAlert)
        viewContoller.present(alertController, animated: true, completion: nil)
    }
}
