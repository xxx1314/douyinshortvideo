# douyinshortvideo
主要实现短视频频播放列表（类似抖音，西瓜视频，主要是左右滑动）
用的播放器是七牛播放器，因为我们拍短视频就是用的七牛，储存资源也是用的七牛，所以就选择选用七牛播放器
MRLifeShowPlayerViewController是主要实现播放控制器
MRCustomizedPageControllerViewController是控制短视频列表滑动的控制器，主要使用WMPageController第三方
代码简单易懂，比较简便
主要的代码实现
//入口
MRCustomizedPageControllerViewController *videoListVC = [[MRCustomizedPageControllerViewController alloc] init];
    [self.navigationController pushViewController:videoListVC animated:YES];
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
    

#pragma mark ---- 初始化播放器
- (void) setupPlayer {
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@(kPLPLAY_FORMAT_MP4) forKey:PLPlayerOptionKeyVideoPreferFormat];
    // 更改需要修改的 option 属性键所对应的值
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
    [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
    [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
    [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
    //播放路径
    NSURL *videoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WAIWANG,_dataDic[@"videoUrl"]]];
    self.player = [PLPlayer playerWithURL:videoUrl option:option];
    self.player.playerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view insertSubview:self.player.playerView atIndex:0];
    self.player.delegateQueue = dispatch_get_main_queue();
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    self.player.delegate = self;
    self.player.loopPlay = YES;
    //预加载
    [self.player openPlayerWithURL:videoUrl];

}
