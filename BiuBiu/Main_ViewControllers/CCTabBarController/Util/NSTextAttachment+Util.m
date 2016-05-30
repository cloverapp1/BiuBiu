//
//  NSTextAttachment+Util.m
//  EntreTest
//
//  Created by laixx on 15/8/27.
//  Copyright (c) 2015年 BaiRongSoft. All rights reserved.
//

#import "NSTextAttachment+Util.h"

@implementation NSTextAttachment (Util)

- (void)adjustY:(CGFloat)y
{
    self.bounds = CGRectMake(0, y, self.image.size.width, self.image.size.height);
}

@end
