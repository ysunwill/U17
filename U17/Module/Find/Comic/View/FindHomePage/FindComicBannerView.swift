//
//  FindComicBannerView.swift
//  U17
//
//  Created by ysunwill on 2022/3/16.
//

import UIKit
import FSPagerView

class FindComicBannerView: BaseCollectionReusableView {
    
    // MARK: - Properties
    
    typealias TapBannerClosure = (_ comicId: Int?, _ comicTitle: String?) -> Void
    var tapBanner: TapBannerClosure?
    
    // 轮播图
    private var banner: FSPagerView = {
        let b = FSPagerView()
        b.register(FindComicBannerCell.self, forCellWithReuseIdentifier: "FindComicBannerView")
        b.isInfinite = true
        b.automaticSlidingInterval = 5
        return b
    }()
    
    // 小圆点
    private var pageControl: FSPageControl = {
        let pc = FSPageControl()
        pc.contentHorizontalAlignment = .left
        pc.numberOfPages = 5
        pc.setImage(R.image.banner_dot(), for: .normal)
        pc.setImage(R.image.banner_dot_selected(), for: .selected)
        pc.contentInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        return pc
    }()
    
    // entity
    var modelArray: [GalleryItem] = [] {
        didSet {
            banner.reloadData()
        }
    }
    
    // MARK: - Override
    
    override func setupSubviews() {
        self.backgroundColor = .white
        
        banner.dataSource = self
        banner.delegate = self
        banner.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width - 20)
        addSubview(banner)
//        drawCurveLayerAt(banner)
        
        pageControl.frame = CGRect(x: 0, y: banner.bounds.maxY - 10, width: banner.bounds.width, height: 10)
        addSubview(pageControl)
    }
    
    // MARK: - Interface
    
    // MARK: - Private Functions
    
    // 轮播图曲线遮罩
    private func drawCurveLayerAt(_ view: UIView) {
        let frame = view.bounds
        
        // 透明layer
        let bottomLayer = CALayer()
        bottomLayer.frame = frame
        view.layer.addSublayer(bottomLayer)
        
        // 白色曲线layer
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        let startPoint = CGPoint(x: 0, y: ceil(frame.height * 0.85))
        let endPoint = CGPoint(x: frame.width, y: ceil(frame.height * 0.7))
        let controlPoint = CGPoint(x: ceil(frame.width * 0.35), y: ceil(frame.height + 70))
        let leftBottomPoint = CGPoint(x: 0, y: frame.height)
        let rightBottomPoint = CGPoint(x: frame.width, y: frame.height)
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        path.addLine(to: rightBottomPoint)
        path.addLine(to: leftBottomPoint)
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        view.layer.addSublayer(shapeLayer)
    }
}

extension FindComicBannerView: FSPagerViewDataSource, FSPagerViewDelegate {
    
    // MARK: - FSPagerViewDataSource
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        modelArray.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FindComicBannerView", at: index) as! FindComicBannerCell
        cell.entity = modelArray[index]
        return cell
    }
    
    
    
    // MARK: - FSPagerViewDelegate
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        guard let tapBanner = tapBanner, modelArray.count > 0 else {
            return
        }
        
        let entity = modelArray[index]
        tapBanner(entity.ext[0].val, entity.title)
    }
    
    func pagerViewWillBeginDragging(_ pagerView: FSPagerView) {
        
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
}


fileprivate class FindComicBannerCell: FSPagerViewCell {
    
    private lazy var bgImgaeView: UIImageView = {
        let bg = UIImageView()
        bg.contentMode = .scaleAspectFill
        return bg
    }()
    
    private lazy var fgImgaeView: UIImageView = {
        let fg = UIImageView()
        fg.contentMode = .scaleAspectFill
        return fg
    }()
    
    var entity: GalleryItem? {
        didSet {
            guard let entity = entity else {
                return
            }
            
            bgImgaeView.kf.setImage(urlString: entity.cover, placeholder: R.image.normal_placeholder_h())
            fgImgaeView.kf.setImage(urlString: entity.topCover, placeholder: R.image.normal_placeholder_h())
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView?.isHidden = true
        
        contentView.addSubview(bgImgaeView)
        bgImgaeView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        contentView.addSubview(fgImgaeView)
        fgImgaeView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
