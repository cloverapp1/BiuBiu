//
//  UIView+Util.m
//  ChuangTestDemo
//
//  Created by laixx on 15/8/21.
//  Copyright (c) 2015年 BaiRongSoft. All rights reserved.
//

#import "UIView+Util.h"
//#import <GPUImage/GPUImage.h>

@implementation UIView (Util)

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setBorderWidth:(CGFloat)width andColor:(UIColor *)color
{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}


- (UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}

- (UIImage *)updateBlur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    UIImage *screenshot = [self convertViewToImage];
    CIImage *inputImage = [[CIImage alloc] initWithImage:screenshot];
    //    // create gaussian blur filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:3] forKey:@"inputRadius"];
    // blur image
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return image;
}


@end
