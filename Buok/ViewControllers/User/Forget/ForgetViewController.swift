//
//  ForgetViewController.swift
//  Buok
//
//  Created by 김혜빈 on 2021/05/09.
//

import UIKit

class ForgetViewController: HeroBaseViewController {
    let closeButton = UIButton()
    let guideLabel = UILabel()
    let emailField = UserTextField()
    let wrongLabel = UILabel()
    let nextButton = UserServiceButton()
    
    let viewModel = ForgetViewModel()
    var nextButtonTopAnchor: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        setupCloseButton()
        setupGuideLabel()
        setupEmailField()
        setupWrongLabel()
        setupNextButton()
    }
    
    @objc
    func clickCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func clickNextButton(_ sender: UIButton) {
        if viewModel.requestCheckingEmail(emailField.text!) {
            // 이메일 인증 화면 띄우기
        } else { activeWrongLabel() }
    }
    
    private func activeWrongLabel() {
        wrongLabel.isHidden = true
        DispatchQueue.main.async { [weak self] in
            self?.nextButtonTopAnchor?.constant = 16
        }
    }
    
}

extension ForgetViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        nextButton.setHeroEnable(viewModel.validateEmail(textField.text ?? ""))
    }
}

extension ForgetViewController {
    // MARK: CloseButton
    func setupCloseButton() {
        closeButton.setImage(UIImage(heroSharedNamed: "ic_x"), for: .normal)
        closeButton.addTarget(self, action: #selector(clickCloseButton(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview()
        }
    }
    
    // MARK: GuideLabel
    func setupGuideLabel() {
        guideLabel.font = .font22P
        guideLabel.numberOfLines = 0
        guideLabel.textColor = .heroGray5B
        guideLabel.text = "비밀번호 재설정을 위해\n가입된 이메일을 입력해주세요."
        self.view.addSubview(guideLabel)
        
        guideLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(92)
            make.leading.equalToSuperview().offset(22)
        }
    }
    
    // MARK: EmailField
    func setupEmailField() {
        emailField.delegate = self
        emailField.setPlaceHolder("이메일 주소를 입력해주세요")
        self.view.addSubview(emailField)
        
        emailField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(192)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: WrongLabel
    func setupWrongLabel() {
        wrongLabel.font = .font13P
        wrongLabel.isHidden = true
        wrongLabel.textColor = .heroServiceSubPink
        wrongLabel.text = "입력하신 이메일이 존재하지 않습니다."
        self.view.addSubview(wrongLabel)
        
        wrongLabel.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(8)
            make.leading.equalTo(emailField.snp.leading).offset(2)
        }
    }
    
    // MARK: NextButton
    func setupNextButton() {
        nextButton.setHeroEnable(false)
        nextButton.setHeroTitle("계속하기")
        nextButton.addTarget(self, action: #selector(clickNextButton(_:)), for: .touchUpInside)
        self.view.addSubview(nextButton)
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        nextButtonTopAnchor = nextButton.topAnchor.constraint(equalTo: emailField.bottomAnchor)
        nextButtonTopAnchor?.constant = 16
        nextButtonTopAnchor?.isActive = true
    }
}
