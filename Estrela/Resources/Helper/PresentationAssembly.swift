//
//  PresentationAssembly.swift
//  Estrela
//
//  Created by Alex Misko on 10.01.23.
//

import UIKit

@available(iOS 15.0, *)
protocol IPresentationAssembly {
    func enterScreen() -> SignInViewController
    func askPermissionsScreen(link: String?) -> PushNotificationViewController
    func mainViewController() -> MainViewController
    func createQuestion() -> CreateQuestionViewController
    func webViewController(site: String, title: String?) -> WebViewViewController
    func settingsScreen() -> SettingsViewController
    func getCountryCheckScreen() -> LaunchScreenViewController
    func getResultScreen() -> ResultViewController
}

@available(iOS 15.0, *)
class PresentationAssembly: IPresentationAssembly {
    
    let serviceAssembly: IServiceAssembly
    
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func getCountryCheckScreen() -> LaunchScreenViewController {
        LaunchScreenViewController(networkService: serviceAssembly.networkService,
                                   presentationAssembly: self,
                                   userInfoService: serviceAssembly.userInfoService,
                                   purchasesService: serviceAssembly.purchasesService)
    }

    func enterScreen() -> SignInViewController {
        SignInViewController(presentationAssembly: self,
                            userInfoService: serviceAssembly.userInfoService,
                            networkService: serviceAssembly.networkService)
    }

    func webViewController(site: String, title: String? = nil) -> WebViewViewController {
        WebViewViewController(site: site, title: title)
    }

    func askPermissionsScreen(link: String?) -> PushNotificationViewController {
        PushNotificationViewController(presentationAssembly: self,
                                     userInfoService: serviceAssembly.userInfoService)
    }
    
    func mainViewController() -> MainViewController {
        MainViewController(presentationAssembly: self,
                           sensetiveUserService: serviceAssembly.userInfoService,
                           purchasesService: serviceAssembly.purchasesService)
    }

    func createQuestion() -> CreateQuestionViewController {
        CreateQuestionViewController(presentationAssembly: self,
                                     sensetiveUserService: serviceAssembly.userInfoService,
                                     purchasesService: serviceAssembly.purchasesService)
    }

    func settingsScreen() -> SettingsViewController {
    
        SettingsViewController(networkService: serviceAssembly.networkService,
                                         userInfoService: serviceAssembly.userInfoService,
                                         productService: serviceAssembly.purchasesService,
                                        presentationAssembly: self)
    }

    func getResultScreen() -> ResultViewController {
        ResultViewController(sensetiveUserService: serviceAssembly.userInfoService,
                             purchasesService: serviceAssembly.purchasesService)
    }
    
}
