//
//  AppDelegate.m
//  BiuBiu
//
//  Created by laixx on 15/9/16.
//  Copyright (c) 2015年 BBSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "BBTabBarController.h"
#import "SideMenuViewController.h"
#import <RESideMenu/RESideMenu.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    BBTabBarController *VC = [[BBTabBarController alloc] init];
    SideMenuViewController *sideMenuVC = [[SideMenuViewController alloc] initWithNibName:@"SideMenuViewController" bundle:nil];
    UINavigationController *leftMenuVC = [[UINavigationController alloc] initWithRootViewController:sideMenuVC];
    RESideMenu *sideMenuTabBarViewController = [[RESideMenu alloc] initWithContentViewController:VC leftMenuViewController:leftMenuVC rightMenuViewController:nil];
    
    sideMenuTabBarViewController.scaleContentView = YES;
    sideMenuTabBarViewController.contentViewScaleValue = 0.95;
    sideMenuTabBarViewController.scaleMenuView = NO;
    sideMenuTabBarViewController.contentViewShadowEnabled = YES;
    sideMenuTabBarViewController.contentViewShadowRadius = 4.5;
    self.window.rootViewController = sideMenuTabBarViewController;

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
  
}

@end
