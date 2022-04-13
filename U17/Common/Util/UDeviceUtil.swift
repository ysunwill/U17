//
//  UDeviceUtil.swift
//  U17
//
//  Created by ysunwill on 2022/3/3.
//

import UIKit

@objc
public class UDeviceUtil: NSObject {
    
    @objc
    public static var statusBarHeight: CGFloat {
        return self.isIphoneX ? 44 : 20
    }

    
    @objc
    public static var navBarHeight: CGFloat {
        return self.statusBarHeight + 44
    }
    
    @objc
    public static var tabBarHeight: CGFloat {
        return self.safeAreaInsets.bottom + 49
    }
    
    @objc
    public static var isIphoneX: Bool {
        return self.safeAreaInsets.bottom > 0 && !self.isIpad
    }
    
    @objc
    public static var isIphone5: Bool {
        return self.screenWidth == 320
    }
    
    @objc
    public static var isIpad: Bool {
        UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
    }
    
    @objc
    public static var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    @objc
    public static var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    @objc
    public static var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
