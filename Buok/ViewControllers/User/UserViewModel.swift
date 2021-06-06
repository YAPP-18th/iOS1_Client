//
//  LoginViewModel.swift
//  Buok
//
//  Copyright © 2021 Buok. All rights reserved.
//

import HeroCommon
import HeroUI
import KakaoSDKAuth
import KakaoSDKUser
import Promise

class UserViewModel {
	var deviceToken: String = TokenManager.shared.getFCMToken() ?? ""
    var email: String = ""
    var password: String = ""
    var nickname: String = ""
    var introduce: String?
    var isSelectedEyeButton: Bool = false
    var appleLoginMode: Bool = false
    
    var isLoginSuccess: Dynamic<Bool> = Dynamic(false)
	var isSNSLoginSuccess: Dynamic<Bool> = Dynamic(false)
    
    var isEmailExist: Dynamic<Bool?> = Dynamic(false)
    var isNicknameExist: Dynamic<Bool?> = Dynamic(false)
    var isSignUpSuccess: Dynamic<Bool> = Dynamic(false)
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool { password.count >= 6 }
    
    func validateNickName(_ nickname: String) -> Bool {
        let regex = "(?!.*[~`!@#$%&*()-+=.^_?,/\\|]).{1,12}"
        let nicknameTest = NSPredicate(format: "SELF MATCHES %@", regex)
        return nicknameTest.evaluate(with: nickname)
    }
    
    func checkEmailExist(_ email: String) {
        self.email = email
        InfoCheckAPIRequest.checkEmail(email: self.email, responseHandler: { result in
            switch result {
            case .success(let code):
                if code == 400 {
                    self.isEmailExist.value = true
                } else {
                    DebugLog("Result code : \(code)")
                    self.isEmailExist.value = false
                }
            case .failure(_):
                self.isEmailExist.value = nil
                ErrorLog("Error")
            }
        })
    }
    
    func checkNicknameExist(_ nickname: String) {
        self.nickname = nickname
        // todo - nickname이 존재하는 별칭인지 아닌지 확인 요청
        InfoCheckAPIRequest.checkNickname(nickname: nickname, responseHandler: { result in
            switch result {
            case .success(let code):
                if code == 400 {
                    self.isNicknameExist.value = true
                } else {
                    DebugLog("Result code : \(code)")
                    self.isNicknameExist.value = false
                }
            case .failure(_):
                self.isNicknameExist.value = nil
                ErrorLog("Error")
            }
        })
    }
    
    func requestLogin() {
        SignAPIRequest.signInRequest(email: email, password: password, responseHandler: { result in
            switch result {
            case .success(let signInData):
                DebugLog("Login SUCCESS ---> Set Token Data To Keychain")
                _ = TokenManager.shared.deleteAllTokenData()
                let sat = TokenManager.shared.setAccessToken(token: signInData.accessToken)
                let srt = TokenManager.shared.setRefreshToken(token: signInData.accessToken)
                let sated = TokenManager.shared.setAccessTokenExpiredDate(expiredAt: signInData.accessExpiredAt.convertToDate())
                let srted = TokenManager.shared.setRefreshTokenExpiredDate(expiredAt: signInData.refreshExpiredAt.convertToDate())
                DebugLog("sat : \(sat), srt : \(srt), sated : \(sated), srted : \(srted)")
                self.isLoginSuccess.value = sat && srt && sated && srted
            case .failure(let error):
                ErrorLog("Error : \(error.localizedDescription) / Status Code : \(error.statusCode)")
                self.isLoginSuccess.value = false
            }
        })
    }
    
    func requestJoin() -> String? {
		SignAPIRequest.signUpRequest(deviceToken: deviceToken, email: email, intro: introduce ?? "", nickname: nickname, password: password, responseHandler: { result in
            switch result {
            case .success(let isSuccess):
                DebugLog("Is Success : \(isSuccess)")
                self.isSignUpSuccess.value = true
			case.failure(_):
                ErrorLog("API Error")
            // Alert 이나 Toast 띄우기
            }
        })
        return nil
    }
    
    func setRootVCToHomeVC() {
        let navigationVC = HeroNavigationController(navigationBarClass: HeroUINavigationBar.self, toolbarClass: nil)
        navigationVC.viewControllers = [MainTabBarViewController()]
        navigationVC.isNavigationBarHidden = true
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = navigationVC
            appDelegate.window?.makeKeyAndVisible()
        }
    }
	
	func goToJoinNickname() {
		
	}
    
    func requestKakaoTalkLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    ErrorLog(error.localizedDescription)
                } else {
                    DebugLog("loginWithKakaoTalk() success ===> \(String(describing: oauthToken))")
                    // Kakao Login Success
//                    _ = oauthToken
                    self.getKakaoUserInfo()
                }
            }
        } else {
            requestKakaoAccountLogin()
        }
    }
    
    private func requestKakaoAccountLogin() {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            if let error = error {
                ErrorLog(error.localizedDescription)
            } else {
                DebugLog("loginWithKakaoAccount() success ===> \(String(describing: oauthToken))")
//                let _ = oauthToken
                self.getKakaoUserInfo()
            }
        }
    }
    
    private func getKakaoUserInfo() {
        UserApi.shared.me(completion: { user, error in
            if let error = error {
                ErrorLog(error.localizedDescription)
            } else {
                DebugLog("me() success.")
                
                if let kakaoUser = user {
                    DebugLog("[로그인된 사용자 정보]\nnickname: \(kakaoUser.kakaoAccount?.profile?.nickname ?? "nil")\nuserId: \(String(describing: kakaoUser.id))")
					if let kakaoUserId = kakaoUser.id {
						self.requestSNSJoinandLogin(socialType: "kakao", email: "", socialId: "\(kakaoUserId)")
					}
//                    UserApi.shared.logout(completion: { error in
//                        // Do Nothing
//                        DebugLog("Kakao Logout Result Error : \(error?.localizedDescription ?? "nil")")
//                    })
                }
            }
        })
    }
	
	func requestSNSJoinandLogin(socialType: String, email: String, socialId: String) {
		SignAPIRequest.snsSignUpRequest(socialType: socialType, email: email, socialId: socialId, responseHandler: { result in
			switch result {
			case .success(let signInData):
				DebugLog("Is Success : \(signInData)")
				self.isSignUpSuccess.value = true
				_ = TokenManager.shared.deleteAllTokenData()
				let sat = TokenManager.shared.setAccessToken(token: signInData.accessToken)
				let srt = TokenManager.shared.setRefreshToken(token: signInData.accessToken)
				let sated = TokenManager.shared.setAccessTokenExpiredDate(expiredAt: signInData.accessExpiredAt.convertToDate())
				let srted = TokenManager.shared.setRefreshTokenExpiredDate(expiredAt: signInData.refreshExpiredAt.convertToDate())
				DebugLog("sat : \(sat), srt : \(srt), sated : \(sated), srted : \(srted)")
				self.isSNSLoginSuccess.value = sat && srt && sated && srted
			case.failure:
				ErrorLog("API Error")
			// Alert 이나 Toast 띄우기
			}
		})
	}
}
