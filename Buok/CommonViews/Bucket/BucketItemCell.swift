//
//  BucketItemCell.swift
//  Buok
//
//  Copyright © 2021 Buok. All rights reserved.
//

import Foundation
import HeroCommon
import HeroUI

public enum BucketItemCellType {
    case normal
    case search
    case friendProfile
}

protocol BucketItemCellProfileDelegate: AnyObject {
    func didSelectUserProfile(userId: Int)
}

final class BucketItemCell: UICollectionViewCell {
    static let identifier: String = "BucketItemCell"
    
    private let stateView: BucketStateView = BucketStateView()
    private let contentBgView: UIView = UIView()
    private let iconContainerView: UIView = UIView()
    private let iconImageView: UIImageView = UIImageView()
    private let userProfileImageView: UIImageView = UIImageView()
    private let userProfileButton: UIButton = UIButton()
    
    private let titleLabel: UILabel = UILabel()
    private let dateLabel: UILabel = UILabel()
    
    public weak var profileDelegate: BucketItemCellProfileDelegate?
    
    public var cellType: BucketItemCellType = .normal {
        didSet {
            updateUserIconView()
        }
    }
    
    public var bucket: BucketModel? {
        didSet {
            titleLabel.text = bucket?.bucketName
            self.updateContentBgView()
            self.setupCategoryIcon()
        }
    }
    
    public var bucketFriendProfile: ProfileBucketModel? {
        didSet {
            titleLabel.text = bucketFriendProfile?.bucketName
            self.updateContentBgView()
            self.setupCategoryIcon()
        }
    }
    
    public var bucketSearch: SearchBucketModel? {
        didSet {
            if let urlStr = bucketSearch?.userProfileUrl, !urlStr.isEmpty, let profileUrl = URL(string: urlStr) {
                self.userProfileImageView.kf.setImage(with: profileUrl)
            } else {
                self.userProfileImageView.image = UIImage(heroSharedNamed: "search_user_default")
            }
            
            self.titleLabel.text = bucketSearch?.bucketName
            self.updateContentBgView()
            self.setupCategoryIcon()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
        updateUserIconView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewLayout() {
        contentView.addSubview(contentBgView)
        contentView.addSubview(stateView)
        contentBgView.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        iconContainerView.addSubview(userProfileImageView)
        iconContainerView.addSubview(userProfileButton)
        
        contentBgView.addSubview(titleLabel)
        contentBgView.addSubview(dateLabel)
        
        contentBgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        iconContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.width.height.equalTo(36)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        userProfileImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        userProfileButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stateView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(36)
            make.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.centerX.equalToSuperview()
        }
        
        contentBgView.layer.cornerRadius = 8
        iconContainerView.layer.cornerRadius = 18
        userProfileImageView.layer.cornerRadius = 18
        userProfileImageView.clipsToBounds = true
        userProfileImageView.contentMode = .scaleAspectFill
        
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.textColor = .heroGray5B
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        userProfileButton.addTarget(self, action: #selector(onClickUserProfile(_:)), for: .touchUpInside)
    }
    
    @objc
    private func onClickUserProfile(_ sender: UIButton) {
        if let userId = bucketSearch?.userId {
            profileDelegate?.didSelectUserProfile(userId: userId)
        }
    }
    
    private func updateUserIconView() {
        iconImageView.isHidden = cellType == .search
        userProfileImageView.isHidden = !(cellType == .search)
    }
    
    private func setupCategoryIcon() {
        var categoryId: Int = 2
        switch cellType {
        case .normal:
            categoryId = bucket?.categoryId ?? 2
        case .search:
            categoryId = bucketSearch?.categoryId ?? 1
        case .friendProfile:
            categoryId = bucketFriendProfile?.categoryId ?? 2
        }
        
        iconImageView.image = BucketCategory(rawValue: categoryId - 2)?.getIcon()?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .heroGrayA6A4A1
    }
    
    private func updateContentBgView() {
        var bucketState: Int = 2
        switch cellType {
        case .normal:
            bucketState = bucket?.bucketState ?? 2
        case .search:
            bucketState = bucketSearch?.bucketState ?? 1
        case .friendProfile:
            bucketState = bucketFriendProfile?.bucketState ?? 2
        }
        
        let state = BucketState(rawValue: bucketState) ?? .all
        stateView.state = state
        
        if state == .failure {
            iconContainerView.backgroundColor = .heroGrayF2EDE8
            contentBgView.backgroundColor = .heroGrayE7E1DC
            contentBgView.layer.shadowRadius = 0
            contentBgView.layer.shadowColor = UIColor.clear.cgColor
            contentBgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        } else {
            iconContainerView.backgroundColor = .heroGrayF1F1F1
            contentBgView.backgroundColor = .heroWhite100s
            contentBgView.layer.shadowRadius = 8
            contentBgView.layer.shadowColor = UIColor.heroGrayC7BFB8.cgColor
            contentBgView.layer.shadowOffset = CGSize(width: 0, height: 5)
        }
        
        updateLabelProperty(state: state)
        setDateToLabel(state: state)
    }
    
    private func updateLabelProperty(state: BucketState) {
        var textColor: UIColor?
        var font: UIFont?
        
        switch state {
        case .now:
            textColor = .heroGrayA6A4A1
            font = UIFont.systemFont(ofSize: 13, weight: .regular)
        case .expect:
            textColor = .heroGrayA6A4A1
            font = UIFont.systemFont(ofSize: 13, weight: .regular)
        case .done:
            textColor = .heroPrimaryPink
            font = UIFont.systemFont(ofSize: 13, weight: .bold)
        case .failure:
            textColor = .heroGrayA6A4A1
            font = UIFont.systemFont(ofSize: 13, weight: .regular)
        case .all:
            break
        }
        
        dateLabel.textColor = textColor
        dateLabel.font = font
    }
    
    private func setDateToLabel(state: BucketState) {
        var endDate: String? = ""
        switch cellType {
        case .normal:
            endDate = bucket?.endDate
        case .search:
            endDate = bucketSearch?.endDate
        case .friendProfile:
            endDate = bucketFriendProfile?.endDate
        }
        
        if state == .failure || state == .done {
            dateLabel.text = endDate?.convertToDate().convertToSmallString()
        } else {
            if let convertEndDate = endDate?.convertToDate() {
                if Calendar.current.dateComponents([.day], from: convertEndDate, to: Date()).day == 0 {
                    dateLabel.text = "D - Day"
                } else {
                    dateLabel.text = "D - \(Calendar.current.dateComponents([.day], from: Date(), to: convertEndDate).day ?? 0)"
                }
            }
        }
    }
}
