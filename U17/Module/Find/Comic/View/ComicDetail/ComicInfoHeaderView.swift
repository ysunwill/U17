//
//  ComicInfoHeaderView.swift
//  U17
//
//  Created by ysunwill on 2022/4/1.
//

import UIKit

class ComicInfoHeaderView: UIView {

    // MARK: - Properties
    
    private let rootFlexContainer = UIView()
    
    private lazy var bgImageView: UIImageView = {
        let bg = UIImageView()
        bg.contentMode = .scaleAspectFill
        return bg
    }()
    
    private lazy var bgMaskView: UIView = {
        let mask = UIView()
        mask.alpha = 0.8
        return mask
    }()
    
    private lazy var grayMaskView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.bg_comic_gray_mask()
        return imageView
    }()
    
    // 左上、右上圆角
    private lazy var roundView: UIView = {
        let round = UIView()
        round.backgroundColor = .white
        return round
    }()
    
    private lazy var coverImageView: UIImageView = {
        let cover = UIImageView()
        cover.contentMode = .scaleAspectFill
        cover.layer.cornerRadius = 10
        cover.layer.masksToBounds = true
        cover.layer.borderColor = UIColor.white.cgColor
        cover.layer.borderWidth = 3
        return cover
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .zoomSystemFont(13)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .zoomSystemFont(18)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var vipIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = R.image.icon_comic_title_vip()
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var tagContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var hotIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = R.image.icon_comic_hot()
        return imageView
    }()
    
    private lazy var collectIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = R.image.icon_comic_collect()
        return imageView
    }()
    
    private lazy var hotLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 153, g: 153, b: 153)
        label.font = .zoomSystemFont(14.5)
        return label
    }()
    
    private lazy var collectLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 153, g: 153, b: 153)
        label.font = .zoomSystemFont(14.5)
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()

        makeRoundCorner()
    }
    
    // MARK: - Private Functions
    
    private func setupSubviews() {
        rootFlexContainer.flex.define { flex in
            flex.addItem(bgImageView).width(100%).aspectRatio(1.7).padding(0).define { flex in
                flex.addItem(bgMaskView).grow(1).define { flex in
                    flex.addItem(grayMaskView).grow(1)
                }
            }

            flex.addItem(roundView).width(100%).aspectRatio(5.3).position(.absolute).bottom(0)
            
            flex.addItem().position(.absolute).width(100%).bottom(0).direction(.row).define { flex in
                
                flex.addItem(coverImageView).marginLeft(18).marginBottom(6).width(37%).aspectRatio(0.77)
                
                flex.addItem().direction(.columnReverse).padding(0, 12, 0, 12).grow(1).shrink(1).define { flex in
                    flex.addItem().direction(.row).marginBottom(15.zoom()).define { flex in
                        flex.addItem(collectIcon).width(14).aspectRatio(of: collectIcon).alignSelf(.center)
                        flex.addItem(collectLabel).marginLeft(5)
                    }
                    
                    flex.addItem().direction(.row).marginBottom(8.zoom()).define { flex in
                        flex.addItem(hotIcon).width(14).aspectRatio(of: hotIcon).alignSelf(.center)
                        flex.addItem(hotLabel).marginLeft(5)
                    }
                    
                    flex.addItem(tagContainer).direction(.row).marginBottom(20.zoom()).height(24)
                    
                    flex.addItem(authorLabel).marginBottom(9.zoom())
                    
                    flex.addItem(titleLabel).position(.absolute).top(6).left(12)
                }
            }
            
            
        }
        
        addSubview(rootFlexContainer)
    }
    
    private func makeRoundCorner() {
        // roundView
        let shapLayer = CAShapeLayer()
        let cornersRadius = CCornersRadius(topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 0)
        shapLayer.path = roundView.createPath(bounds: roundView.bounds, cornersRadius: cornersRadius)
        roundView.layer.mask = shapLayer
    }
    
    private func makeHeaderTag(_ title: String) -> UILabel {
        let label = UILabel()
        label.font = .zoomSystemFont(14.5)
        label.textColor = .white
        label.layer.cornerRadius = 12
        label.layer.borderWidth = 1
        label.text = title
        label.textAlignment = .center
        label.layer.borderColor = UIColor.white.cgColor
        return label
    }
    
    // MARK: - Interface
    
    func configureViews(_ entity: ComicSummary?) {
        guard let entity = entity else {
            return
        }
        
        // bg
        bgImageView.kf.setImage(urlString: entity.wideCover,
                                placeholder: R.image.normal_placeholder_h())
        if let color = entity.wideColor {
            bgMaskView.backgroundColor = .hex(hexString: color)
        }
        
        // title
        titleLabel.text = entity.name
        titleLabel.flex.markDirty()
        
        // author
        authorLabel.text = entity.author?.name ?? ""
        authorLabel.flex.markDirty()

        // cover
        coverImageView.kf.setImage(urlString: entity.cover,
                                   placeholder: R.image.normal_placeholder_v())

        // 热度值、收藏值
        var collect: String = String(entity.favorite_total)
        if entity.favorite_total > 10000 {
            let num = (Double(entity.favorite_total) / 10000.0).rounded(1)
            collect = String(num).appending("万")
        }
        hotLabel.text = "热度值 ".appending(entity.click_total)
        collectLabel.text = "收藏值 ".appending(collect)
        hotLabel.flex.markDirty()
        collectLabel.flex.markDirty()

        // tag
        tagContainer.flex.define { flex in
            guard let titles = entity.theme_ids else {
                return
            }

            for t in titles {
                flex.addItem(makeHeaderTag(t)).marginRight(10).paddingHorizontal(12)
            }
        }
        
        setNeedsLayout()
    }
    
    
    
}
