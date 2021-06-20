//
//  EditBucketViewController.swift
//  Buok
//
//  Copyright © 2021 Buok. All rights reserved.
//

import Foundation
import HeroCommon
import HeroSharedAssets
import HeroUI

final class EditBucketViewController: HeroBaseViewController, UINavigationControllerDelegate {
    private let topContentView: UIView = UIView()
    private let backButton: HeroImageButton = HeroImageButton()
    private let doneButton: HeroImageButton = HeroImageButton()
    
    private let filterContentView: UIView = UIView()
    private let statusButton: HeroButton = HeroButton()
    private let statusContainerView: UIView = UIView()
    private let statusTitleLabel: UILabel = UILabel()
    private let statusImageView: UIImageView = UIImageView()
    
    private let categoryContainerView: UIView = UIView()
    private let categoryButton: HeroButton = HeroButton()
    private let categoryTitleLabel: UILabel = UILabel()
    private let categoryImageView: UIImageView = UIImageView()
    
    private let titleField: UITextField = UITextField()
    private let divisionBar: UIView = UIView()
    
    private let finishDateContainerView: UIView = UIView()
    private let finishDateTitleLabel: UILabel = UILabel()
    private let finishDateSelectButton: HeroButton = HeroButton()
    
    private let detailTitleLabel: UILabel = UILabel()
    private let detailBackgroundView: UIView = UIView()
    private let detailTextView: UITextView = UITextView()
    private let detailLengthLabel: UILabel = UILabel()
    
    private var imageCollectionView: UICollectionView?
    private var tagCollectionView: UICollectionView?
    
    private let dateChooserAlert = UIAlertController(title: "날짜 선택", message: nil, preferredStyle: .actionSheet)
    private let datePicker: UIDatePicker = UIDatePicker()
    private let imagePicker = UIImagePickerController()
    
    public var viewModel: EditBucketViewModel?
    private var selectViewType: Any.Type = BucketStatus.self
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        setupMainLayout()
        setupViewProperties()
        bindViewModel()
    }
    
    private func setupMainLayout() {
        view.addSubview(topContentView)
        view.addSubview(filterContentView)
        view.addSubview(titleField)
        view.addSubview(divisionBar)
        view.addSubview(finishDateContainerView)
        view.addSubview(detailTitleLabel)
        view.addSubview(detailBackgroundView)
        imagePicker.delegate = self
        
        setupNavigationView()
        setupTitleSectionView()
        
        // MARK: Title
        titleField.snp.makeConstraints { make in
            make.top.equalTo(filterContentView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        
        divisionBar.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(2)
        }
        
        // MARK: Finish Date
        finishDateContainerView.addSubview(finishDateTitleLabel)
        finishDateContainerView.addSubview(finishDateSelectButton)
        
        finishDateContainerView.snp.makeConstraints { make in
            make.top.equalTo(divisionBar.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        finishDateTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        finishDateSelectButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        setupDetailSectionView()
        setupImageCollectionView()
        setupTagCollectionView()
    }
    
    private func setupNavigationView() {
        topContentView.addSubview(backButton)
        topContentView.addSubview(doneButton)
        
        topContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(13)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(48)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        doneButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(48)
            make.height.equalTo(32)
        }
    }
    
    private func setupTitleSectionView() {
        filterContentView.snp.makeConstraints { make in
            make.top.equalTo(topContentView.snp.bottom).offset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.height.equalTo(16)
        }
        
        filterContentView.addSubview(statusContainerView)
        filterContentView.addSubview(categoryContainerView)
        
        statusContainerView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        statusContainerView.addSubview(statusTitleLabel)
        statusContainerView.addSubview(statusImageView)
        statusContainerView.addSubview(statusButton)
        statusContainerView.bringSubviewToFront(statusButton)
        
        statusTitleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        statusImageView.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(statusTitleLabel.snp.trailing).offset(2)
            make.width.equalTo(12)
            make.height.equalTo(12)
        }
        
        statusButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        categoryContainerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(statusContainerView.snp.trailing).offset(16)
        }
        
        categoryContainerView.addSubview(categoryTitleLabel)
        categoryContainerView.addSubview(categoryImageView)
        categoryContainerView.addSubview(categoryButton)
        categoryContainerView.bringSubviewToFront(categoryButton)
        
        categoryTitleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        categoryImageView.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(categoryTitleLabel.snp.trailing).offset(2)
            make.width.equalTo(12)
            make.height.equalTo(12)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupDetailSectionView() {
        detailTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(finishDateContainerView.snp.bottom).offset(9)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(16)
        }
        
        detailBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(detailTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(200)
        }
        
        detailBackgroundView.addSubview(detailTextView)
        detailBackgroundView.addSubview(detailLengthLabel)
        
        detailTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        detailLengthLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-8)
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
        imageCollectionView?.register(CreateImageCell.self, forCellWithReuseIdentifier: CreateImageCell.identifier)
        imageCollectionView?.register(CreateAddCell.self, forCellWithReuseIdentifier: CreateAddCell.identifier)
        imageCollectionView?.backgroundColor = .clear
        
        view.addSubview(imageCollectionView!)
        imageCollectionView?.snp.makeConstraints { make in
            make.top.equalTo(detailBackgroundView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(64)
        }
    }
    
    private func setupTagCollectionView() {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = CGSize(width: 140, height: 32)
        
        //        let layout = TagFlowLayout()
        //        layout.estimatedItemSize = CGSize(width: 140, height: 40)
        
        tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tagCollectionView?.dataSource = self
        tagCollectionView?.delegate = self
        tagCollectionView?.register(CreateTagAddCell.self, forCellWithReuseIdentifier: CreateTagAddCell.identifier)
        tagCollectionView?.register(CreateTagCell.self, forCellWithReuseIdentifier: CreateTagCell.identifier)
        tagCollectionView?.backgroundColor = .clear
        view.addSubview(tagCollectionView!)
        
        tagCollectionView?.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView!.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(32)
        }
    }
    
    private func setupDatePicker() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        
        dateChooserAlert.view.addSubview(datePicker)
        dateChooserAlert.view.snp.makeConstraints { make in
            make.height.equalTo(350)
        }
        
        datePicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.top.equalToSuperview()
        }
        
        dateChooserAlert.addAction(UIAlertAction(title: "선택완료", style: .default, handler: { _ in
            self.viewModel?.setBucketFinishDate(date: self.datePicker.date)
        }))
    }
    
    private func setDateStringToButton(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        let dateString = formatter.string(from: date)
        DebugLog("[DatePicker]-> choose -> \(dateString)")
        
        finishDateSelectButton.setTitleColor(.heroGray5B, for: .normal)
        finishDateSelectButton.setTitle(dateString, for: .normal)
    }
    
    @objc
    private func handleDatePicker(_ sender: UIDatePicker) {
        DebugLog(datePicker.date.description)
        viewModel?.finishDate.value = datePicker.date
    }
    
    private func bindViewModel() {
        viewModel?.bucketTitle.bindAndFire({ title in
            DebugLog("Bucket Title : \(title)")
            self.titleField.text = title
        })
        
        viewModel?.bucketContent.bindAndFire({ content in
            self.detailTextView.text = content
            self.detailLengthLabel.text = "\(content.count)/1500"
        })
        
        viewModel?.bucketStatus.bindAndFire({ status in
            DebugLog("BucketStatus Changed : \(status)")
            self.statusTitleLabel.text = status.getTitle()
        })
        
        viewModel?.finishDate.bindAndFire({ date in
            self.setDateStringToButton(self.datePicker.date)
        })
        
        viewModel?.bucketCategory.bindAndFire({ category in
            DebugLog("Selected Category : \(category.getTitle())")
            self.categoryTitleLabel.text = category.getTitle()
        })
        
        viewModel?.imageList.bindAndFire({ _ in
            self.imageCollectionView?.reloadData()
        })
        
        viewModel?.imageURLStringList.bindAndFire({ urlList in
            DebugLog("Image URL List : \(urlList.debugDescription)")
            self.imageCollectionView?.reloadData()
        })
        
        viewModel?.tagList.bindAndFire({ _ in
            self.tagCollectionView?.reloadData()
        })
        
        viewModel?.isPostSuccess.bind({ isPostSuccess in
            if isPostSuccess {
                DebugLog("Edit Post SUCCESS")
                self.navigationController?.popViewController(animated: true)
            } else {
                ErrorLog("Edit Post ERROR")
                self.showPostErrorAlert()
            }
        })
    }
    
    private func setupViewProperties() {
        view.backgroundColor = .heroGrayF2EDE8
        backButton.setImage(UIImage(heroSharedNamed: "ic_back"), for: .normal)
        backButton.addTarget(self, action: #selector(onClickBackButton(_:)), for: .touchUpInside)
        
        doneButton.layer.cornerRadius = 8
        doneButton.backgroundColor = .heroGray5B
        doneButton.titleLabel?.font = .font15P
        doneButton.setTitleColor(.heroWhite100s, for: .normal)
        doneButton.setTitle("수정", for: .normal)
        doneButton.addTarget(self, action: #selector(onClickDoneButton(_:)), for: .touchUpInside)
        
        statusTitleLabel.text = "Hero_Common_Status".localized
        statusTitleLabel.font = .font15P
        statusTitleLabel.textColor = .heroGray82
        statusButton.addTarget(self, action: #selector(onClickStatusFilterButton(_:)), for: .touchUpInside)
        statusImageView.image = UIImage(heroSharedNamed: "ic_narrow_12")
        
        categoryTitleLabel.text = "Hero_Common_Category".localized
        categoryTitleLabel.font = .font15P
        categoryTitleLabel.textColor = .heroGray82
        categoryButton.addTarget(self, action: #selector(onClickCategoryFilterButton(_:)), for: .touchUpInside)
        categoryImageView.image = UIImage(heroSharedNamed: "ic_narrow_12")
        
        titleField.font = .font20PMedium
        titleField.textColor = .heroGray5B
        titleField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        titleField.attributedPlaceholder = NSAttributedString(string: "Hero_Add_Title_Placeholder".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.heroGrayA6A4A1])
        divisionBar.backgroundColor = .heroGrayE7E1DC
        
        finishDateTitleLabel.text = "Hero_Add_FinishDate_Title".localized
        finishDateTitleLabel.font = .font15P
        finishDateTitleLabel.textColor = .heroGray82
        
        finishDateSelectButton.setTitle("Hero_Add_FinishDate_Description".localized, for: .normal)
        finishDateSelectButton.setTitleColor(.heroGrayA6A4A1, for: .normal)
        finishDateSelectButton.titleLabel?.font = .font15P
        finishDateSelectButton.addTarget(self, action: #selector(onClickFinishDateButton(_:)), for: .touchUpInside)
        
        detailTitleLabel.text = "상세 내용"
        detailTitleLabel.font = .font15P
        detailTitleLabel.textColor = .heroGray82
        
        detailBackgroundView.backgroundColor = .heroWhite100s
        detailBackgroundView.layer.cornerRadius = 7
        
        detailTextView.delegate = self
        detailTextView.font = .font13P
        detailTextView.textColor = .heroGray5B
        detailTextView.text = ""
        
        detailLengthLabel.font = .font13P
        detailLengthLabel.textColor = .heroGrayA6A4A1
        detailLengthLabel.text = "0/1500"
    }
    
    @objc
    private func onClickBackButton(_ sender: Any?) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func onClickDoneButton(_ sender: Any?) {
        DebugLog("Done Button Clicked")
        viewModel?.uploadImageList()
    }
    
    @objc
    private func onClickStatusFilterButton(_ sender: Any?) {
        let selectVC = HeroSelectViewController()
        
        selectVC.titleContent = "상태 선택"
        selectVC.modalPresentationStyle = .overCurrentContext
        selectVC.itemList = viewModel?.statusItemList ?? [HeroSelectItem]()
        selectVC.delegate = self
        selectViewType = BucketStatus.self
        self.present(selectVC, animated: false, completion: nil)
    }
    
    @objc
    private func onClickCategoryFilterButton(_ sender: Any?) {
        let selectVC = HeroSelectViewController()
        
        selectVC.titleContent = "카테고리 선택"
        selectVC.modalPresentationStyle = .overCurrentContext
        selectVC.itemList = viewModel?.categoryItemList ?? [HeroSelectItem]()
        selectVC.delegate = self
        selectViewType = BucketCategory.self
        self.present(selectVC, animated: false, completion: nil)
    }
    
    @objc
    private func onClickFinishDateButton(_ sender: Any?) {
        DebugLog("FinishDateButton Clicked")
        present(dateChooserAlert, animated: true, completion: nil)
    }
}

extension EditBucketViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        //        self.profileImageView.image = selectedImage
        viewModel?.imageList.value.append(selectedImage)
        //        let _ = selectedImage.jpegData(compressionQuality: 0.5)
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditBucketViewController {
    @objc
    func textFieldDidChange() {
        DebugLog("BucketTitle : \(titleField.text ?? "")")
        viewModel?.bucketTitle.value = titleField.text ?? ""
    }
}

extension EditBucketViewController: UICollectionViewDataSource, UICollectionViewDelegate, CreateImageCellDelegate {
    public func didSelectDeleteButton(index: Int) {
        if viewModel?.imageURLStringList.value.count ?? 0 > index {
            viewModel?.imageURLStringList.value.remove(at: index)
        } else {
            viewModel?.imageList.value.remove(at: index - (viewModel?.imageURLStringList.value.count ?? 0))
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == imageCollectionView {
            // IMAGE Collection View
            if indexPath.row == 0 {
                if viewModel?.imageList.value.count ?? 0 < 4 {
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "", message: "사진은 4개까지 선택 가능합니다.", preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
                    
                    alertController.addAction(okButton)
                    self.present(alertController, animated: true, completion: nil)
                }
            } else {
                viewModel?.imageList.value.remove(at: indexPath.row - 1)
            }
        } else {
            // TAG Collection View
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageCollectionView {
            // IMAGE Collection View
            return (viewModel?.imageURLStringList.value.count ?? 0) + (viewModel?.imageList.value.count ?? 0) + 1
        } else {
            // TAG Collection View
            return viewModel?.tagList.value.count ?? 0 + 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCollectionView {
            // IMAGE Collection View
            if indexPath.row == 0 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateAddCell.identifier, for: indexPath) as? CreateAddCell {
                    return cell
                }
            } else {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateImageCell.identifier, for: indexPath) as? CreateImageCell {
                    if viewModel?.imageURLStringList.value.count ?? 0 > indexPath.row - 1 {
                        cell.itemImageURL = viewModel?.imageURLStringList.value[indexPath.row - 1]
                    } else {
                        cell.itemImage = viewModel?.imageList.value[indexPath.row - 1]
                    }
                    
                    cell.index = indexPath.row - 1
                    cell.delegate = self
                    
                    return cell
                }
            }
        } else {
            // TAG Collection View
            DebugLog("tagCollectionView!.contentSize.height : \(tagCollectionView!.contentSize.height)")
            tagCollectionView!.snp.updateConstraints { make in
                make.height.equalTo(tagCollectionView!.contentSize.height)
            }
            
            if indexPath.row == 0 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateTagAddCell.identifier, for: indexPath) as? CreateTagAddCell {
                    cell.delegate = self
                    return cell
                }
            } else {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateTagCell.identifier, for: indexPath) as? CreateTagCell {
                    cell.itemTitle = viewModel?.tagList.value[indexPath.row - 1]
                    cell.itemIndex = indexPath.row - 1
                    cell.delegate = self
                    return cell
                }
            }
        }
        return UICollectionViewCell()
    }
}

extension EditBucketViewController: HeroSelectViewDelegate {
    public func selectViewCloseClicked(viewController: HeroSelectViewController) {
        viewController.dismiss(animated: false, completion: nil)
    }
    
    public func selectViewItemSelected(viewController: HeroSelectViewController, selected index: Int) {
        if selectViewType == BucketStatus.self {
            viewModel?.bucketStatus.value = BucketStatus(rawValue: index) ?? .pre
        } else if selectViewType == BucketCategory.self {
            viewModel?.bucketCategory.value = BucketCategory(rawValue: index) ?? .travel
        }
        viewController.dismiss(animated: false, completion: nil)
    }
}

extension EditBucketViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .heroGrayDA {
//            textView.text = nil
            viewModel?.bucketContent.value = ""
            textView.textColor = .heroGray5B
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if (viewModel?.bucketContent.value ?? "").isEmpty {
            textView.text = "메모할 내용을 기입해보세요.\n혹은 버킷리스트와 관련해서 상세 내용을 입력해봅시다!"
            textView.textColor = .heroGrayDA
        } else {
            viewModel?.bucketContent.value = textView.text
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if textView.textColor == .heroGrayDA {
            detailLengthLabel.text = "0/1500"
        } else {
            detailLengthLabel.text = "\(textView.text.count)/1500"
        }
    }
}

extension EditBucketViewController: TagAddCellDelegate, TagCellDelegate {
    func onClickDeleteButton(index: Int) {
        viewModel?.tagList.value.remove(at: index)
    }
    
    func onClickAddButton() {
        if viewModel?.tagList.value.count ?? 0 > 4 {
            showErrorAlert()
        } else {
            showAddTagAlert()
        }
    }
    
    private func showAddTagAlert() {
        let alert = UIAlertController(title: "태그 입력", message: "태그를 입력해주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let newTag = alert.textFields?.first?.text {
                self.viewModel?.tagList.value.append(newTag)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            DebugLog("Cancelled.")
        }
        
        alert.addTextField()
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "태그 개수 초과", message: "태그는 5개까지 추가가능합니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            // Nothing
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showPostErrorAlert() {
        let alert = UIAlertController(title: "오류", message: "버킷 수정 중 오류가 발생하였습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            // Nothing
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
