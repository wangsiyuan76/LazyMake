//
//  VEAudioCropViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/13.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEAudioCropViewController.h"
#import <AliyunPlayer/AliyunPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <LanSongFFmpegFramework/LanSongFFmpeg.h>
#import "VEAudioCropView.h"

@interface VEAudioCropViewController () <AVPDelegate,AVAudioPlayerDelegate>

@property (strong, nonatomic) VEAudioCropView *audioCropView;           //配乐裁剪view
@property (strong, nonatomic) UIButton *doneBtn;                        //完成按钮
@property (nonatomic, strong) UIView *playView;                         //视频播放器
@property (nonatomic, strong) AliPlayer *player;                        //视频播放器
@property (nonatomic, strong) UIButton *playBtn;                        //视频播放器播放按钮
@property (strong, nonatomic) AVAudioPlayer * __nullable audioPlayer;        //播放音乐的player

@property (nonatomic, assign) NSInteger beginTime;
@property (nonatomic, assign) double endTime;
@property (nonatomic, strong) NSString *cropUrl;                        //音频裁剪后的地址


@end

@implementation VEAudioCropViewController

- (void)dealloc{
    [self.player pause];
    [self.player stop];
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    self.player = nil;
    LMLog(@"VEAudioCropViewController 页面释放");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    self.title = @"剪裁配乐";
    [self.view addSubview:self.playView];
    [self.view addSubview:self.audioCropView];
    [self.view addSubview:self.playBtn];
    self.cropUrl = self.audioPath;
    self.endTime = self.audioDur;
    [self createVideo];
    [self createDoneBtn];
    
    if (self.hasOut) {
        NSString *changeAudilUrl = self.videoOutPath;
        if ([self.videoOutPath containsString:@"file://"]) {
            changeAudilUrl = [self.videoOutPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        }
        NSString *audioUrl = [LSOVideoEditor executeGetAudioTrack:changeAudilUrl];
        self.audioPath = audioUrl;
        self.cropUrl = audioUrl;
        [self createAudioPlayer];
    }else{
        NSString *str =  [LSOVideoEditor executeAudioCutOut:self.audioPath startS:0 duration:self.endTime];
        self.cropUrl = str;
        [self createAudioPlayer];
    }
    // Do any additional setup after loading the view.
}

- (void)createVideo{
    [AliPlayer setEnableLog:NO];
    self.player = [[AliPlayer alloc] init];
    self.player.delegate = self;
    self.player.loop = YES;
    self.player.autoPlay = YES;
    self.player.scalingMode = AVP_SCALINGMODE_SCALEASPECTFILL;
    self.player.playerView = self.playView;
    self.player.volume = 0;
    self.player.muted = YES;
    
    AVPUrlSource *soucre = [[AVPUrlSource alloc]urlWithString:self.videoPath];
    [self.player setUrlSource:soucre];
    [self.player prepare];
    [self.player start];
}

- (UIView *)playView{
    if (!_playView) {
        _playView = [[UIView alloc]initWithFrame:self.videoFrame];
        _playView.backgroundColor = [UIColor redColor];
    }
    return _playView;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [[UIButton alloc]initWithFrame:self.videoFrame];
        [_playBtn setImage:nil forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"vm_icon_video"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(clickPalyBtb) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

//音乐裁剪的view
- (VEAudioCropView *)audioCropView{
    if (!_audioCropView) {
        CGFloat top = kScreenHeight - Height_SafeAreaBottom-[VEAudioCropView viewHeight];
        _audioCropView = [[VEAudioCropView alloc]initWithFrame:CGRectMake(0,top , kScreenWidth, [VEAudioCropView viewHeight])];
        _audioCropView.backgroundColor = self.view.backgroundColor;
        _audioCropView.allTime = self.audioDur;
        [_audioCropView hiddenTitleView];

        @weakify(self);
        _audioCropView.changeSelectTimeBlock = ^(NSInteger beginTime, NSInteger endTime, NSInteger continuedTime, BOOL ifLeft) {
            @strongify(self);
            self.beginTime = beginTime;
            if (!ifLeft) {
                self.endTime = endTime;
            }
            //防止音乐时长有小数，造成裁剪不全的情况
            if (self.endTime > self.audioDur) {
                self.endTime = self.audioDur;
            }else{
                int dur = self.audioDur;
                if (self.endTime == dur) {
                    self.endTime = self.audioDur;
                }
            }
            NSString *str =  [LSOVideoEditor executeAudioCutOut:self.audioPath startS:beginTime duration:self.endTime-beginTime];
            self.cropUrl = str;
            [self createAudioPlayer];
        };
    }
    return _audioCropView;
}

- (void)createDoneBtn{
    self.doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 26)];
     [self.doneBtn setTitle:@"完成" forState:UIControlStateNormal];
     UIImage *image = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(60, 26)];
     [self.doneBtn setBackgroundImage:image forState:UIControlStateNormal];
     [self.doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.doneBtn.layer.masksToBounds = YES;
    self.doneBtn.layer.cornerRadius = 13;
    self.doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
     UIBarButtonItem *searchBtnBar = [[UIBarButtonItem alloc]initWithCustomView:self.doneBtn];
     self.navigationItem.rightBarButtonItem = searchBtnBar;
}

//初始化音乐播放器
- (void)createAudioPlayer{
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:self.cropUrl] error:nil];
    self.audioPlayer.delegate = self;
    self.audioPlayer.volume = 1;

    // 设置循环次数，-1为一直循环
    self.audioPlayer.numberOfLoops = 1;
    // 准备播放
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}


- (void)clickPalyBtb{
    self.playBtn.selected = !self.playBtn.selected;
    if (self.playBtn.selected) {
        [self.player pause];
        [self.audioPlayer pause];
    }else{
        [self.player start];
        [self.audioPlayer play];
    }
}

- (void)doneBtnClick{
    NSInteger index = (NSInteger)[[self.navigationController viewControllers] indexOfObject:self];
    if (index > 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    BOOL ifAddF = YES;
    if (!self.ifAddF) {
        if ([self.cropUrl isEqualToString:self.audioPath]) {
            ifAddF = NO;
        }
    }
    if (self.cropAudioBlock) {
        self.cropAudioBlock(self.cropUrl,ifAddF);
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    LMLog(@"===endTime=播放完成==");
    [self.audioPlayer play];
}

#pragma mark - AVPDelegate
- (void)onPlayerEvent:(AliPlayer *)player eventType:(AVPEventType)eventType{
    //从头开始播放
    if (eventType == AVPEventLoopingStart) {
        LMLog(@"===AVPEventLoopingStart=播放完成==");
        self.audioPlayer.currentTime = 0;
        [self.audioPlayer play];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
