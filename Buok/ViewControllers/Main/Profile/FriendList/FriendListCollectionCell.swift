//
//  FriendListCollectionCell.swift
//  Buok
//
//  Copyright © 2021 Buok. All rights reserved.
//

import HeroUI

public protocol FriendListCollectionCellDelegate: AnyObject {
	func changeFriendTypeToFriend(index: Int)
}

class FriendListCollectionCell: UICollectionViewCell {
    static let identifier = "FriendListCollectionCell"
    private let profileImageView = UIImageView()
    private let userLabel = UILabel()
    private let introLabel = UILabel()
    private let friendButton = FriendButton()
	
    private var topOfUserLabel: NSLayoutConstraint?
	public var friendListIndex: Int = 0
	public weak var delegate: FriendListCollectionCellDelegate?
	
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        setupProfileImageVIew()
        setupUserLabel()
        setupIntroLabel()
        setupFriendButton()
    }
    
    func setFriendUser(user: FriendUser) {
        if let introduce = user.intro {
            introLabel.text = introduce
            topOfUserLabel?.constant = 6
            introLabel.isHidden = false
        } else {
            introLabel.isHidden = true
            topOfUserLabel?.constant = 16
        }
        
        if let profileUrl = URL(string: user.profileUrl ?? "") {
            profileImageView.kf.setImage(with: profileUrl)
        }
        
        userLabel.text = user.nickname ?? ""
		
		if user.friendStatus == 1 {
			friendButton.friendType.value = .friend
		} else if user.friendStatus == 2 {
			friendButton.friendType.value = .request
		} else {
			friendButton.friendType.value = .none
		}
		friendButton.settingFriendButtonType(for: friendButton.friendType.value)
    }
	
	func setSearchUser(user: SearchUserModel) {
		if let introduce = user.intro {
			introLabel.text = introduce
			topOfUserLabel?.constant = 6
			introLabel.isHidden = false
		} else {
			introLabel.isHidden = true
			topOfUserLabel?.constant = 16
		}
		
		if let profileUrl = URL(string: user.profileUrl ?? "") {
			if !(user.profileUrl?.contains("http") ?? false) {
				profileImageView.image = UIImage(heroSharedNamed: "ic_profile_48")
			} else {
				profileImageView.kf.setImage(with: profileUrl)
			}
		}
		
		userLabel.text = user.nickname
		
		if user.friendStatus == 1 {
			friendButton.friendType.value = .friend
		} else if user.friendStatus == 2 {
			friendButton.friendType.value = .request
		} else {
			friendButton.friendType.value = .none
		}
		friendButton.settingFriendButtonType(for: friendButton.friendType.value)
	}
    
    @objc
    func clickFriendButton(_ sender: UIButton) {
        // todo - 친구 취소 성공하면..
		if friendButton.friendType.value == .none {
			friendButton.settingFriendButtonType(for: .request)
			delegate?.changeFriendTypeToFriend(index: friendListIndex)
		} else if friendButton.friendType.value == .friend {
			friendButton.settingFriendButtonType(for: .none)
		} else {
			friendButton.settingFriendButtonType(for: .friend)
		}
    }
}

extension FriendListCollectionCell {
    // MARK: ProfileImageView
    private func setupProfileImageVIew() {
        profileImageView.layer.cornerRadius = 24
        profileImageView.image = UIImage(heroSharedNamed: "ic_profile_48")
        self.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    // MARK: UserLabel
    private func setupUserLabel() {
        userLabel.text = "Hero_Profile_Name_Sample".localized
        userLabel.textColor = .heroGray5B
        userLabel.font = .font15P
        self.addSubview(userLabel)
        
        userLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        
        topOfUserLabel = userLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor)
        topOfUserLabel?.constant = 6
        topOfUserLabel?.isActive = true
    }
    
    // MARK: IntroLabel
    private func setupIntroLabel() {
        introLabel.text = ""
        introLabel.textColor = .heroGray5B
        introLabel.font = .font12P
        self.addSubview(introLabel)
        
        introLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom).offset(-6)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
    }
    
    // MARK: FriendButton
    private func setupFriendButton() {
		friendButton.settingFriendButtonType(for: friendButton.friendType.value)
        friendButton.addTarget(self, action: #selector(clickFriendButton(_:)), for: .touchUpInside)
        self.addSubview(friendButton)
		
		friendButton.snp.makeConstraints { make in
			make.width.equalTo(48)
			make.centerY.equalToSuperview()
			make.trailing.equalToSuperview().offset(-20)
		}
    }
}
