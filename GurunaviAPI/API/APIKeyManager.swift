//
//  APIKeyManager.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/01/13.
//

import UIKit

struct APIKeyManager {

    private let keyFilePath = Bundle.main.path(forResource: "GurunaviAPIKey", ofType: "plist")

    func getKeys() -> NSDictionary? {
        guard let keyFilePath = keyFilePath else {
            return nil
        }
        return NSDictionary(contentsOfFile: keyFilePath)
    }

    func getValue(key: String) -> AnyObject? {
        guard let keys = getKeys() else {
            return nil
        }
        return keys[key]! as AnyObject
    }
}
