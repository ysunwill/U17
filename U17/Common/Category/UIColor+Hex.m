//
//  UIColor+Hex.m
//  U17
//
//  Created by ysunwill on 2022/3/2.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorFromHex:(unsigned int)hexValue
{
    unsigned int red = 0;
    unsigned int green = 0;
    unsigned int blue = 0;
    
    red = (hexValue & 0xFF0000) >> 16;
    green = (hexValue & 0xFF00) >> 8;
    blue = hexValue & 0xFF;
    
    return [UIColor colorWithRed:((float)red / 255.0) green:((float)green / 255.0) blue:((float)blue / 255.0) alpha:1.0f];
}

+ (UIColor *)colorFromHex:(unsigned int)hexValue alpha:(CGFloat)alpha
{
    unsigned int red = 0;
    unsigned int green = 0;
    unsigned int blue = 0;
    
    red = (hexValue & 0xFF0000) >> 16;
    green = (hexValue & 0xFF00) >> 8;
    blue = hexValue & 0xFF;
    
    return [UIColor colorWithRed:((float)red / 255.0) green:((float)green / 255.0) blue:((float)blue / 255.0) alpha:alpha];
}

@end
