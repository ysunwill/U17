//
//  ComicInfoForumCell.swift
//  U17
//
//  Created by ysunwill on 2022/4/6.
//

import UIKit

class ComicInfoForumCell: BaseTableViewCell {

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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .zoomSystemSemiboldFont(18)
        label.textColor = .colorFrom(hex: 0x353535)
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .zoomSystemFont(13.5)
        label.textColor = .colorFrom(hex: 0x555555)
        return label
    }()

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
    
    private lazy var likeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = R.image.icon_comic_forum_like()
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
        imageView.image = R.image.bg_comment_separator()
        return imageView
    }()
    
    var entity: CommunityListItem? {
        didSet {
            guard let entity = entity else {
                return
            }
            
            // user
            avatar.kf.setImage(urlString: entity.user?.face, placeholder: R.image.normal_placeholder_h())
            nameLabel.text = entity.user?.nickname
            timeLabel.text = entity.create_time_str
            
            // 标题、内容
            titleLabel.text = entity.title
            commentLabel.text = entity.content
            
            // 评论、点赞
            commentCountLabel.text = "\(entity.total_reply)"
            likeCountLabel.text = "\(entity.praise_total)"
            
            likeCountLabel.flex.markDirty()
            commentCountLabel.flex.markDirty()
            nameLabel.flex.markDirty()
            timeLabel.flex.markDirty()
            titleLabel.flex.markDirty()
            commentLabel.flex.markDirty()
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
            }
            
            flex.addItem(titleLabel).margin(12, 17, 12, 17)
            
            flex.addItem(commentLabel).margin(0, 17, 8, 7)
            
            flex.addItem().direction(.rowReverse).height(20.5).paddingRight(12).define { flex in
                flex.addItem().direction(.row).alignItems(.center).define { flex in
                    flex.addItem(likeIcon).width(16).height(20.5)
                    flex.addItem(likeCountLabel).marginLeft(6)
                }
                flex.addItem().direction(.row).alignItems(.center).marginRight(43).define { flex in
                    flex.addItem(commentIcon).width(15.5).height(14)
                    flex.addItem(commentCountLabel).marginLeft(6)
                }
            }

            flex.addItem(separatorImageView).marginTop(10).marginRight(6)
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

}
