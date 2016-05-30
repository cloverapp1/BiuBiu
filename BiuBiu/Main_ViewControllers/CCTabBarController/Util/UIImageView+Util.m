//
//  UIImageView+Util.m
//  EntreTest
//
//  Created by laixx on 15/8/26.
//  Copyright (c) 2015年 BaiRongSoft. All rights reserved.
//

#import "UIImageView+Util.h"

@implementation UIImageView (Util)

- (void)loadPortrait:(NSURL *)portraitURL
{
    [self sd_setImageWithURL:portraitURL placeholderImage:[UIImage imageNamed:@"default-portrait"] options:0];
}

@end
