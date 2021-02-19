//
//  VEVideoEditViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/16.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVideoEditViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SJVideoPlayView.h"
#import "SJVideoCropView.h"
#import "SJMediaInfoConfig.h"
#import "UIView+SJExtension.h"
#import "SJCommon.h"
#import "VECreateVideoDirectionView.h"
#import "VEVideoSucceedViewController.h"
#import "VECreateBottomFeaturesView.h"
#import "VECreateSpeedView.h"
#import "VESelectVideoCoverView.h"
#import "VEAddCoverMainView.h"
#import "VECreateHUD.h"
#import "HFDraggableView.h"
#import "VEAudioCropView.h"
#import "VESaveAudioView.h"
#import "VEAudioModel.h"
#import "VEAudioChangeSizeView.h"
#import "VEMediaListController.h"
#import <LanSongFFmpegFramework/LSOMediaInfo.h>

#import <CallKit/CallKit.h>
#import <CoreServices/CoreServices.h>
#import "VESelectVideoController.h"

#define BOTTOM_VIEW_H 140
#define BTN_ALPHA 0.7f

@interface VEVideoEditViewController () <SJVideoCropViewDelegate,SJVideoPlayViewDelegate,AVAudioPlayerDelegate,CXCallObserverDelegate>

@property (nonatomic, strong) SJVideoPlayView *palyView;
@property (nonatomic, strong) id timeObserver;
@property (nonatomic, strong) NSURL *localVideoUrl;
@property (nonatomic, strong) SJMediaInfoConfig *mediaConfig;
@property (nonatomic, strong) SJVideoCropView *cropView;              //裁剪的底部的view

@property (nonatomic, strong) LSOVideoOneDo *videoExecute;            //制作的对象
@property (nonatomic, strong) LSOVideoEditor *videoEditor;            //视频处理相关对象
@property (nonatomic, strong) NSString *srcVideoPath;                 //视频地址
@property (nonatomic, strong) VECreateHUD *hud;

//增加封面相关view
@property (nonatomic, strong) VESelectVideoCoverView *coverBottomView;
@property (nonatomic, strong) VEAddCoverMainView *coverMainView;
@property (nonatomic, strong) UIImageView *videoCoverImage;
@property (nonatomic, assign) CGRect coverFrame;
@property (nonatomic, strong) UIImage *coverImage;

//视频去水印和页面裁剪的view
@property (nonatomic, strong) UIView *mainHfView;
@property (nonatomic, strong) HFDraggableView *hfView;

//视频提取音乐的相关操作
@property (strong, nonatomic) VEAudioCropView *audioCropView;           //配乐裁剪view
@property (strong, nonatomic) VESaveAudioView *saveAudioView;           //保存配乐的view
@property (strong, nonatomic) VEAudioModel *audioModel;                 //配乐相关model
@property (assign, nonatomic) BOOL showSaveView;                        //是否有弹出保存音频的view

//替换背景音乐相关操作
@property (strong, nonatomic) VEAudioChangeSizeView  *audioSizeView;    //调整声音大小的view
@property (strong, nonatomic) AVAudioPlayer * __nullable player;        //播放音乐的player
@property (assign, nonatomic) BOOL showSelectF;                         //是否有弹出view
@property (strong, nonatomic) UIButton *shadowBtn;                      //背景遮罩btn
@property (strong, nonatomic) UIButton *shadowNavBtn;                   //背景遮罩btn
@property (strong, nonatomic) UIButton *doneBtn;                        //完成按钮
@property (assign, nonatomic) BOOL ifPushSelectMusic;                   //是否要跳转到选择音乐页面
@property (assign, nonatomic) CGRect cropRect;                          //视频裁剪的尺寸
@property(nonatomic)CXCallObserver *callCenter;

@end

@implementation VEVideoEditViewController

- (void)dealloc{
    [VETool deleteAllLansonBoxDataIfAll:NO];
    [self.palyView.player pause];
    [self.palyView.player.currentItem cancelPendingSeeks];
    [self.palyView.player.currentItem.asset cancelLoading];
    [self.palyView removeFromSuperview];
    [self.hud hide];
    self.hud = nil;
    self.palyView = nil;
    [self.player stop];
    self.player = nil;
    self.callCenter = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.hud) {
        self.hud=[[VECreateHUD alloc] init];
    }
    self.doneBtn.userInteractionEnabled = YES;
    if (self.shadowBtn.alpha > 0 && self.shadowNavBtn.alpha == 0) {
        self.shadowNavBtn.alpha = self.shadowBtn.alpha;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.hud hide];
    self.hud = nil;
    [self.palyView stop];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.shadowNavBtn.alpha > 0) {
        self.shadowNavBtn.alpha = 0;
    }
    
    if (!self.ifPushSelectMusic) {
        [self.player stop];
    }
    self.ifPushSelectMusic = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    self.title = @"编辑";
    //设置在静音模式下，player也能有声音
     [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                      withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                                            error:nil];
    
    _localVideoUrl=[NSURL URLWithString:self.videoModel.videoUrl];
    self.srcVideoPath = self.videoModel.videoAss.videoPath;
    
    [self.navigationController.navigationBar addSubview:self.shadowNavBtn];
    [self setConfig];
    [self.view addSubview:self.palyView];
    self.palyView.mediaConfig=_mediaConfig;
    self.palyView.playerItem.forwardPlaybackEndTime = CMTimeMake(_mediaConfig.endTime * 1000, 1000);
    [self createDoneBtn];
    [self createVideoSize];
    [self crateBottomView];
    self.hud=[[VECreateHUD alloc] init];
    
    self.callCenter = [[CXCallObserver alloc] init];
    [self.callCenter setDelegate:self queue:dispatch_get_main_queue()];
    
    if (self.videoType == LMEditVideoTypeCrop || self.videoType == LMEditVideoTypeSelect || self.videoType == LMEditVideoTypeWatermark || self.videoType == LMEditVideoTypeGIF) {
        [self createBackBtn];
    }
    
//    [self loadTestImage];
}

- (void)loadTestImage{
    [self.videoModel.videoAss getThunbnailUIImageAsynchronously:20 uiimageHandler:^(UIImage * _Nonnull image) {
        LMLog(@"=======%@",image);
    }];
}

- (void)createBackBtn{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [backBtn setImage:[UIImage imageNamed:@"vm_icon_back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    UIBarButtonItem *barBackBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackBtn;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - CXCallObserverDelegate
- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call{
    if (!call.outgoing && !call.onHold && !call.hasConnected && !call.hasEnded) {
        LMLog(@"来电");
        [self.palyView stop];
        [self.player stop];
       } else if (!call.outgoing && !call.onHold && !call.hasConnected && call.hasEnded) {
        LMLog(@"来电-挂掉(未接通)");
        [self.palyView play];
        [self.player play];
       } else if (!call.outgoing && !call.onHold && call.hasConnected && !call.hasEnded) {
           LMLog(@"来电-接通");
       } else if (!call.outgoing && !call.onHold && call.hasConnected && call.hasEnded) {
        LMLog(@"来电-接通-挂掉");
        [self.palyView play];
        [self.player play];
       } else if (call.outgoing && !call.onHold && !call.hasConnected && !call.hasEnded) {
           LMLog(@"拨打");
       } else if (call.outgoing && !call.onHold && !call.hasConnected && call.hasEnded) {
           LMLog(@"拨打-挂掉(未接通)");
       } else if (call.outgoing && !call.onHold && call.hasConnected && !call.hasEnded) {
           LMLog(@"拨打-接通");
       } else if (call.outgoing && !call.onHold && call.hasConnected && call.hasEnded) {
           LMLog(@"拨打-接通-挂掉");
       }
}

#pragma mark - 创建各个view
- (void)crateBottomView{
    [self.view addSubview:self.cropView];
    [self.view addSubview:self.shadowBtn];
    if (self.videoType == LMEditVideoTypeSpeed || self.videoType == LMEditVideoTypeChangeAudio) {       //变速和替换背景音乐
        self.cropView.hidden = YES;
        [self createSpeedBottomView];
    }else if (self.videoType == LMEditVideoTypeCover) {
        self.cropView.hidden = YES;
        [MBProgressHUD showMessage:@"提取封面中"];
        [self createChangeCoverView];
    }else if (self.videoType == LMEditVideoTypeOutAudio){
        self.cropView.hidden = YES;
        [self showAudioOutData];
    }else if(self.videoType == LMEditVideoTypeWatermark || self.videoType == LMEditVideoTypeCrop || self.videoType == LMEditVideoTypeSelect || self.videoType == LMEditVideoTypeGIF){
        if (!self.ifHiddenCrop) {
            [self.view addSubview:self.mainHfView];
        }
    }else{
        self.cropView.hidden = NO;
    }
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

-(void)setConfig{
    SJMediaInfoConfig  *config = [[SJMediaInfoConfig alloc]init];
    config.startTime=0;
//    config.endTime=self.videoModel.second;
    config.endTime=self.videoModel.videoAss.duration;
    config.minDuration=5;
    config.maxDuration=self.videoModel.second;
    config.sourceDuration =[self avAssetVideoTrackDuration:self.palyView.playerItem.asset];
    _mediaConfig=config;
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

- (UIView *)mainHfView{
    if (!_mainHfView) {
        _mainHfView = [[UIView alloc]initWithFrame:self.coverFrame];
        _mainHfView.backgroundColor = [UIColor clearColor];
        _mainHfView.userInteractionEnabled = YES;
        [_mainHfView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playPauseClick)]];
        [_mainHfView addSubview:self.hfView];
    }
    return _mainHfView;
}

- (HFDraggableView *)hfView{
    if (!_hfView) {
        _hfView = [[HFDraggableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        if (self.videoType == LMEditVideoTypeCrop || self.videoType == LMEditVideoTypeSelect  || self.videoType == LMEditVideoTypeGIF) {
            _hfView.frame = CGRectMake(0, 0, self.coverFrame.size.width, self.coverFrame.size.height);
            //画面等比例裁剪视频
            if (self.videoType == LMEditVideoTypeSelect && self.cropBili.width > 0){
                CGFloat h = self.coverFrame.size.width/(self.cropBili.width/self.cropBili.height);
                if (h > self.coverFrame.size.height) {
                    h = self.coverFrame.size.height;
                }
                _hfView.frame = CGRectMake(0, 0, self.coverFrame.size.width, h);
                _hfView.biliSize = self.cropBili;
            }
        }
        _hfView.backgroundColor = [UIColor clearColor];
        [_hfView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playPauseClick)]];
        [HFDraggableView setActiveView:_hfView];
    }
    return _hfView;
}

- (void)playPauseClick{
    [self.palyView playPauseClick];
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

//提取音乐
- (void)showAudioOutData{
     //如果是提取音频，则提前弹出音乐裁剪view
     self.shadowBtn.alpha = 0;
    [self.view addSubview:self.audioCropView];
    [self.view addSubview:self.saveAudioView];
     //去掉file：//
     NSString *changeAudilUrl = self.videoModel.videoUrl;
     if ([self.videoModel.videoUrl containsString:@"file://"]) {
         changeAudilUrl = [self.videoModel.videoUrl stringByReplacingOccurrencesOfString:@"file://" withString:@""];
     }
     NSString *audioUrl = [LSOVideoEditor executeGetAudioTrack:changeAudilUrl];
     NSData *audioData = [NSData dataWithContentsOfFile:audioUrl];
     if (audioData) {
         NSRange startRange = [audioUrl rangeOfString:@"lansongBox/"];
         NSRange endRange = [audioUrl rangeOfString:@".m4a"];
         NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
         NSString *result = [audioUrl substringWithRange:range];
         [self alertAudioModel];
         self.audioModel.audioName = result;
         self.audioModel.audioUrl = audioUrl;
         self.audioModel.endTime = self.videoModel.second;
     }else{
         [MBProgressHUD showError:@"音频获取失败"];
     }
}

- (void)clickShadowBtn{
    if (self.videoType == LMEditVideoTypeOutAudio) {
        [self showSaveAudioView];
        self.doneBtn.userInteractionEnabled = YES;
    }
}

/// 初始化音乐model
- (void)alertAudioModel{
    self.audioModel = [[VEAudioModel alloc]init];
    self.audioModel.oldSize = 1;
    self.audioModel.soundtrackSize = 1;
    self.audioModel.beginTime = 0;
    self.audioModel.previewOldSize = 0;
}

/// 变速底部按钮和替换背景音乐按钮
- (void)createSpeedBottomView{
    NSArray *titleArr = @[@"音乐"];
    NSArray *imageArr = @[@"vm_detail_material_music"];
    VECreateBottomFeaturesView *subV = [[VECreateBottomFeaturesView alloc]initWithFrame:CGRectMake(0, kScreenHeight - Height_SafeAreaBottom - BOTTOM_VIEW_H , self.view.width, BOTTOM_VIEW_H) titleArr:titleArr imageArr:imageArr];
    subV.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:subV];
    @weakify(self);
    subV.clickBtnBlock = ^(NSInteger btnTag) {
        @strongify(self);
        [self.palyView stop];
        if (self.videoType == LMEditVideoTypeChangeAudio) {
            self.showSelectF = YES;
            [self createChangeAudioSizeView];
        }
    };
    
    //如果是替换背景音乐，则初始化裁剪音乐相关view
    if (self.videoType == LMEditVideoTypeChangeAudio) {
        [self alertAudioModel];
        [self.view addSubview:self.audioSizeView];
    }
}

//保存音乐的弹框view
- (VESaveAudioView *)saveAudioView{
    if (!_saveAudioView) {
        _saveAudioView = [[VESaveAudioView alloc]initWithFrame:CGRectMake(0, 0, 296, 180)];
        _saveAudioView.backgroundColor = [UIColor whiteColor];
        _saveAudioView.center = CGPointMake(kScreenWidth/2, kScreenHeight+100);
        _saveAudioView.layer.masksToBounds = YES;
        _saveAudioView.layer.cornerRadius = 10.f;
        _saveAudioView.hidden = YES;
        @weakify(self);
        _saveAudioView.clickSubBtnBlock = ^(NSInteger btnTag, NSString * _Nonnull titleStr) {
            @strongify(self);
            [self showSaveAudioView];
            if (btnTag == 2) {
                self.audioModel.audioName = titleStr;
                NSInteger dur = self.audioModel.endTime - self.audioModel.beginTime;
                NSString *cropUrl = [LSOVideoEditor executeAudioCutOut:self.audioModel.audioUrl startS:self.audioModel.beginTime duration:dur];
                [self saveAudioWithUrl:cropUrl audioName:[NSString stringWithFormat:@"%@.m4a",titleStr]];
            }
        };
    }
    return _saveAudioView;
}

//选取封面的view
- (VEAddCoverMainView *)coverMainView{
    if (!_coverMainView) {
        _coverMainView = [[VEAddCoverMainView alloc]initWithFrame:self.coverFrame];
        _coverMainView.backgroundColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _coverMainView.hidden = YES;
        _coverMainView.imageSize = self.videoModel.videoSize;
        @weakify(self);
        _coverMainView.changeImageBlock = ^(UIImage * _Nonnull image) {
            @strongify(self);
            self.coverImage = image;
        };
    }
    return _coverMainView;
}
//视频提取封面的view
- (UIImageView *)videoCoverImage{
    if (!_videoCoverImage) {
        _videoCoverImage = [[UIImageView alloc]initWithFrame:self.coverFrame];
        _videoCoverImage.contentMode = UIViewContentModeScaleAspectFill;
        _videoCoverImage.clipsToBounds = YES;
        _videoCoverImage.backgroundColor = [UIColor colorWithHexString:@"#A1A7B2"];
    }
    return _videoCoverImage;
}

-(SJVideoPlayView *)palyView{
    if (!_palyView) {
        _palyView=[[SJVideoPlayView alloc]initWithFrame:CGRectZero localUrl:_localVideoUrl];
        _palyView.delegate=self;
    }
    return _palyView;
}
-(SJVideoCropView *)cropView{
    if (!_cropView) {
        _cropView=[[SJVideoCropView alloc]initWithFrame:CGRectMake(18, kScreenHeight - Height_SafeAreaBottom - BOTTOM_VIEW_H , self.view.width-36, BOTTOM_VIEW_H) mediaConfig:_mediaConfig];
        _cropView.avAsset=[AVAsset assetWithURL:_localVideoUrl];
        _cropView.delegate=self;
    }
    return _cropView;
}

//音乐裁剪的view
- (VEAudioCropView *)audioCropView{
    if (!_audioCropView) {
        CGFloat top = kScreenHeight - Height_SafeAreaBottom-[VEAudioCropView viewHeight];
        if (self.videoType == LMEditVideoTypeChangeAudio) {
            top = kScreenHeight + 20;
        }
        _audioCropView = [[VEAudioCropView alloc]initWithFrame:CGRectMake(0,top , kScreenWidth, [VEAudioCropView viewHeight])];
        _audioCropView.backgroundColor = self.view.backgroundColor;
        _audioCropView.allTime = self.videoModel.second;
        
        if (self.videoType != LMEditVideoTypeChangeAudio) {
            [_audioCropView hiddenTitleView];
        }else{
            _audioCropView.hidden = YES;
        }
        @weakify(self);
        _audioCropView.changeSelectTimeBlock = ^(NSInteger beginTime, NSInteger endTime, NSInteger continuedTime, BOOL ifLeft) {
            @strongify(self);
            self.audioModel.beginTime = beginTime;
            self.audioModel.endTime = endTime;
            self.mediaConfig.startTime = beginTime;
            self.mediaConfig.endTime = endTime;
            self.palyView.playerItem.forwardPlaybackEndTime = CMTimeMake(endTime * 1000, 1000);
            if(ifLeft){
                [self cutBarDidMovedToTime:beginTime];
            }else{
                [self cutBarDidMovedToTime:endTime];
            }
            [self.palyView play];
        };
        
        _audioCropView.clickDoneBtnBlock = ^(BOOL ifSucceed) {
            @strongify(self);
            self.palyView.player.volume = self.audioModel.oldSize;
            if (ifSucceed) {
                self.audioModel.beginTime = self.audioModel.previewBeginTime;
                self.audioModel.endTime = self.audioModel.previewEndTime;
                self.audioModel.audioUrl = self.audioModel.catAudioUrl;
            }else{
                self.shadowBtn.alpha = 0.f;
                self.shadowNavBtn.alpha = 0.f;
            }
            [UIView animateWithDuration:0.3 animations:^{
                self.audioCropView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEAudioCropView viewHeight]);
            }completion:^(BOOL finished) {
                self.audioCropView.hidden = YES;
            }];
        };
    }
    return _audioCropView;
}

//改变音量的view
-(VEAudioChangeSizeView *)audioSizeView{
    if (!_audioSizeView) {
        _audioSizeView = [[VEAudioChangeSizeView alloc]initWithFrame:CGRectMake(0, kScreenHeight + 20, kScreenWidth, [VEAudioChangeSizeView viewHeightIfAll:self.audioModel.audioUrl?YES:NO] )];
        _audioSizeView.backgroundColor = self.view.backgroundColor;
        [_audioSizeView changeHeadIfShow:self.audioModel.audioUrl?YES:NO];

        @weakify(self);
        _audioSizeView.clickBtnBlock = ^(BOOL ifSucceed, CGFloat oldSize, CGFloat videoSize) {
            @strongify(self);
            [self.palyView play];
            [self audioSizeViewClick:ifSucceed oldSize:oldSize videoSize:videoSize];
        };
        
        _audioSizeView.clickSelectBtnBlock = ^(NSInteger btnTag) {
            @strongify(self);
            self.showSelectF = YES;
            if (btnTag == 1) {
                [self pushSelectAudioVC];
            }else{
                [self pushVideoOutAudioVC];
            }
            [UIView animateWithDuration:0.3 animations:^{
                self.audioSizeView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEAudioChangeSizeView viewHeightIfAll:self.audioModel.audioUrl?YES:NO]);
                self.shadowBtn.alpha = 0;
                self.shadowNavBtn.alpha = 0;
            }completion:^(BOOL finished) {
                self.audioSizeView.hidden = YES;
            }];
        };
        
        _audioSizeView.clickDeleteAudioBlock = ^{
            @strongify(self);
            self.audioModel.audioUrl = nil;
            [self.player stop];
            self.player = nil;
        };
    }
    return _audioSizeView;
}

//音乐调整音量view点击完成的回调
- (void)audioSizeViewClick:(BOOL)ifSucceed oldSize:(CGFloat)oldSize videoSize:(CGFloat)videoSize{
    self.showSelectF = YES;
    if (ifSucceed) {
        self.audioModel.oldSize = oldSize;
        self.audioModel.soundtrackSize = videoSize;
        self.audioModel.previewOldSize = oldSize;
        self.palyView.player.volume = oldSize;
        if (self.audioModel.audioUrl.length > 0 && self.player) {
            self.player.volume = videoSize;
        }
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.shadowBtn.alpha = 0.f;
        self.shadowNavBtn.alpha = 0.f;
        self.audioSizeView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEAudioChangeSizeView viewHeightIfAll:self.audioModel.audioUrl?YES:NO]);
    }completion:^(BOOL finished) {
        self.audioSizeView.hidden = YES;
    }];
}

#pragma mark - 弹出各个view
/// 选择镜像方向的view
- (void)showSelectDirectionView{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    VECreateVideoDirectionView *view = [[VECreateVideoDirectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [win addSubview:view];
    @weakify(self);
    view.clickSelectBlock = ^(NSInteger btnTag, BOOL ifSucceed) {
        @strongify(self);
        self.doneBtn.userInteractionEnabled = YES;
        if (ifSucceed) {
            [self createMirrorWithType:btnTag];
        }
    };
}

///保存提取音乐的view
- (void)showSaveAudioView{
    if (self.showSaveView) {
        self.saveAudioView.audioName = self.audioModel.audioName;
        self.saveAudioView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.saveAudioView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2-60);
            self.shadowBtn.alpha = BTN_ALPHA;
            self.shadowNavBtn.alpha = BTN_ALPHA;
        }completion:^(BOOL finished) {
            [self.saveAudioView.contentText becomeFirstResponder];
        }];
    }else{
        [self.saveAudioView.contentText resignFirstResponder];
        [UIView animateWithDuration:0.2 animations:^{
             self.saveAudioView.center = CGPointMake(kScreenWidth/2, kScreenHeight+100);
            self.shadowBtn.alpha = 0.f;
            self.shadowNavBtn.alpha = 0.f;
        }completion:^(BOOL finished) {
            self.saveAudioView.hidden = YES;
        }];
    }
    self.showSaveView = !self.showSaveView;
}

/// 底部添加封面的view
- (void)createChangeCoverView{
    self.coverBottomView = [[VESelectVideoCoverView alloc]initWithFrame:CGRectMake(0, kScreenHeight - BOTTOM_VIEW_H - Height_SafeAreaBottom, kScreenWidth, BOTTOM_VIEW_H)];
    self.coverBottomView.backgroundColor = self.view.backgroundColor;
    self.coverBottomView.videoModel = self.videoModel;
    self.coverBottomView.videoUrl = self.videoModel.videoUrl;
    [self.view addSubview:self.coverBottomView];
    [self.view addSubview:self.coverMainView];
    [self.view addSubview:self.videoCoverImage];
    self.palyView.hidden = YES;
    [self.palyView stop];
    
    //调用蓝松获取到的视频图片都是空白的
//    NSMutableArray *imageCoverArr = [NSMutableArray new];
//    @weakify(self);
//    [self.videoModel.videoAss getThunbnailUIImageAsynchronously:6 uiimageHandler:^(UIImage * _Nonnull image) {
//        @strongify(self);
//        LMLog(@"safasfadsfads====%@",NSStringFromCGSize(image.size));
//        [imageCoverArr addObject:image];
//        if (imageCoverArr.count >= 6) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.coverBottomView.allImageArr = imageCoverArr;
////                 UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//            });
//        }
//    }];
    
    ///蓝松第二种获取图片的方法，过于消耗内存
//     LSOVideoDecoder *decoder=[[LSOVideoDecoder alloc] initWithURL:[NSURL URLWithString:self.videoModel.videoUrl]];
//     [decoder start];
//
//     while (!decoder.isEnd) {
//         UIImage *image=[decoder getOneFrame];
//         NSLog(@"save  image is :%@",[LSOFileUtil saveUIImage:image]);
//     }
//    [decoder stop];
    
    NSArray *arr = [VETool thumbnailImageRequestWithVideoUrl:[NSURL URLWithString:self.videoModel.videoUrl]];
    LMLog(@"arr=======%@",arr);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.coverBottomView.allImageArr = arr;
    });

    @weakify(self);
    self.coverBottomView.clickSubImageBlock = ^(UIImage * _Nonnull selcectImage) {
        @strongify(self);
        self.coverImage = selcectImage;
        [self.videoCoverImage setImage:selcectImage];
    };
    
    self.coverBottomView.loadAllImageBlock = ^(NSArray * _Nonnull allImage) {
        @strongify(self);
        if (allImage.count > 0) {
            self.coverImage = allImage[0];
            [self.videoCoverImage setImage:allImage[0]];
        }
    };
    
    self.coverBottomView.clickSubBtnBlock = ^(NSInteger btnTag, UIImage *selcectImage) {
        @strongify(self);
        if (btnTag == 1) {
            self.coverImage = selcectImage;
            self.coverMainView.hidden = YES;
            self.videoCoverImage.hidden = NO;
        }else{
            self.coverImage = self.coverMainView.image;
            self.coverMainView.hidden = NO;
            self.videoCoverImage.hidden = YES;
        }
    };
    
    self.coverBottomView.clickAddImageBlock = ^{
        @strongify(self);
        [self.coverMainView changeImage];
    };
}

//裁剪配乐的view
- (void)cropAudioSizeView{
    if (self.showSelectF) {
        self.audioCropView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.shadowBtn.alpha = BTN_ALPHA;
            self.shadowNavBtn.alpha = BTN_ALPHA;
            self.audioCropView.frame = CGRectMake(0, kScreenHeight - Height_SafeAreaBottom-[VEAudioCropView viewHeight], kScreenWidth, [VEAudioCropView viewHeight]);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.shadowBtn.alpha = 0;
            self.shadowNavBtn.alpha = 0;
            self.audioCropView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEAudioCropView viewHeight]);
        }completion:^(BOOL finished) {
            self.audioCropView.hidden = YES;
        }];
    }
}

//调整配乐音量的view
- (void)createChangeAudioSizeView{
    [self.audioSizeView changeHeadIfShow:self.audioModel.audioUrl?YES:NO];
    if (self.showSelectF) {
        [self.audioSizeView setOldSize:self.audioModel.oldSize newSize:self.audioModel.soundtrackSize];
        self.audioSizeView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.audioSizeView.frame = CGRectMake(0, kScreenHeight - Height_SafeAreaBottom-[VEAudioChangeSizeView viewHeightIfAll:self.audioModel.audioUrl?YES:NO], kScreenWidth, [VEAudioChangeSizeView viewHeightIfAll:self.audioModel.audioUrl?YES:NO]);
            self.shadowBtn.alpha = BTN_ALPHA;
            self.shadowNavBtn.alpha = BTN_ALPHA;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.audioSizeView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEAudioChangeSizeView viewHeightIfAll:self.audioModel.audioUrl?YES:NO]);
            self.shadowBtn.alpha = 0.0f;
            self.shadowNavBtn.alpha = 0.0f;
        }completion:^(BOOL finished) {
            self.audioSizeView.hidden = YES;
        }];
    }
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
    [self.palyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.mas_equalTo(lR);
        make.right.mas_equalTo(-lR);
        make.height.mas_equalTo(h);
    }];
    self.coverFrame = CGRectMake(lR, top, kScreenWidth - (lR * 2), h);
}

#pragma mark - CropViewDelegate
#pragma mark  手指滚动
- (void)cutBarDidMovedToTime:(CGFloat)time {
    LMLog(@"time=============%.f",time);

    if (time<=0) {
        return;
    }
    if (self.palyView.playerItem.status == AVPlayerItemStatusReadyToPlay) {
        [self.palyView.player seekToTime:CMTimeMake(time * 1000, 1000) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        if (self.palyView.playerStatus == CropPlayerStatusPlaying) {
            [self.palyView.player pause];
            self.palyView.playerStatus = CropPlayerStatusPlayingBeforeSeek;
            if (_timeObserver){
                [self.palyView.player removeTimeObserver:_timeObserver];
                _timeObserver=nil;
            }
        }
    }
}
#pragma mark 手指滚动结束
- (void)cutBarTouchesDidEnd {
    self.palyView.playerItem.forwardPlaybackEndTime = CMTimeMake(_mediaConfig.endTime * 1000, 1000);
    if (self.palyView.playerStatus == CropPlayerStatusPlayingBeforeSeek) {
        [self playVideo];
    }
}

- (void)clickPlayBtn:(BOOL)ifSelect{
    if (ifSelect) {
        [self.palyView play];
    }else{
        [self.palyView stop];
    }
}

#pragma mark - palyViewDelegate
- (void)playVideo {
    if (self.palyView.playerStatus == CropPlayerStatusPlayingBeforeSeek) {
        CGFloat time = (self.cropView.siderTime+_mediaConfig.startTime);
        if (self.cropView.siderTime+1>=_mediaConfig.endTime-_mediaConfig.startTime) {
            time=_mediaConfig.startTime;
        }
        [self.palyView.player seekToTime:CMTimeMake(time* 1000, 1000) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    }
    
    if (self.videoType != LMEditVideoTypeCover) {
        [self.palyView.player play];
        self.palyView.playerStatus = CropPlayerStatusPlaying;
    }
    
    if (_timeObserver){
        [self.palyView.player removeTimeObserver:_timeObserver];
        _timeObserver=nil;
    }
    //    return;
    __weak __typeof(self) weakSelf = self;
    _timeObserver = [self.palyView.player  addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong __typeof(self) strong = weakSelf;
        CGFloat crt = CMTimeGetSeconds(time);
        if (strong.palyView.playerStatus == CropPlayerStatusPlayingBeforeSeek||strong.palyView.playerStatus==CropPlayerStatusPause) {
            return ;
        }
        [strong.cropView updateProgressViewWithProgress:(crt-strong->_mediaConfig.startTime)/(strong->_mediaConfig.endTime-strong->_mediaConfig.startTime)];
    }];
}

-(void)SJVideoReadyToPlay{
    self.palyView.playerStatus =CropPlayerStatusPlayingBeforeSeek;
    [self playVideo];
    [self.cropView loadThumbnailData];
}

- (void)SJVideoPlay{
    self.cropView.playBtn.selected = YES;
    [self goonAudioPlayer];
}

- (void)SJVideoStop{
    self.cropView.playBtn.selected = NO;
    [self stopAudioPlayer];
}

- (void)SJVideoEnd{
    if (self.audioModel.audioUrl.length > 0 && self.player) {
        self.player.currentTime = self.audioModel.beginTime;
    }
}

- (void)addCoverAllImage:(NSArray *)allImage{
    [MBProgressHUD hideHUD];
//    self.coverBottomView.allImageArr = allImage;
}

- (CGFloat)avAssetVideoTrackDuration:(AVAsset *)asset {
    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if (videoTracks.count) {
        AVAssetTrack *track = videoTracks[0];
        return CMTimeGetSeconds(CMTimeRangeGetEnd(track.timeRange));
    }
    
    NSArray *audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
    if (audioTracks.count) {
        AVAssetTrack *track = audioTracks[0];
        return CMTimeGetSeconds(CMTimeRangeGetEnd(track.timeRange));
    }
    return -1;
}

#pragma mark - 制作相关
- (void)doneBtnClick{
    [self.palyView stop];
    self.doneBtn.userInteractionEnabled = NO;
    if (self.videoType == LMEditVideoTypeMirror) {                    //视频镜像
        [self showSelectDirectionView];
    }else if (self.videoType == LMEditVideoTypeBack){                //视频倒放
        [self testReverseVideo];
    }else if (self.videoType == LMEditVideoTypeCrop || self.videoType == LMEditVideoTypeSelect || self.videoType == LMEditVideoTypeGIF){                //视频裁剪
        [self createCropVideo];
    }else if (self.videoType == LMEditVideoTypeCover){                 //视频加封面
        [self createVideoAddCover];
    }else if (self.videoType == LMEditVideoTypeWatermark){              //去水印
        [self removeWatermark];
    }else if (self.videoType == LMEditVideoTypeOutAudio) {              //提取背景音乐
        self.showSaveView = YES;
        [self showSaveAudioView];
    }else if (self.videoType == LMEditVideoTypeChangeAudio) {           //替换背景音乐
        [self changeAudio];
    }
}

/// 视频加封面
- (void)createVideoAddCover{
    if (self.coverImage) {
        self.hud=[[VECreateHUD alloc] init];
        self.videoExecute=[[LSOVideoOneDo alloc] initWithNSURL:[LSOFileUtil filePathToURL:self.srcVideoPath]];
        [self.videoExecute setCoverPicture:self.coverImage startTime:0 endTime:0.5f];
        if ([LMUserManager sharedManger].userInfo.vipState.intValue != 1) {
            [self.videoExecute setUIView:[self addTextLogoWithSize:CGSizeMake(self.videoModel.videoAss.width, self.videoModel.videoAss.height)]];  //增加水印;
        }
        [self beginDo];
    }else{
        self.doneBtn.userInteractionEnabled = YES;
        [MBProgressHUD showError:@"请选择封面"];
    }
}

/// 替换背景音乐
- (void)changeAudio{
    self.hud=[[VECreateHUD alloc] init];
    self.videoExecute=[[LSOVideoOneDo alloc] initWithNSURL:[LSOFileUtil filePathToURL:self.srcVideoPath]];
    self.videoExecute.videoUrlVolume = self.audioModel.oldSize;
    NSURL *audio=[NSURL URLWithString:self.audioModel.audioUrl];
    if (self.audioModel.isAddFile) {
        audio=[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",self.audioModel.audioUrl]];
    }

    BOOL bo = [self.videoExecute addAudio:audio volume:self.audioModel.soundtrackSize loop:YES];
//    BOOL bo= [self.videoExecute addAudio:audio start:self.audioModel.beginTime end:self.audioModel.endTime pos:0 volume:self.audioModel.soundtrackSize];
    LMLog(@"bo========%d",bo);
    if ([LMUserManager sharedManger].userInfo.vipState.intValue != 1) {
        [self.videoExecute setUIView:[self addTextLogoWithSize:CGSizeMake(self.videoModel.videoAss.width, self.videoModel.videoAss.height)]];  //增加水印;
    }
    [self beginDo];
}

/// 镜像视频
-(void)createMirrorWithType:(NSInteger)type{
    self.hud=[[VECreateHUD alloc] init];
    self.videoExecute=[[LSOVideoOneDo alloc] initWithNSURL:[LSOFileUtil filePathToURL:self.srcVideoPath]];
    LanSongMirrorFilter *filter=[[LanSongMirrorFilter alloc] init];
    if (type == 0) {
        filter.isVMirror = YES;
    }else{
        filter.isVMirror = NO;
    }
    [self.videoExecute setFilter:filter];
    if ([LMUserManager sharedManger].userInfo.vipState.intValue != 1) {
        [self.videoExecute setUIView:[self addTextLogoWithSize:CGSizeMake(self.videoModel.videoAss.width, self.videoModel.videoAss.height)]];  //增加水印;
    }
    [self beginDo];
}

/// 裁剪视频
-(void)createCropVideo{
    if (self.videoType == LMEditVideoTypeGIF) {
        NSInteger maxNum = 20;
        if (self.videoModel.videoAss.bitrate > 19000000) {
            maxNum = 10;
        }
        if (self.cropView.timeData > maxNum+1) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"视频时长不能大于%zds",maxNum]];
            self.doneBtn.userInteractionEnabled = YES;
            [self.palyView play];
            return;
        }
    }
    self.hud=[[VECreateHUD alloc] init];
    self.videoExecute=[[LSOVideoOneDo alloc] initWithNSURL:[LSOFileUtil filePathToURL:self.srcVideoPath]];
    self.videoExecute.cutStartTimeS=self.cropView.beginTime;
    self.videoExecute.cutDurationTimeS=self.cropView.timeData;
    LMLog(@"==========%.2f",self.cropView.timeData);
    LMLog(@"==========%.2f",self.videoExecute.cutDurationTimeS);
    
    CGFloat xBili = self.hfView.left/self.hfView.superview.frame.size.width;
    CGFloat yBili = self.hfView.top/self.hfView.superview.frame.size.height;
    int x = self.videoModel.videoAss.width*xBili;
    int y = self.videoModel.videoAss.height*yBili;
    int w = self.videoModel.videoAss.width/self.hfView.superview.frame.size.width*self.hfView.frame.size.width;
    int h = self.videoModel.videoAss.height/self.hfView.superview.frame.size.height*self.hfView.frame.size.height;
    if (w % 2 > 0) {        //取偶数
        w += 1;
    }
    if (h % 2 > 0) {        //取偶数
        h += 1;
    }
    CGRect cropRect = CGRectMake(x, y, w, h);
    self.cropRect = cropRect;
    [self.videoExecute setCropRect:cropRect];
    if (self.videoType != LMEditVideoTypeSelect) {
        if ([LMUserManager sharedManger].userInfo.vipState.intValue != 1) {
            if (w > 360 && h > 360) { //增加水印;
                [self.videoExecute setUIView:[self addTextLogoWithSize:CGSizeMake(w, h)]];
            }
        }
    }

    [self beginDo];
}

// 去水印
- (void)removeWatermark{
    self.hud=[[VECreateHUD alloc] init];
    self.videoEditor=[[LSOVideoEditor alloc] init];
    @weakify(self);
    [self.hud showProgress:[NSString stringWithFormat:@"制作中0%%"] par:0];
    [self.videoEditor setProgressBlock:^(int percent) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (percent > 0) {
                [self.hud showProgress:[NSString stringWithFormat:@"制作中%d%%",percent] par:(double)percent/100];
            }
        });
    }];

    [self.videoEditor setCompletionBlock:^(NSString *dstPath) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([LMUserManager sharedManger].userInfo.vipState.intValue != 1) {
                //如果是去水印增加logo，生成的视频则会失败
                [self createSueeccd:dstPath];
            }else{
                [self createSueeccd:dstPath];
            }
        });
    }];
        
    CGFloat xBili = self.hfView.left/self.hfView.superview.frame.size.width;
    CGFloat yBili = self.hfView.top/self.hfView.superview.frame.size.height;
    int x = self.videoModel.videoAss.width*xBili;
    int y = self.videoModel.videoAss.height*yBili;
    int w = self.videoModel.videoAss.width/self.hfView.superview.frame.size.width*self.hfView.frame.size.width;
    int h = self.videoModel.videoAss.height/self.hfView.superview.frame.size.height*self.hfView.frame.size.height;
    if (w % 2 > 0) {        //取偶数
        w += 1;
    }
    if (h % 2 > 0) {        //取偶数
        h += 1;
    }
    [self.videoEditor startDeleteLogo:self.srcVideoPath startX:x startY:y width:w height:h];
}

/**
 倒序 先增加水印，然后倒放
 */
-(void)testReverseVideo{
    if (self.cropView.timeData > 60) {
        [MBProgressHUD showError:@"视频时长不能大于60s"];
        self.doneBtn.userInteractionEnabled = YES;
        [self.palyView play];
        return;
    }
    self.hud=[[VECreateHUD alloc] init];
    self.videoExecute=[[LSOVideoOneDo alloc] initWithNSURL:[LSOFileUtil filePathToURL:self.srcVideoPath]];
    self.videoExecute.cutStartTimeS=self.cropView.beginTime;
    self.videoExecute.cutDurationTimeS=self.cropView.timeData;
    if ([LMUserManager sharedManger].userInfo.vipState.intValue != 1) {
        [self.videoExecute setUIView:[self addTextLogoWithSize:CGSizeMake(self.videoModel.videoAss.width, self.videoModel.videoAss.height)]];
    }
    @weakify(self);
     [self.videoExecute setVideoProgressBlock:^(CGFloat currentFramePts, CGFloat percent) {
         @strongify(self);
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.hud showProgress:[NSString stringWithFormat:@"制作中%d%%",(int)(percent*100/2)] par:percent/2];
         });
     }];
     
     [self.videoExecute setCompletionBlock:^(NSString * _Nonnull video) {
         @strongify(self);
         dispatch_async(dispatch_get_main_queue(), ^{
            //开始倒放
            self.videoEditor=[[LSOVideoEditor alloc] init];
            [self.videoEditor setProgressBlock:^(int percent) {
                @strongify(self);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (percent > 0) {
                        float x = (percent/2+50);
                        float par = x/100;
                        [self.hud showProgress:[NSString stringWithFormat:@"制作中%d%%",percent/2+50] par:(double)par];
                    }
                });
            }];

            [self.videoEditor setCompletionBlock:^(NSString *dstPath) {
                @strongify(self);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self createSueeccd:dstPath];
                });
            }];
            [self.videoEditor startAVReverse:video isReverseAudio:YES];
         });
     }];
     [self.videoExecute start];
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

/// 开始制作        是否是额外的增加水印功能
- (void)beginDo{
    self.hud=[[VECreateHUD alloc] init];
    [self.hud showProgress:[NSString stringWithFormat:@"制作中0%%"] par:0];
    @weakify(self);
    [self.videoExecute setVideoProgressBlock:^(CGFloat currentFramePts, CGFloat percent) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.videoType == LMEditVideoTypeGIF){
                [self.hud showProgress:[NSString stringWithFormat:@"制作中%d%%",(int)(percent*100/2)] par:percent/2];
            }else{
                [self.hud showProgress:[NSString stringWithFormat:@"制作中%d%%",(int)(percent*100)] par:percent];
            }
        });
    }];
    
    [self.videoExecute setCompletionBlock:^(NSString * _Nonnull video) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.videoType == LMEditVideoTypeSelect) {
                [self.hud hide];
                if (self.dismissSelectBlock) {
                    self.dismissSelectBlock(self.videoModel,video);
                }
                if (self.ifSplice || self.ifHiddenCrop) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }else if(self.videoType == LMEditVideoTypeGIF){
                [self changeGIFWithUrl:video];
            }else{
                [self createSueeccd:video];
            }
        });
    }];
    [self.videoExecute start];
}

/// 视频转gif
/// @param videoUrl 视频url
- (void)changeGIFWithUrl:(NSString *)videoUrl{
    self.videoEditor=[[LSOVideoEditor alloc] init];
    @weakify(self);
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
        
    [self.videoEditor startVideoConvertToGif:videoUrl interval:5 scaleSize:CGSizeMake(self.cropRect.size.width*0.7, self.cropRect.size.height*0.7) speed:1];
}

/// 制作完成
- (void)createSueeccd:(NSString *)videoPath{
    self.doneBtn.userInteractionEnabled = YES;
    [MBProgressHUD hideHUD];
    [self.hud hide];
    [self.palyView stop];
    [self.videoEditor cancelFFmpeg];
    [self.videoExecute stop];
    
    VEVideoSucceedViewController *vc = [[VEVideoSucceedViewController alloc]init];
    vc.videoPath = videoPath;
    vc.videoSize = self.videoModel.videoSize;
    if (self.videoType == LMEditVideoTypeWatermark) {
        vc.ifHiddenWearerBtn = YES;
    }
    if (self.videoType == LMEditVideoTypeGIF) {
        vc.ifImage = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
    LMLog(@"dstPath ==== %@",videoPath);
}

//保存提取的音频
- (void)saveAudioWithUrl:(NSString *)audioUrl audioName:(NSString *)audioName{
    NSData *audioData = [NSData dataWithContentsOfFile:audioUrl];
    [MBProgressHUD showMessage:@"提取中..."];

    [VETool createEmoticonFolderBlock:^(BOOL ifSucceed, NSString * _Nonnull fileUrl, NSError * _Nonnull error) {
        if (ifSucceed) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *path = [fileUrl stringByAppendingString:[NSString stringWithFormat:@"/%@",audioName]];
            BOOL isSaved = [fileManager createFileAtPath:path contents:audioData attributes:nil];
            [MBProgressHUD hideHUD];

            LMLog(@"=====%d",isSaved);
            if (isSaved) {
                [MBProgressHUD showSuccess:@"音频保存成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showSuccess:@"音频保存失败"];
            }
        }else{
            [MBProgressHUD showError:@"路径创建失败"];
        }
    }];
}

#pragma mark - 音乐播放器
/// 跳转选择音乐页面
- (void)pushSelectAudioVC{
    VEMediaListController *vc = [VEMediaListController new];
    self.ifPushSelectMusic = YES;
    vc.videoUrl = self.srcVideoPath;
    vc.videoFrame = self.coverFrame;
    [self.navigationController pushViewController:vc animated:YES];
    @weakify(self);
    vc.cropAudioBlock = ^(NSString * _Nonnull audioPath, BOOL ifAddFile, NSString * _Nonnull audioName) {
        @strongify(self);
        self.audioSizeView.audioTitle.text = audioName;
        self.audioModel.audioUrl = audioPath;
        self.audioModel.isAddFile = ifAddFile;
        [self createAudioPlayer];
        [self.palyView stop];
        [self createChangeAudioSizeView];
    };
}

/// 跳转选择从视频提取音乐页面
- (void)pushVideoOutAudioVC{
    VESelectVideoController *vc = [VESelectVideoController new];
    vc.videoFrame = self.coverFrame;
    vc.videoType = LMEditVideoTypeVideoOutAudio;
    vc.videoOutUrl = self.srcVideoPath;
    self.ifPushSelectMusic = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    @weakify(self);
    vc.selectVideoOutAudioBlock = ^(NSString * _Nonnull audioPath, NSString * _Nonnull nameStr) {
        @strongify(self);
        self.audioSizeView.audioTitle.text = nameStr;
        self.audioModel.audioUrl = audioPath;
        self.audioModel.isAddFile = YES;
        [self createAudioPlayer];
        [self.palyView stop];
        [self createChangeAudioSizeView];
    };
}

//初始化音乐播放器
- (void)createAudioPlayer{
    [self.player stop];
    self.player = nil;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:self.audioModel.audioUrl] error:nil];
    self.player.delegate = self;
    self.player.volume = 1;
    // 设置循环次数，-1为一直循环
    self.player.numberOfLoops = 1;
    // 准备播放
    [self.player prepareToPlay];
    [self.player play];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    LMLog(@"===endTime=播放完成==");
    [self.player play];
}

//暂停音乐播放器
- (void)stopAudioPlayer{
    if (self.audioModel.audioUrl.length > 0 && self.player) {
        [self.player pause];
    }
}

//继续音乐播放器
- (void)goonAudioPlayer{
    if (self.audioModel.audioUrl.length > 0 && self.player) {
        [self.player play];
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
