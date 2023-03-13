//
//  SettingsViewController.swift
//  Estrela
//
//  Created by Alex Misko on 27.12.22.
//

import UIKit
import MBProgressHUD

class SettingsViewController: UIViewController {

    private let backButton = UIButton()
    private let appLogoImage = UIImageView()
    private let settingsTitleLabel = UILabel()
    private let noMoreAdsButton = UIButton()
    private let sendFeedbackButton = UIButton()
    private let privacyPolicyButton = UIButton()
    private let termsOfUseButton = UIButton()
    private let deleteAccountButton = UIButton()
    
    private let userInfoService: ISensentiveInfoService
    private let productService: IProductService
    private let networkService: INetworkService
    private let presentationAssembly: IPresentationAssembly
    
    init(
        networkService: INetworkService,
        userInfoService: ISensentiveInfoService,
        productService: IProductService,
        presentationAssembly: IPresentationAssembly
    ) {
        self.networkService = networkService
        self.userInfoService = userInfoService
        self.productService = productService
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        view.addSubview(backButton)
        view.addSubview(appLogoImage)
        view.addSubview(settingsTitleLabel)
        view.addSubview(noMoreAdsButton)
        view.addSubview(sendFeedbackButton)
        view.addSubview(privacyPolicyButton)
        view.addSubview(termsOfUseButton)
        view.addSubview(deleteAccountButton)

    }
    

    private func style() {
        
        view.backgroundColor = UIColor(hexFromString: "001D3D")

        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        
        appLogoImage.image = UIImage(named: "applogo")
        appLogoImage.transform = appLogoImage.transform.rotated(by: .pi / 0.17)
        
        settingsTitleLabel.text = "Settings"
        settingsTitleLabel.textColor = .white
        settingsTitleLabel.font = UIFont.montserratBlack(ofSize: 24 * Constraints.yCoeff)
        
        noMoreAdsButton.setTitle("NO MORE ADS", for: .normal)
        noMoreAdsButton.titleLabel?.font = UIFont.montserratMedium(ofSize: 16 * Constraints.yCoeff)
        noMoreAdsButton.titleLabel?.textColor = .white
        noMoreAdsButton.addTarget(self, action: #selector(noMoreAdsButtonTap), for: .touchUpInside)

        sendFeedbackButton.setTitle("SEND FEEDBACK", for: .normal)
        sendFeedbackButton.titleLabel?.font = UIFont.montserratMedium(ofSize: 16 * Constraints.yCoeff)
        sendFeedbackButton.titleLabel?.textColor = .white
        sendFeedbackButton.addTarget(self, action: #selector(sendFeedbackButtonTap), for: .touchUpInside)

        privacyPolicyButton.setTitle("PRIVACY POLICY", for: .normal)
        privacyPolicyButton.titleLabel?.font = UIFont.montserratMedium(ofSize: 16 * Constraints.yCoeff)
        privacyPolicyButton.titleLabel?.textColor = .white
        privacyPolicyButton.addTarget(self, action: #selector(privacyPolicyButtonTap), for: .touchUpInside)

        termsOfUseButton.setTitle("TERMS OF USE", for: .normal)
        termsOfUseButton.titleLabel?.font = UIFont.montserratMedium(ofSize: 16 * Constraints.yCoeff)
        termsOfUseButton.titleLabel?.textColor = .white
        termsOfUseButton.addTarget(self, action: #selector(termsOfUseButtonTap), for: .touchUpInside)

        deleteAccountButton.setTitle("DELETE ACCOUNT", for: .normal)
        deleteAccountButton.titleLabel?.font = UIFont.montserratMedium(ofSize: 16 * Constraints.yCoeff)
        deleteAccountButton.titleLabel?.textColor = .white
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTap), for: .touchUpInside)

    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view).offset(61 * Constraints.yCoeff)
            make.height.equalTo(21 * Constraints.yCoeff)
            make.width.equalTo(21 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(30 * Constraints.xCoeff)
        }
        
        appLogoImage.snp.makeConstraints { make in
            make.top.equalTo(view).offset(100 * Constraints.yCoeff)
            make.height.equalTo(387.38 * Constraints.yCoeff)
            make.width.equalTo(387.38 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(152 * Constraints.xCoeff)
        }
        
        settingsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(328 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(50 * Constraints.xCoeff)
        }
        
        noMoreAdsButton.snp.makeConstraints { make in
            make.top.equalTo(settingsTitleLabel.snp.bottom).offset(25 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(50 * Constraints.xCoeff)
        }
        
        if userInfoService.isPremiumActive() {
            noMoreAdsButton.alpha = 0
            sendFeedbackButton.snp.makeConstraints { make in
                make.top.equalTo(settingsTitleLabel.snp.bottom).offset(25 * Constraints.yCoeff)
                make.leading.equalTo(view).offset(50 * Constraints.xCoeff)
            }
        } else {
            noMoreAdsButton.alpha = 1
            sendFeedbackButton.snp.makeConstraints { make in
                make.top.equalTo(noMoreAdsButton.snp.bottom).offset(13 * Constraints.yCoeff)
                make.leading.equalTo(view).offset(50 * Constraints.xCoeff)
            }
        }
        
        privacyPolicyButton.snp.makeConstraints { make in
            make.top.equalTo(sendFeedbackButton.snp.bottom).offset(13 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(50 * Constraints.xCoeff)
        }
        
        termsOfUseButton.snp.makeConstraints { make in
            make.top.equalTo(privacyPolicyButton.snp.bottom).offset(13 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(50 * Constraints.xCoeff)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(termsOfUseButton.snp.bottom).offset(13 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(50 * Constraints.xCoeff)
        }
        
    }
    
    @objc func backButtonTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func noMoreAdsButtonTap() {
        buyRemoveAdd()
    }
    
    @objc func sendFeedbackButtonTap() {
        routeToWebSite("\(ApiConstants.URL.mainURL)/#support")
    }
    
    @objc func privacyPolicyButtonTap() {
        routeToWebSite("\(ApiConstants.URL.mainURL)/privacy.html")
    }
    
    @objc func termsOfUseButtonTap() {
        routeToWebSite("\(ApiConstants.URL.mainURL)/terms.html")
    }
    
    @objc func deleteAccountButtonTap() {
        networkService.deleteProfile { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(_):
                    strongSelf.revokeAppleToken()
                    strongSelf.goToEnterScreen()
                case .failure(_):
                    strongSelf.goToEnterScreen()
                }
            }
        }
    }
    
    func routeToWebSite(_ site: String) {
        navigationController?.pushViewController(
            presentationAssembly.webViewController(site: site, title: nil), animated: true
        )
    }
    
    func buyRemoveAdd() {
        self.showLoading()
        productService.buyAddsOff { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.userInfoService.savePremium()
                case .failure(let error):
                    self?.showMessage(text: error.localizedDescription)
                    print(error)
                }
                self?.hideLoading()
                self?.updateSettings()
            }
        }
    }
    
    private func updateSettings() {
        if userInfoService.isPremiumActive() {
            DispatchQueue.main.async { [self] in
                noMoreAdsButton.alpha = 0
                sendFeedbackButton.snp.makeConstraints { make in
                    make.top.equalTo(settingsTitleLabel.snp.bottom).offset(25 * Constraints.yCoeff)
                    make.leading.equalTo(view).offset(50 * Constraints.xCoeff)
                }
            }
        } else {
            DispatchQueue.main.async { [self] in
                noMoreAdsButton.alpha = 1
            }
        }
    }

    private func revokeAppleToken() {
        guard let appleToken = userInfoService.getAppleToken() else { return }
        networkService.revokeToken(appleId: appleToken)
    }
    
    private func goToEnterScreen() {
        userInfoService.deleteAllInfo { _ in
            self.routeToEnterScreen()
        }
    }
    
    func routeToEnterScreen() {
        if #available(iOS 13.0, *) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(presentationAssembly.enterScreen())
        } else {
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(presentationAssembly.enterScreen())
        }
    }

    private func restorePurchases() {
        productService.restorePurchases { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.userInfoService.savePremium()
                case .failure(let error):
                    self?.showMessage(text: error.localizedDescription)
                }
                self?.hideLoading()
                self?.updateSettings()
            }
        }
    }
    
    func showMessage(text: String) {
        displayMsg(title: nil, msg: text)
    }
    
}
