//
//  ServiceAssembly.swift
//  Estrela
//
//  Created by Alex Misko on 10.01.23.
//

import Foundation

protocol IServiceAssembly {
    var networkService: INetworkService { get }
    var userInfoService: ISensentiveInfoService { get }
    var purchasesService: IProductService { get }
    var deviceLocationService: IDeviceLocationService { get }
}

class ServiceAssembly: IServiceAssembly {
    
    private let coreAssembly: ICoreAssembly
    lazy var deviceLocationService: IDeviceLocationService = DeviceLocationService.shared
 
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var networkService: INetworkService = NetworkService(requestSender: coreAssembly.requestSender)
    lazy var purchasesService: IProductService = ProductService(purchases: coreAssembly.purchases)
    lazy var userInfoService: ISensentiveInfoService = AppInfoService(secureStorage: coreAssembly.secureStorage,
                                                                      userInfoStorage: coreAssembly.userDefaultsSettings)
}
