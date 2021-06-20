//
//  NotificationFriendAcceptTableCell.swift
//  Buok
//
//  Created by 김보민 on 2021/06/17.
//  Copyright © 2021 Buok. All rights reserved.
//

import HeroUI

class NotificationFriendAcceptTableCell: UITableViewCell {
	static let identifier = "NotificationFriendAcceptTableCell"
	private let profileImageView = UIImageView()
	private let titleLabel: UILabel = {
		$0.font = .font15P
		$0.textColor = .heroGray5B
		$0.numberOfLines = 1
		return $0
	}(UILabel())
	private let contentLabel: UILabel = {
		$0.font = .font15P
		$0.textColor = .heroGray82
		$0.numberOfLines = 2
		return $0
	}(UILabel())
	private let mainContentView: UIView = {
		$0.backgroundColor = .white
		$0.layer.cornerRadius = 8
		return $0
	}(UIView())
	private let bottomView: UIView = {
		$0.backgroundColor = .heroServiceSkin
		return $0
	}(UIView())
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
		setupContentLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupView() {
		self.backgroundColor = .heroServiceSkin
		profileImageView.image = UIImage(heroSharedNamed: "ic_profile_48")
		profileImageView.contentMode = .scaleAspectFill
		profileImageView.layer.cornerRadius = 28
		profileImageView.clipsToBounds = true
		
	}
	
	private func setupContentLayout() {
		contentView.addSubview(mainContentView)
		mainContentView.addSubview(profileImageView)
		mainContentView.addSubview(titleLabel)
		mainContentView.addSubview(contentLabel)
		contentView.addSubview(bottomView)
		
		mainContentView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
		}
		
		bottomView.snp.makeConstraints { make in
			make.top.equalTo(mainContentView.snp.bottom)
			make.leading.trailing.bottom.equalToSuperview()
			make.height.equalTo(12)
		}
		
		profileImageView.snp.makeConstraints { make in
			make.width.height.equalTo(56)
			make.top.equalTo(mainContentView.snp.top).offset(14)
			make.leading.equalTo(mainContentView.snp.leading).offset(16)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(mainContentView.snp.top).offset(12)
			make.leading.equalTo(profileImageView.snp.trailing).offset(16)
			make.trailing.equalTo(mainContentView.snp.trailing).inset(16)
		}
		
		contentLabel.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(4)
			make.leading.equalTo(titleLabel.snp.leading)
			make.trailing.equalTo(titleLabel.snp.trailing)
			make.bottom.equalTo(mainContentView.snp.bottom).inset(12)
		}
	}
	
	func applyAttributedTitleNicknameText(nickname: String) {
		let text = "\(nickname)님과 친구가 되었습니다."
		
		let attributedStr = NSMutableAttributedString(string: text)
		attributedStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .bold), range: (text as NSString).range(of: nickname))
		attributedStr.addAttribute(.foregroundColor, value: UIColor.heroGray5B, range: (text as NSString).range(of: nickname))
		titleLabel.attributedText = attributedStr
	}
	
	func applyAttributedContentNicknameText(nickname: String) {
		let text = "\(nickname)님의 친구 요청을 수락했습니다. 버킷북을 구경해보세요!"
		contentLabel.text = text
	}
}
