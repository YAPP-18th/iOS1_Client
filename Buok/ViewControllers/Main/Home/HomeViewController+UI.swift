//
//  HomeViewController+UI.swift
//  Buok
//
//  Created by Taein Kim on 2021/05/31.
//

import Foundation
import HeroCommon
import HeroUI

extension HomeViewController {
    func setupMainLayout() {
        view.addSubview(topContentView)
        view.addSubview(topSectionView)
        topContentView.addSubview(notiButton)
        topContentView.addSubview(searchButton)
        
        // Top Filter Section
        topSectionView.addArrangedSubview(filterContainerView)
        topSectionView.addArrangedSubview(messageContainerView)
        filterContainerView.addSubview(bucketFilterView)
        filterContainerView.addSubview(categoryContainerView)
        
        // Category Button
        categoryContainerView.addSubview(categoryTitleLabel)
        categoryContainerView.addSubview(categoryImageView)
        categoryContainerView.addSubview(categoryButton)
        categoryContainerView.bringSubviewToFront(categoryButton)
        
        categoryContainerView.addSubview(categoryDeleteButton)
        
        messageContainerView.addSubview(bubbleTriangleView)
        messageContainerView.addSubview(bucketCountBubble)
        bucketCountBubble.addSubview(countDescLabel)
        
        topContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(48)
        }
        
        notiButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(7)
            make.centerY.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        searchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-7)
            make.centerY.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        // Top Filter Section
        topSectionView.snp.makeConstraints { make in
            make.top.equalTo(topContentView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        filterContainerView.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        bucketFilterView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Category Button
        categoryContainerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        categoryTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        
        categoryImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalTo(categoryTitleLabel.snp.trailing).offset(2)
            make.width.equalTo(12)
            make.height.equalTo(12)
        }
        
        categoryDeleteButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(categoryImageView.snp.leading)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupBubbleLayout()
    }
    
    func setupBubbleLayout() {
        bucketCountBubble.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(48)
        }
        
        bubbleTriangleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(22.93)
            make.height.equalTo(19)
            make.bottom.equalTo(bucketCountBubble.snp.top).offset(3)
            make.leading.equalToSuperview().offset(13)
        }
        
        countDescLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setupViewProperties() {
        view.backgroundColor = .heroGrayF2EDE8
        
        topSectionView.axis = .vertical
        messageContainerView.backgroundColor = .clear
        bucketFilterView.delegate = self
        
        bucketCountBubble.layer.cornerRadius = 7
        bucketCountBubble.backgroundColor = .heroPrimaryNavyLight
        bubbleTriangleView.image = UIImage(heroSharedNamed: "ic_bubble_triangle")
        
        countDescLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        countDescLabel.textColor = .heroWhite100s
        
        categoryContainerView.backgroundColor = .heroWhite100s
        categoryContainerView.layer.cornerRadius = 8
        
        categoryTitleLabel.text = "Hero_Common_Category".localized
        categoryTitleLabel.font = .font15P
        categoryTitleLabel.textColor = .heroGray82
        categoryButton.addTarget(self, action: #selector(onClickCategoryFilterButton(_:)), for: .touchUpInside)
        categoryImageView.image = UIImage(heroSharedNamed: "ic_narrow_12")
        
        categoryDeleteButton.isEnabled = false
        categoryDeleteButton.addTarget(self, action: #selector(onClickCategoryDeleteButton(_:)), for: .touchUpInside)
    }
}
