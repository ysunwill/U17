//
//  ComicInfoTableHeaderView.swift
//  U17
//
//  Created by ysunwill on 2022/4/7.
//

import UIKit

class ComicInfoTableHeaderView: UIView {
    
    // MARK: - Properties
    
    let space: CGFloat = 12
    var descriptionLabelHeight: CGFloat?
    let rootFlexContainer = UIView()
    var foldDescriptionClosure: (() -> Void)?
    
    private lazy var roundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 102, g: 102, b: 102)
        label.font = .zoomSystemFont(13)
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var moreDescriptionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(R.image.icon_description_more(), for: .normal)
        button.addTarget(self, action: #selector(moreDescriptionAction(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    // 连载中
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 53, g: 53, b: 53)
        label.font = .zoomSystemSemiboldFont(18)
        return label
    }()
    
    // 共XX话
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 153, g: 153, b: 153)
        label.font = .zoomSystemFont(13)
        return label
    }()
    
    // 全部目录
    private lazy var catalogLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 153, g: 153, b: 153)
        label.font = .zoomSystemFont(13)
        return label
    }()
    
    // 最新一话封面
    private lazy var chapterCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 9
        imageView.layer.masksToBounds = true
        imageView.image = R.image.normal_placeholder_h()
        return imageView
    }()
    
    // 最新一话标题
    private lazy var chapterTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 68, g: 68, b: 68)
        label.font = .zoomSystemSemiboldFont(13)
        return label
    }()
    
    // 第XX话
    private lazy var currentCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 153, g: 153, b: 153)
        label.font = .zoomSystemFont(10)
        return label
    }()
    
    // 绿色背景
    private lazy var greenView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 29, g: 221, b: 143, a: 0.04)
        view.layer.cornerRadius = 6
        return view
    }()
    
    // 本月月票
    private lazy var monthTicketLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 53, g: 53, b: 53)
        label.font = .zoomSystemFont(14.5)
        let text = "本月月票--"
        let attString = NSMutableAttributedString(string: text)
        attString.setAttributes([NSAttributedString.Key.font : UIFont.zoomSystemBoldFont(18)], range: NSRange(location: 4, length: 2))
        label.attributedText = attString
        return label
    }()
    
    // 打赏排行榜容器
    private lazy var rewardContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    // 成为打赏第一人
    private lazy var firstRewardLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .zoomSystemFont(14.5)
        label.text = "成为打赏第一人"
        return label
    }()
    
    // 打赏
    private lazy var rewardIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.icon_comic_reward()
        return imageView
    }()
    
    var cover: String? {
        didSet {
            guard let cover = cover else {
                return
            }
            
            chapterCoverImageView.kf.setImage(urlString: cover, placeholder: R.image.normal_placeholder_h())
        }
    }
    
    var ticket: ChapterTicket? {
        didSet {
            guard let ticket = ticket else {
                return
            }
            
            // reward
            if let rankArray = ticket.ticketRank {
                if rankArray.isEmpty { return }
                
                firstRewardLabel.removeFromSuperview()
                rewardContainer.flex.define { flex in
                    for r in rankArray {
                        let avatar = UIImageView()
                        avatar.layer.cornerRadius = 13
                        avatar.layer.masksToBounds = true
                        avatar.contentMode = .scaleAspectFill
                        avatar.kf.setImage(urlString: r.face)
                        flex.addItem(avatar).width(26).height(26).marginRight(3)
                    }
                }
                rewardContainer.flex.markDirty()
            }
            
            // month ticket
            let rank = ticket.comicTicket?.rank ?? ""
            let string = "本月月票\(rank)"
            let attString = NSMutableAttributedString(string: string)
            attString.setAttributes([NSAttributedString.Key.font : UIFont.zoomSystemBoldFont(18)], range: NSRange(location: 4, length: rank.count))
            monthTicketLabel.attributedText = attString
            monthTicketLabel.flex.markDirty()
            
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        rootFlexContainer.flex.define { flex in
            flex.addItem(roundView).height(12)
            
            flex.addItem().backgroundColor(.white).define { flex in
                flex.addItem(descriptionLabel).marginHorizontal(space).justifyContent(.end).alignItems(.end).define { flex in
                    flex.addItem(moreDescriptionButton).size(CGSize(width: 38, height: 18))
                }

                flex.addItem().padding(16.5, space, 16.5, space).direction(.row).define { flex in
                    flex.addItem(statusLabel)
                    flex.addItem(countLabel)
                    flex.addItem().shrink(1).grow(1)
                    flex.addItem(catalogLabel)
                }

                flex.addItem().direction(.row).paddingHorizontal(space).define { flex in
                    flex.addItem(chapterCoverImageView).width(32%).aspectRatio(1.7)

                    flex.addItem().direction(.column).justifyContent(.center).paddingHorizontal(space).define { flex in
                        flex.addItem().define { flex in
                            flex.addItem().direction(.row).define { flex in
                                flex.addItem(chapterTitleLabel)
                            }
                        }

                        flex.addItem(currentCountLabel).marginTop(12)
                    }
                }

                flex.addItem(greenView).direction(.row).margin(24, space, 0, space).padding(16, space, 16, space).define { flex in
                    flex.addItem(monthTicketLabel).grow(1)
                    flex.addItem(rewardContainer).direction(.row).marginRight(5).height(26).alignSelf(.center).define { flex in
                        flex.addItem(firstRewardLabel)
                    }
                    flex.addItem(rewardIcon).size(CGSize(width: 60, height: 26))
                }
            }
        }
        
        addSubview(rootFlexContainer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews(_ entity: ComicInfoEntity) {
        guard let summary = entity.comic else {
            return
        }
        
        // description
        descriptionLabel.text = summary.description
        if descriptionLabelHeight == nil {
            let desSize = descriptionLabel.sizeThatFits(CGSize(width: UDeviceUtil.screenWidth - 2 * space, height: CGFloat(MAXFLOAT)))
            descriptionLabelHeight = desSize.height
        }
        let height = ceil(descriptionLabel.font.lineHeight * 3)
        if descriptionLabelHeight! > height {
            descriptionLabel.flex.height(height).markDirty()
            moreDescriptionButton.isHidden = false
        } else {
            descriptionLabel.flex.height(50).markDirty()
            moreDescriptionButton.isHidden = true
        }
        
        // chapter
        let chapter = entity.chapter_list[0]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = Date(timeIntervalSince1970: chapter.publish_time)
        let time = formatter.string(from: date)
        statusLabel.text = summary.series_status ? "连载中" : "已完结"
        countLabel.text = "(共\(chapter.chapterIndex + 1)话)"
        catalogLabel.text = "全部目录"
        chapterTitleLabel.text = chapter.name
        currentCountLabel.text = "第\(chapter.chapterIndex + 1)话 \(time)"
        
        
        statusLabel.flex.markDirty()
        countLabel.flex.markDirty()
        catalogLabel.flex.markDirty()
        chapterTitleLabel.flex.markDirty()
        currentCountLabel.flex.markDirty()

        setNeedsLayout()
    }
    
    @objc
    private func moreDescriptionAction(_ sender: UIButton) {
        sender.isHidden = true
        
        descriptionLabel.flex.height(descriptionLabelHeight).markDirty()
        setNeedsLayout()

        guard let foldDescriptionClosure = foldDescriptionClosure else {
            return
        }
        foldDescriptionClosure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
        makeRoundCorner()
    }
    
    func layout() {
        rootFlexContainer.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        rootFlexContainer.pin.width(size.width)
        layout()

        return rootFlexContainer.frame.size
    }
    
    private func makeRoundCorner() {
        // roundView
        let shapLayer = CAShapeLayer()
        let cornersRadius = CCornersRadius(topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 0)
        shapLayer.path = roundView.createPath(bounds: roundView.bounds, cornersRadius: cornersRadius)
        roundView.layer.mask = shapLayer
    }
}
