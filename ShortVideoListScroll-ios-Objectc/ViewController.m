//
//  ViewController.m
//  ShortVideoListScroll-ios-Objectc
//
//  Created by hello on 2019/1/15.
//  Copyright © 2019年 Hello. All rights reserved.
//

#import "ViewController.h"
#import "data.h"
#import "MRCustomizedPageControllerViewController.h"
#import <WMPageController.h>
#import "ViewController2.h"
#import "ViewController1.h"

@interface ViewController ()<WMPageControllerDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [listButton setTitle:@"点击获取视频列表" forState:UIControlStateNormal];
    [listButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    listButton.backgroundColor = [UIColor redColor];
    listButton.frame = CGRectMake((SCREEN_WIDTH-200)/2, 100, 200, 40);
    [listButton addTarget:self action:@selector(videoList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listButton];
    
    UIButton *viewChangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewChangeButton setTitle:@"不同界面切换" forState:UIControlStateNormal];
    [viewChangeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    viewChangeButton.backgroundColor = [UIColor redColor];
    viewChangeButton.frame = CGRectMake((SCREEN_WIDTH-200)/2, 200, 200, 40);;
    viewChangeButton.center = self.view.center;
    [viewChangeButton addTarget:self action:@selector(viewChange) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewChangeButton];

}





#pragma mark --- videoList
- (void)videoList{
    MRCustomizedPageControllerViewController *videoListVC = [[MRCustomizedPageControllerViewController alloc] init];
    [self.navigationController pushViewController:videoListVC animated:YES];
}


#pragma mark -- viewChange
- (void)viewChange{
    NSArray *viewControllers = @[[ViewController1 class],[ViewController2 class]]; //需要注意，传入的是类名
    NSArray *titles = @[@"首页",@"推荐"];
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.dataSource = self;
    pageVC.titleColorSelected = [UIColor redColor];
    pageVC.menuItemWidth = SCREEN_WIDTH/titles.count;
    [self.navigationController pushViewController:pageVC animated:YES];
}


//内容容器大小
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,0 , SCREEN_WIDTH, SCREEN_HEIGHT);
}

//上面导航的大小
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,StatusBarHeight+44 , SCREEN_WIDTH, 40);
}

@end
