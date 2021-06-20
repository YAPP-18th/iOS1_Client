//
//  CreateImageCell.swift
//  Buok
//
//  Copyright © 2021 Buok. All rights reserved.
//

import Foundation
import HeroCommon
import HeroSharedAssets
import HeroUI
import Kingfisher

public protocol CreateImageCellDelegate: AnyObject {
    func didSelectDeleteButton(index: Int)
}

public class CreateImageCell: UICollectionViewCell {
    static let identifier: String = "CreateImageCell"
    private let imageView: UIImageView = UIImageView()
    private let dimmedView: UIView = UIView()
    private let deleteIconView: UIImageView = UIImageView()
    private let deleteButton: UIButton = UIButton()
    
    public weak var delegate: CreateImageCellDelegate?
    public var index: Int = -1
    
    public var itemImage: UIImage? {
        didSet {
            imageView.image = itemImage
        }
    }
    
    public var itemImageURL: String? {
        didSet {
            if let url = URL(string: itemImageURL ?? "") {
                self.imageView.kf.setImage(with: url)
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellLayout() {
        contentView.addSubview(imageView)
        imageView.addSubview(dimmedView)
        dimmedView.addSubview(deleteIconView)
        dimmedView.addSubview(deleteButton)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
        
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        deleteIconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        dimmedView.layer.cornerRadius = 8
        dimmedView.backgroundColor = .heroGray333333700
        
        deleteIconView.image = UIImage(heroSharedNamed: "ic_x")?.withRenderingMode(.alwaysTemplate)
        deleteIconView.tintColor = .heroWhite100s
        deleteButton.addTarget(self, action: #selector(onClickDeleteButton(_:)), for: .touchUpInside)
    }
    
    @objc
    private func onClickDeleteButton(_ sender: UIButton) {
        delegate?.didSelectDeleteButton(index: index)
    }
}
