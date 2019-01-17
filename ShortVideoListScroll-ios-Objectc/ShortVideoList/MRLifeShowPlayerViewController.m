//
//  MRLifeShowPlayerViewController.m
//  Home
//
//  Created by hello on 2018/11/7.
//  Copyright © 2018年 zyj. All rights reserved.
//

#import "MRLifeShowPlayerViewController.h"
#import "data.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import <UIImageView+WebCache.h>



@interface MRLifeShowPlayerViewController ()<PLPlayerDelegate>

@property (nonatomic, strong) UIImageView  *thumbImageView; //视频封
//播放器
@property (nonatomic, strong) PLPlayer *player;
//创建播放进度定时器
@property (nonatomic, strong) dispatch_source_t progressTimer;
//进度条
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation MRLifeShowPlayerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];

    //监听这个方法非活跃状态，判断APP当前状态，如果是从活跃状态进入switcher页面，则不进行信息保护
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationResignActive:) name:@"UIApplicationWillResignActiveNotification" object:nil];
    
    //封面
    self.thumbImageView = [[UIImageView alloc] init];
    self.thumbImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.thumbImageView];
    [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WAIWANG,_dataDic[@"videoCoverUrl"]]]];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-1, SCREEN_WIDTH, 1)];
    progressView.tintColor = [UIColor redColor];
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    //播放器创建
    [self setupPlayer];
    
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

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
}



#pragma mark ---- 停止播放器
- (void)stop {
    [self.player stop];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if(_progressTimer){
        dispatch_source_cancel(_progressTimer);
        _progressTimer = nil;
    }
    [self stop];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIApplicationWillResignActiveNotification" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.player.isPlaying) {
        [self.player play];
    }
}

#pragma mark --- PLPlayerDelegate
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state{
    if(PLPlayerStatusReady == state){
//        准备播放创建定时器
        [self createProgressTimer];
    }
}

- (void)player:(PLPlayer *)player stoppedWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenHUD" object:nil];
    //显示错误信息，播放器因错误停止播放
    NSString *info = error.userInfo[@"NSLocalizedDescription"];
    NSLog(@"%@",info);
    
}


- (void)player:(nonnull PLPlayer *)player firstRender:(PLPlayerFirstRenderType)firstRenderType {
    //获取到视频第一帧
    if (PLPlayerFirstRenderTypeVideo == firstRenderType) {
        //do thing
         self.thumbImageView.hidden = YES;
    }
}

//进入后台
- (void)playerWillBeginBackgroundTask:(nonnull PLPlayer *)player{
    [player pause];
}

//进入前台
- (void)playerWillEndBackgroundTask:(nonnull PLPlayer *)player{
    [player resume];
}

//进入不活跃状态，（后台或者双击home）
- (void)applicationResignActive:(UIApplication *)application {
    [self.player pause];
}


#pragma mark --- 定时器
- (void)createProgressTimer{
    JzZWeakSelf;
    //定时器
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    创建定时器,本身也是个oc对象,必须设置为全局，不然已创建就销毁了，所以要保存下来
    _progressTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //控制计时器第一次触发的时刻，延迟0s
    dispatch_time_t strat = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);
    //每隔多长时间执行一次
    dispatch_source_set_timer(_progressTimer, strat, 0.1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_progressTimer, ^{
        if (CMTimeGetSeconds(weakSelf.player.totalDuration)) {
            float total = CMTimeGetSeconds(weakSelf.player.totalDuration);
            float current = CMTimeGetSeconds(weakSelf.player.currentTime);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.progressView.progress = current/total;
            });
        }
    });
    dispatch_resume(self.progressTimer);    
}






@end
