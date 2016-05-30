//
//  UIImage+Util.h
//  ChuangTestDemo
//
//  Created by laixx on 15/8/21.
//  Copyright (c) 2015年 BaiRongSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)

- (UIImage *)imageMaskedWithColor:(UIColor *)maskColor;
- (UIImage *)cropToRect:(CGRect)rect;

@end
