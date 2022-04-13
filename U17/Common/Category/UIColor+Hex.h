//
//  UIColor+Hex.h
//  U17
//
//  Created by ysunwill on 2022/3/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)


/// 十六进制颜色
/// @param hexValue 0xFFFFFF
+ (UIColor *)colorFromHex:(unsigned int)hexValue;


/// 十六进制颜色，带透明度
/// @param hexValue 0xFFFFFF
/// @param alpha 0~1
+ (UIColor *)colorFromHex:(unsigned int)hexValue alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
