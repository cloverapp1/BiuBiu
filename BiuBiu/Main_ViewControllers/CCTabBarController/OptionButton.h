//
//  OptionButton.h
//  ChuangTestDemo
//
//  Created by laixx on 15/8/21.
//  Copyright (c) 2015年 BaiRongSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionButton : UIView

@property (nonatomic,strong) UIView *button;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image andColor:(UIColor *)color;

@end
