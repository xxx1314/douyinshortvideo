//
//  MRCustomizedPageControllerViewController.m
//  Home
//
//  Created by licheng on 2018/12/14.
//  Copyright © 2018年 zyj. All rights reserved.
//

#import "MRCustomizedPageControllerViewController.h"
#import "MRLifeShowPlayerViewController.h"
#import "data.h"



@interface MRCustomizedPageControllerViewController ()
@property (nonatomic, strong) NSArray     *videos; //视频数据集合

@end

@implementation MRCustomizedPageControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.bounces = YES;
    self.cachePolicy =  WMPageControllerCachePolicyDisabled;
    //获取数据
    [self refreshData];
    
}



#pragma mark ---  WMPageControllerDataSource, WMPageControllerDelegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
     return self.videos.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    MRLifeShowPlayerViewController*playerController=  [[MRLifeShowPlayerViewController alloc] init];
    playerController.dataDic = [self.videos objectAtIndex:index];
    return playerController;
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectZero;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:                                                                                                                                                                                                                                                                                                                   (WMScrollView *)contentView {
    return CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    
}

//下载数据并且刷新
-(void)refreshData{
    self.videos = @[@{@"videoCoverUrl":@"image/eblog/20190116/56555_15476273930003858.jpg",@"videoUrl":@"video/eblog/20190116/56555_15476273950006365.mp4"},@{@"videoCoverUrl":@"image/eblog/20190116/56544_15476187790000781.jpg",@"videoUrl":@"video/eblog/20190116/56544_15476187790005097.mp4"},@{@"videoCoverUrl":@"image/eblog/20190116/56544_15476187510006254.jpg",@"videoUrl":@"video/eblog/20190116/56544_15476187520007837.mp4"},@{@"videoCoverUrl":@"image/eblog/20190116/56544_15476184220007135.jpg",@"videoUrl":@"video/eblog/20190116/56544_15476184230006026.mp4"},@{@"videoCoverUrl":@"image/eblog/20190116/12770_1547613716478w1x5.jpg",@"videoUrl":@"video/eblog/20190116/12770_1547613717012gwa8.mp4"},@{@"videoCoverUrl":@"image/eblog/20190116/12770_1547610694053of9o.jpg",@"videoUrl":@"video/eblog/20190116/12770_1547610695450cwn7.mp4"},@{@"videoCoverUrl":@"image/eblog/20190116/56544_15476053990000138.jpg",@"videoUrl":@"video/eblog/20190116/56544_15476054000007042.mp4"},@{@"videoCoverUrl":@"image/eblog/20190116/56544_15476053720003954.jpg",@"videoUrl":@""},@{@"videoCoverUrl":@"",@"videoUrl":@"video/eblog/20190116/56544_15476053730005735.mp4"},@{@"videoCoverUrl":@"image/eblog/20190116/56544_15476050290000071.jpg",@"videoUrl":@"video/eblog/20190116/56544_15476050300004890.mp4"},@{@"videoCoverUrl":@"image/eblog/20190116/56544_15476049960009600.jpg",@"videoUrl":@"video/eblog/20190116/56544_15476049960009924.mp4"}];
    [self reloadData];
}


@end
