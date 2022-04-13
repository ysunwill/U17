//
//  FindComicOtherCell.swift
//  U17
//
//  Created by ysunwill on 2022/3/28.
//

import UIKit

enum OtherCellType {
    case advertisement
    case flow
    case animation
}

class FindComicOtherCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    typealias TapCellClosure = (_ comicId: Int?, _ comicTitle: String?) -> Void
    var tapCell: TapCellClosure?
    
    // collection view
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5.5
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.register(cellType: ComicOtherCell.self)
        return cv
    }()
    
    // cell type
    var type: OtherCellType?
    
    // entity
    var modelArray: [FindComicModuleItem]? {
        didSet {
            guard modelArray != nil && type != nil else {
                return
            }
            
            collectionView.reloadData()
        }
    }
    
    // MARK: - Override
    
    override func setupSubviews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
}

extension FindComicOtherCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == .advertisement {
            return 1
        } else {
            return modelArray?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ComicOtherCell.self)
        cell.type = type
        if type == .advertisement {
            cell.entity = modelArray?.first
        } else {
            cell.entity = modelArray?[indexPath.row]
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch type {
        case .flow:
            guard let tapCell = tapCell else {
                return
            }
            
            let entity = modelArray?[indexPath.row]
            tapCell(entity?.ext[0].val, entity?.title)
        default:
            break
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if type == .flow || type == .animation {
            return UIEdgeInsets(top: 0, left: 12, bottom: 10, right: 0)
        }
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch type {
        case .advertisement:
            return CGSize(width: bounds.width, height: bounds.height)
        case .flow:
            let width = floor((UDeviceUtil.screenWidth - 12 - 5.5) / 1.25)
            let height = floor(width * 0.74)
            return CGSize(width: width, height: height)
        case .animation:
            let width = floor((UDeviceUtil.screenWidth - 12 - 5.5 - 5.5) / 2.3)
            let height = floor(width * 1.3)
            return CGSize(width: width, height: height)
        default:
            return .zero
        }
    }
}

fileprivate class ComicOtherCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    // image
    private var coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    // 渐变背景
    private var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor(r: 100, g: 100, b: 100, a: 0).cgColor, UIColor(r: 100, g: 100, b: 100, a: 0.35).cgColor]
        layer.locations = [0, 0.7]
        layer.isHidden = true
        return layer
    }()
    
    // play icon
    private var playIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.icon_find_comic_play()
        iv.isHidden = true
        return iv
    }()
    
    // title
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = .zoomSystemSemiboldFont(14)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    // description
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = .zoomSystemFont(12)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    // cell type
    var type: OtherCellType? {
        didSet {
            guard let type = type else {
                return
            }
            
            switch type {
            case .advertisement:
                gradientLayer.isHidden = true
                playIcon.isHidden = true
                titleLabel.isHidden = true
                descriptionLabel.isHidden = true
                coverImageView.layer.cornerRadius = 6
                coverImageView.layer.masksToBounds = true
            case .flow:
                gradientLayer.isHidden = true
                playIcon.isHidden = true
                titleLabel.isHidden = true
                descriptionLabel.isHidden = true
                coverImageView.layer.cornerRadius = 0
                coverImageView.layer.masksToBounds = false
            case .animation:
                gradientLayer.isHidden = false
                playIcon.isHidden = false
                titleLabel.isHidden = false
                descriptionLabel.isHidden = false
                coverImageView.layer.cornerRadius = 6
                coverImageView.layer.masksToBounds = true
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
            if type == .animation {
                titleLabel.text = entity.title
                descriptionLabel.text = entity.subTitle
            }
        }
    }
    
    // MARK: - Override
    
    override func setupSubviews() {
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        coverImageView.layer.addSublayer(gradientLayer)
        
        coverImageView.addSubview(playIcon)
        playIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        coverImageView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalTo(10)
            make.right.equalTo(-5)
        }
        
        coverImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-5)
            make.left.equalTo(descriptionLabel.snp.left)
            make.right.equalTo(-5)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = CGRect(x: 0,
                                     y: 0,
                                     width: coverImageView.frame.width,
                                     height: coverImageView.frame.height)
    }
}

