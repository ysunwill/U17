//
//  FindComicTopBar.swift
//  U17
//
//  Created by ysunwill on 2022/3/4.
//

import UIKit

enum TopBarItem: NSInteger {
    case rank = 0
    case vip
    case pay
    case category
}

class FindComicTopBar: UIView {
    
    // MARK: - Properties
    
    private var items: [ItemView] = []
    
    // 背景
    private lazy var bg = UIImageView().then {
        $0.image = R.image.bg_find_comic_top()
    }
    
    // 搜索框
    private lazy var searchButton = SearchButton(type: .custom).then {
        $0.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    // 四个按钮
    private lazy var itemsView = UIView().then {
        let images = [[R.image.find_comic_nav_rank_down(), R.image.find_comic_nav_rank_up()],
                     [R.image.find_comic_nav_vip_down(), R.image.find_comic_nav_vip_up()],
                     [R.image.find_comic_nav_pay_down(), R.image.find_comic_nav_pay_up()],
                     [R.image.find_comic_nav_cate_down(), R.image.find_comic_nav_cate_up()]]
        
        var last: UIView? = nil
        for index in 0..<4 {
            let item = ItemView()
            item.downIcon.image = images[index][0]
            item.upIcon.image = images[index][1]
            items.append(item)
            $0.addSubview(item)
            item.snp.makeConstraints { make in
                make.top.bottom.equalTo(0)
                
                if last != nil {
                    make.left.equalTo(last!.snp.right)
                } else {
                    make.left.equalTo(0)
                }
                
                if index < 3 {
                    make.width.equalToSuperview().multipliedBy(0.25)
                } else {
                    make.right.equalTo(0)
                }
                
                last = item
            }
        }
    }
    
    // 热搜词
    var hotSearch: String = "" {
        didSet {
            searchButton.searchLabel.text = hotSearch
        }
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white.withAlphaComponent(0)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    
    private func setupSubviews() {
        addSubview(bg)
        bg.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        addSubview(itemsView)
        itemsView.snp.makeConstraints { make in
            make.right.equalTo(-9)
            make.height.equalToSuperview().multipliedBy(0.58)
            make.centerY.equalToSuperview()
            make.width.equalTo(43.5.zoom() * 4)
        }
        
        addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.58)
            make.right.equalTo(itemsView.snp.left).offset(-9)
        }
        
    }
    
    // MARK: - Interface
    
    /// 划动时改变透明度
    func changeAlpha(by offsetY: CGFloat) {
        if offsetY <= 0 { // y <= 0，恢复默认状态
            // 背景
            self.backgroundColor = .white.withAlphaComponent(0)
            bg.isHidden = false
            
            // 搜索框
            searchButton.backgroundColor = .black.withAlphaComponent(0.3)
            searchButton.upIcon.alpha = 1.0
            searchButton.downIcon.alpha = 0.0
            searchButton.searchLabel.textColor = UIColor(r: 255, g: 255, b: 255)
            
            // 四个按钮
            for itemView in items {
                itemView.bgView.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.3)
                itemView.downIcon.alpha = 0.0
                itemView.upIcon.alpha = 1.0
            }
        } else if offsetY >= UDeviceUtil.navBarHeight + 100 {
            // 背景
            self.backgroundColor = .white.withAlphaComponent(1.0)
            bg.isHidden = true
            
            // 搜索框
            searchButton.backgroundColor = UIColor(r: 247, g: 247, b: 247).withAlphaComponent(1.0)
            searchButton.upIcon.alpha = 0.0
            searchButton.downIcon.alpha = 1.0
            searchButton.searchLabel.textColor = UIColor(r: 187, g: 187, b: 187)
            
            // 四个按钮
            for itemView in items {
                itemView.bgView.backgroundColor = UIColor(r: 29, g: 221, b: 143, a: 0.1)
                itemView.downIcon.alpha = 1.0
                itemView.upIcon.alpha = 0.0
            }
        } else {
            let alpha = (offsetY / (UDeviceUtil.navBarHeight + 100)).rounded(2)
            let value1: UInt32 = UInt32(offsetY + 8) > 247 ? 247 : UInt32(offsetY + 8)
            let value2: UInt32 = (255 - value1 / 4) < 187 ? 187 : (255 - value1 / 4)
            let value3 = (0.3 + alpha) > 1.0 ? 1.0 : (0.3 + alpha)
            
            // 背景
            self.backgroundColor = .white.withAlphaComponent(alpha)
    
            // 搜索框
            searchButton.backgroundColor = UIColor(r: value1, g: value1, b: value1).withAlphaComponent(value3)
            searchButton.upIcon.alpha = 1.0 - alpha
            searchButton.downIcon.alpha = alpha
            searchButton.searchLabel.textColor = UIColor(r: value2, g: value2, b: value2)
            
            // 四个按钮
            for itemView in items {
                itemView.bgView.backgroundColor = UIColor(r: UInt32(29 * alpha), g: UInt32(221 * alpha), b: UInt32(143 * alpha), a: (0.3 - 0.2 * alpha))
                itemView.downIcon.alpha = alpha
                itemView.upIcon.alpha = 1.0 - alpha
            }
        }
    }
}

/// 搜索框
fileprivate class SearchButton: UIButton {
    // img，up放大镜
    lazy var upIcon: UIImageView = UIImageView().then {
        $0.image = R.image.find_comic_nav_search_up()
        $0.alpha = 1.0
    }
    
    // 搜索框内部，down放大镜
    lazy var downIcon = UIImageView().then {
        $0.image = R.image.find_comic_nav_search_down()
        $0.alpha = 0.0
    }
    
    // 搜索框内部，label
    lazy var searchLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13.5.zoom())
        $0.text = ""
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(downIcon)
        downIcon.snp.makeConstraints { make in
            make.left.equalTo(12.zoom())
            make.width.height.equalTo(15.zoom())
            make.centerY.equalToSuperview()
        }
        
        addSubview(upIcon)
        upIcon.snp.makeConstraints { make in
            make.left.equalTo(downIcon.snp.left)
            make.width.height.equalTo(downIcon.snp.width)
            make.centerY.equalToSuperview()
        }
        
        addSubview(searchLabel)
        searchLabel.snp.makeConstraints { make in
            make.left.equalTo(downIcon.snp.right).offset(12.zoom())
            make.height.equalTo(19.zoom())
            make.centerY.equalToSuperview()
            make.right.equalTo(self.snp.right).offset(-3.zoom())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 2
    }
    
}

/// 四个按钮
fileprivate class ItemView: UIView {
    // 底部圆圈
    lazy var bgView = UIView().then {
        $0.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.3)
    }
    
    // down icon
    lazy var downIcon = UIImageView().then {
        $0.alpha = 0.0
    }
    
    // down icon
    lazy var upIcon = UIImageView().then {
        $0.alpha = 1.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.height)
            make.top.bottom.equalTo(0)
            make.centerX.equalToSuperview()
        }
        
        addSubview(downIcon)
        downIcon.snp.makeConstraints { make in
            make.width.height.equalTo(bgView.snp.width).offset(-15.zoom())
            make.center.equalToSuperview()
        }
        
        addSubview(upIcon)
        upIcon.snp.makeConstraints { make in
            make.width.height.equalTo(downIcon.snp.width)
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.layer.cornerRadius = self.frame.height / 2
    }
    
}

