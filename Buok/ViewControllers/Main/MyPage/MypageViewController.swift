//
//  MypageViewController.swift
//  Buok
//
//  Created by 김혜빈 on 2021/05/11.
//

import HeroUI

class MypageViewController: HeroBaseViewController {
    let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: UICollectionViewFlowLayout())
    let settingButton = UIButton()
    let profileView = MypageProfileView()
    let buokmarkHeader = MypageBuokmarkHeaderView()
    
    static let buokmarkColors: [UIColor] = [.heroPrimaryPinkLight, .heroPrimaryNavyLight, .heroPrimaryBlueLight]
    
    private let viewModel = MypageViewModel()
    private var buokmarks: [BuokmarkFlag] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindingViewModel()
    }
    
    private func setupView() {
        setupCollectionView()
        setupSettingButton()
        setupProfileView()
        setupBuokmarkHeader()
    }
    
    private func bindingViewModel() {
        viewModel.fetchBuokmarks().then { [weak self] values in
            self?.buokmarks = values
            self?.buokmarkHeader.count = values.count
            self?.collectionView.reloadSections(IndexSet(0...0))
        }
    }

    @objc
    func clickSettingButton(_ sender: UIButton) {
        // todo - 설정 버튼 기능
    }
    
    @objc
    func clickEditProfileButton(_ sender: UIButton) {
        let editVC = EditProfileViewController()
        editVC.modalPresentationStyle = .fullScreen
        self.pushViewController(editVC)
    }
    
    @objc
    func clickFriendButton(_ sender: UIButton) {
        // todo - 친구 카운팅 버튼 기능
    }
    
    @objc
    func clickBucketButton(_ sender: UIButton) {
        // todo - 버킷 카운팅 버튼 기능
    }
    
}

// MARK: +Delegate
extension MypageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return buokmarks.count
        } else { return 3 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            return settingBuokmarkCell(collectionView, indexPath)
        } else { return settingEmptyCell(collectionView, indexPath) }
    }
    
    private func settingBuokmarkCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BuokmarkCollectionCell.identifier, for: indexPath) as? BuokmarkCollectionCell else {
            return BuokmarkCollectionCell()
        }
        
        cell.setInformation(to: buokmarks[indexPath.row], color: MypageViewController.buokmarkColors[indexPath.row % 3])
        
        return cell
    }
    
    private func settingEmptyCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BuokmarkEmptyCollectionCell.identifier, for: indexPath) as? BuokmarkEmptyCollectionCell else {
            return BuokmarkEmptyCollectionCell()
        }
        
        if indexPath.row == 0 {
            cell.isFirst = true
        } else { cell.isFirst = false }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let heightForSettingButton: CGFloat = 44
        let heightForProfileView: CGFloat = 284
        let heightForHeader: CGFloat = 40
        
        let totalOffset = scrollView.contentOffset.y + heightForSettingButton + heightForProfileView + heightForHeader + 20
        let offsetForHeader = heightForSettingButton + heightForProfileView
        
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 0, max(-offsetForHeader, -totalOffset), 0)
        
        settingButton.layer.transform = transform
        profileView.layer.transform = transform
        buokmarkHeader.layer.transform = transform
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            if indexPath.row > 0 { return false }
            print("새로운 북마크 추가")
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MypageViewController {
    // MARK: CollectionView
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 368 + 20, left: 0, bottom: 0, right: 0)
        collectionView.register(BuokmarkCollectionCell.self, forCellWithReuseIdentifier: BuokmarkCollectionCell.identifier)
        collectionView.register(BuokmarkEmptyCollectionCell.self, forCellWithReuseIdentifier: BuokmarkEmptyCollectionCell.identifier)
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: SettingButton
    private func setupSettingButton() {
        if #available(iOS 13.0, *) {
            settingButton.setImage(UIImage(heroSharedNamed: "ic_setting")!.withTintColor(.heroGray82), for: .normal)
        } else {
            settingButton.setImage(UIImage(heroSharedNamed: "ic_setting")!, for: .normal)
        }
        settingButton.addTarget(self, action: #selector(clickSettingButton(_:)), for: .touchUpInside)
        self.view.addSubview(settingButton)
        
        settingButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    // MARK: ProfileView
    private func setupProfileView() {
        profileView.editButton.addTarget(self, action: #selector(clickEditProfileButton(_:)), for: .touchUpInside)
        profileView.countingButtonStack.friendButton.addTarget(self, action: #selector(clickFriendButton(_:)), for: .touchUpInside)
        profileView.countingButtonStack.bucketButton.addTarget(self, action: #selector(clickBucketButton(_:)), for: .touchUpInside)
        self.view.addSubview(profileView)
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(settingButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: BuokmarkHeader
    private func setupBuokmarkHeader() {
        buokmarkHeader.count = 10
        buokmarkHeader.backgroundColor = .heroServiceSkin
        self.view.addSubview(buokmarkHeader)
        
        buokmarkHeader.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(profileView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
}
