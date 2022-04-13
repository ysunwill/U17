//
//  BaseTableViewCell.swift
//  U17
//
//  Created by ysunwill on 2022/4/5.
//

import UIKit

class BaseTableViewCell: UITableViewCell, Reusable {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupSubviews() {}

}
