//
//  SignInViewController.swift
//  Buok
//
//  Created by 김혜빈 on 2021/04/13.
//

import Foundation
import HeroCommon
import HeroSharedAssets
import HeroUI
import SnapKit

public class LoginViewController: HeroBaseViewController {
    let scrollView = UIScrollView()
    let contentsView = UIView()
    
    let guideLabel = UILabel()
    let emailField = UserTextField()
    let nextButton = UserServiceButton()
    let orLabel = UILabel()
    let appleSignInButton = UserServiceButton()
    let googleSignInButton = UserServiceButton()
    let kakaoSignInButton = UserServiceButton()
    let servicePolicyButton = UIButton()
    
    var viewModel = LoginViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {        
        setupScrollView()
        setupGuideLabel()
        setupEmailField()
        setupNextButton()
        setupOrLabel()
        setupAppleSignInButton()
        setupGoogleSignInButton()
        setupKakaoSignInButton()
        setupServicePolicyButton()
        
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer()
        tap.delegate = self
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc
    func clickNextButton(_ sender: UIButton) {
        guard let email = emailField.text else { return }
        viewModel.email = email
        let loginPasswordVC = LoginPasswordViewController()
        loginPasswordVC.viewModel = viewModel
        self.navigationController?.pushViewController(loginPasswordVC, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        nextButton.setHeroEnable(viewModel.validateEmail(textField.text ?? ""))
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}