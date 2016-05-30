//
//  CCTabBarController.m
//  ChuangTestDemo
//
//  Created by laixx on 15/8/21.
//  Copyright (c) 2015年 BaiRongSoft. All rights reserved.
//

#import "BBTabBarController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "ForthViewController.h"
#import "UIView+Util.h"
#import "UIColor+Util.h"
#import "UIImage+Util.h"
#import "OptionButton.h"
#import "DetailViewController.h"
#import <RESideMenu/RESideMenu.h>
#import "SearchViewController.h"


@interface BBTabBarController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, assign) BOOL isPressed;
@property (nonatomic, strong) NSMutableArray *optionButtons;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGGlyph length;

@end

@implementation BBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FirstViewController *vc0 = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    SecondViewController *vc1 = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    ThirdViewController *vc3 = [[ThirdViewController alloc] initWithNibName:@"ThirdViewController" bundle:nil];
    ForthViewController *vc4 = [[ForthViewController alloc] initWithNibName:@"ForthViewController" bundle:nil];
    
    self.tabBar.translucent = NO;
    self.viewControllers = @[
                             [self addNavigationItemForViewController:vc0],
                             [self addNavigationItemForViewController:vc1],
                             [UIViewController new],
                             [self addNavigationItemForViewController:vc3],
                             [[UINavigationController alloc] initWithRootViewController:vc4]
                             ];
    //tabbar图标
    NSArray *titles = @[@"综合", @"动弹", @"", @"发现", @"我"];
    NSArray *images = @[@"tabbar-news", @"tabbar-tweet", @"", @"tabbar-discover", @"tabbar-me"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        [item setImage:[UIImage imageNamed:images[idx]]];
        [item setSelectedImage:[UIImage imageNamed:[images[idx] stringByAppendingString:@"-selected"]]];
    }];
    [self.tabBar.items[2] setEnabled:NO];
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"tabbar-more"]];
    
    [self.tabBar addObserver:self
                  forKeyPath:@"selectedItem"
                     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                     context:nil];
    
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 49)];
    backView.backgroundColor = [UIColor cyanColor];
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.tintColor = [UIColor redColor];
    
    // 功能键相关  + 号键
    _optionButtons = [NSMutableArray new];
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth  = [UIScreen mainScreen].bounds.size.width;
    _length = 60;        // 圆形按钮的直径
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    NSArray *buttonTitles = @[@"文字", @"相册", @"拍照", @"语音", @"扫一扫", @"找人"];
    NSArray *buttonImages = @[@"tweetEditing", @"picture", @"shooting", @"sound", @"scan", @"search"];
    int buttonColors[] = {0xe69961, 0x0dac6b, 0x24a0c4, 0xe96360, 0x61b644, 0xf1c50e};
    
    for (int i = 0; i < 6; i++) {
        OptionButton *optionButton = [[OptionButton alloc] initWithTitle:buttonTitles[i]
                                                                   image:[UIImage imageNamed:buttonImages[i]]
                                                                andColor:[UIColor colorWithHex:buttonColors[i]]];
        
        optionButton.frame = CGRectMake((_screenWidth/6 * (i%3*2+1) - (_length+16)/2),
                                        _screenHeight + 150 + i/3*100,
                                        _length + 16,
                                        _length + [UIFont systemFontOfSize:14].lineHeight + 24);
        [optionButton.button setCornerRadius:_length/2];
        
        optionButton.tag = i;
        optionButton.userInteractionEnabled = YES;
        [optionButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOptionButton:)]];
        
        [self.view addSubview:optionButton];
        [_optionButtons addObject:optionButton];
    }
    
}




#pragma mark -

- (UINavigationController *)addNavigationItemForViewController:(UIViewController *)viewController
{
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    viewController.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"]
                                                                                        style:UIBarButtonItemStylePlain
                                                                                       target:self action:@selector(onClickMenuButton)];
    
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-search"]
                                                                                        style:UIBarButtonItemStylePlain
                                                                                       target:self action:@selector(pushSearchViewController)];
    
    
    
    return navigationController;

}

-(void)addCenterButtonWithImage:(UIImage *)buttonImage
{
    _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGPoint origin = [self.view convertPoint:self.tabBar.center toView:self.tabBar];
    CGSize buttonSize = CGSizeMake(self.tabBar.frame.size.width / 5 - 6, self.tabBar.frame.size.height - 4);
    
    _centerButton.frame = CGRectMake(origin.x - buttonSize.height/2, origin.y - buttonSize.height/2, buttonSize.height, buttonSize.height);
    
    [_centerButton setCornerRadius:buttonSize.height/2];
    [_centerButton setBackgroundColor:[UIColor colorWithHex:0x24a83d]];
    [_centerButton setImage:buttonImage forState:UIControlStateNormal];
    [_centerButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:_centerButton];
}

#pragma mark - 处理点击事件


- (void)onTapOptionButton:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.view.tag) {
        case 0: {
            
            DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
            UINavigationController *t_vc = [[UINavigationController alloc] initWithRootViewController:detailVC];
            [self.selectedViewController presentViewController:t_vc animated:YES completion:nil];
            break;
        }
        case 1: {
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.allowsEditing = NO;
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
            
            break;
        }
        case 2: {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Device has no camera"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                
                [alertView show];
            } else {
                UIImagePickerController *imagePickerController = [UIImagePickerController new];
                imagePickerController.delegate = self;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.allowsEditing = NO;
                imagePickerController.showsCameraControls = YES;
                imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
            break;
        }
        case 3: {

            
            DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
            UINavigationController *t_vc = [[UINavigationController alloc] initWithRootViewController:detailVC];
            [self.selectedViewController presentViewController:t_vc animated:YES completion:nil];
            
            break;
        }
        case 4: {
            DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
            UINavigationController *t_vc = [[UINavigationController alloc] initWithRootViewController:detailVC];
            [self.selectedViewController presentViewController:t_vc animated:YES completion:nil];
            break;
        }
        case 5: {
            DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
            UINavigationController *t_vc = [[UINavigationController alloc] initWithRootViewController:detailVC];
            [self.selectedViewController presentViewController:t_vc animated:YES completion:nil];
            break;
        }
        default: break;
    }
    
    [self buttonPressed];
}

- (void)buttonPressed
{
    [self changeTheButtonStateAnimatedToOpen:_isPressed];
    
    _isPressed = !_isPressed;
}
- (void)changeTheButtonStateAnimatedToOpen:(BOOL)isPressed
{
    if (isPressed) {
        [self removeBlurView];
        
        [_animator removeAllBehaviors];
        for (int i = 0; i < 6; i++) {
            UIButton *button = _optionButtons[i];
            
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(_screenWidth/6 * (i%3*2+1),
                                                                                                      _screenHeight + 200 + i/3*100)];
            attachment.damping = 0.65;
            attachment.frequency = 4;
            attachment.length = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC * (6 - i)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    } else {
        [self addBlurView];
        
        [_animator removeAllBehaviors];
        for (int i = 0; i < 6; i++) {
            UIButton *button = _optionButtons[i];
            [self.view bringSubviewToFront:button];
            
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:button
                                                                         attachedToAnchor:CGPointMake(_screenWidth/6 * (i%3*2+1),
                                                                                                      _screenHeight - 200 + i/3*100)];
            attachment.damping = 0.65;
            attachment.frequency = 4;
            attachment.length = 1;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC * (i + 1)), dispatch_get_main_queue(), ^{
                [_animator addBehavior:attachment];
            });
        }
    }
}

- (void)addBlurView
{
    _centerButton.enabled = NO;
    
    if (nil == _blurView) {
        
        _blurView = [[UIImageView alloc] init];
        _blurView.frame = self.view.bounds;
        [_blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed)]];
        _blurView.userInteractionEnabled = YES;
    }
    
    UIImage *originalImage = [self.view updateBlur];
    UIImage *croppedBlurImage = [originalImage cropToRect:self.view.bounds];
    _blurView.image = croppedBlurImage;
    
    [self.view addSubview:_blurView];
    
    if (nil == _dimView) {
        _dimView = [[UIView alloc] initWithFrame:self.view.bounds];
        _dimView.backgroundColor = [UIColor whiteColor];
        _dimView.alpha = 0.8;
    }
    [self.view insertSubview:_dimView belowSubview:self.tabBar];
    
    
    [UIView animateWithDuration:0.25f
                     animations:nil
                     completion:^(BOOL finished) {
                         if (finished) {_centerButton.enabled = YES;}
                     }];
}


- (void)removeBlurView
{
    _centerButton.enabled = NO;
    
    self.view.alpha = 1;
    [UIView animateWithDuration:0.25f
                     animations:nil
                     completion:^(BOOL finished) {
                         if(finished) {
                             [_dimView removeFromSuperview];
                             [self.blurView removeFromSuperview];
                             _centerButton.enabled = YES;
                         }
                     }];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
    //UIImageWriteToSavedPhotosAlbum(edit, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [picker dismissViewControllerAnimated:NO completion:^{
        DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        UINavigationController *t_vc = [[UINavigationController alloc] initWithRootViewController:detailVC];
        [self.selectedViewController presentViewController:t_vc animated:YES completion:nil];
    }];
    
    
}

#pragma mark - UITabBarDelegate

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedItem"]) {
        if(self.isPressed) {[self buttonPressed];}
    }
}


- (void)onClickMenuButton
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)pushSearchViewController
{
    [self.navigationController pushViewController:[SearchViewController new] animated:YES];
}




@end
