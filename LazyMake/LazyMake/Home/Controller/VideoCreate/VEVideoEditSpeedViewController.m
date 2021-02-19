//
//  VEVideoEditSpeedViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVideoEditSpeedViewController.h"
#import "VECreateSpeedView.h"
#import "VECreateBottomFeaturesView.h"
#import "VECreateHUD.h"
#import "VEVideoSucceedViewController.h"
#import <AliyunPlayer/AliyunPlayer.h>

#define BOTTOM_VIEW_H 140
#define BTN_ALPHA 0.7f

@interface VEVideoEditSpeedViewController () <AVPDelegate>

@property (nonatomic, strong) LSOVideoOneDo *videoExecute;            //制作的对象
@property (nonatomic, strong) LSOVideoEditor *videoEditor;            //视频处理相关对象
@property (nonatomic, strong) NSString *srcVideoPath;                 //视频地址
@property (nonatomic, strong) VECreateHUD *hud;


//视频变速的相关view
@property (nonatomic, strong) VECreateSpeedView *sepView;             //视频变速调节的view
@property (nonatomic, strong) NSString *sepValue;                     //视频变速的value
@property (strong, nonatomic) UIButton *shadowBtn;                      //背景遮罩btn
@property (strong, nonatomic) UIButton *shadowNavBtn;                   //背景遮罩btn

@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) AliPlayer *player;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong)  UIButton *doneBtn;
@end

@implementation VEVideoEditSpeedViewController

- (void)dealloc{
    [self.player pause];
    [self.player stop];
    self.player = nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.player pause];
    self.playBtn.selected = YES;
    [self.hud hide];
    self.hud = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.hud = [[VECreateHUD alloc]init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    if (self.videoType == LMEditVideoTypeVideoSplice || self.videoType == LMEditVideoTypeVideoLattice) {
        self.title = @"预览";
    }else{
        self.title = @"编辑";
    }
    self.srcVideoPath = self.videoModel.videoAss.videoPath;
    [self.view addSubview:self.playView];
    [self.view addSubview:self.playBtn];
    [self.navigationController.navigationBar addSubview:self.shadowNavBtn];
    [self.view addSubview:self.shadowBtn];
    self.sepValue = @"1";
    [self createVideo];
    if (self.videoType == LMEditVideoTypeVideoSplice || self.videoType == LMEditVideoTypeVideoLattice) {
        [self createPreviewVideoSize];
    }else{
        [self createVideoSize];
        [self createSpeedBottomView];
        [self createDoneBtn];
    }
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
    [AliPlayer setEnableLog:NO];
    self.player = [[AliPlayer alloc] init];
    self.player.delegate = self;
    self.player.loop = YES;
    self.player.autoPlay = YES;
    self.player.scalingMode = AVP_SCALINGMODE_SCALEASPECTFILL;
    self.player.playerView = self.playView;
    
    AVPUrlSource *soucre = [[AVPUrlSource alloc]urlWithString:self.srcVideoPath];
    [self.player setUrlSource:soucre];
    [self.player prepare];
    [self.player start];
}

- (UIView *)playView{
    if (!_playView) {
        _playView = [UIView new];
        _playView.backgroundColor = [UIColor clearColor];
    }
    return _playView;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:nil forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"vm_icon_video"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(clickPalyBtb) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)shadowBtn{
    if (!_shadowBtn) {
        _shadowBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _shadowBtn.backgroundColor = [UIColor blackColor];
        _shadowBtn.alpha = 0.f;
        [_shadowBtn addTarget:self action:@selector(clickShadowBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shadowBtn;
}

- (UIButton *)shadowNavBtn{
    if (!_shadowNavBtn) {
        _shadowNavBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, -Height_StatusBar, kScreenWidth, Height_NavBar)];
        _shadowNavBtn.backgroundColor = [UIColor blackColor];
        _shadowNavBtn.alpha = 0.f;
        [_shadowNavBtn addTarget:self action:@selector(clickShadowBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shadowNavBtn;
}

- (void)clickShadowBtn{
}

- (void)clickPalyBtb{
    self.playBtn.selected = !self.playBtn.selected;
    if (self.playBtn.selected) {
        [self.player pause];
    }else{
        [self.player start];
    }
}

/// 变速底部按钮和替换背景音乐按钮
- (void)createSpeedBottomView{
    NSArray *titleArr = @[@"变速"];
    NSArray *imageArr = @[@"vm_detail_material_speed"];
    VECreateBottomFeaturesView *subV = [[VECreateBottomFeaturesView alloc]initWithFrame:CGRectMake(0, kScreenHeight - Height_SafeAreaBottom - BOTTOM_VIEW_H , self.view.width, BOTTOM_VIEW_H) titleArr:titleArr imageArr:imageArr];
    subV.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:subV];
    @weakify(self);
    subV.clickBtnBlock = ^(NSInteger btnTag) {
        @strongify(self);
        [self createSpeedView];
    };
}

/// 设置视频的宽高
- (void)createVideoSize{
    CGFloat bili = self.videoModel.videoSize.width/self.videoModel.videoSize.height;      //获取视频款高比
    CGFloat maxH = SCREENH_HEIGHT - Height_NavBar - BOTTOM_VIEW_H - Height_SafeAreaBottom - 30;
    CGFloat h = maxH;                       //获取当前设置屏幕上视频高度
    CGFloat w = h * bili;
    if (w > kScreenWidth - 30) {
        w = kScreenWidth - 30;
        h = w / bili;
    }
    self.videoModel.showVideoSize = CGSizeMake(w, h);
    CGFloat lR = (kScreenWidth - w) / 2;                                                                                //视频左右间距
    CGFloat top = Height_NavBar + 20;
    if (self.videoModel.videoSize.width > self.videoModel.videoSize.height) {
        top = Height_NavBar + 20 + ((maxH - h)/2);
    }
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.mas_equalTo(lR);
        make.right.mas_equalTo(-lR);
        make.height.mas_equalTo(h);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.mas_equalTo(lR);
        make.right.mas_equalTo(-lR);
        make.height.mas_equalTo(h);
    }];
}

- (void)createPreviewVideoSize{
    CGFloat bili = self.videoModel.videoSize.width/self.videoModel.videoSize.height;      //获取视频款高比
    CGFloat maxH = SCREENH_HEIGHT - Height_NavBar - Height_SafeAreaBottom - 40;
    CGFloat h = maxH;                       //获取当前设置屏幕上视频高度
    CGFloat w = h * bili;
    if (w > kScreenWidth) {
        w = kScreenWidth;
        h = w / bili;
    }
    self.videoModel.showVideoSize = CGSizeMake(w, h);
    CGFloat lR = (kScreenWidth - w) / 2;                                                                                //视频左右间距
    CGFloat top = Height_NavBar + 20;
    if (self.videoModel.videoSize.width > self.videoModel.videoSize.height) {
        top = Height_NavBar + 20 + ((maxH - h)/2);
    }
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.mas_equalTo(lR);
        make.right.mas_equalTo(-lR);
        make.height.mas_equalTo(h);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.mas_equalTo(lR);
        make.right.mas_equalTo(-lR);
        make.height.mas_equalTo(h);
    }];
}

/// 视频变速调节的view
- (void)createSpeedView{
    if (!self.sepView) {
        self.sepView = [[VECreateSpeedView alloc]initWithFrame:CGRectMake(0, kScreenHeight+20, kScreenWidth, BOTTOM_VIEW_H)];
        self.sepView.backgroundColor = self.view.backgroundColor;
        [self.view addSubview:self.sepView];
    }
    self.sepView.hidden = NO;
    self.sepView.speValue = self.sepValue;
    [UIView animateWithDuration:0.2 animations:^{
        self.sepView.frame = CGRectMake(0, kScreenHeight - Height_SafeAreaBottom - BOTTOM_VIEW_H, kScreenWidth, BOTTOM_VIEW_H);
        self.shadowNavBtn.alpha = BTN_ALPHA;
        self.shadowBtn.alpha = BTN_ALPHA;
    }];

    @weakify(self);
    self.sepView.clickBtnBlock = ^(BOOL ifSucceed, NSString * _Nonnull selectStr) {
        @strongify(self);
        self.doneBtn.userInteractionEnabled = YES;
        if (ifSucceed) {
            self.sepValue = selectStr;
        }else{
            self.player.rate = self.sepValue.floatValue;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.sepView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, BOTTOM_VIEW_H);
            self.shadowNavBtn.alpha = 0;
            self.shadowBtn.alpha = 0;
        }completion:^(BOOL finished) {
            self.sepView.hidden = YES;
        }];
    };
    
    self.sepView.changeValueBlock = ^(CGFloat changeF) {
        @strongify(self);
        self.player.rate = changeF;
    };
}

/// 视频加减速 先增加水印，然后加减速
- (void)createVideoChangeSpeed{
    if (self.sepValue.length > 0) {
        self.doneBtn.userInteractionEnabled = NO;
        self.hud=[[VECreateHUD alloc] init];
        self.videoExecute=[[LSOVideoOneDo alloc] initWithNSURL:[LSOFileUtil filePathToURL:self.srcVideoPath]];
        if ([LMUserManager sharedManger].userInfo.vipState.intValue != 1) {
            [self.videoExecute setUIView:[self addTextLogoWithSize:CGSizeMake(self.videoModel.videoAss.width, self.videoModel.videoAss.height)]];
        }
        @weakify(self);
         [self.videoExecute setVideoProgressBlock:^(CGFloat currentFramePts, CGFloat percent) {
             @strongify(self);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.hud showProgress:[NSString stringWithFormat:@"制作中%d%%",(int)(percent/2*100)] par:percent/2];
             });
         }];
         
        [self.videoExecute setCompletionBlock:^(NSString * _Nonnull video) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
               //开始加减速
                self.videoEditor=[[LSOVideoEditor alloc] init];
                [self.hud showProgress:[NSString stringWithFormat:@"制作中50%%"] par:0.5];
                [self.videoEditor setProgressBlock:^(int percent) {
                    @strongify(self);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (percent > 0) {
                            float x = (percent/2+50);
                            float par = x/100;
                            [self.hud showProgress:[NSString stringWithFormat:@"制作中%d%%",percent/2+50] par:par];
                        }
                    });
                }];

                [self.videoEditor setCompletionBlock:^(NSString *dstPath) {
                    @strongify(self);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self createSueeccd:dstPath];
                    });
                }];
                [self.videoEditor startAdjustVideoSpeed:video speed:self.sepValue.floatValue];
            });
        }];
        [self.videoExecute start];
    }else{
        [self createSpeedView];
    }
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

/// 制作完成
- (void)createSueeccd:(NSString *)videoPath{
    [MBProgressHUD hideHUD];
    [self.hud hide];
    self.doneBtn.userInteractionEnabled = YES;
    VEVideoSucceedViewController *vc = [[VEVideoSucceedViewController alloc]init];
    vc.videoPath = videoPath;
    vc.videoSize = self.videoModel.videoSize;
    [self.navigationController pushViewController:vc animated:YES];
    LMLog(@"dstPath ==== %@",videoPath);
}

#pragma mark - AVPDelegate
- (void)onPlayerEvent:(AliPlayer *)player eventType:(AVPEventType)eventType{
    switch (eventType) {
            case AVPEventPrepareDone: {
                // 准备完成
            }
                break;
            case AVPEventAutoPlayStart:
                // 自动播放开始事件
                break;
            case AVPEventFirstRenderedStart:
                // 首帧显示
                self.playView.hidden = NO;
                break;
            case AVPEventCompletion:
                // 播放完成
                break;
            case AVPEventLoadingStart:
                // 缓冲开始
            LMLog(@"缓冲开始");
                break;
            case AVPEventLoadingEnd:
                // 缓冲完成
            LMLog(@"缓冲完成");
                break;
            case AVPEventSeekEnd:
                // 跳转完成
                break;
            case AVPEventLoopingStart:
                // 循环播放开始
                break;
            default:
                break;
        }
}

- (void)onError:(AliPlayer*)player errorModel:(AVPErrorModel *)errorModel{
    LMLog(@"=======%@",errorModel);
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
