//
//  SignInViewController.swift
//  Estrela
//
//  Created by Alex Misko on 27.12.22.
//

import UIKit
import AuthenticationServices

@available(iOS 15.0, *)
class SignInViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding {
    
    private let signInLogoImage = UIImageView()
    private let welcomeLabel = UILabel()
    private let firstDescriptionLabel = UILabel()
    private let secondDescriptionLabel = UILabel()
    private let signInWithAppleButton = UIButton()
    private let privacyPolicyLabel = UILabel()
    private let presentationAssembly: IPresentationAssembly
    private let userInfoService: ISensentiveInfoService
    private let networkService: INetworkService
    
    init(
        presentationAssembly: IPresentationAssembly,
        userInfoService: ISensentiveInfoService,
        networkService: INetworkService
    ) {
        self.presentationAssembly = presentationAssembly
        self.userInfoService = userInfoService
        self.networkService = networkService
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
        view.addSubview(signInLogoImage)
        view.addSubview(welcomeLabel)
        view.addSubview(firstDescriptionLabel)
        view.addSubview(secondDescriptionLabel)
        view.addSubview(signInWithAppleButton)
        view.addSubview(privacyPolicyLabel)

    }

    private func style() {
        view.backgroundColor = UIColor(hexFromString: "001D3D")
        
        signInLogoImage.image = UIImage(named: "signInLogo")
        
        welcomeLabel.text = "Hello!"
        welcomeLabel.textColor = .white
        welcomeLabel.font = UIFont.montserratBold(ofSize: 32 * Constraints.yCoeff)
        welcomeLabel.textAlignment = .center
        
        firstDescriptionLabel.text = "My name is Estrela.\nI'm a bot with superpower"
        firstDescriptionLabel.textColor = .white
        firstDescriptionLabel.font = UIFont.montserratBold(ofSize: 16 * Constraints.yCoeff)
        firstDescriptionLabel.numberOfLines = 0
        firstDescriptionLabel.textAlignment = .center

        
        secondDescriptionLabel.text = "for help with \ndifficult choices - ask me."
        secondDescriptionLabel.numberOfLines = 0
        secondDescriptionLabel.textColor = .white
        secondDescriptionLabel.font = UIFont.montserratBold(ofSize: 16 * Constraints.yCoeff)
        secondDescriptionLabel.textAlignment = .center

        
        signInWithAppleButton.setTitle("Sign in with Apple", for: .normal)
        signInWithAppleButton.configuration = UIButton.Configuration.filled()
        signInWithAppleButton.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.montserratBold(ofSize: 18 * Constraints.yCoeff)
            return outgoing
        }
        
        signInWithAppleButton.titleLabel?.textColor = .white
        signInWithAppleButton.setImage(UIImage(named: "appleLogo"), for: .normal)
        signInWithAppleButton.configuration?.background.backgroundColor = UIColor(hexFromString: "8D063F")
        signInWithAppleButton.configuration?.imagePadding = 10
        signInWithAppleButton.addTarget(self, action: #selector(signInWithAppleButtonTap), for: .touchUpInside)
        signInWithAppleButton.layer.cornerRadius = 5
        signInWithAppleButton.layer.masksToBounds = true
        
        let fullText = NSMutableAttributedString(string: "Please, read our\n")
        let attrs = [NSAttributedString.Key.font : UIFont.gilroyMedium(ofSize: 12 * Constraints.yCoeff),
                     NSAttributedString.Key.foregroundColor : UIColor.white,
                     NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        let termsOfuse = NSMutableAttributedString(string: "Terms and Conditions", attributes: attrs)
        let andText = NSMutableAttributedString(string: " and ")
        let privacyPolicyText = NSMutableAttributedString(string: "Privacy Policy", attributes: attrs)
        fullText.append(termsOfuse)
        fullText.append(andText)
        fullText.append(privacyPolicyText)
        privacyPolicyLabel.attributedText = fullText
        privacyPolicyLabel.textColor = .white
        privacyPolicyLabel.numberOfLines = 0
        privacyPolicyLabel.font = UIFont.gilroyMedium(ofSize: 12 * Constraints.yCoeff)
        privacyPolicyLabel.textAlignment = .center
        privacyPolicyLabel.isUserInteractionEnabled = true
        privacyPolicyLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapPrivacyPolicy(gesture:))))
        
    }

    private func setupConstraints() {
        
        signInLogoImage.snp.makeConstraints { make in
            make.top.equalTo(view).offset(168 * Constraints.yCoeff)
            make.height.equalTo(198 * Constraints.yCoeff)
            make.leading.equalTo(63 * Constraints.xCoeff)
            make.trailing.equalTo(-62 * Constraints.xCoeff)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(signInLogoImage.snp.bottom).offset(12 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
        }
        
        firstDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(39 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
        }
        
        secondDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(firstDescriptionLabel.snp.bottom).offset(20 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
        }
        
        signInWithAppleButton.snp.makeConstraints { make in
            make.top.equalTo(secondDescriptionLabel.snp.bottom).offset(60 * Constraints.yCoeff)
            make.height.equalTo(60 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
        }
        
        privacyPolicyLabel.snp.makeConstraints { make in
            make.top.equalTo(signInWithAppleButton.snp.bottom).offset(27 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
        }
        
    }
    
    @objc func signInWithAppleButtonTap() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private func makeAppleAuth(code: String) {
        networkService.makeAuth(code: code) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(let authModel):
                    guard authModel.accessToken.count > 3 else { return }
                    strongSelf.userInfoService.saveAppleToken(token: authModel.accessToken)
                    strongSelf.makeAuth(token: authModel.accessToken)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func makeAuth(token: String) {
        networkService.makeAuth(token: token) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(let token):
                    guard token.count > 3 else { return }
                    strongSelf.userInfoService.saveToken(token: token) { _ in
                        strongSelf.goToMainView()
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
    private func goToMainView() {
        let viewController = presentationAssembly.mainViewController()
        if #available(iOS 13.0, *) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        } else {
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(viewController)
        }
    }
    
    @objc func tapPrivacyPolicy(gesture: UITapGestureRecognizer) {
        let termsRange = (privacyPolicyLabel.text! as NSString).range(of: "Terms and Conditions")
        // comment for now
        let privacyRange = (privacyPolicyLabel.text! as NSString).range(of: "Privacy Policy")

        if gesture.didTapAttributedTextInLabel(label: privacyPolicyLabel, inRange: termsRange) {
            let webview = presentationAssembly.webViewController(site: "\(ApiConstants.URL.mainURL)/terms.html", title: nil)
            navigationController?.pushViewController(webview, animated: true)
        } else if gesture.didTapAttributedTextInLabel(label: privacyPolicyLabel, inRange: privacyRange) {
            let webview = presentationAssembly.webViewController(site: "\(ApiConstants.URL.mainURL)/privacy.html", title: nil)
            navigationController?.pushViewController(webview, animated: true)
        } else {
            print("Tapped none")
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
}

@available(iOS 15.0, *)
extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("failed")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentiontials as ASAuthorizationAppleIDCredential:
            guard
                let code = credentiontials.authorizationCode,
                let codeString = String(data: code, encoding: .utf8)
            else { return }
            print(codeString)
            makeAppleAuth(code: codeString)
        default:
            break
        }
    }
}
