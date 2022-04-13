//
//  ComicInfoCommentCell.swift
//  U17
//
//  Created by ysunwill on 2022/4/5.
//

import UIKit

class ComicInfoCommentCell: BaseTableViewCell {
    
    var commentAllHeight: CGFloat?
    var commentFoldHeight: CGFloat?
    var foldCommentClosure: (() -> Void)?
    
    private lazy var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.colorFrom(hex: 0xBBBBBB).cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 42.zoom() / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .zoomSystemSemiboldFont(12.5)
        label.textColor = .colorFrom(hex: 0x353535)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .zoomSystemFont(12.5)
        label.textColor = .colorFrom(hex: 0xBBBBBB)
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var allFoldButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.theme, for: .normal)
        button.setTitleColor(UIColor.theme, for: .selected)
//        button.backgroundColor = .clear
        button.setTitle("全文", for: .normal)
        button.setTitle("收起", for: .selected)
        button.titleLabel?.font = .zoomSystemFont(14.5)
//        button.isHidden = true
        button.addTarget(self, action: #selector(foldCommentAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    // 精华icon
    private lazy var goodIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = R.image.icon_good_comment()
        return imageView
    }()
    
//    private lazy var commentCountContainer: UIView = {
//        let view = UIView()
////        view.isHidden = true
//        return view
//    }()
    
    private lazy var commentIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = R.image.icon_comment()
        return imageView
    }()
    
    private lazy var commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = .zoomSystemFont(12)
        label.textColor = .colorFrom(hex: 0xBBBBBB)
        return label
    }()
    
//    private lazy var likeCountContainer: UIView = {
//        let view = UIView()
////        view.isHidden = true
//        return view
//    }()
    
    private lazy var likeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = R.image.icon_comment_like()
        return imageView
    }()
    
    private lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = .zoomSystemFont(12)
        label.textColor = .colorFrom(hex: 0xBBBBBB)
        label.text = "15"
        return label
    }()
    
    private lazy var separatorImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
        imageView.image = R.image.bg_comment_separator()
        return imageView
    }()
    
    var entity: ComicInfoCommentItem? {
        didSet {
            guard let entity = entity else {
                return
            }
            
            // user
            avatar.kf.setImage(urlString: entity.user?.face, placeholder: R.image.normal_placeholder_h())
            nameLabel.text = entity.user?.nickname
            timeLabel.text = entity.create_time_str
            
            // 富文本评论
            // 简单处理，实际要复杂得多
            if let data = entity.content.data(using: String.Encoding.unicode, allowLossyConversion: true) {
                if let attributedText = try? NSMutableAttributedString(data: data,
                                                                       options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html],
                                                                       documentAttributes: nil) {
                    attributedText.addAttributes([NSAttributedString.Key.font : UIFont.zoomSystemFont(13.5)],
                                                 range: NSRange(location: 0, length: attributedText.length))
                    attributedText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.colorFrom(hex: 0x555555)],
                                                 range: NSRange(location: 0, length: attributedText.length))
                    commentLabel.attributedText = attributedText
                    // 超过4行折叠
                    if commentAllHeight == nil {
                        let size = commentLabel.sizeThatFits(CGSize(width: UDeviceUtil.screenWidth - 24, height: CGFloat(MAXFLOAT)))
                        commentAllHeight = size.height
                        commentFoldHeight = ceil(commentLabel.font.lineHeight * 4)
                    }
                    if commentAllHeight! > commentFoldHeight! {
                        allFoldButton.flex.height(16)
                        allFoldButton.isHidden = false
                        fold(true)
                    } else {
                        allFoldButton.flex.height(0)
                        allFoldButton.isHidden = true
                        fold(false)
                    }
                    
                }
            }
            
            // 评论、点赞
            commentCountLabel.text = "\(entity.total_reply)"
            likeCountLabel.text = "\(entity.praise_total)"
            
            likeCountLabel.flex.markDirty()
            commentCountLabel.flex.markDirty()
            nameLabel.flex.markDirty()
            timeLabel.flex.markDirty()
            allFoldButton.flex.markDirty()
            setNeedsLayout()
        }
    }

    override func setupSubviews() {
        contentView.flex.define { flex in
            flex.addItem().direction(.row).padding(12, 17, 0, 17).define { flex in
                flex.addItem(avatar).size(42.zoom())
                
                flex.addItem().direction(.column).marginLeft(10).justifyContent(.center).define { flex in
                    flex.addItem(nameLabel)
                    flex.addItem(timeLabel).marginTop(3.5)
                }
//
//                flex.addItem(imageContainer).height(0)
            }
            
            flex.addItem(commentLabel).margin(10, 17, 8, 7)
            
            flex.addItem(allFoldButton).alignSelf(.start).height(16).margin(0, 17, 12, 0)
            
            flex.addItem().direction(.rowReverse).height(18).paddingRight(12).define { flex in
                flex.addItem().direction(.row).alignItems(.center).define { flex in
                    flex.addItem(likeIcon).width(15.5).height(14)
                    flex.addItem(likeCountLabel).marginLeft(6)
                }
                flex.addItem().direction(.row).alignItems(.center).marginRight(43).define { flex in
                    flex.addItem(commentIcon).width(15.5).height(14)
                    flex.addItem(commentCountLabel).marginLeft(6)
                }
            }

            flex.addItem(separatorImageView).marginTop(5).marginRight(6)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()

        return contentView.frame.size
    }
    
    private func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    @objc
    private func foldCommentAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            fold(false)
        } else {
            fold(true)
        }
        
        guard let foldCommentClosure = foldCommentClosure else {
            return
        }
        foldCommentClosure()
    }
    
    private func fold(_ fold: Bool) {
        if fold {
            commentLabel.flex.height(commentFoldHeight)
        } else {
            commentLabel.flex.height(commentAllHeight)
        }
        
        commentLabel.flex.markDirty()
        setNeedsLayout()
    }

}
