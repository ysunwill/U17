//
//  ComicInfoTableSectionHeaderView.swift
//  U17
//
//  Created by ysunwill on 2022/4/8.
//

import UIKit

class ComicInfoTableSectionHeaderView: BaseTableViewHeaderFooterView {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .colorFrom(hex: 0x353535)
        label.font = .zoomSystemSemiboldFont(18)
        return label
    }()
    
    var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .colorFrom(hex: 0x999999)
        label.font = .zoomSystemFont(13.5)
        return label
    }()
    
    var moreIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.icon_comic_info_more()
        return imageView
    }()
    
    override func setupSubviews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.bottom.equalTo(-10)
        }
        
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right)
            make.bottom.equalTo(-10)
        }
        
        contentView.addSubview(moreIcon)
        moreIcon.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.width.height.equalTo(12.5)
            make.centerY.equalTo(titleLabel)
        }
    }

}
