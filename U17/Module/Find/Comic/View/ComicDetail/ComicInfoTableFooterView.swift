//
//  ComicInfoTableFooterView.swift
//  U17
//
//  Created by ysunwill on 2022/4/12.
//

import UIKit

class ComicInfoTableFooterView: UIView {

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
        label.font = .zoomSystemFont(14.5)
        label.textColor = .colorFrom(hex: 0x353535)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zoomSystemSemiboldFont(18)
        label.textColor = .colorFrom(hex: 0x353535)
        label.text = "本漫作者"
        return label
    }()
    
    var moreIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.icon_comic_info_more()
        return imageView
    }()
    
    var arrowIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.icon_comic_uparrow()
        return imageView
    }()
    
    var container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 241, g: 241, b: 241, a: 0.5)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .zoomSystemFont(14.5)
        label.textColor = .colorFrom(hex: 0x353535)
        label.numberOfLines = 0
        
        label.preferredMaxLayoutWidth = UDeviceUtil.screenWidth - 24 - 24
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(30)
        }
        
        addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.width.height.equalTo(42.zoom())
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatar.snp.right).offset(10)
            make.centerY.equalTo(avatar)
        }
        
        addSubview(moreIcon)
        moreIcon.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.centerY.equalTo(avatar)
        }
        
        addSubview(container)
        container.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(avatar.snp.bottom).offset(13)
            make.bottom.equalTo(-60).priority(.medium)
        }
        
        container.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        addSubview(arrowIcon)
        arrowIcon.snp.makeConstraints { make in
            make.bottom.equalTo(container.snp.top)
            make.centerX.equalTo(avatar)
            make.width.equalTo(7.5)
            make.height.equalTo(4.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews(_ entity: ComicInfoEntity) {
        guard let summary = entity.comic else {
            return
        }
        
        avatar.kf.setImage(urlString: summary.author?.avatar)
        nameLabel.text = summary.author?.name
        if summary.affiche.count > 0 {
            descriptionLabel.text = "公告：\(summary.affiche)"
        } else {
            container.isHidden = true
            descriptionLabel.isHidden = true
            arrowIcon.isHidden = true
            descriptionLabel.snp.remakeConstraints { make in
                make.height.equalTo(0)
                make.center.equalToSuperview()
            }
            container.snp.remakeConstraints { make in
                make.left.equalTo(12)
                make.right.equalTo(-12)
                make.top.equalTo(avatar.snp.bottom).offset(13)
                make.height.equalTo(0)
                make.bottom.equalTo(-60).priority(.medium)
            }
        }
        
    }
    
}
