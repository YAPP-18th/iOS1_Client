//
//  DetailViewController.swift
//  Nadam
//
//  Copyright © 2021 Buok. All rights reserved.
//

import Foundation
import HeroCommon
import HeroSharedAssets
import HeroUI

public class DetailViewController: HeroBaseViewController {
    private let topContentView: UIView = UIView()
    private let backButton: HeroImageButton = HeroImageButton()
    private let optionButton: HeroImageButton = HeroImageButton()
    private let menuButton: HeroImageButton = HeroImageButton()
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let contentStackView: UIStackView = UIStackView()
    private let contentContainerView: UIView = UIView()
    private let historyContainerView: UIView = UIView()
    
    private let historyTitleLabel: UILabel = UILabel()
    private let historyDescLabel: UILabel = UILabel()
    private let historyTableView: UITableView = UITableView()
    
    private let stateView: UIView = UIView()
    private let stateLabel: UILabel = UILabel()
    
    private let categoryView: UIView = UIView()
    private let categoryLabel: UILabel = UILabel()
    
    private let titleLabel: UILabel = UILabel()
    private let bottomBar: UIView = UIView()
    
    private let clockImageView: UIImageView = UIImageView()
    private let dateLabel: UILabel = UILabel()
    
    private let contentBackgroundView: UIView = UIView()
    private let contentTextView: UITextView = UITextView()
    
    private var collectionStackView: UIStackView = UIStackView()
    private var imageCollectionView: UICollectionView?
    private var tagCollectionView: UICollectionView?
    
    public var viewModel: DetailViewModel?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupMainLayout()
        setupViewProperties()
        bindViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateContent()
        setContentData()
        viewModel?.getBucketDetailInfo()
    }
    
    private func updateContent() {
        if viewModel?.state.value == .done || viewModel?.state.value == .failure {
            optionButton.heroImage = (viewModel?.isBookmark.value ?? false) ? UIImage(heroSharedNamed: "ic_mark_fill") : UIImage(heroSharedNamed: "ic_mark")
        } else {
            optionButton.heroImage = (viewModel?.isPinned.value ?? false) ? UIImage(heroSharedNamed: "ic_pin_fill") : UIImage(heroSharedNamed: "ic_pin")
        }
    }
    
    private func bindViewModel() {
        viewModel?.state.bind({ _ in
            self.updateContent()
        })
        
        viewModel?.isBookmark.bind({ _ in
            self.updateContent()
        })
        
        viewModel?.isPinned.bind({ _ in
            self.updateContent()
        })
        
        viewModel?.bucketContent.bind({ content in
            self.contentTextView.text = content
        })
        
        viewModel?.bucketItem.bind({ bucketItem in
            self.viewModel?.state.value = BucketState(rawValue: bucketItem?.bucketState ?? 0) ?? .now
            self.setContentData()
        })
        
        viewModel?.historyList.bind({ historyList in
            if historyList?.count ?? 0 < 1 {
                self.historyContainerView.isHidden = true
            } else {
                self.historyContainerView.isHidden = false
                self.historyTableView.reloadData()
            }
        })
        
        viewModel?.tagList.bind({ tagList in
            if tagList?.count ?? 0 < 1 {
                self.tagCollectionView?.isHidden = true
            } else {
                self.tagCollectionView?.isHidden = false
                self.tagCollectionView?.reloadData()
            }
        })
        
        viewModel?.imageUrlList.bind({ imageList in
            if imageList?.count ?? 0 < 1 {
                self.imageCollectionView?.isHidden = true
            } else {
                self.imageCollectionView?.isHidden = false
                self.imageCollectionView?.reloadData()
            }
        })
    }
    
    private func setContentData() {
        let state = BucketState(rawValue: viewModel?.bucketItem.value?.bucketState ?? 0)
        let category = BucketCategory(rawValue: (viewModel?.bucketItem.value?.categoryId ?? 2) - 2)
        var bgColor: UIColor?
        
        stateLabel.text = viewModel?.state.value.getTitle()
        categoryLabel.text = category?.getTitle()
        
        switch state {
        case .now:
            bgColor = .heroServiceNavy
        case .expect:
            bgColor = .heroPrimaryBlue
        case .done:
            bgColor = .heroPrimaryPink
        case .failure:
            bgColor = .heroPrimaryPink
        default:
            break
        }
        
        stateView.backgroundColor = bgColor
        categoryView.backgroundColor = .heroGray5B
        
        titleLabel.text = viewModel?.bucketItem.value?.bucketName ?? ""
        dateLabel.text = viewModel?.bucketItem.value?.endDate.convertToDate().convertToKoreanString()
        
        contentTextView.text = "API좀 만들어줘라"
    }
    
    private func setupMainLayout() {
        view.addSubview(topContentView)
        topContentView.addSubview(backButton)
        topContentView.addSubview(optionButton)
        topContentView.addSubview(menuButton)
        
        view.addSubview(scrollView)
        scrollView.delegate = self.tabBarController as? UIScrollViewDelegate
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.addSubview(contentView)

        topContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(44)
        }

        backButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }

        menuButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        optionButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(menuButton.snp.leading)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topContentView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-2)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview().priority(250)
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(contentStackView)
        contentView.backgroundColor = .heroGrayF2EDE8
        
        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        contentStackView.addArrangedSubview(contentContainerView)
        contentStackView.addArrangedSubview(historyContainerView)
        
//        contentContainerView.snp.makeConstraints { make in
//            make.height.equalTo(500)
//        }
        
//        historyContainerView.snp.makeConstraints { make in
//            make.height.equalTo(250)
//        }
        
        setupContentLayout()
        setupCollectionStackView()
        setupImageCollectionView()
        setupTagCollectionView()
        setupHistoryLayout()
    }
    
    private func setupContentLayout() {
        // MARK: Content Layout
        contentContainerView.addSubview(stateView)
        stateView.addSubview(stateLabel)
        
        contentContainerView.addSubview(categoryView)
        categoryView.addSubview(categoryLabel)
        
        stateView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(44)
            make.height.equalTo(32)
        }
        
        categoryView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalTo(stateView.snp.trailing).offset(12)
            make.width.equalTo(44)
            make.height.equalTo(32)
        }
        
        stateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        contentContainerView.addSubview(titleLabel)
        contentContainerView.addSubview(bottomBar)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(stateView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        bottomBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(2)
        }
        
        contentContainerView.addSubview(clockImageView)
        contentContainerView.addSubview(dateLabel)
        
        clockImageView.snp.makeConstraints { make in
            make.top.equalTo(bottomBar.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(clockImageView.snp.centerY)
            make.leading.equalTo(clockImageView.snp.trailing).offset(7)
        }
        
        contentContainerView.addSubview(contentBackgroundView)
        contentBackgroundView.addSubview(contentTextView)
        
        contentBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(clockImageView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(200)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func setupHistoryLayout() {
        historyContainerView.addSubview(historyTitleLabel)
        historyContainerView.addSubview(historyDescLabel)
        historyContainerView.addSubview(historyTableView)
        
        historyTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(20)
        }
        
        historyDescLabel.snp.makeConstraints { make in
            make.centerY.equalTo(historyTitleLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        historyTableView.snp.makeConstraints { make in
            make.top.equalTo(historyTitleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    private func setupCollectionStackView() {
        contentContainerView.addSubview(collectionStackView)
        collectionStackView.spacing = 16
        collectionStackView.axis = .vertical
        
        collectionStackView.snp.makeConstraints { make in
            make.top.equalTo(contentBackgroundView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-32)
        }
    }
    
    private func setupImageCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 76, height: 64)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        imageCollectionView?.dataSource = self
        imageCollectionView?.delegate = self
        imageCollectionView?.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        imageCollectionView?.backgroundColor = .clear
        
        collectionStackView.addArrangedSubview(imageCollectionView!)
        
        imageCollectionView?.snp.makeConstraints { make in
            make.height.equalTo(64)
        }
    }
    
    private func setupTagCollectionView() {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = CGSize(width: 140, height: 32)
        
        tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tagCollectionView?.dataSource = self
        tagCollectionView?.delegate = self
        tagCollectionView?.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        tagCollectionView?.backgroundColor = .clear
        
        collectionStackView.addArrangedSubview(tagCollectionView!)
        tagCollectionView?.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
    }
    
    private func setupViewProperties() {
        view.backgroundColor = .heroGrayF2EDE8
        backButton.imageInset = 8
        backButton.heroImage = UIImage(heroSharedNamed: "ic_back")
        backButton.addTarget(self, action: #selector(onClickBackButton(_:)), for: .touchUpInside)
        
        optionButton.imageInset = 8
        optionButton.heroImage = UIImage(heroSharedNamed: "ic_pin")
        optionButton.addTarget(self, action: #selector(onClickOptionButton(_:)), for: .touchUpInside)
//        ic_mark / ic_pin
        
        menuButton.imageInset = 8
        menuButton.heroImage = UIImage(heroSharedNamed: "ic_menu_ver")
        menuButton.addTarget(self, action: #selector(onClickMoreButton(_:)), for: .touchUpInside)
        
        scrollView.showsVerticalScrollIndicator = false
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        
        [contentContainerView, historyContainerView].forEach {
            $0.backgroundColor = .heroWhite100s
            $0.layer.cornerRadius = 16
        }
        
        historyContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        [stateLabel, categoryLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            $0.textColor = .heroWhite100s
            $0.textAlignment = .center
        }
        
        [stateView, categoryView].forEach {
            $0.layer.cornerRadius = 8
        }
        
        bottomBar.backgroundColor = .heroGrayF1F1F1
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = .heroGray5B
        
        clockImageView.image = UIImage(heroSharedNamed: "ic_clock")
        dateLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        dateLabel.textColor = .heroGray5B
        
        contentBackgroundView.layer.cornerRadius = 7
        contentBackgroundView.backgroundColor = .heroGrayF2EDE8
        contentTextView.isEditable = false
        contentTextView.textColor = .heroGray5B
        contentTextView.backgroundColor = .clear
        contentTextView.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        historyTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        historyTitleLabel.textColor = .heroGray5B
        historyTitleLabel.text = "수정 타임라인"
        
        historyDescLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        historyDescLabel.textColor = .heroGrayDA
        historyDescLabel.text = "2021. 03. 24에 최종적으로 변경됨"
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.register(DetailHistoryCell.self, forCellReuseIdentifier: DetailHistoryCell.identifier)
        historyTableView.isScrollEnabled = false
        historyTableView.separatorStyle = .none
    }
    
    @objc
    private func onClickBackButton(_ sender: Any?) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func onClickMoreButton(_ sender: Any?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyAction = UIAlertAction(title: "수정하기", style: .default, handler: { _ in
            let vc = EditBucketViewController()
            if let detailItem = self.viewModel?.bucketDetailItem.value {
                let viewModel = EditBucketViewModel(detailModel: detailItem)
                vc.viewModel = viewModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(modifyAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func onClickOptionButton(_ sender: Any?) {
        if viewModel?.state.value == .done || viewModel?.state.value == .failure {
            // Add Bookmark
            viewModel?.addBucketToBookmark()
        } else {
            // Pin
            viewModel?.setPinBucket()
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.historyList.value?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DetailHistoryCell.identifier, for: indexPath) as? DetailHistoryCell {
            cell.historyItem = viewModel?.historyList.value?[indexPath.row]
        }
        return UITableViewCell()
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageCollectionView {
            return viewModel?.imageUrlList.value?.count ?? 0
        } else {
            return viewModel?.tagList.value?.count ?? 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell {
                cell.itemImage = viewModel?.imageUrlList.value?[indexPath.row]
                cell.index = indexPath.row - 1
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell {
                cell.itemTitle = viewModel?.tagList.value?[indexPath.row]
                cell.itemIndex = indexPath.row - 1
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
}
