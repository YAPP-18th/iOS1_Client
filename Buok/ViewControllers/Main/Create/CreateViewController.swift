//
//  CreateViewController.swift
//  Buok
//
//  Created by Taein Kim on 2021/03/18.
//

import Foundation
import HeroCommon
import HeroSharedAssets
import HeroUI

final class CreateViewController: HeroBaseViewController, UINavigationControllerDelegate {
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
    
    private let dateChooserAlert = UIAlertController(title: "날짜 선택", message: nil, preferredStyle: .actionSheet)
    private let datePicker: UIDatePicker = UIDatePicker()
    private let imagePicker = UIImagePickerController()
    
    private let viewModel: CreateViewModel = CreateViewModel()
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
            make.height.greaterThanOrEqualTo(200)
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
            self.viewModel.finishDate.value = self.datePicker.date
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
        viewModel.finishDate.value = datePicker.date
    }
    
    private func bindViewModel() {
        viewModel.bucketTitle.bind({ title in
            DebugLog("Bucket Title : \(title)")
        })
        
        viewModel.bucketStatus.bind({ status in
            DebugLog("BucketStatus Changed : \(status)")
            self.statusTitleLabel.text = status.getTitle()
        })
        
        viewModel.finishDate.bind({ date in
            self.setDateStringToButton(self.datePicker.date)
        })
        
        viewModel.bucketCategory.bind({ category in
            DebugLog("Selected Category : \(category.getTitle())")
            self.categoryTitleLabel.text = category.getTitle()
        })
        
        viewModel.imageList.bind({ _ in
            self.imageCollectionView?.reloadData()
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
        doneButton.setTitle("Hero_Add_Item_Submit".localized, for: .normal)
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
        detailTextView.textColor = .heroGrayDA
        detailTextView.text = "메모할 내용을 기입해보세요.\n혹은 버킷리스트와 관련해서 상세 내용을 입력해봅시다!"
        
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
    }
    
    @objc
    private func onClickStatusFilterButton(_ sender: Any?) {
        let selectVC = HeroSelectViewController()
        
        selectVC.titleContent = "상태 선택"
        selectVC.modalPresentationStyle = .overCurrentContext
        selectVC.itemList = viewModel.statusItemList
        selectVC.delegate = self
        selectViewType = BucketStatus.self
        self.present(selectVC, animated: false, completion: nil)
    }
    
    @objc
    private func onClickCategoryFilterButton(_ sender: Any?) {
        let selectVC = HeroSelectViewController()
        
        selectVC.titleContent = "카테고리 선택"
        selectVC.modalPresentationStyle = .overCurrentContext
        selectVC.itemList = viewModel.categoryItemList
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

extension CreateViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
//        self.profileImageView.image = selectedImage
        viewModel.imageList.value.append(selectedImage)
//        let _ = selectedImage.jpegData(compressionQuality: 0.5)
        self.dismiss(animated: true, completion: nil)
    }
}

extension CreateViewController: UICollectionViewDataSource, UICollectionViewDelegate, CreateImageCellDelegate {
    public func didSelectDeleteButton(index: Int) {
        viewModel.imageList.value.remove(at: index)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if viewModel.imageList.value.count < 4 {
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "", message: "사진은 4개까지 선택 가능합니다.", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
                
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            viewModel.imageList.value.remove(at: indexPath.row - 1)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageList.value.count + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateAddCell.identifier, for: indexPath) as? CreateAddCell {
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateImageCell.identifier, for: indexPath) as? CreateImageCell {
                cell.itemImage = viewModel.imageList.value[indexPath.row - 1]
                cell.index = indexPath.row - 1
                cell.delegate = self
                
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

extension CreateViewController: HeroSelectViewDelegate {
    public func selectViewCloseClicked(viewController: HeroSelectViewController) {
        viewController.dismiss(animated: false, completion: nil)
    }
    
    public func selectViewItemSelected(viewController: HeroSelectViewController, selected index: Int) {
        if selectViewType == BucketStatus.self {
            viewModel.bucketStatus.value = BucketStatus(rawValue: index) ?? .pre
        } else if selectViewType == BucketCategory.self {
            viewModel.bucketCategory.value = BucketCategory(rawValue: index) ?? .travel
        }
        viewController.dismiss(animated: false, completion: nil)
    }
}

extension CreateViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .heroGrayDA {
            textView.text = nil
            textView.textColor = .heroGray5B
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메모할 내용을 기입해보세요.\n혹은 버킷리스트와 관련해서 상세 내용을 입력해봅시다!"
            textView.textColor = .heroGrayDA
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
