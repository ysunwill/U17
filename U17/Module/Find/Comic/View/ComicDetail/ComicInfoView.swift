//
//  ComicInfoView.swift
//  U17
//
//  Created by ysunwill on 2022/4/2.
//

import UIKit
import simd
import PinLayout
import SwiftUI
import AVFoundation

class ComicInfoView: UIView {
    
    // MARK: - Properties
    
    private var header = ComicInfoTableHeaderView()
    private var footer = ComicInfoTableFooterView()
    private var commentEntity: ComicInfoComment?
    private var communityEntity: ComicInfoCommunityEntity?
    typealias ShowTitle = (_ show: Bool) -> Void
    var showTitleClosure: ShowTitle?
    var comicTitle: String?
    
    private lazy var roundView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.estimatedRowHeight = 50
        tv.sectionFooterHeight = 0.0
        tv.register(cellType: ComicInfoCommentCell.self)
        tv.register(cellType: ComicInfoNoCommentCell.self)
        tv.register(headerFooterViewType: ComicInfoTableSectionHeaderView.self)
        tv.register(cellType: ComicInfoForumCell.self)
        tv.register(cellType: ComicInfoForumAddPostCell.self)
        tv.showsVerticalScrollIndicator = false
        let offset = ceil(UDeviceUtil.screenWidth * 0.73) - UDeviceUtil.navBarHeight
        tv.contentInset = UIEdgeInsets(top: offset, left: 0, bottom: 0, right: 0)
        tv.contentOffset = CGPoint(x: 0, y: -offset)
        tv.backgroundColor = .clear
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .none
        return tv
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        roundView.pin.all()
        roundView.flex.layout()
        
        makeRoundCorner()
    }
    
    // MARK: - Private Functions
    
    private func setupSubviews() {
        header.foldDescriptionClosure = { [weak self] in
            self?.resizeHeaderFrame()
        }
        
        roundView.flex.define { flex in
            flex.addItem(tableView).grow(1)
        }
        
        addSubview(roundView)
    }
    
    private func makeRoundCorner() {
        // roundView
        let shapLayer = CAShapeLayer()
        let cornersRadius = CCornersRadius(topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 0)
        shapLayer.path = roundView.createPath(bounds: roundView.bounds, cornersRadius: cornersRadius)
        roundView.layer.mask = shapLayer
    }
    
    private func resizeHeaderFrame() {
        let size = header.sizeThatFits(CGSize(width: UDeviceUtil.screenWidth, height: .greatestFiniteMagnitude))
        header.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        tableView.tableHeaderView = header
    }
    
    private func resizeFooterFrame() {
        let size = footer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        footer.frame = CGRect(x: 0, y: 0, width: UDeviceUtil.screenWidth, height: size.height)
        tableView.tableFooterView = footer
    }
    
    // MARK: - Interface
    
    func configureViews(_ entity: ComicInfoEntity?) {
        guard let entity = entity else {
            return
        }
        
        // header
        header.configureViews(entity)
        resizeHeaderFrame()
        
        // footer
        footer.configureViews(entity)
        resizeFooterFrame()
        
        // table view
        commentEntity = entity.comment
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
    }
    
    func configureChapter(cover: String?, ticket: ChapterTicket?) {
        // 章节cover
        header.cover = cover
        
        // ticket
        header.ticket = ticket
    }
    
    func configureCommunity(_ entity: ComicInfoCommunityEntity?) {
        guard let entity = entity else {
            return
        }

        communityEntity = entity
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
    
}

extension ComicInfoView: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let commentArray = commentEntity?.commentList, !commentArray.isEmpty {
                return commentArray.count
            } else {
                return 1
            }
        } else {
            if let communityArray = communityEntity?.communityList, !communityArray.isEmpty {
                return communityArray.count + 1 > 3 ? 3 : communityArray.count + 1
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let commentArray = commentEntity?.commentList, !commentArray.isEmpty {
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicInfoCommentCell.self)
                cell.selectionStyle = .none
                cell.entity = commentArray[indexPath.row]
                cell.foldCommentClosure = {
                    UIView.performWithoutAnimation {
                        tableView.beginUpdates()
                        tableView.endUpdates()
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicInfoNoCommentCell.self)
                cell.selectionStyle = .none
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicInfoForumAddPostCell.self)
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicInfoForumCell.self)
                cell.selectionStyle = .none
                cell.entity = communityEntity?.communityList?[indexPath.row - 1]
                return cell
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(ComicInfoTableSectionHeaderView.self)!
        if section == 0 {
            view.titleLabel.text = "评论"
            view.countLabel.text = "(共\(commentEntity?.commentCount ?? 0)条评论)"
            view.countLabel.snp.remakeConstraints { make in
                make.left.equalTo(view.titleLabel.snp.right)
                make.lastBaseline.equalTo(view.titleLabel.snp.lastBaseline)
            }
        } else {
            view.titleLabel.text = "#\(comicTitle ?? "")"
            view.countLabel.text = "共\(communityEntity?.communityTotal ?? 0)条"
            view.countLabel.snp.remakeConstraints { make in
                make.right.equalTo(view.moreIcon.snp.left).offset(-10)
                make.centerY.equalTo(view.moreIcon)
            }
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        55
    }
    
    // MARK: - UITableViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let showTitleClosure = showTitleClosure else {
            return
        }
        
        if scrollView.contentOffset.y > 0 {
            showTitleClosure(true)
        } else {
            showTitleClosure(false)
        }
    }
}
