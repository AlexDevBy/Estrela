//
//  CoreAssembly.swift
//  Estrela
//
//  Created by Alex Misko on 10.01.23.
//

import Foundation

protocol ICoreAssembly {
    var requestSender: IRequestSender { get }
    var secureStorage: ISecureStorage { get }
    var userDefaultsSettings: IUserDefaultsSettings { get }
    var purchases: Purchases { get }
}

class CoreAssembly: ICoreAssembly {
    init() {}
    lazy var requestSender: IRequestSender = RequestSender()
    lazy var secureStorage: ISecureStorage = SecureStorage.shared
    lazy var userDefaultsSettings: IUserDefaultsSettings = UserDefaultsStorage.shared
    lazy var purchases: Purchases = Purchases.default
}
