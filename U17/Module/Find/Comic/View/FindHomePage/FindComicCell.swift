//
//  FindComicCell.swift
//  U17
//
//  Created by ysunwill on 2022/3/22.
//

import UIKit

enum FindComicCellType {
    case horizontal
    case vertical
    case largeHorizontal 
}

class FindComicCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    // image
    private var coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 6
        iv.layer.masksToBounds = true
        return iv
    }()
    
    // title
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = .zoomSystemFont(14)
        label.textColor = .colorFrom(hex: 0x333333)
        return label
    }()
    
    // description
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = .zoomSystemFont(12)
        label.textColor = .colorFrom(hex: 0x999999)
        return label
    }()
    
    // cell type
    var type: FindComicCellType = .horizontal {
        didSet {
            switch type {
            case .horizontal:
                coverImageView.snp.remakeConstraints { make in
                    make.top.left.right.equalTo(0)
                    make.height.equalTo(self.snp.height).multipliedBy(0.6)
                }
            case .vertical:
                coverImageView.snp.remakeConstraints { make in
                    make.top.left.right.equalTo(0)
                    make.height.equalTo(self.snp.height).multipliedBy(0.68)
                }
            case .largeHorizontal:
                coverImageView.snp.remakeConstraints { make in
                    make.top.left.right.equalTo(0)
                    make.height.equalTo(self.snp.height).multipliedBy(0.68)
                }
            }
        }
    }
    
    // entity
    var entity: FindComicModuleItem? {
        didSet {
            guard let entity = entity else {
                return
            }
            
            coverImageView.kf.setImage(urlString: entity.cover,
                                       placeholder: bounds.width > bounds.height ? R.image.normal_placeholder_h() : R.image.normal_placeholder_v())
            titleLabel.text = entity.title
            descriptionLabel.text = entity.subTitle
        }
    }
    
    // MARK: - Override
    
    override func setupSubviews() {
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(self.snp.height).multipliedBy(0.6)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(coverImageView.snp.bottom).offset(10)
            make.right.equalTo(-5)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.right.equalTo(-5)
        }
        
        
        
    }
}
