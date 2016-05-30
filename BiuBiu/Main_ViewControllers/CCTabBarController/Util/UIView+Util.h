//
//  UIView+Util.h
//  ChuangTestDemo
//
//  Created by laixx on 15/8/21.
//  Copyright (c) 2015年 BaiRongSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util)

- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setBorderWidth:(CGFloat)width andColor:(UIColor *)color;

- (UIImage *)convertViewToImage;
- (UIImage *)updateBlur;

@end
