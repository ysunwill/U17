//
//  CustomNavigationBar.swift
//  U17
//
//  Created by ysunwill on 2022/3/31.
//

import UIKit

class CustomNavigationBar: UIView {
    
    public typealias PopBackClosure = () -> Void
    public var popBack: PopBackClosure?
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 15
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .zoomSystemSemiboldFont(16)
        label.isHidden = true
        return label
    }()
    
    var title: String? {
        didSet {
            guard let title = title else {
                return
            }
            
            titleLabel.text = title
        }
    }
    
    var hideTitle: Bool? {
        didSet {
            guard let hideTitle = hideTitle else {
                return
            }
            
            titleLabel.isHidden = hideTitle
        }
    }

    // MARK: - Override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupSubviews() {
        // 返回
        let backButton = UIButton(type: .custom)
        backButton.setImage(R.image.icon_nav_back(), for: .normal)
        backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.width.equalTo(22)
            make.height.equalTo(25)
            make.centerY.equalToSuperview().offset(UDeviceUtil.statusBarHeight / 2)
        }
        
        // title
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(UDeviceUtil.statusBarHeight / 2)
        }
        
        // stack
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.height.equalTo(22)
            make.width.equalTo(22 * 3 + 15 + 15)
            make.centerY.equalToSuperview().offset(UDeviceUtil.statusBarHeight / 2)
        }
        stackView.addArrangedSubview(addStackButton(R.image.icon_nav_report()))
        stackView.addArrangedSubview(addStackButton(R.image.icon_nav_down()))
        stackView.addArrangedSubview(addStackButton(R.image.icon_nav_share()))
    }
    
    private func addStackButton(_ image: UIImage?) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        return button
    }
    
    // MARK: - Action
    
    @objc
    private func backAction(_ sender: UIButton) {
        guard let popBack = popBack else {
            return
        }
        
        popBack()
    }
    
}
