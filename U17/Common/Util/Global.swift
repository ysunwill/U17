//
//  Global.swift
//  U17
//
//  Created by ysunwill on 2022/3/24.
//

import Foundation
import UIKit
import Kingfisher

// 应用主题颜色
extension UIColor {
    class var theme: UIColor {
        return UIColor(r: 29, g: 221, b: 143)
    }
}

var topVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC = _topVC(UIApplication.shared.keyWindow?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)
    }
    return resultVC
}

private func _topVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        return _topVC((vc as? UINavigationController)?.topViewController)
    } else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)
    } else {
        return vc
    }
}

//MARK: print
func uLog<T>(_ message: T, file: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):funciton:\(function):line:\(lineNumber)]- \(message)")
    #endif
}

//MARK: Kingfisher
extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    @discardableResult
    public func setImage(urlString: String?, placeholder: Placeholder? = UIImage(named: "normal_placeholder_h")) -> DownloadTask? {
        return setImage(with: URL(string: urlString ?? ""),
                        placeholder: placeholder,
                        options: [.transition(.fade(0.5))])
    }
}

extension KingfisherWrapper where Base: KFCrossPlatformButton {
    @discardableResult
    public func setImage(urlString: String?, for state: UIControl.State, placeholder: UIImage? = UIImage(named: "normal_placeholder_h")) -> DownloadTask? {
        return setImage(with: URL(string: urlString ?? ""),
                        for: state,
                        placeholder: placeholder,
                        options: [.transition(.fade(0.5))])
    }
}


typealias CCornersRadius = (topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat)
extension UIView {
    // 自定义圆角

    //创建Path
    func createPath(bounds:CGRect, cornersRadius:CCornersRadius) -> CGPath {
            let minX = bounds.minX
            let minY = bounds.minY
            let maxX = bounds.maxX
            let maxY = bounds.maxY

            let topLeftCenterX = minX + cornersRadius.topLeft
            let topLeftCenterY = minY + cornersRadius.topLeft
            let topRightCenterX = maxX - cornersRadius.topRight
            let topRightCenterY = minY + cornersRadius.topRight
            let bottomLeftCenterX = minX + cornersRadius.bottomLeft
            let bottomLeftCenterY = maxY - cornersRadius.bottomLeft
            let bottomRightCenterX = maxX - cornersRadius.bottomRight
            let bottomRightCenterY = maxY - cornersRadius.bottomRight
            
            let path = CGMutablePath()
            path.addArc(center: CGPoint(x: topLeftCenterX, y: topLeftCenterY), radius: cornersRadius.topLeft, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2.0), clockwise: false)
            path.addArc(center: CGPoint(x: topRightCenterX, y: topRightCenterY), radius: cornersRadius.topRight, startAngle: CGFloat(3 * Double.pi / 2.0), endAngle: 0, clockwise: false)
            path.addArc(center: CGPoint(x: bottomRightCenterX, y: bottomRightCenterY), radius: cornersRadius.bottomRight, startAngle: 0, endAngle: CGFloat(Double.pi / 2.0), clockwise: false)
            path.addArc(center: CGPoint(x: bottomLeftCenterX, y: bottomLeftCenterY), radius: cornersRadius.bottomLeft, startAngle: CGFloat(Double.pi / 2.0), endAngle: CGFloat(Double.pi), clockwise: false)
            path.closeSubpath()
            
            return path
    }
}
