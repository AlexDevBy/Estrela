//
//  MainViewController.swift
//  Estrela
//
//  Created by Alex Misko on 27.12.22.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    private let settingsButton = UIButton()
    private let premiumBackgroundView = UIView()
    private let premiumImage = UIImageView()
    private let premiumTitleLabel = UILabel()
    private let premiumDescriptionLabel = UILabel()
    private let emptyPageLogo = UIImageView()
    private let emptyPageTitle = UILabel()
    private let questionTableView = UITableView()
    private let takeAChanceButton = UIButton()
    
    private let presentationAssembly: IPresentationAssembly
    private let sensetiveUserService: ISensentiveInfoService
    private let purchasesService: IProductService
    
    
    init(
        presentationAssembly: IPresentationAssembly,
        sensetiveUserService: ISensentiveInfoService,
        purchasesService: IProductService
    ) {
        self.presentationAssembly = presentationAssembly
        self.sensetiveUserService = sensetiveUserService
        self.purchasesService = purchasesService
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var allQuestions: Results<Questions>!
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        style()
        setupConstraints()
        hideEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        reloadQuestions()
        updateSettings()
        if allQuestions.count == 0 {
            questionTableView.alpha = 0
            emptyPageLogo.alpha = 1
            emptyPageTitle.alpha = 1
        } else {
            questionTableView.alpha = 1
            emptyPageLogo.alpha = 0
            emptyPageTitle.alpha = 0
        }
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setup() {
        view.addSubview(settingsButton)
        view.addSubview(premiumBackgroundView)
        view.addSubview(premiumImage)
        premiumBackgroundView.addSubview(premiumTitleLabel)
        premiumBackgroundView.addSubview(premiumDescriptionLabel)
        view.addSubview(emptyPageLogo)
        view.addSubview(emptyPageTitle)
        view.addSubview(questionTableView)
        view.addSubview(takeAChanceButton)

    }
    
    private func hideEmptyView() {
        emptyPageLogo.alpha = 0
        emptyPageTitle.alpha = 0
    }

    private func style() {
        view.backgroundColor = UIColor(hexFromString: "001D3D")

        settingsButton.setTitle("", for: .normal)
        settingsButton.setImage(UIImage(named: "menu"), for: .normal)
        settingsButton.addTarget(self, action: #selector(settingButtonTap), for: .touchUpInside)

        premiumImage.image = UIImage(named: "noAdsLogo")
        
        premiumBackgroundView.backgroundColor = UIColor(hexFromString: "FFD100")
        premiumBackgroundView.layer.cornerRadius = 5
        premiumBackgroundView.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.premiumTapped(_:)))
        premiumBackgroundView.addGestureRecognizer(tap)
        premiumBackgroundView.isUserInteractionEnabled = true
        
        premiumTitleLabel.text = "Premium"
        premiumTitleLabel.font = UIFont.montserratBold(ofSize: 20 * Constraints.yCoeff)
        premiumTitleLabel.textColor = UIColor(hexFromString: "001D3D")
        
        premiumDescriptionLabel.text = "Remove ads"
        premiumDescriptionLabel.font = UIFont.montserratRegular(ofSize: 12 * Constraints.yCoeff)
        premiumDescriptionLabel.textColor = UIColor(hexFromString: "001D3D")
        premiumDescriptionLabel.textAlignment = .center
        
        emptyPageLogo.image = UIImage(named: "emptyPageLogo")
        
        emptyPageTitle.text = "Try to take a chance ;)"
        emptyPageTitle.textColor = .white
        emptyPageTitle.font = UIFont.montserratRegular(ofSize: 18 * Constraints.yCoeff)
        
        takeAChanceButton.setTitle("Take a chance", for: .normal)
        takeAChanceButton.titleLabel?.font = UIFont.montserratBold(ofSize: 18 * Constraints.yCoeff)
        takeAChanceButton.backgroundColor = UIColor(hexFromString: "8D063F")
        takeAChanceButton.layer.cornerRadius = 5
        takeAChanceButton.layer.masksToBounds = true
        takeAChanceButton.addTarget(self, action: #selector(takeAChanceButtonTap), for: .touchUpInside)
        
        
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.registerNib(class: MainViewCell.self)
        questionTableView.backgroundColor = UIColor(hexFromString: "001D3D")
        questionTableView.rowHeight = 120
    }
    
    private func setupConstraints () {
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(view).offset(61 * Constraints.yCoeff)
            make.height.equalTo(24 * Constraints.yCoeff)
            make.width.equalTo(24 * Constraints.yCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
        }
        
        premiumBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(settingsButton.snp.bottom).offset(48 * Constraints.yCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
            make.height.equalTo(100 * Constraints.yCoeff)

        }
        
        premiumImage.snp.makeConstraints { make in
            make.top.equalTo(view).offset(99 * Constraints.yCoeff)
            make.height.equalTo(130 * Constraints.yCoeff)
            make.width.equalTo(130 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(62 * Constraints.xCoeff)

        }
        
        premiumTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(premiumBackgroundView).offset(30 * Constraints.yCoeff)
            make.leading.equalTo(160 * Constraints.xCoeff)
        }
        
        premiumDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(premiumTitleLabel.snp.bottom).offset(2 * Constraints.yCoeff)
            make.leading.equalTo(160 * Constraints.xCoeff)
        }
        
        emptyPageLogo.snp.makeConstraints { make in
            make.top.equalTo(view).offset(297 * Constraints.yCoeff)
            make.height.equalTo(222 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(77 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-76 * Constraints.xCoeff)

        }
        
        emptyPageTitle.snp.makeConstraints { make in
            make.top.equalTo(emptyPageLogo.snp.bottom).offset(10 * Constraints.yCoeff)
            make.centerX.equalTo(view)
        }
        
        takeAChanceButton.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-62 * Constraints.yCoeff)
            make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
            make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
            make.height.equalTo(60 * Constraints.yCoeff)
        }
        
        if sensetiveUserService.isPremiumActive() {
            questionTableView.snp.makeConstraints { make in
                premiumImage.alpha = 0
                premiumBackgroundView.alpha = 0
                premiumTitleLabel.alpha = 0
                premiumDescriptionLabel.alpha = 0
                make.top.equalTo(settingsButton.snp.bottom).offset(48 * Constraints.yCoeff)
                make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
                make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
                make.bottom.equalTo(view)
                
            }
        } else {
            premiumImage.alpha = 1
            premiumBackgroundView.alpha = 1
            premiumTitleLabel.alpha = 1
            premiumDescriptionLabel.alpha = 1
            questionTableView.snp.makeConstraints { make in
                make.top.equalTo(premiumBackgroundView.snp.bottom).offset(17 * Constraints.yCoeff)
                make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
                make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
                make.bottom.equalTo(view)
                
            }
        }
    }
    
    private func reloadQuestions() {
        allQuestions = realm.objects(Questions.self)
        questionTableView.reloadData()
    }
    
    func buyRemoveAdd() {
        self.showLoading()
        purchasesService.buyAddsOff { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.sensetiveUserService.savePremium()
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
    
    @objc func settingButtonTap() {
        let vc = presentationAssembly.settingsScreen()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func takeAChanceButtonTap() {
        let vc = presentationAssembly.createQuestion()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func premiumTapped(_ sender: UITapGestureRecognizer) {
         buyRemoveAdd()
      }
    
    private func updateSettings() {
        if sensetiveUserService.isPremiumActive() {
            DispatchQueue.main.async { [self] in
                premiumImage.alpha = 0
                premiumBackgroundView.alpha = 0
                premiumTitleLabel.alpha = 0
                premiumDescriptionLabel.alpha = 0
                questionTableView.snp.makeConstraints { make in
                    make.top.equalTo(settingsButton.snp.bottom).offset(21 * Constraints.yCoeff)
                    make.leading.equalTo(view).offset(52 * Constraints.xCoeff)
                    make.trailing.equalTo(view).offset(-52 * Constraints.xCoeff)
                    make.bottom.equalTo(view)
                }
            }
        } else {
            DispatchQueue.main.async { [self] in
                premiumImage.alpha = 1
                premiumBackgroundView.alpha = 1
                premiumTitleLabel.alpha = 1
                premiumDescriptionLabel.alpha = 1
            }
        }
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = questionTableView.deque(class: MainViewCell.self, for: indexPath)
        cell.backgroundColor = UIColor(hexFromString: "001D3D")
        cell.questionLabel.text = allQuestions[indexPath.row].question
        cell.yesAnswer.text = allQuestions[indexPath.row].answerYes
        cell.noAnswr.text = allQuestions[indexPath.row].answerNo
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(110)
    }
    
     
}
