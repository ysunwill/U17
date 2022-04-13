//
//  FindComicSectionHeaderView.swift
//  U17
//
//  Created by ysunwill on 2022/3/22.
//

import UIKit

class FindComicSectionHeaderView: BaseCollectionReusableView {
    
    // MARK: - Properties
    
    // title
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorFrom(hex: 0x333333)
        label.font = .zoomSystemSemiboldFont(18)
        return label
    }()
    
    // icon
    private var moreButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(R.image.icon_find_more(), for: .normal)
        return btn
    }()
    
    // title
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: - Override
    
    override func setupSubviews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
        }
        
        addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(21)
            make.width.equalTo(37)
        }
    }
    
    // MARK: - Interface
    
}
