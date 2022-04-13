//
//  ComicInfoViewController.swift
//  U17
//
//  Created by ysunwill on 2022/3/31.
//

import UIKit

class ComicInfoViewController: UBaseViewController {

    // MARK: - Properties
    
    var comicId: Int?
    var comicTitle: String?
    private var infoEntity: ComicInfoEntity?
    private var chapterEntity: ComicChapterEntity?
    private var communityEntity: ComicInfoCommunityEntity?
    
    private lazy var navBar: CustomNavigationBar = {
        let bar = CustomNavigationBar(frame: CGRect(x: 0, y: 0, width: UDeviceUtil.screenWidth, height: UDeviceUtil.navBarHeight))
        return bar
    }()
    
    private lazy var tabBar: CustomTabBar = {
        let bar = CustomTabBar(frame: CGRect(x: 0, y: UDeviceUtil.screenHeight - UDeviceUtil.tabBarHeight - 6, width: UDeviceUtil.screenWidth, height: UDeviceUtil.tabBarHeight + 6))
        return bar
    }()
    
    private lazy var header: ComicInfoHeaderView = {
        let header = ComicInfoHeaderView(frame: CGRect(x: 0, y: 0, width: UDeviceUtil.screenWidth, height: ceil(UDeviceUtil.screenWidth * 0.73)))
        return header
    }()
    
    
    private lazy var infoView: ComicInfoView = {
        let info = ComicInfoView(frame: CGRect(x: 0, y: UDeviceUtil.navBarHeight, width: UDeviceUtil.screenWidth, height: UDeviceUtil.screenHeight - UDeviceUtil.navBarHeight - tabBar.frame.height))
        return info
    }()

    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    
    override func setupViews() {
        // header
        view.addSubview(header)

        // nav
        view.addSubview(navBar)
        navBar.title = comicTitle
        navBar.popBack = {
            self.navigationController?.popViewController(animated: true)
        }
        
        // info
        view.addSubview(infoView)
        infoView.comicTitle = comicTitle
        infoView.showTitleClosure = { [weak self] show in
            self?.navBar.hideTitle = !show
        }
        
        // tab
        view.addSubview(tabBar)
    }
    
    override func loadData() {
        guard let comicId = comicId else {
            return
        }

        // 漫画介绍
        ApiProvider.request(Api.comicIntro(comicid: comicId), model: ComicInfoEntity.self) { [weak self] returnData in
            self?.infoEntity = returnData
            
            self?.header.configureViews(self?.infoEntity?.comic)
            self?.infoView.configureViews(self?.infoEntity)
        }
        
        // 所有章节
        ApiProvider.request(Api.comicChapterList(comicid: comicId), model: ComicChapterEntity.self) { [weak self] returnData in
            self?.chapterEntity = returnData
            
            let cover = self?.chapterEntity?.chapter_list?.last?.smallPlaceCover
            let ticket = self?.chapterEntity?.ticket
            self?.infoView.configureChapter(cover: cover, ticket: ticket)
        }
        
        // 漫画社区
        ApiProvider.request(Api.comicCommunity(comicid: comicId), model: ComicInfoCommunityEntity.self) { [weak self] returnData in
            self?.communityEntity = returnData
            
            self?.infoView.configureCommunity(self?.communityEntity)
        }

    }
    
    // MARK: - Private Functions
    

}
