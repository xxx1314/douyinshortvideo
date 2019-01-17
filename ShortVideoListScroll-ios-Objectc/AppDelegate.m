//
//  AppDelegate.m
//  ShortVideoListScroll-ios-Objectc
//
//  Created by hello on 2019/1/15.
//  Copyright © 2019年 Hello. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import <WMPageController/WMPageController.h>

@interface AppDelegate ()<WMPageControllerDataSource>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

#pragma mark 返回一个WMPageController对象
- (WMPageController *) getPages {
    //WMPageController中包含的页面数组
    NSArray *controllers = [NSArray arrayWithObjects:[ViewController1 class], [ViewController2 class], nil];
    //WMPageController控件的标题数组
    NSArray *titles = [NSArray arrayWithObjects:@"体育新闻", @"娱乐新闻", nil];
    //用上面两个数组初始化WMPageController对象
    WMPageController *pageController = [[WMPageController alloc] initWithViewControllerClasses:controllers andTheirTitles:titles];
    pageController.dataSource = self;
    pageController.scrollEnable = NO;
    //设置WMPageController每个标题的宽度
    pageController.menuItemWidth = 100;
    //设置WMPageController标题栏的高度
    pageController.titleSizeNormal = 15;
    //设置WMPageController选中的标题的颜色
    pageController.titleColorSelected = [UIColor redColor];
    return pageController;
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, 0, 375-100,35);
}

- (CGRect)pageController:(nonnull WMPageController *)pageController preferredFrameForContentView:(nonnull WMScrollView *)contentView {
     return CGRectMake(0, 0, 375, 667);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
