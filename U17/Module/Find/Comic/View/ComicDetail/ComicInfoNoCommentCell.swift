//
//  ComicInfoNoCommentCell.swift
//  U17
//
//  Created by ysunwill on 2022/4/6.
//

import UIKit

class ComicInfoNoCommentCell: BaseTableViewCell {

    private lazy var noCommentLabel: UILabel = {
        let label = UILabel()
        label.font = .zoomSystemFont(12.5)
        label.textColor = .colorFrom(hex: 0xBBBBBB)
        label.textAlignment = .center
        label.text = "什么都没有，快来参与吧~"
        return label
    }()
    
    override func setupSubviews() {
        contentView.addSubview(noCommentLabel)
        noCommentLabel.snp.makeConstraints { make in
            make.edges.equalTo(0)
            make.height.equalTo(60).priority(.medium)
        }
    }
}
