//
//  LaunchScreenViewController.swift
//  Estrela
//
//  Created by Alex Misko on 09.01.23.
//

import UIKit

@available(iOS 15.0, *)
class LaunchScreenViewController: UIViewController {
    
    private let logoImage = UIImageView()
    private let appNameLabel = UILabel()
    private let networkService: INetworkService
    private let presentationAssembly: IPresentationAssembly
    private let userInfoService: ISensentiveInfoService
    private let purchasesService: IProductService
    
    init(networkService: INetworkService,
         presentationAssembly: IPresentationAssembly,
         userInfoService: ISensentiveInfoService,
         purchasesService: IProductService
    ) {
        self.networkService = networkService
        self.userInfoService = userInfoService
        self.presentationAssembly = presentationAssembly
        self.purchasesService = purchasesService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPurchases()
        checkCountry()
        setup()
        style()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setup() {
        self.view.addSubview(logoImage)
        self.view.addSubview(appNameLabel)
    }
    
    private func style() {
        view.backgroundColor = UIColor(hexFromString: "001D3D")
        
        logoImage.image = UIImage(named: "applogo")
        
        appNameLabel.text = "ESTRELA"
        appNameLabel.textColor = .white
        appNameLabel.textAlignment = .center
        appNameLabel.font = UIFont.montserratBlack(ofSize: 48 * Constraints.yCoeff)
    }
    
    private func setupConstraints() {
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(view).offset(302 * Constraints.yCoeff)
            make.height.equalTo(150)
            make.width.equalTo(150)
            make.centerX.equalTo(view)

        }
        
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(2 * Constraints.yCoeff)
            make.centerX.equalTo(view)
        }
    }
    
    private func initPurchases() {
        purchasesService.purchasesInit()
    }
    
    private func checkCountry() {
        getCountry(ip: nil)
    }
    
    private func getPublicIPAddress() -> String {
        var publicIP = ""
        do {
            try publicIP = String(contentsOf: URL(string: "https://www.bluewindsolution.com/tools/getpublicip.php")!, encoding: String.Encoding.utf8)
            publicIP = publicIP.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        catch {
            print("Error: \(error)")
        }
        return publicIP
    }
    
    private func getCountry(ip: String?) {
        networkService.getCountry(ip: ip) { [ weak self ] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let launchModel):
                    strongSelf.userInfoService.saveCountryCode(country: launchModel.countryCode)
                    strongSelf.routeToNextScreen(appWay: launchModel.appWay)
                case .failure(let error):
                    strongSelf.displayMsg(title: nil, msg: error.textToDisplay)
                }
            }
        }
    }
    
    private func routeToNextScreen(appWay: AppWayByCountry) {
        switch appWay {
        case .toApp:
            guard userInfoService.wasPushAsked()
            else {
                let enterVC = presentationAssembly.askPermissionsScreen(link: nil)
                setWindowRoot(enterVC)
                return
            }
            homeOrEnterScreen()
        case .web:
            loadLink()
        }
    }
    
    private func loadLink() {
        networkService.loadLink { [ weak self ] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let link):
                    guard strongSelf.userInfoService.wasPushAsked()
                    else {
                        let enterVC = strongSelf.presentationAssembly.askPermissionsScreen(link: link)
                        strongSelf.setWindowRoot(enterVC)
                        return
                    }
                    let webview = strongSelf.presentationAssembly.webViewController(site: link, title: nil)
                    strongSelf.setWindowRoot(webview)
                case .failure(let failure):
                    strongSelf.displayMsg(title: nil, msg: failure.textToDisplay)
                }
            }
        }
    }
    
    private func homeOrEnterScreen() {
        guard
            userInfoService.isUserInApp() == false
        else {
            let tabbarController = presentationAssembly.mainViewController()
            setWindowRoot(tabbarController)
            return
        }
        let enterVC = presentationAssembly.enterScreen()
        setWindowRoot(enterVC)
    }
    
    private func setWindowRoot(_ viewController: UIViewController) {
        if #available(iOS 13.0, *) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        } else {
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(viewController)
        }
    }
    



}
