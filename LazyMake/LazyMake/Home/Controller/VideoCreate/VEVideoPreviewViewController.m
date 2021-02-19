//
//  VEVideoPreviewViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/21.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVideoPreviewViewController.h"
#import "VECreateHUD.h"
#import "VEVideoSucceedViewController.h"
#import <AliyunPlayer/AliyunPlayer.h>
#import "VEVideoSpliceChangeView.h"
#import "VEVideoSucceedViewController.h"
#import "VEVideoEditViewController.h"
#define BOTTOM_VIEW_H 150
#define BTN_ALPHA 0.7f

@interface VEVideoPreviewViewController ()

@property (nonatomic, strong) NSString *srcVideoPath;                 //视频地址
@property (nonatomic, strong) VECreateHUD *hud;
@property (strong, nonatomic) VEVideoSpliceChangeView *changeView;

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, assign) CGSize videoSize;
@property (nonatomic, assign) NSInteger playIndex;                  //播放的下标
@property (nonatomic, strong) DrawPadConcatVideoExecute *videoExecute;   //制作的对象
@property (nonatomic, assign) NSInteger cropIndex;                  //裁剪视频的下标

@property (strong, nonatomic) AVPlayer *myPlayer;//播放器
@property (strong, nonatomic) AVPlayerItem *item;//播放单元
@property (strong, nonatomic) AVPlayerLayer *playerLayer;//播放界面（layer）
@property (assign, nonatomic) BOOL hasNow;              //是否在当前页面

@end

@implementation VEVideoPreviewViewController

- (void)dealloc{
    [self.myPlayer pause];
    [self.myPlayer.currentItem cancelPendingSeeks];
    [self.myPlayer.currentItem.asset cancelLoading];
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer=nil;
    self.myPlayer = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.hasNow = NO;
    [self.myPlayer pause];
    self.playBtn.selected = YES;
    self.changeView.playBtn.selected = NO;
    [self.hud hide];
    self.hud = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.hasNow = YES;
    self.hud = [[VECreateHUD alloc]init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    self.title = @"编辑";
    [self.view addSubview:self.changeView];
    [self createVideo];
    [self createDoneBtn];
    [self.view addSubview:self.playBtn];
    // Do any additional setup after loading the view.
}

- (void)createDoneBtn{
    self.doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 26)];
     [self.doneBtn setTitle:@"完成" forState:UIControlStateNormal];
     UIImage *image = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(60, 26)];
     [self.doneBtn setBackgroundImage:image forState:UIControlStateNormal];
     [self.doneBtn addTarget:self action:@selector(createVideoChangeSpeed) forControlEvents:UIControlEventTouchUpInside];
    self.doneBtn.layer.masksToBounds = YES;
    self.doneBtn.layer.cornerRadius = 13;
    self.doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *searchBtnBar = [[UIBarButtonItem alloc]initWithCustomView:self.doneBtn];
     self.navigationItem.rightBarButtonItem = searchBtnBar;
}

- (void)createVideo{
    NSInteger second = 0;
    for (int x = 0; x < self.dataArr.count; x++) {
        VESelectVideoModel *subModel = self.dataArr[x];
        second += subModel.second;
    }
    self.changeView.secondAll = second;
    
    if (self.dataArr.count > 0) {
        VESelectVideoModel *subModel = self.dataArr[0];
        
        NSURL *mediaURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",subModel.videoUrl]];
        self.item = [AVPlayerItem playerItemWithURL:mediaURL];
        self.myPlayer = [AVPlayer playerWithPlayerItem:self.item];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
        self.playerLayer.frame = [self createVideoSize];
        self.playerLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self.view.layer addSublayer:self.playerLayer];
        [self.myPlayer play];
        // 添加视频播放结束通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        @weakify(self);
        [self.myPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:NULL usingBlock:^(CMTime time) {
            @strongify(self);
              //进度 当前时间/总时间
//              CGFloat progress = CMTimeGetSeconds(self.myPlayer.currentItem.currentTime) / CMTimeGetSeconds(self.myPlayer.currentItem.duration);
//              LMLog(@"===progressprogress====%.2f",CMTimeGetSeconds(self.myPlayer.currentItem.currentTime));
            NSInteger timeS = CMTimeGetSeconds(self.myPlayer.currentItem.currentTime);
            if (timeS > 0) {
                if (self.dataArr.count > self.playIndex) {
                    NSInteger allTime = timeS;
                    if (self.playIndex > 0) {
                        for (int x = 0; x < self.playIndex; x++) {
                            VESelectVideoModel *subModel = self.dataArr[x];
                            allTime += subModel.second;
                        }
                    }
                    [self.changeView changePlayTimeSchedule:allTime];
                  }
              }
          }];
    }
}

- (void)moviePlayDidEnd:(NSNotification *)notifi{
    if (!self.hasNow) {
        return;
    }
    self.playIndex ++;
    if (self.dataArr.count <= self.playIndex) {
        self.playIndex = 0;
    }
    VESelectVideoModel *subModel = self.dataArr[self.playIndex];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:subModel.videoUrl]];
    [self.myPlayer replaceCurrentItemWithPlayerItem:item];
    [self.myPlayer play];
    if (self.playIndex == 0) {
        [self.changeView changePlayTimeSchedule:0];
    }
    [self.changeView changeSelectIndex:self.playIndex];
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [[UIButton alloc]initWithFrame:[self createVideoSize]];
        [_playBtn setImage:nil forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"vm_icon_video"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(clickPalyBtb) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (VEVideoSpliceChangeView *)changeView{
    if (!_changeView) {
        _changeView = [[VEVideoSpliceChangeView alloc]initWithFrame:CGRectMake(20, kScreenHeight-BOTTOM_VIEW_H-Height_SafeAreaBottom, kScreenWidth-(20*2), BOTTOM_VIEW_H)];
        _changeView.dataArr = self.dataArr;
        _changeView.backgroundColor = self.view.backgroundColor;
        @weakify(self);
        _changeView.clickCellItemBlock = ^(NSInteger index) {
            @strongify(self);
            if (self.dataArr.count > index) {
                self.playIndex = index;
                self.playBtn.selected = NO;
                self.changeView.playBtn.selected = YES;
                VESelectVideoModel *subModel = self.dataArr[index];
                AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:subModel.videoUrl]];
                [self.myPlayer replaceCurrentItemWithPlayerItem:item];
                [self.myPlayer play];
                NSInteger allTime = 0;
                if (self.playIndex > 0) {
                    for (int x = 0; x < self.playIndex; x++) {
                        VESelectVideoModel *subModel = self.dataArr[x];
                        allTime += subModel.second;
                    }
                }
                [self.changeView changePlayTimeSchedule:allTime];
            }
        };
        
        _changeView.clickPlayBtnBlock = ^(BOOL ifPlay) {
            @strongify(self);
            if (ifPlay) {
                self.playBtn.selected = NO;
                [self.myPlayer play];
            }else{
                self.playBtn.selected = YES;
                [self.myPlayer pause];
            }
        };
        
        _changeView.clickCropBtnBlock = ^(NSInteger index) {
            @strongify(self);
            [self pushCropVCWithIndex:index];
        };
        
        _changeView.moveCellBlock = ^(UIGestureRecognizerState moveState) {
            @strongify(self);
            if (moveState == UIGestureRecognizerStateBegan) {
                [self.myPlayer pause];
                self.playBtn.selected = YES;
                self.changeView.playBtn.selected = NO;
            }else{
                [self.myPlayer play];
                self.playBtn.selected = NO;
                self.changeView.playBtn.selected = YES;
            }
        };
        
        _changeView.changeDataArrNumberBlock = ^(NSArray * _Nonnull dataChangeArr) {
            @strongify(self);
            self.dataArr = [NSMutableArray arrayWithArray:dataChangeArr];
            for (int x = 0; x < dataChangeArr.count; x++) {
                VESelectVideoModel *subModel = dataChangeArr[x];
                if (subModel.ifSelect) {
                    self.playIndex = x;
                    break;
                }
            }
        };
    }
    return _changeView;
}

- (void)clickPalyBtb{
    self.playBtn.selected = !self.playBtn.selected;
    if (self.playBtn.selected) {
        [self.myPlayer pause];
        self.changeView.playBtn.selected = NO;
    }else{
        [self.myPlayer play];
        self.changeView.playBtn.selected = YES;
    }
}

- (void)pushCropVCWithIndex:(NSInteger)index{
    VEVideoEditViewController *VC = [[VEVideoEditViewController alloc]init];
    VC.videoModel = self.dataArr[index];
    VC.videoType = LMEditVideoTypeSelect;
    VC.ifSplice = YES;
    self.cropIndex = index;
    self.playIndex = index;
    [self.navigationController pushViewController:VC animated:YES];
    
    [self.myPlayer pause];
    self.playBtn.selected = YES;
    self.changeView.playBtn.selected = NO;
    @weakify(self);
    VC.dismissSelectBlock = ^(VESelectVideoModel * _Nonnull videoModel, NSString * _Nonnull videoPath) {
        @strongify(self);
        LSOVideoAsset *videoAss = [[LSOVideoAsset alloc] initWithPath:videoPath];
        UIImage *image = [LSOVideoAsset getVideoImageimageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",videoPath]]];
        if (self.dataArr.count > self.cropIndex) {
            VESelectVideoModel *model = self.dataArr[self.cropIndex];
            model.showImage = image;
            model.videoAss = videoAss;
            model.videoUrl = [NSString stringWithFormat:@"file://%@",videoPath];
            model.second = videoAss.duration;
            
            NSInteger second = 0;
            for (int x = 0; x < self.dataArr.count; x++) {
                VESelectVideoModel *subModel = self.dataArr[x];
                second += subModel.second;
            }
            self.changeView.secondAll = second;

            AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.videoUrl]];
            [self.myPlayer replaceCurrentItemWithPlayerItem:item];
            [self.myPlayer play];
            self.playBtn.selected = NO;
            self.changeView.playBtn.selected = YES;
        }
    };
}

/// 设置视频的宽高  1080  1920
- (CGRect)createVideoSize{
    self.videoSize = CGSizeMake(1920, 1080);
    BOOL hasDone = NO;      //如果有竖屏视频
    for (VESelectVideoModel *subModel in self.dataArr) {
        if (subModel.videoSize.width < subModel.videoSize.height) {
            self.videoSize = CGSizeMake(1080, 1920);
            hasDone = YES;
        }
    }
    //如果没有竖屏视频，判断有没有方形视频
    if (hasDone == NO) {
        for (VESelectVideoModel *subModel in self.dataArr) {
            if (subModel.videoSize.width == subModel.videoSize.height) {
                self.videoSize = CGSizeMake(1080, 1080);
            }
        }
    }
    
    CGFloat bili = self.videoSize.width/self.videoSize.height;      //获取视频款高比
    CGFloat maxH = SCREENH_HEIGHT - Height_NavBar - BOTTOM_VIEW_H - Height_SafeAreaBottom - 30;
    CGFloat h = maxH;                       //获取当前设置屏幕上视频高度
    CGFloat w = h * bili;
    if (w > kScreenWidth - 30) {
        w = kScreenWidth - 30;
        h = w / bili;
    }

    CGFloat lR = (kScreenWidth - w) / 2;                                                                                //视频左右间距
    CGFloat top = Height_NavBar + 20;
    if (self.videoSize.width > self.videoSize.height) {
        top = Height_NavBar + 20 + ((maxH - h)/2);
    }
    
    return CGRectMake(lR, top, w, h);
}

/// 视频合成
- (void)createVideoChangeSpeed{
    [self.myPlayer pause];
    self.playBtn.selected = YES;
    self.changeView.playBtn.selected = NO;
    
    NSMutableArray *urlArr = [NSMutableArray new];
    for (int x = 0; x < self.dataArr.count; x++) {
        VESelectVideoModel *model = self.dataArr[x];
        NSURL *url = [NSURL URLWithString:model.videoUrl];
        [urlArr addObject:url];
    }
    self.videoExecute = [[DrawPadConcatVideoExecute alloc] initWithURLArray:urlArr drawPadSize:self.videoSize];
    self.hud=[[VECreateHUD alloc] init];
    [self.hud showProgress:[NSString stringWithFormat:@"制作中0%%"] par:0];

    @weakify(self);
    [self.videoExecute setProgressBlock:^(CGFloat progess,CGFloat percent) {
        @strongify(self);
        NSLog(@"initWithURLArray  is :%f, percent:%f",progess,percent);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud showProgress:[NSString stringWithFormat:@"进度:%d%%",(int)(percent*100)] par:percent];
        });
    }];
  
    //增加水印
    if ([LMUserManager sharedManger].userInfo.vipState.intValue != 1) {
        [self.videoExecute addViewPen:[self addTextLogoWithSize:CGSizeMake(self.videoSize.width, self.videoSize.height)]];
    }

    [self.videoExecute setCompletionBlock:^(NSString *dstPath) {
    @strongify(self);
      dispatch_async(dispatch_get_main_queue(), ^{
          [self createSueeccd:dstPath];
      });
  }];
    [self.videoExecute start];
}

/// 制作完成
- (void)createSueeccd:(NSString *)videoPath{
    self.doneBtn.userInteractionEnabled = YES;
    [MBProgressHUD hideHUD];
    [self.hud hide];
    VEVideoSucceedViewController *vc = [[VEVideoSucceedViewController alloc]init];
    vc.videoPath = videoPath;
    vc.videoSize = self.videoSize;
    [self.navigationController pushViewController:vc animated:YES];
    LMLog(@"dstPath ==== %@",videoPath);
}

/// 增加水印logo
-(UIView *)addTextLogoWithSize:(CGSize)videoSize{
    int bitmapWidth = videoSize.width * 3 / 7;
    int bitmapHeight = bitmapWidth * 40 / 130;
    
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, videoSize.width,videoSize.height)];
    rootView.backgroundColor = [UIColor clearColor];
    UIImage *image = [UIImage imageNamed:@"watermark_custom_blue"];
    UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, videoSize.height - bitmapHeight - 2, bitmapWidth, bitmapHeight);
    imageView.backgroundColor = [UIColor clearColor];
    [rootView addSubview:imageView];
    return rootView;
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
