//
//  TestViewController.swift
//  U17
//
//  Created by ysunwill on 2022/3/31.
//

import UIKit

class TestViewController: UBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .random
    }
}



extension TestViewController: JXCategoryListContentViewDelegate {
    func listView() -> UIView! {
        view
    }
}


