//
//  CustomTabBar.swift
//  U17
//
//  Created by ysunwill on 2022/3/31.
//

import UIKit

class CustomTabBar: UIView {
    
    private lazy var line: UIImageView = {
        let line = UIImageView()
        line.image = R.image.bg_tab_line()
        return line
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 15
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var readButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .theme
        button.setTitleColor(.white, for: .normal)
        button.setTitle("阅读 第1话", for: .normal)
        button.titleLabel?.font = .zoomSystemFont(14.5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: UDeviceUtil.safeAreaInsets.bottom / 2.0, right: 0)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(line)
        line.snp.makeConstraints { make in
            make.left.top.right.equalTo(0)
            make.height.equalTo(6)
        }
        
        addSubview(readButton)
        readButton.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(self.snp.width).multipliedBy(0.45)
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom)
            make.left.equalTo(15)
            make.right.equalTo(readButton.snp.left).offset(-15)
            make.bottom.equalTo(-UDeviceUtil.safeAreaInsets.bottom / 2.0)
        }
        stackView.addArrangedSubview(addButton(image: R.image.tab_reward(), title: "打赏"))
        stackView.addArrangedSubview(addButton(image: R.image.tab_comment(), title: "评论"))
        stackView.addArrangedSubview(addButton(image: R.image.tab_collect_no(), title: "收藏"))
        
    }
    
    /// 打赏、评论、收藏
    private func addButton(image:UIImage?, title: String) -> UIButton {
        let button = UIButton(type: .custom)
        
        let container = UIView()
        let icon = UIImageView(image: image)
        let label = UILabel()
        label.font = .zoomSystemFont(12)
        label.textColor = UIColor(r: 153, g: 153, b: 153)
        label.text = title
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(0)
        }
        container.addSubview(icon)
        icon.snp.makeConstraints { make in
            let size = image!.size.zoom()
            make.size.equalTo(size)
            make.top.equalTo(0)
            make.bottom.equalTo(label.snp.top).offset(-3.zoom())
            make.centerX.equalToSuperview()
        }
        
        
        button.addSubview(container)
        container.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.centerY.equalToSuperview()
        }
        
        return button
    }

}
