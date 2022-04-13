//
//  BaseTableViewHeaderFooterView.swift
//  U17
//
//  Created by ysunwill on 2022/4/8.
//

import UIKit

class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView, Reusable {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupSubviews() { }

}
