//
//  ViewController.swift
//  Estrela
//
//  Created by Alex Misko on 27.12.22.
//

import UIKit
import SnapKit
import UserNotifications
import CoreLocation

@available(iOS 15.0, *)
class PushNotificationViewController: UIViewController {

    private let welcomeTitleLabel = UILabel()
    private let questionLabel = UILabel()
    private let logoImage = UIImageView()
    private let okayButton = UIButton()
    private let skipButton = UIButton()
    private let presentationAssembly: IPresentationAssembly
    private let userInfoService: ISensentiveInfoService
    private let linkToGo: String?
    
    init(
        presentationAssembly: IPresentationAssembly,
        userInfoService: ISensentiveInfoService,
        link: String? = nil
    ) {
        self.presentationAssembly = presentationAssembly
        self.userInfoService = userInfoService
        self.linkToGo = link
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
    
    func setup() {
        view.addSubview(logoImage)
        view.addSubview(welcomeTitleLabel)
        view.addSubview(questionLabel)
        view.addSubview(okayButton)
        view.addSubview(skipButton)
    }
    
    func style() {
        view.backgroundColor = UIColor(hexFromString: "001D3D")
        
        welcomeTitleLabel.text = "Hey!"
        welcomeTitleLabel.textColor = .white
        welcomeTitleLabel.font = UIFont.gilroyBold(ofSize: 32 * Constraints.yCoeff)
        
        questionLabel.text = "Can we send you\npush-notifications?"
        questionLabel.textColor = .white
        questionLabel.font = UIFont.gilroyMedium(ofSize: 16 * Constraints.yCoeff)
        questionLabel.numberOfLines = 0
        
        logoImage.image = UIImage(named: "applogo")
        logoImage.transform = logoImage.transform.rotated(by: .pi / 0.17)
        
        okayButton.backgroundColor = UIColor(hexFromString: "8D063F")
        okayButton.setAttributedTitle(NSAttributedString(string: "Okay"), for: .normal)
        okayButton.titleLabel?.textColor = .white
        okayButton.titleLabel?.font = UIFont.montserratBold(ofSize: 18 * Constraints.yCoeff)
        okayButton.addTarget(self, action: #selector(okayButtonTap), for: .touchUpInside)
        okayButton.layer.cornerRadius = 5
        okayButton.layer.masksToBounds = true
        
        skipButton.setAttributedTitle("Skip".underLined, for: .normal)
        skipButton.titleLabel?.textColor = .white
        skipButton.titleLabel?.font = UIFont.montserratMedium(ofSize: 12 * Constraints.yCoeff)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        
    }

    func setupConstraints() {
        welcomeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(282 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeTitleLabel.snp.bottom).offset(3 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
        }
        
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(view).offset(82 * Constraints.yCoeff)
            make.height.equalTo(387.38 * Constraints.yCoeff)
            make.width.equalTo(387.38 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(122 * Constraints.xCoeff)
        }
        
        okayButton.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(59 * Constraints.yCoeff)
            make.height.equalTo(60 * Constraints.yCoeff)
            make.leading.equalTo(52 * Constraints.xCoeff)
            make.trailing.equalTo(-52 * Constraints.xCoeff)
        }
        
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(okayButton.snp.bottom).offset(46 * Constraints.yCoeff)
            make.height.equalTo(10 * Constraints.yCoeff)
            make.leading.equalTo(52 * Constraints.xCoeff)
            make.trailing.equalTo(-52 * Constraints.xCoeff)
        }
    }
    
    
    @objc func okayButtonTap() {
        registerForPushNotifications {
            self.userInfoService.changeAskPushValue()
            DispatchQueue.main.async {
                self.skipTapped()
            }
        }
    }

    @objc
    func skipTapped() {
        userInfoService.changeAskPushValue()
        guard
            let link = linkToGo
        else {
            let enterVC = presentationAssembly.enterScreen()
            navigationController?.pushViewController(enterVC, animated: true)
            return
        }
        let webview = presentationAssembly.webViewController(site: "", title: nil)
        navigationController?.pushViewController(webview, animated: true)
    }

    private func registerForPushNotifications(completionHandler: @escaping () -> Void) {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            completionHandler()
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }
    
    private func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
          guard settings.authorizationStatus == .authorized else { return }
          DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
          }
      }
    }

}

