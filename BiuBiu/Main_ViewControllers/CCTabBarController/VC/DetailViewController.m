//
//  DetailViewController.m
//  ChuangTestDemo
//
//  Created by laixx on 15/8/21.
//  Copyright (c) 2015年 BaiRongSoft. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
- (IBAction)handleBackButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelButtonClicked
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"扫一扫";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
