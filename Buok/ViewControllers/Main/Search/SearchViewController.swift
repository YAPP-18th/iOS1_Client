//
//  SearchViewController.swift
//  Buok
//
//  Copyright © 2021 Buok. All rights reserved.
//

import Foundation
import HeroCommon
import HeroUI

final class SearchViewController: HeroBaseViewController {
    private let statusBarBackgroundView: UIView = UIView()
    private let searchContainerView: UIView = UIView()
    private let closeButton: UIButton = UIButton()
    private let searchBar: UISearchBar = UISearchBar()
    
    private let filterContainerView: UIView = UIView()
    private let filterStackView: UIStackView = UIStackView()
    
    private let filterMyBookButton: UIButton = UIButton()
    private let filterAccountButton: UIButton = UIButton()
    private let filterBookmarkButton: UIButton = UIButton()
    
    private let filterMyBookBar: UIView = UIView()
    private let filterAccountBar: UIView = UIView()
    private let filterBookmarkBar: UIView = UIView()
    
    private let noSearchResults: UILabel = UILabel()

    private let mybuokCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let friendCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    public var viewModel: SearchViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewLayout()
		setupViewProperties()
        bindViewModel()
        viewModel?.currentSearchType.value = .myBucket
    }
    
    private func bindViewModel() {
        viewModel?.currentSearchType.bind({ [weak self] type in
            self?.filterMyBookBar.isHidden = !(type == .myBucket)
            self?.filterAccountBar.isHidden = !(type == .user)
            self?.filterBookmarkBar.isHidden = !(type == .mark)
            
            self?.filterMyBookButton.setTitleColor((type == .myBucket ? .heroGray5B : .heroGray82), for: .normal)
            self?.filterAccountButton.setTitleColor((type == .user ? .heroGray5B : .heroGray82), for: .normal)
            self?.filterBookmarkButton.setTitleColor((type == .mark ? .heroGray5B : .heroGray82), for: .normal)
            
            self?.mybuokCollectionView.isHidden = !(type == .mark || type == .myBucket)
            self?.friendCollectionView.isHidden = !(type == .user)
        })
        
        viewModel?.bucketSearchList.bind({ [weak self] _ in
            self?.mybuokCollectionView.reloadData()
        })
		
		viewModel?.friendList.bind({ [weak self] _ in
			self?.friendCollectionView.reloadData()
		})
		
		viewModel?.bookmarkSearchList.bind({ [weak self] _ in
			self?.mybuokCollectionView.reloadData()
		})
    }
    
    private func setupBucketCollectionView() {
        mybuokCollectionView.backgroundColor = .heroServiceSkin
        view.addSubview(mybuokCollectionView)
        mybuokCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterContainerView.snp.bottom).offset(22)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupFriendCollectionView() {
        friendCollectionView.backgroundColor = .heroServiceSkin
        view.addSubview(friendCollectionView)
        friendCollectionView.snp.makeConstraints { make in
			make.top.equalTo(filterContainerView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupViewLayout() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(statusBarBackgroundView)
        view.addSubview(searchContainerView)
        searchContainerView.addSubview(closeButton)
        searchContainerView.addSubview(searchBar)
        
        view.addSubview(filterContainerView)
        filterContainerView.addSubview(filterStackView)
        filterStackView.addArrangedSubview(filterMyBookButton)
        filterStackView.addArrangedSubview(filterAccountButton)
        filterStackView.addArrangedSubview(filterBookmarkButton)
        
        filterMyBookButton.addSubview(filterMyBookBar)
        filterAccountButton.addSubview(filterAccountBar)
        filterBookmarkButton.addSubview(filterBookmarkBar)
        
        setupBucketCollectionView()
        setupFriendCollectionView()
        view.addSubview(noSearchResults)
        
        statusBarBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        searchContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-19)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(closeButton.snp.leading).offset(-16)
        }
        
        filterContainerView.snp.makeConstraints { make in
            make.top.equalTo(searchContainerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        filterStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(41)
            make.trailing.equalToSuperview().offset(-41)
        }
        
        filterMyBookBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalTo(72)
        }
        
        filterAccountBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalTo(72)
        }
        
        filterBookmarkBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalTo(72)
        }
        
        noSearchResults.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        statusBarBackgroundView.backgroundColor = .heroWhite100s
        searchContainerView.backgroundColor = .heroWhite100s
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        closeButton.setTitle("닫기", for: .normal)
        closeButton.setTitleColor(.heroGray82, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        closeButton.addTarget(self, action: #selector(onClickClose(_:)), for: .touchUpInside)
        
        filterStackView.axis = .horizontal
        filterStackView.distribution = .equalSpacing
        filterMyBookButton.setTitle("마이북", for: .normal)
        filterAccountButton.setTitle("계정", for: .normal)
        filterBookmarkButton.setTitle("북마크", for: .normal)
        
        filterMyBookButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        filterAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        filterBookmarkButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        filterContainerView.backgroundColor = .heroWhite100s
        
        filterMyBookBar.backgroundColor = .heroGray5B
        filterAccountBar.backgroundColor = .heroGray5B
        filterBookmarkBar.backgroundColor = .heroGray5B
        
        filterMyBookButton.addTarget(self, action: #selector(onClickMyBuok(_:)), for: .touchUpInside)
        filterAccountButton.addTarget(self, action: #selector(onClickAccount(_:)), for: .touchUpInside)
        filterBookmarkButton.addTarget(self, action: #selector(onClickBookmark(_:)), for: .touchUpInside)
        
        noSearchResults.text = "검색 결과가 없습니다."
        noSearchResults.font = .font17P
        noSearchResults.textColor = .heroGray5B
    }
    
    private func setupViewProperties() {
        mybuokCollectionView.delegate = self
        mybuokCollectionView.dataSource = self
        mybuokCollectionView.backgroundColor = .clear
        mybuokCollectionView.showsVerticalScrollIndicator = false
        mybuokCollectionView.register(BucketItemCell.self, forCellWithReuseIdentifier: BucketItemCell.identifier)
		
		friendCollectionView.delegate = self
		friendCollectionView.dataSource = self
		friendCollectionView.backgroundColor = .clear
		friendCollectionView.showsVerticalScrollIndicator = false
		friendCollectionView.register(FriendListCollectionCell.self, forCellWithReuseIdentifier: FriendListCollectionCell.identifier)
    }
    
    @objc
    private func onClickMyBuok(_ sender: UIButton) {
        viewModel?.currentSearchType.value = .myBucket
		if viewModel?.isSearchedKeyword == true, viewModel?.searchKeyword.value != "" {
			viewModel?.fetchSearchResult(type: .myBucket, keyword: viewModel?.searchKeyword.value ?? "")
			self.mybuokCollectionView.reloadData()
		}
    }
    
    @objc
    private func onClickAccount(_ sender: UIButton) {
        viewModel?.currentSearchType.value = .user
		if viewModel?.isSearchedKeyword == true, viewModel?.searchKeyword.value != "" {
			viewModel?.fetchSearchResult(type: .user, keyword: viewModel?.searchKeyword.value ?? "")
			self.friendCollectionView.reloadData()
		}
    }
    
    @objc
    private func onClickBookmark(_ sender: UIButton) {
        viewModel?.currentSearchType.value = .mark
		if viewModel?.isSearchedKeyword == true, viewModel?.searchKeyword.value != "" {
			viewModel?.fetchSearchResult(type: .mark, keyword: viewModel?.searchKeyword.value ?? "")
			self.mybuokCollectionView.reloadData()
		}
    }
    
    @objc
    private func onClickClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: FriendListCollectionCellDelegate {
	func changeFriendTypeToFriend(index: Int) {
		viewModel?.requestFriend(friendId: viewModel?.friendList.value[index].userId ?? 0)
	}
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let type = viewModel?.currentSearchType.value, let keyword = searchBar.text {
			if let viewModel = viewModel {
            viewModel.fetchSearchResult(type: type, keyword: keyword)
            noSearchResults.isHidden = true
			viewModel.searchKeyword.value = keyword
			viewModel.isSearchedKeyword = true
			}
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let value = viewModel?.currentSearchType.value
		if value == .user {
			return viewModel?.friendList.value.count ?? 0
		} else if value == .mark {
			return viewModel?.bookmarkSearchCount.value ?? 0
		} else {
			return viewModel?.bucketSearchCount.value ?? 0
		}
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let value = viewModel?.currentSearchType.value
		if value == .user {
			return settingUserCell(collectionView, indexPath)
		} else if value == .mark {
			return settingBookMarkCell(collectionView, indexPath)
		} else {
			return settingMyBuokCell(collectionView, indexPath)
		}
	}
	
	private func settingUserCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendListCollectionCell.identifier, for: indexPath) as? FriendListCollectionCell else {
			return FriendListCollectionCell()
		}
		
		if let user = viewModel?.friendList.value[indexPath.row] {
			cell.setSearchUser(user: user)
			cell.delegate = self
			cell.friendListIndex = indexPath.row
		}
		
		return cell
	}
	
	private func settingMyBuokCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BucketItemCell.identifier, for: indexPath) as? BucketItemCell else {
			return BucketItemCell()
		}
		
		cell.bucketSearch = viewModel?.bucketSearchList.value[indexPath.row]
		
		return cell
	}
	
	private func settingBookMarkCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BucketItemCell.identifier, for: indexPath) as? BucketItemCell else {
			return BucketItemCell()
		}
		
		cell.bucketSearch = viewModel?.bookmarkSearchList.value[indexPath.row]
		
		return cell
	}

//    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let bucket = viewModel?.bucketSearchList.value[indexPath.row]
//        let vc = DetailViewController()
//        let viewModel = DetailViewModel()
//        viewModel.bucketItem.value = bucket
//        vc.viewModel = viewModel
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = UIScreen.main.bounds.width - 40
		if let value = viewModel?.currentSearchType.value, value == .user {
			return CGSize(width: width, height: 48)
		} else {
			return CGSize(width: width / 2 - 9, height: width / 2 - 9 + 16 + 2)
		}
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		if let value = viewModel?.currentSearchType.value, value == .user {
			return 16
		} else {
			return 15
		}
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		if let value = viewModel?.currentSearchType.value, value == .myBucket || value == .mark {
			return 18
		} else {
			return 0
		}
    }
}
