//
//  FindComicViewController.swift
//  U17
//
//  Created by ysunwill on 2022/3/4.
//
// 发现 --> 漫画

import UIKit

protocol FindComicViewControllerDelegate: AnyObject {
    func comicDidScroll(to offsetY: CGFloat)
}

class FindComicViewController: UBaseViewController {
    
    // MARK: - Properties
    
    weak var delegate: FindComicViewControllerDelegate?
    private var times: Int = 0
    private var entity: FindComicEntity = FindComicEntity()
    
    // top bar
    private lazy var topBar: FindComicTopBar = {
        let bar = FindComicTopBar(frame: CGRect(x: 0, y: UDeviceUtil.navBarHeight, width: UDeviceUtil.screenWidth, height: 58.zoom()))
        return bar
    }()
    
    // collection view
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5.5
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.register(cellType: FindComicCell.self)
        cv.register(cellType: FindComicOtherCell.self)
        cv.register(supplementaryViewType: FindComicSectionHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        cv.register(supplementaryViewType: FindComicBannerView.self, ofKind: UICollectionView.elementKindSectionHeader)
        // 刷新控件
        cv.uHead = RefreshHeader { [weak self] in self?.loadData() }
        cv.uFoot = RefreshDiscoverFooter()
        cv.uempty = UEmptyView(verticalOffset: -(cv.contentInset.top)) { self.loadData() }
        return cv
    }()
    
    
    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupViews() {
        // collection view
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        // top bar
        view.addSubview(topBar)
    }
    
    override func loadData() {
        ApiProvider.request(Api.findComic, model: FindComicEntity.self) { [weak self] (returnData) in
            guard let entity = returnData else {
                return
            }
            
            self?.collectionView.uHead.endRefreshing()
            self?.collectionView.uempty?.allowShow = true
            
            self?.entity = entity
            self?.topBar.hotSearch = entity.defaultSearch
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: - Init
    
    convenience init(delegate: FindComicViewControllerDelegate?) {
        self.init()
        
        self.delegate = delegate
    }
}

extension FindComicViewController: JXCategoryListContentViewDelegate, UIScrollViewDelegate {
    
    // MARK: - JXCategoryListContentViewDelegate
    
    func listView() -> UIView! {
        view
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 划动回调频繁，简单处理下
        times += 1
        if times % 2 != 0 {
            return
        }
        if times > 100 {
            times = 0
        }
        
        // 随划动改变透明度
        topBar.changeAlpha(by: scrollView.contentOffset.y)
        delegate?.comicDidScroll(to: scrollView.contentOffset.y)
    }
}

extension FindComicViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 轮播图算一个单独的section，所以+1
        entity.modules.count > 0 ? entity.modules.count + 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return entity.modules[section - 1].items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return UICollectionViewCell()
        }
        
        let model = entity.modules[indexPath.section - 1]
        if model.moduleType == 1 { // 普通
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FindComicCell.self)
            if model.uiType == 1 { // 两等分
                cell.type = .horizontal
            } else if model.uiType == 3 { // 三等分
                cell.type = .vertical
            } else if model.uiType == 4 { // 一大四小
                if indexPath.row == 0 {
                    cell.type = .largeHorizontal
                } else {
                    cell.type = .vertical
                }
            }
            cell.entity = model.items[indexPath.row].first
            return cell
        } else if model.moduleType == 2 { // 广告或者横向滑动
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FindComicOtherCell.self)
            if model.uiType == 1 { // 广告
                cell.type = .advertisement
            } else if model.uiType == 4 { // 横向滚动
                cell.type = .flow
                cell.tapCell = { [weak self] (comicId, comicTitle) in
                    let vc = ComicInfoViewController()
                    vc.comicId = comicId
                    vc.comicTitle = comicTitle
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            cell.modelArray = model.items[indexPath.row]
            return cell
        } else if model.moduleType == 4 { // 动画
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FindComicOtherCell.self)
            cell.type = .animation
            cell.modelArray = model.items[indexPath.row]
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: FindComicBannerView.self)
            headerView.modelArray = entity.galleryItems
            headerView.tapBanner = { [weak self] (comicId, comicTitle) in
                let vc = ComicInfoViewController()
                vc.comicId = comicId
                vc.comicTitle = comicTitle
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return headerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: FindComicSectionHeaderView.self)
            headerView.title = entity.modules[indexPath.section - 1].moduleInfo?.title ?? ""
            return headerView
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = entity.modules[indexPath.section - 1]
        let item = model.items[indexPath.row].first
        
        let vc = ComicInfoViewController()
        vc.comicId = item?.comicId
        vc.comicTitle = item?.title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            let model = entity.modules[section - 1]
            if (model.moduleType == 2 && model.uiType == 4) || (model.moduleType == 4 && model.uiType == 1) { // 横向滑动或者影视
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            } else if model.moduleType == 2 && model.uiType == 1 { // 广告
                return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            } else {
                return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: UDeviceUtil.screenWidth, height: ceil(UDeviceUtil.screenWidth * 0.96) + 20)
        } else {
            let model = entity.modules[section - 1]
            if model.moduleType == 2 && model.uiType == 1 { // 广告
                return .zero
            } else {
                return CGSize(width: UDeviceUtil.screenWidth, height: 58)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize = .zero
        if indexPath.section != 0 {
            let model = entity.modules[indexPath.section - 1]
            if model.moduleType == 1 { // 普通
                if model.uiType == 1 { // 两等分
                    let width = floor((UDeviceUtil.screenWidth - 12 - 5.5 - 12) / 2)
                    let height = ceil(width * 0.95)
                    size = CGSize(width: width, height: height)
                } else if model.uiType == 3 { // 三等分
                    let width = floor((UDeviceUtil.screenWidth - 12 - 5.5 - 5.5 - 12) / 3)
                    let height = ceil(width * 1.85)
                    size = CGSize(width: width, height: height)
                } else if model.uiType == 4 { // 一大四小
                    let width = floor((UDeviceUtil.screenWidth - 12 - 5.5 - 5.5 - 12) / 3)
                    let height = ceil(width * 1.85)
                    if indexPath.row == 0 {
                        size = CGSize(width: width * 2, height: height)
                    } else {
                        size = CGSize(width: width, height: height)
                    }
                }
            } else if model.moduleType == 2 { // 广告或者横向滑动
                if model.uiType == 1 { // 广告
                    let width = UDeviceUtil.screenWidth - 12 - 12
                    let height = ceil(width * 0.33)
                    size = CGSize(width: width, height: height)
                } else if model.uiType == 4 { // 横向滑动
                    let width = UDeviceUtil.screenWidth
                    let height = ceil(width * 0.63)
                    size = CGSize(width: width, height: height)
                }
            } else if model.moduleType == 4 { // 动画
                let width = UDeviceUtil.screenWidth
                let height = ceil(width * 0.6)
                size = CGSize(width: width, height: height)
            }
        }
        
        return size
    }
    
    
}
