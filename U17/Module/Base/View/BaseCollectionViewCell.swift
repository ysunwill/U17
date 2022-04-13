//
//  BaseCollectionViewCell.swift
//  U17
//
//  Created by ysunwill on 2022/3/16.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupSubviews() {}
}
