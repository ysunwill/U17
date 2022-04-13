//
//  ComicInfoForumAddPostCell.swift
//  U17
//
//  Created by ysunwill on 2022/4/6.
//

import UIKit

class ComicInfoForumAddPostCell: BaseTableViewCell {
    
    override func setupSubviews() {
        let view = UIView()
        view.backgroundColor = .colorFrom(hex: 0xf1f1f1)
        view.layer.cornerRadius = 42.zoom() / 2
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.height.equalTo(42.zoom()).priority(.medium)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
        
        let cameraIcon = UIImageView()
        cameraIcon.image = R.image.icon_comic_camera()
        view.addSubview(cameraIcon)
        cameraIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
        }
        
        let label = UILabel()
        label.font = .zoomSystemFont(14.5)
        label.textColor = .colorFrom(hex: 0xBBBBBB)
        label.text = "快来讨论吧~"
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(cameraIcon.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
    }

}
