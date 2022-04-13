//
//  UIFontExtension.swift
//  U17
//
//  Created by ysunwill on 2022/3/22.
//

import UIKit

extension UIFont {
    
    class func zoomSystemFont(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size.zoom(), weight: .regular)
    }
    
    class func zoomSystemSemiboldFont(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size.zoom(), weight: .semibold)
    }
    
    class func zoomSystemBoldFont(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size.zoom(), weight: .bold)
    }
}
