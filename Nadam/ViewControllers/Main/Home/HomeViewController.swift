//
//  HomeViewController.swift
//  Nadam
//
//  Created by Taein Kim on 2021/03/18.
//

import Foundation
import HeroCommon
import HeroSharedAssets
import HeroUI

public class HomeViewController: HeroBaseViewController {
    private let topContentView: UIView = UIView()
    private let notiButton: HeroImageButton = HeroImageButton()
    private let searchButton: HeroImageButton = HeroImageButton()
    private var viewModel: HomeViewModel?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupMainLayout()
        setupViewProperties()
    }
    
    private func setupMainLayout() {
        view.addSubview(topContentView)
        topContentView.addSubview(notiButton)
        topContentView.addSubview(searchButton)

        topContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(44)
        }

        notiButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }

        searchButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
    }
    
    private func setupViewProperties() {
        view.backgroundColor = .heroGraySample100s
        notiButton.imageInset = 8
        searchButton.imageInset = 8
        notiButton.heroImage = UIImage(heroSharedNamed: "tab_home.png")
        searchButton.heroImage = UIImage(heroSharedNamed: "tab_home.png")
    }
    
    @objc
    private func onClickNotification(_ sender: Any?) {
        navigationController?.pushViewController(MultiLevelViewController(), animated: true)
    }
    
    @objc
    private func onClickSearch(_ sender: Any?) {
        navigationController?.pushViewController(MultiLevelViewController(), animated: true)
    }
}
