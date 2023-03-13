//
//  CreateQuestionViewController.swift
//  Estrela
//
//  Created by Alex Misko on 28.12.22.
//

import UIKit
//import IronSource

class CreateQuestionViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    private let backButton = UIButton()
    private let youQuestionTitleLabel = UILabel()
    private let questionTextView = UITextField()
    private let smallDescriptionLabel = UILabel()
    private let firstAlertBgView = UIView()
    private let firstAlertLabel = UILabel()
    private let secondAlertBgView = UIView()
    private let secondAlertLabel = UILabel()
    private let agreePrivacyLabel = UILabel()
    private let agreePrivacyCheckBox = UIButton()
    private let agreeTermsOfUseLabel = UILabel()
    private let agreeTermsOfUserCheckBox = UIButton()
    private let agreeUserRulesLabel = UILabel()
    private let agreeUserRulesCheckBox = UIButton()
    private let letsGoButton = UIButton()
    
    
    var isCheckedPrivacy: Bool = true
    var isCheckedTerms: Bool = true
    var isCheckedUser: Bool = true

    private let presentationAssembly: IPresentationAssembly
    private let userInfoService: ISensentiveInfoService
    private let productService: IProductService
    
    init(
        presentationAssembly: IPresentationAssembly,
        sensetiveUserService: ISensentiveInfoService,
        purchasesService: IProductService
    ) {
        self.presentationAssembly = presentationAssembly
        self.userInfoService = sensetiveUserService
        self.productService = purchasesService
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
        disableLetsGoButton()
        self.dismissKeyboard()
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
        view.addSubview(youQuestionTitleLabel)
        view.addSubview(questionTextView)
        view.addSubview(smallDescriptionLabel)
        view.addSubview(firstAlertBgView)
        firstAlertBgView.addSubview(firstAlertLabel)
        view.addSubview(secondAlertBgView)
        secondAlertBgView.addSubview(secondAlertLabel)
        view.addSubview(agreePrivacyCheckBox)
        view.addSubview(agreeTermsOfUseLabel)
        view.addSubview(agreeTermsOfUserCheckBox)
        view.addSubview(agreeUserRulesLabel)
        view.addSubview(agreeUserRulesCheckBox)
        view.addSubview(letsGoButton)
        view.addSubview(agreePrivacyLabel)
    }
    
    private func style() {
        view.backgroundColor = UIColor(hexFromString: "001D3D")

        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backBtnTap), for: .touchUpInside)
        
        youQuestionTitleLabel.text = "YOUR QUESTION?"
        youQuestionTitleLabel.textColor = .white
        youQuestionTitleLabel.font = UIFont.montserratBlack(ofSize: 24 * Constraints.yCoeff)
        
        questionTextView.backgroundColor = UIColor(hexFromString: "00336B")
        questionTextView.layer.cornerRadius = 5
        questionTextView.layer.masksToBounds = true
        questionTextView.textColor = .white
        questionTextView.font = UIFont.montserratRegular(ofSize: 15 * Constraints.yCoeff)
        questionTextView.delegate = self
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 30))
        questionTextView.leftView = paddingView
        questionTextView.leftViewMode = .always
        let attrsForTextField = [NSAttributedString.Key.font : UIFont.montserratRegular(ofSize: 15 * Constraints.yCoeff),
                     NSAttributedString.Key.foregroundColor : UIColor.white] as [NSAttributedString.Key : Any]
        let placeholder = NSMutableAttributedString(string: "Subject of question?", attributes: attrsForTextField)
        questionTextView.attributedPlaceholder = placeholder
        questionTextView.addTarget(self, action:  #selector(textFieldDidChange(_:)),  for:.editingChanged )

        
        smallDescriptionLabel.text = "*The answer will be a yes or no"
        smallDescriptionLabel.textColor = UIColor(hexFromString: "7C90A5")
        smallDescriptionLabel.font = UIFont.montserratRegular(ofSize: 15 * Constraints.yCoeff)
        
        firstAlertBgView.backgroundColor = UIColor(hexFromString: "FDD623")
        firstAlertBgView.layer.cornerRadius = 5
        firstAlertBgView.layer.masksToBounds = true
        
        firstAlertLabel.text = "Attention!\nWe moderate each question manually. It can take up to 24 hours."
        firstAlertLabel.textColor = UIColor(hexFromString: "001D3D")
        firstAlertLabel.font = UIFont.montserratRegular(ofSize: 15 * Constraints.yCoeff)
        firstAlertLabel.numberOfLines = 0
        
        secondAlertBgView.backgroundColor = UIColor(hexFromString: "FDD623")
        secondAlertBgView.layer.cornerRadius = 5
        secondAlertBgView.layer.masksToBounds = true
        
        secondAlertLabel.text = "Note!\nThe results of the answers are complete randomness. Please do not take them as advice for action. Remember that our application is entertaining."
        secondAlertLabel.textColor = UIColor(hexFromString: "001D3D")
        secondAlertLabel.font = UIFont.montserratRegular(ofSize: 15 * Constraints.yCoeff)
        secondAlertLabel.numberOfLines = 0

        let attrs = [NSAttributedString.Key.font : UIFont.montserratMedium(ofSize: 16 * Constraints.yCoeff),
                     NSAttributedString.Key.foregroundColor : UIColor(hexFromString: "7C90A5"),
                     NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        
        let privacyText = NSMutableAttributedString(string: "I agree with ")
        let termsAndConditionText = NSMutableAttributedString(string: "Terms and conditions", attributes: attrs)
        let privacyPolicyText = NSMutableAttributedString(string: "Privacy Policy", attributes: attrs)
        let userRulesText = NSMutableAttributedString(string: "user generated content rules", attributes: attrs)
        let ofServiceText = NSMutableAttributedString(string: " of service")
        
        privacyText.append(privacyPolicyText)
        privacyText.append(ofServiceText)
        
    
        
        
        
//        agreePrivacyLabel.text = "I agree with Privacy policy of service"
        agreePrivacyLabel.attributedText = privacyText
        agreePrivacyLabel.textColor = UIColor(hexFromString: "7C90A5")
        agreePrivacyLabel.font = UIFont.montserratMedium(ofSize: 16 * Constraints.yCoeff)
        agreePrivacyLabel.numberOfLines = 0
    

        let termsText = NSMutableAttributedString(string: "I agree with ")
        
        termsText.append(termsAndConditionText)
        termsText.append(ofServiceText)
//        agreeTermsOfUseLabel.text = "Terms and conditions of service"
        agreeTermsOfUseLabel.attributedText = termsText
        agreeTermsOfUseLabel.textColor = UIColor(hexFromString: "7C90A5")
        agreeTermsOfUseLabel.font = UIFont.montserratMedium(ofSize: 16 * Constraints.yCoeff)
        agreeTermsOfUseLabel.numberOfLines = 0

        
        let userText = NSMutableAttributedString(string: "I agree with ")
        userText.append(userRulesText)
        userText.append(ofServiceText)
        
//        agreeUserRulesLabel.text = "I agree with user generated content rules"
        agreeUserRulesLabel.attributedText = userText
        agreeUserRulesLabel.textColor = UIColor(hexFromString: "7C90A5")
        agreeUserRulesLabel.font = UIFont.montserratMedium(ofSize: 16 * Constraints.yCoeff)
        agreeUserRulesLabel.numberOfLines = 0

        agreePrivacyCheckBox.setTitle("", for: .normal)
        agreePrivacyCheckBox.setImage(UIImage(named: "check"), for: .normal)
        agreePrivacyCheckBox.addTarget(self, action: #selector(agreePrivacyCheckBoxTap), for: .touchUpInside)
        
        agreeUserRulesCheckBox.setTitle("", for: .normal)
        agreeUserRulesCheckBox.setImage(UIImage(named: "check"), for: .normal)
        agreeUserRulesCheckBox.addTarget(self, action: #selector(agreeUserRulesCheckBoxTap), for: .touchUpInside)

        agreeTermsOfUserCheckBox.setTitle("", for: .normal)
        agreeTermsOfUserCheckBox.setImage(UIImage(named: "check"), for: .normal)
        agreeTermsOfUserCheckBox.addTarget(self, action: #selector(agreeTermsOfUserCheckBoxTap), for: .touchUpInside)

        letsGoButton.setTitle("Let's go!", for: .normal)
        letsGoButton.backgroundColor = UIColor(hexFromString: "8D063F")
        letsGoButton.titleLabel?.textColor = .white
        letsGoButton.titleLabel?.font = UIFont.montserratBold(ofSize: 18 * Constraints.yCoeff)
        letsGoButton.layer.cornerRadius = 5
        letsGoButton.layer.masksToBounds = true
        letsGoButton.addTarget(self, action: #selector(letsGoButtonTap), for: .touchUpInside)
        
        
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view).offset(61 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(33 * Constraints.yCoeff)
            make.height.equalTo(21 * Constraints.yCoeff)
            make.width.equalTo(21 * Constraints.yCoeff)
        }
        
        youQuestionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(37 * Constraints.yCoeff)
            make.centerX.equalTo(view)
        }
        
        questionTextView.snp.makeConstraints { make in
            make.top.equalTo(youQuestionTitleLabel.snp.bottom).offset(28 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
            make.height.equalTo(60 * Constraints.yCoeff)
        }
        
        smallDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(questionTextView.snp.bottom).offset(8 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(54 * Constraints.yCoeff)
        }
        
        firstAlertBgView.snp.makeConstraints { make in
            make.top.equalTo(smallDescriptionLabel.snp.bottom).offset(30 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
            make.height.equalTo(98 * Constraints.yCoeff)
        }
        
        firstAlertLabel.snp.makeConstraints { make in
            make.top.equalTo(firstAlertBgView).offset(12 * Constraints.yCoeff)
            make.leading.equalTo(firstAlertBgView).offset(14 * Constraints.xCoeff)
            make.trailing.equalTo(firstAlertBgView).offset(-16 * Constraints.xCoeff)
        }
        
        secondAlertBgView.snp.makeConstraints { make in
            make.top.equalTo(firstAlertBgView.snp.bottom).offset(15 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
            make.height.equalTo(133 * Constraints.yCoeff)
        }
        
        secondAlertLabel.snp.makeConstraints { make in
            make.top.equalTo(secondAlertBgView).offset(12 * Constraints.yCoeff)
            make.leading.equalTo(secondAlertBgView).offset(14 * Constraints.xCoeff)
            make.trailing.equalTo(secondAlertBgView).offset(-16 * Constraints.xCoeff)
        }
        
        agreePrivacyCheckBox.snp.makeConstraints { make in
            make.top.equalTo(secondAlertBgView.snp.bottom).offset(31 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
            make.height.equalTo(14 * Constraints.yCoeff)
            make.width.equalTo(14 * Constraints.yCoeff)

        }
        
        agreePrivacyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(agreePrivacyCheckBox)
            make.leading.equalTo(agreePrivacyCheckBox.snp.trailing).offset(16 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
        }
        
        agreeTermsOfUserCheckBox.snp.makeConstraints { make in
            make.top.equalTo(agreePrivacyCheckBox.snp.bottom).offset(28 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
            make.height.equalTo(14 * Constraints.yCoeff)
            make.width.equalTo(14 * Constraints.yCoeff)

        }
        
        
        agreeTermsOfUseLabel.snp.makeConstraints { make in
            make.centerY.equalTo(agreeTermsOfUserCheckBox)
            make.leading.equalTo(agreeTermsOfUserCheckBox.snp.trailing).offset(16 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
        }
        
        agreeUserRulesCheckBox.snp.makeConstraints { make in
            make.top.equalTo(agreeTermsOfUserCheckBox.snp.bottom).offset(28 * Constraints.yCoeff)
            make.height.equalTo(14 * Constraints.yCoeff)
            make.width.equalTo(14 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)

        }
        
        agreeUserRulesLabel.snp.makeConstraints { make in
            make.centerY.equalTo(agreeUserRulesCheckBox)
            make.leading.equalTo(agreeUserRulesCheckBox.snp.trailing).offset(16 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
        }
        
        letsGoButton.snp.makeConstraints { make in
            make.top.equalTo(agreeUserRulesLabel.snp.bottom).offset(29 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
            make.height.equalTo(60 * Constraints.yCoeff)

        }
        
        
    }
    
    func disableLetsGoButton() {
        letsGoButton.isUserInteractionEnabled = false
        letsGoButton.backgroundColor = UIColor(hexFromString: "DC91B1")
    }
    
    func enableLetsGoButton() {
        letsGoButton.isUserInteractionEnabled = true
        letsGoButton.backgroundColor = UIColor(hexFromString: "8D063F")
    }
    
    @objc func letsGoButtonTap() {
//        presentationAssembly
        let vc = ResultViewController(sensetiveUserService: userInfoService, purchasesService: productService)
        vc.questionText = questionTextView.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func agreePrivacyCheckBoxTap() {
        if isCheckedPrivacy {
            agreePrivacyCheckBox.setImage(UIImage(named: "uncheck"), for: .normal)
            isCheckedPrivacy = false
            disableLetsGoButton()
        } else {
            agreePrivacyCheckBox.setImage(UIImage(named: "check"), for: .normal)
            isCheckedPrivacy = true
            var questionTextEmpty = questionTextView.text?.isEmpty
            if isCheckedTerms && isCheckedUser && !questionTextEmpty! {
                enableLetsGoButton()
            }
        }
    }
    
    @objc func agreeUserRulesCheckBoxTap() {
        if isCheckedTerms {
            agreeUserRulesCheckBox.setImage(UIImage(named: "uncheck"), for: .normal)
            isCheckedTerms = false
            disableLetsGoButton()
        } else {
            agreeUserRulesCheckBox.setImage(UIImage(named: "check"), for: .normal)
            isCheckedTerms = true
            var questionTextEmpty = questionTextView.text?.isEmpty
            if isCheckedUser && isCheckedPrivacy && !questionTextEmpty! {
                enableLetsGoButton()
            }
        }
    }
    
    @objc func agreeTermsOfUserCheckBoxTap() {
        if isCheckedUser {
            agreeTermsOfUserCheckBox.setImage(UIImage(named: "uncheck"), for: .normal)
            disableLetsGoButton()
            isCheckedUser = false
        } else {
            agreeTermsOfUserCheckBox.setImage(UIImage(named: "check"), for: .normal)
            isCheckedUser = true
            var questionTextEmpty = questionTextView.text?.isEmpty
            if isCheckedTerms && isCheckedPrivacy && !questionTextEmpty! {
                enableLetsGoButton()
            }
        }
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        if questionTextView.text == "" {
            disableLetsGoButton()
        } else {
            enableLetsGoButton()
        }
    }
    
    @objc func backBtnTap() {
        self.navigationController?.popViewController(animated: true)
    }

}


