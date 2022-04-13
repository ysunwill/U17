//
//  FindViewController.swift
//  U17
//
//  Created by ysunwill on 2022/2/28.
//

import UIKit
import Moya
import MBProgressHUD

class FindViewController: UBaseViewController {
    
    // MARK: - Properties
    
    private lazy var topView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: UDeviceUtil.screenWidth, height: UDeviceUtil.navBarHeight))
        v.backgroundColor = .white.withAlphaComponent(0)
        return v
    }()
    
    private lazy var bg: UIImageView = {
        let iv =  UIImageView(frame: topView.bounds)
        iv.image = R.image.bg_find_comic_nav()
        return iv
    }()
    
    private lazy var categoryView: JXCategoryTitleView = {
        let cate = JXCategoryTitleView(frame: CGRect(x: 0, y: UDeviceUtil.statusBarHeight, width: UDeviceUtil.screenWidth, height: 44))
        cate.delegate = self
        cate.backgroundColor = .white.withAlphaComponent(0.0)
        cate.isTitleLabelZoomEnabled = true;
        cate.titleLabelZoomScale = 1.5;
        cate.isTitleLabelStrokeWidthEnabled = true;
        cate.titleLabelAnchorPointStyle = .bottom
        cate.isSelectedAnimationEnabled = true;
        cate.isCellWidthZoomEnabled = true;
        cate.cellWidthZoomScale = 1.5;
        cate.selectedAnimationDuration = 0.15
        cate.titleColor = .white
        cate.titleSelectedColor = .white
        cate.titleFont = .systemFont(ofSize: 16.zoom())
        cate.titleLabelSelectedStrokeWidth = -4
        cate.cellSpacing = 30
        cate.contentEdgeInsetLeft = 15
        cate.contentEdgeInsetRight = 15
//        cate.titleSelectedFont = UIFont.systemFont(ofSize: 17, weight: .semibold) // 不用设置
        cate.isContentScrollViewClickTransitionAnimationEnabled = false
        return cate
    }()
    
    private lazy var containerView: JXCategoryListContainerView = {
        let container = JXCategoryListContainerView(type: .scrollView, delegate: self)!
        container.frame = CGRect(x: 0, y: 0, width: UDeviceUtil.screenWidth, height: UDeviceUtil.screenHeight  - UDeviceUtil.tabBarHeight)
        return container
    }()
    
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func setupViews() {
        view.addSubview(containerView)
        view.addSubview(topView)
        topView.addSubview(bg)
        
        categoryView.listContainer = containerView
        topView.addSubview(categoryView)
    }
    
    override func loadData() {
        ApiProvider.request(Api.findCategory, model: [FindCategoryItem].self) { [weak self] (returnData) in
            guard let entity = returnData else {
                return
            }
            
            self?.categoryView.titles = entity.map{ $0.title! }
            self?.categoryView.defaultSelectedIndex = 1
            self?.categoryView.reloadData()
        }
    }
}

extension FindViewController: JXCategoryViewDelegate, JXCategoryListContainerViewDelegate, FindComicViewControllerDelegate {
    
    // MARK: - JXCategoryViewDelegate
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
       
    }
    
    // MARK: - JXCategoryListContainerViewDelegate
    
    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        categoryView.titles == nil ? 0 : categoryView.titles.count
    }
    
    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        index == 1 ? FindComicViewController(delegate: self) : TestViewController()
    }
    
    // MARK: - FindComicViewControllerDelegate
    
    func comicDidScroll(to offsetY: CGFloat) {
        if offsetY <= 0 { // y <= 0，恢复默认状态
            topView.backgroundColor = .white.withAlphaComponent(0)
            bg.isHidden = false
            categoryView.titleColor = .white
            categoryView.titleSelectedColor = .white
        } else if offsetY >= UDeviceUtil.navBarHeight + 100 {
            topView.backgroundColor = .white.withAlphaComponent(1)
            bg.isHidden = true
            categoryView.titleColor = UIColor(r: 153, g: 153, b: 153)
            categoryView.titleSelectedColor = UIColor(r: 53, g: 53, b: 53)
        } else {
            let alpha = (offsetY / (UDeviceUtil.navBarHeight + 100)).rounded(2)
    
            topView.backgroundColor = .white.withAlphaComponent(alpha)
            categoryView.titleColor = .white
            categoryView.titleSelectedColor = .white
        }
        
        categoryView.reloadDataWithoutListContainer()
    }
    
    
}
