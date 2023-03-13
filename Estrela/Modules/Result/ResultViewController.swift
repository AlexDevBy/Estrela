//
//  ResultViewController.swift
//  Estrela
//
//  Created by Alex Misko on 28.12.22.
//

import UIKit
//import IronSource

class ResultViewController: UIViewController {
    
    private let resultTitleLabel = UILabel()
    private let questionLabel = UILabel()
    private let yesResultLabel = UILabel()
    private let yesLogo = UIImageView()
    private let xLogo = UIImageView()
    private let noResultLabel = UILabel()
    private let noLogo = UIImageView()
    private let okayButton = UIButton()
    
    var yesNumber = 0.0
    var noNumber = 0.0
    var questionText = ""
    
    private let userInfoService: ISensentiveInfoService
    private let productService: IProductService
    
    init(
        sensetiveUserService: ISensentiveInfoService,
        purchasesService: IProductService
    ) {
        self.userInfoService = sensetiveUserService
        self.productService = purchasesService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        calculateAnswer()
        setup()
        style()
        setupConstraints()
        
//        IronSource.setRewardedVideoDelegate(self)

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
        view.addSubview(resultTitleLabel)
        view.addSubview(questionLabel)
        view.addSubview(yesResultLabel)
        view.addSubview(yesLogo)
        view.addSubview(xLogo)
        view.addSubview(noResultLabel)
        view.addSubview(noLogo)
        view.addSubview(okayButton)
    }
    
    private func style() {
        view.backgroundColor = UIColor(hexFromString: "001D3D")

        resultTitleLabel.text = "Your chances for question:"
        resultTitleLabel.textColor = .white
        resultTitleLabel.font = UIFont.montserratRegular(ofSize: 20 * Constraints.yCoeff)
        
        questionLabel.text = questionText
        questionLabel.numberOfLines = 0
        questionLabel.textColor = .white
        questionLabel.font = UIFont.montserratBold(ofSize: 20 * Constraints.yCoeff)
        questionLabel.textAlignment = .center
        
        yesResultLabel.text = "x\(yesNumber)"
        yesResultLabel.textColor = .white
        yesResultLabel.font = UIFont.montserratBold(ofSize: 20 * Constraints.yCoeff)
        
        noResultLabel.text = "x\(noNumber)"
        noResultLabel.textColor = .white
        noResultLabel.font = UIFont.montserratBold(ofSize: 20 * Constraints.yCoeff)
        
        yesLogo.image = UIImage(named: "yes")
        noLogo.image = UIImage(named: "no")
        xLogo.image = UIImage(named: "x")
        
        okayButton.setTitle("Okay", for: .normal)
        okayButton.backgroundColor = UIColor(hexFromString: "8D063F")
        okayButton.titleLabel?.textColor = .white
        okayButton.titleLabel?.font = UIFont.montserratBold(ofSize: 18 * Constraints.yCoeff)
        okayButton.layer.cornerRadius = 5
        okayButton.layer.masksToBounds = true
        okayButton.addTarget(self, action: #selector(okayButtonTap), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        resultTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(90 * Constraints.yCoeff)
            make.centerX.equalTo(view)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(resultTitleLabel.snp.bottom).offset(14 * Constraints.yCoeff)
            make.centerX.equalTo(view)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
        }
        
        yesResultLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(87 * Constraints.yCoeff)
            make.centerX.equalTo(view)
        }
        
        yesLogo.snp.makeConstraints { make in
            make.top.equalTo(yesResultLabel.snp.bottom).offset(2 * Constraints.yCoeff)
            make.centerX.equalTo(view)
            make.height.equalTo(64 * Constraints.yCoeff)
            make.width.equalTo(73 * Constraints.xCoeff)
        }
        
        xLogo.snp.makeConstraints { make in
            make.top.equalTo(yesLogo.snp.bottom).offset(41 * Constraints.yCoeff)
            make.centerX.equalTo(view)
            make.height.equalTo(31.55 * Constraints.yCoeff)
            make.width.equalTo(33.15 * Constraints.yCoeff)
        }
        
        noResultLabel.snp.makeConstraints { make in
            make.top.equalTo(xLogo.snp.bottom).offset(33.45 * Constraints.yCoeff)
            make.centerX.equalTo(view)
        }
        
        noLogo.snp.makeConstraints { make in
            make.top.equalTo(noResultLabel.snp.bottom).offset(2 * Constraints.yCoeff)
            make.centerX.equalTo(view)
            make.height.equalTo(62 * Constraints.yCoeff)
            make.width.equalTo(62 * Constraints.yCoeff)
        }
        
        okayButton.snp.makeConstraints { make in
            make.top.equalTo(noLogo.snp.bottom).offset(131 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
            make.height.equalTo(60 * Constraints.yCoeff)
        }
    }
    
    private func calculateAnswer() {
        yesNumber = Double.random(min: 0.0, max: 10.0).rounded(toPlaces: 2)
        print(yesNumber)
        noNumber = Double(10.0 - yesNumber).rounded(toPlaces: 2)
    }
    
    
    @objc func okayButtonTap() {
        let question = Questions()
        question.id = UUID().uuidString
        question.question = questionLabel.text ?? ""
        question.date = Date()
        question.answerNo = noResultLabel.text ?? ""
        question.answerYes = yesResultLabel.text ?? ""

        RealmManager.shared.saveToRealm(question)
        
//        if !userInfoService.isPremiumActive() && IronSource.hasRewardedVideo() {
//            IronSource.showRewardedVideo(with: self, placement: nil)
//        } else {
            afterShowingAdd()
//        }
        
//        for obj in (self.navigationController?.viewControllers)! {
//                if obj is MainViewController {
//         self.navigationController?.popToViewController(obj, animated: true)
//                    break
//                }
//            }

    }
    
    private func afterShowingAdd() {
        for obj in (self.navigationController?.viewControllers)! {
                if obj is MainViewController {
         self.navigationController?.popToViewController(obj, animated: true)
                    break
                }
            }
    }

}

//extension ResultViewController: ISRewardedVideoDelegate {
//    func rewardedVideoHasChangedAvailability(_ available: Bool) {
//        print("video is available == \(available)")
//    }
//
//    func didReceiveReward(forPlacement placementInfo: ISPlacementInfo!) {}
//
//    func rewardedVideoDidFailToShowWithError(_ error: Error!) {}
//
//    func rewardedVideoDidOpen() {}
//
//    func rewardedVideoDidStart() {}
//
//    func rewardedVideoDidEnd() {
//        afterShowingAdd()
//    }
//
//    func didClickRewardedVideo(_ placementInfo: ISPlacementInfo!) {}
//
//    // Iron Source delegate
//    public func rewardedVideoDidClose() {
//        afterShowingAdd()
//    }
//
    
//}
