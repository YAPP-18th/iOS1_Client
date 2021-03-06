//
//  SignInViewController.swift
//  Buok
//
//  Copyright © 2021 Buok. All rights reserved.
//

import Firebase
import FirebaseAuth
import Foundation
import GoogleSignIn
import HeroCommon
import HeroSharedAssets
import HeroUI
import SnapKit

public class LoginViewController: HeroBaseViewController {
    let scrollView: UIScrollView = UIScrollView()
    let contentsView: UIView = UIView()
    let loginButtonStackView: UIStackView = UIStackView()
    
    let guideLabel = UILabel()
    let emailField = UserTextField()
    let nextButton = LoginButton()
    let orLabel = UILabel()
    let appleSignInButton = LoginButton()
    let googleSignInButton = LoginButton()
    let kakaoSignInButton = LoginButton()
    let servicePolicyButton = UIButton()
    
    var viewModel = UserViewModel()
    
    public override func viewDidLoad() {
		super.viewDidLoad()
		
        _ = TokenManager.shared.deleteAllTokenData()
        
        viewModel.isEmailExist.bind({ isExist in
            guard let isExist = isExist else {
                return
            }
            if isExist {
                let loginPasswordVC = LoginPasswordViewController()
                loginPasswordVC.viewModel = self.viewModel
                self.navigationController?.pushViewController(loginPasswordVC, animated: true)
            } else {
                let joinVC = JoinViewController()
                joinVC.viewModel = self.viewModel
                self.navigationController?.pushViewController(joinVC, animated: true)
            }
        })
		
		viewModel.isSNSJoinSuccess.bind({ [weak self] isSuccess in
			if isSuccess {
				let joinNameVC = JoinNameViewController()
				joinNameVC.viewModel = self?.viewModel
				joinNameVC.isSNSLogin = true
				self?.navigationController?.pushViewController(joinNameVC, animated: true)
			}
		})
        
        viewModel.isSNSLoginSuccess.bind({ [weak self] isSuccess in
            if isSuccess {
                self?.viewModel.setRootVCToHomeVC()
            }
        })
        
        viewModel.isSNSLoginError.bind({ [weak self] isSuccess in
            if isSuccess {
                self?.showSNSLoginErrorAlert()
            }
        })
		
		setupView()
	}
    
    private func setupView() {        
        setupScrollView()
        setupGuideLabel()
        setupEmailField()
        setupNextButton()
        setupOrLabel()
        setupLoginButtonStackView()
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer()
        tap.delegate = self
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc
    func onClickGoogleLogin(_ sender: UIButton) {
		GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
		GIDSignIn.sharedInstance().signIn()
    }
    
    @objc
    func onClickKakaoLogin(_ sender: UIButton) {
        viewModel.requestKakaoTalkLogin()
    }
    
    @objc
    func clickNextButton(_ sender: UIButton) {
        guard let email = emailField.text else { return }
        viewModel.checkEmailExist(email)
    }
    
    private func showSNSLoginErrorAlert() {
        let alert = UIAlertController(title: "SNS 회원가입", message: "아이디가 중복됩니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            // Nothing
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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

extension LoginViewController: GIDSignInDelegate {
	public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            DebugLog("Google Login Cancel : \(error.localizedDescription)")
            return
        }

        guard let authentication = user.authentication else { return }
        
		let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
		Auth.auth().signIn(with: credential) { (authResult, error) in
			if let error = error {
				ErrorLog("Firebase sign in error : \(error)")
				return
			}
			if let authResult = authResult {
				self.viewModel.socialType.value = .google
				self.viewModel.requestSNSJoinandLogin(email: authResult.user.email ?? "", socialId: authResult.user.uid)
			}
		}
	}
    
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        ErrorLog("Google Login Disconnect")
    }
}
