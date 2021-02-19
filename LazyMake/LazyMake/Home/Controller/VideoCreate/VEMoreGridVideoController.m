//
//  VEMoreGridVideoController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/5.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEMoreGridVideoController.h"
#import "VEAudioChangeSizeView.h"
#import <AVFoundation/AVFAudio.h>
#import "VEAudioModel.h"
#import "VEMediaListController.h"
#import "VESelectVideoController.h"
#import "VEMoreLatticeVideoSortView.h"
#import "VEMoreLatticeVideoCanvasView.h"
#import "VECreateHUD.h"
#import "VEVideoSucceedViewController.h"
#define BOTTOM_ENUM_HEIGHT 170
#define BTN_ALPHA 0.7f

@interface VEMoreGridVideoController () <AVAudioPlayerDelegate>

@property (strong, nonatomic) UIButton *doneBtn;                        //保存按钮
@property (strong, nonatomic) UIButton *shadowBtn;                      //背景遮罩btn
@property (strong, nonatomic) UIButton *shadowNavBtn;                   //背景遮罩btn

@property (strong, nonatomic) VEMoreLatticeVideoSortView *sortView;     //排序的view
@property (assign, nonatomic) NSInteger playStyle;                     //0同时播放 1顺序播放

@property (strong, nonatomic) VEMoreLatticeVideoCanvasView *biliView;     //画面比例的view
@property (assign, nonatomic) NSInteger biliSelectIndex;                   //画面比例选择项

//替换背景音乐相关操作
@property (strong, nonatomic) VEAudioChangeSizeView  *audioSizeView;    //调整声音大小的view
@property (strong, nonatomic) AVAudioPlayer * __nullable player;        //播放音乐的player
@property (strong, nonatomic) VEAudioModel *audioModel;                 //配乐相关model
@property (assign, nonatomic) BOOL ifPushSelectMusic;                   //是否要跳转到选择音乐页面
@property (assign, nonatomic) BOOL showSelectF;                         //是否有弹出view
@property (assign, nonatomic) BOOL ifPushStopPlay;                      //是否跳转到其他页面并停止播放
@property (nonatomic, strong) VECreateHUD *hud;

//制作相关
@property (nonatomic, strong) LSOVideoOneDo *videoExecute;              //制作的对象
@property (nonatomic, strong) NSMutableArray *cropArr;                  //裁剪完成后的视频数组
@property (nonatomic, strong) DrawPadAllExecute *allExecute;
@end

@implementation VEMoreGridVideoController

-(void)dealloc{
    LMLog(@"VEMoreGridVideoController释放");
    [self.mainView releaseAllPlayer];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.ifPushStopPlay = YES;
    [self.mainView stopAllVideo];
    [self.player stop];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.ifPushStopPlay && !self.ifPushSelectMusic) {
        self.ifPushStopPlay = NO;
        [self.mainView playAllVideo];
        [self.player play];
    }
    self.ifPushSelectMusic = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    self.title = @"编辑";
    [self alertAudioModel];
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.enumView];
    [self.view addSubview:self.shadowBtn];
    [self.navigationController.navigationBar addSubview:self.shadowNavBtn];
    [self.view addSubview:self.sortView];
    [self.view addSubview:self.biliView];
    [self.view addSubview:self.audioSizeView];
    [self createDoneBtn];
    // Do any additional setup after loading the view.
}

/// 初始化音乐model
- (void)alertAudioModel{
    self.audioModel = [[VEAudioModel alloc]init];
    self.audioModel.oldSize = 1;
    self.audioModel.soundtrackSize = 1;
    self.audioModel.beginTime = 0;
    self.audioModel.previewOldSize = 0;
}
    
- (void)createDoneBtn{
    self.doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 26)];
    [self.doneBtn setTitle:@"保存" forState:UIControlStateNormal];
    UIImage *image = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(60, 26)];
    [self.doneBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.doneBtn.layer.masksToBounds = YES;
    self.doneBtn.layer.cornerRadius = 13;
    self.doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *searchBtnBar = [[UIBarButtonItem alloc]initWithCustomView:self.doneBtn];
    self.navigationItem.rightBarButtonItem = searchBtnBar;
}


- (VEMoreLatticeVideoMainView *)mainView{
    if (!_mainView) {
        _mainView = [[VEMoreLatticeVideoMainView alloc]initWithFrame:[self createMainFrameBili:CGSizeMake(9, 16)]];
        _mainView.backgroundColor = self.view.backgroundColor;
        _mainView.videoArr = self.videoArr;
        _mainView.model = self.model;
        _mainView.playStyle = self.playStyle;
        @weakify(self);
        _mainView.changeVideoArrBlock = ^(NSMutableArray * _Nonnull changeArr) {
            @strongify(self);
            self.videoArr = changeArr;
            [self.sortView createDataArr:self.videoArr];
        };
        
        _mainView.playSucceedBlock = ^{
            @strongify(self);
            if ([self.audioModel.audioUrl isNotBlank]) {
                [self.player setCurrentTime:0];
            }
        };
    }
    return _mainView;
}

-(VEMoreLatticeVideoEnumView *)enumView{
    if (!_enumView) {
        _enumView = [[VEMoreLatticeVideoEnumView alloc]initWithFrame:CGRectMake(28, kScreenHeight - Height_SafeAreaBottom - BOTTOM_ENUM_HEIGHT - 20, kScreenWidth-56, BOTTOM_ENUM_HEIGHT)];
        _enumView.videoStyleIndex = self.selectModelIndex;
        @weakify(self);
        _enumView.clickSubBtnBlock = ^(NSInteger selectIndex) {
            @strongify(self);
            self.showSelectF = YES;
            if (selectIndex == 0) {
                [self showSortView];
            }else if (selectIndex == 1){
                [self showCanvasView];
            }else if(selectIndex == 2){
                [self createChangeAudioSizeView];
            }
        };
        _enumView.clickBiliBlock = ^(NSInteger selectIndex) {
            @strongify(self);
            if (self.modelArr.count > selectIndex) {
                self.model = self.modelArr[selectIndex];
                self.selectModelIndex = selectIndex;
                self.mainView.model = self.model;
            }
        };
    }
    return _enumView;
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

- (VEMoreLatticeVideoSortView *)sortView{
    if (!_sortView) {
        _sortView = [[VEMoreLatticeVideoSortView alloc]initWithFrame:CGRectMake(0, kScreenHeight+20, kScreenWidth, 220)];
        _sortView.backgroundColor = [UIColor colorWithHexString:@"#15182A"];
        [_sortView createDataArr:self.videoArr];
        @weakify(self);
        _sortView.clickSureBtnBlock = ^(BOOL ifSucceed, NSInteger playStyle, NSMutableArray * _Nonnull changeArr) {
            @strongify(self);
            self.showSelectF = NO;
            [self showSortView];
            if (ifSucceed) {
                self.playStyle = playStyle;
                [self.mainView changePlayStyle:playStyle andVideoArr:changeArr];
                self.videoArr = changeArr;
                
            }
        };
    }
    return _sortView;
}

- (VEMoreLatticeVideoCanvasView *)biliView{
    if (!_biliView) {
        _biliView = [[VEMoreLatticeVideoCanvasView alloc]initWithFrame:CGRectMake(0, kScreenHeight+20, kScreenWidth, 150)];
        _biliView.backgroundColor = [UIColor colorWithHexString:@"#15182A"];
        @weakify(self);
        _biliView.clickSubChangeBlock = ^(BOOL ifSucceed, NSInteger index, CGSize selectSize) {
            @strongify(self);
            self.showSelectF = NO;
            [self showCanvasView];
            if (ifSucceed) {
                self.biliSelectIndex = index;
                [UIView animateWithDuration:0.2 animations:^{
                    self.mainView.frame = [self createMainFrameBili:selectSize];
                    [self.mainView changeAllSubViewFrame];
                }];
            }
        };
    }
    return _biliView;
}

- (void)clickShadowBtn{}

//改变音量的view
-(VEAudioChangeSizeView *)audioSizeView{
    if (!_audioSizeView) {
        _audioSizeView = [[VEAudioChangeSizeView alloc]initWithFrame:CGRectMake(0, kScreenHeight + 20, kScreenWidth, [VEAudioChangeSizeView viewHeightIfAll:self.audioModel.audioUrl?YES:NO] )];
        _audioSizeView.backgroundColor = self.view.backgroundColor;
        [_audioSizeView changeHeadIfShow:self.audioModel.audioUrl?YES:NO];

        @weakify(self);
        _audioSizeView.clickBtnBlock = ^(BOOL ifSucceed, CGFloat oldSize, CGFloat videoSize) {
            @strongify(self);
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
    [self.mainView playAllVideo];
    [self.player play];

    if (ifSucceed) {
        self.audioModel.oldSize = oldSize;
        self.audioModel.soundtrackSize = videoSize;
        self.audioModel.previewOldSize = oldSize;
        [self.mainView changeAllVolume:oldSize];
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

- (CGRect)createMainFrameBili:(CGSize)biliSize{
    CGFloat top = 20+ Height_NavBar;
    CGFloat h = kScreenHeight - Height_SafeAreaBottom - BOTTOM_ENUM_HEIGHT - top - 20;
    CGFloat bili = biliSize.width/biliSize.height;
    CGFloat w = h*bili;
    CGFloat left = (kScreenWidth-w)/2;
    if (left < 20) {
        left = 20;
        w = kScreenWidth - 20 * 2;
        h = w/bili;
        top = (kScreenHeight - Height_SafeAreaBottom - BOTTOM_ENUM_HEIGHT - h)/2;
        if (top < 20 + Height_NavBar) {
            top = 20 + Height_NavBar;
        }
    }
    return CGRectMake(left, top, w, h);
}

- (void)doneBtnClick{
    [self cropAllVideo];
}

//弹出，隐藏 调整画面比例的view
- (void)showCanvasView{
    if (self.showSelectF) {
        self.biliView.hidden = NO;
        [self.mainView stopAllVideo];
        [self.player stop];
        [self.biliView changeSelectWithIndex:self.biliSelectIndex];
        [UIView animateWithDuration:0.3 animations:^{
            self.biliView.frame = CGRectMake(0, kScreenHeight - Height_SafeAreaBottom-150, kScreenWidth, 150);
            self.shadowBtn.alpha = BTN_ALPHA;
            self.shadowNavBtn.alpha = BTN_ALPHA;
        }];
    }else{
        [self.mainView playAllVideo];
        [self.player play];
        [UIView animateWithDuration:0.3 animations:^{
            self.biliView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth,150);
            self.shadowBtn.alpha = 0.0f;
            self.shadowNavBtn.alpha = 0.0f;
        }completion:^(BOOL finished) {
            self.biliView.hidden = YES;
        }];
    }
}

//弹出，隐藏 排序的view
- (void)showSortView{
    [self.sortView createPlayStyle:self.playStyle];

    if (self.showSelectF) {
        self.sortView.hidden = NO;
        [self.mainView stopAllVideo];
        [self.player stop];
        [UIView animateWithDuration:0.3 animations:^{
            self.sortView.frame = CGRectMake(0, kScreenHeight - Height_SafeAreaBottom-220, kScreenWidth, 220);
            self.shadowBtn.alpha = BTN_ALPHA;
            self.shadowNavBtn.alpha = BTN_ALPHA;
        }];
    }else{
        [self.mainView playAllVideo];
        [self.player play];
        [UIView animateWithDuration:0.3 animations:^{
            self.sortView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth,220);
            self.shadowBtn.alpha = 0.0f;
            self.shadowNavBtn.alpha = 0.0f;
        }completion:^(BOOL finished) {
            self.sortView.hidden = YES;
        }];
    }
}

//调整配乐音量的view
- (void)createChangeAudioSizeView{
    [self.audioSizeView changeHeadIfShow:self.audioModel.audioUrl?YES:NO];
    if (self.showSelectF) {
        [self.mainView stopAllVideo];
        if (!self.ifPushSelectMusic) {
            [self.player stop];
        }
        [self.audioSizeView setOldSize:self.audioModel.oldSize newSize:self.audioModel.soundtrackSize];
        self.audioSizeView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.audioSizeView.frame = CGRectMake(0, kScreenHeight - Height_SafeAreaBottom-[VEAudioChangeSizeView viewHeightIfAll:self.audioModel.audioUrl?YES:NO], kScreenWidth, [VEAudioChangeSizeView viewHeightIfAll:self.audioModel.audioUrl?YES:NO]);
            self.shadowBtn.alpha = BTN_ALPHA;
            self.shadowNavBtn.alpha = BTN_ALPHA;
        }];
    }else{
        [self.mainView playAllVideo];
        [self.player play];
        [UIView animateWithDuration:0.3 animations:^{
            self.audioSizeView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEAudioChangeSizeView viewHeightIfAll:self.audioModel.audioUrl?YES:NO]);
            self.shadowBtn.alpha = 0.0f;
            self.shadowNavBtn.alpha = 0.0f;
        }completion:^(BOOL finished) {
            self.audioSizeView.hidden = YES;
        }];
    }
}

#pragma mark - 音乐播放相关
/// 跳转选择音乐页面
- (void)pushSelectAudioVC{
    VEMediaListController *vc = [VEMediaListController new];
    vc.ifShowCropView = YES;
    
    //获取最小时长
    NSMutableArray *arr = [NSMutableArray new];
    for (VESelectVideoModel *subV in self.videoArr) {
        NSNumber *num = [NSNumber numberWithFloat:subV.videoAss.duration];
        [arr addObject:num];
    }
    vc.minS = [[arr valueForKeyPath:@"@min.floatValue"] intValue];
    
    //获取最大时长
    NSInteger maxTime = 0;
    for (VESelectVideoModel *subV in self.videoArr) {
        maxTime += subV.videoAss.duration;
    }
    vc.maxS = maxTime;
    
    self.ifPushSelectMusic = YES;
    [self.navigationController pushViewController:vc animated:YES];
    @weakify(self);
    vc.cropAudioBlock = ^(NSString * _Nonnull audioPath, BOOL ifAddFile, NSString * _Nonnull audioName) {
        @strongify(self);
        self.audioSizeView.audioTitle.text = audioName;
        self.audioModel.audioUrl = audioPath;
        self.audioModel.isAddFile = ifAddFile;
        [self createChangeAudioSizeView];
        [self createAudioPlayer];
    };
}

/// 跳转选择从视频提取音乐页面
- (void)pushVideoOutAudioVC{
    VESelectVideoController *vc = [VESelectVideoController new];
    vc.videoType = LMEditVideoTypeVideoOutAudioCrop;
    //获取最小时长
    NSMutableArray *arr = [NSMutableArray new];
    for (VESelectVideoModel *subV in self.videoArr) {
        NSNumber *num = [NSNumber numberWithFloat:subV.videoAss.duration];
        [arr addObject:num];
    }
    vc.minS = [[arr valueForKeyPath:@"@min.floatValue"] intValue];
    
    //获取最大时长
    NSInteger maxTime = 0;
    for (VESelectVideoModel *subV in self.videoArr) {
        maxTime += subV.videoAss.duration;
    }
    vc.maxS = maxTime;
    
    self.ifPushSelectMusic = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    @weakify(self);
    vc.selectVideoOutAudioBlock = ^(NSString * _Nonnull audioPath, NSString * _Nonnull nameStr) {
        @strongify(self);
        self.audioSizeView.audioTitle.text = nameStr;
        self.audioModel.audioUrl = audioPath;
        self.audioModel.isAddFile = YES;
        [self createChangeAudioSizeView];
        [self createAudioPlayer];
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
    self.player.numberOfLoops = -1;
    [self.player prepareToPlay];
    [self.player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    LMLog(@"===endTime=播放完成==");
    [self.player play];
}

#pragma mark - 进行制作
- (void)cropAllVideo{
    //判断视频是否等于模板的数量
    if (self.videoArr.count < self.model.maxNum) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"至少选取%zd个视频",self.model.maxNum]];
        return;
    }
    //首先判断视频中有没有大于1分钟的
    BOOL hasDo = YES;
    int errNum = 0;
    for (int x = 0; x < self.videoArr.count; x++) {
        VESelectVideoModel *model = self.videoArr[x];
        if (model.videoAss.duration > 60) {
            hasDo = NO;
            errNum = x+1;
            break;
        }
    }

    if (!hasDo) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"第%d个视频时长大于1分钟，请裁剪",errNum]];
        return;
    }
    self.hud=[[VECreateHUD alloc] init];
    self.cropArr = [NSMutableArray new];
    [self cropAllVideoWithIndex:0];
}

- (void)cropAllVideoWithIndex:(NSInteger)index{
    [self.player stop];
    [self.mainView stopAllVideo];
    
    if (self.mainView.subViewArr.count > index && self.videoArr.count > index) {
        self.doneBtn.userInteractionEnabled = NO;
        LMMoreLatticeVideoSubView *subView = self.mainView.subViewArr[index];
        VESelectVideoModel *selectModel = self.videoArr[index];
        self.videoExecute=[[LSOVideoOneDo alloc] initWithNSURL:[NSURL URLWithString:selectModel.videoUrl]];
 
        CGFloat xBili = fabs(subView.playScrollView.contentOffset.x)/subView.playScrollView.contentSize.width;
        CGFloat yBili = fabs(subView.playScrollView.contentOffset.y)/subView.playScrollView.contentSize.height;
        int x = selectModel.videoAss.width*xBili;
        int y = selectModel.videoAss.height*yBili;
        int w = selectModel.videoAss.width/subView.playScrollView.contentSize.width*subView.playScrollView.frame.size.width;
        int h = selectModel.videoAss.height/subView.playScrollView.contentSize.height*subView.playScrollView.frame.size.height;
        if (w % 2 > 0) {        //取偶数
            w += 1;
        }
        if (h % 2 > 0) {        //取偶数
            h += 1;
        }
//        CGRect cropRect = CGRectMake(x, y, w, h);

        //如果样式是横着三个并且画面比例是9：16
        if (self.model.selectId.intValue == 2 && self.biliSelectIndex == 1) {
            CGFloat videoBili = w/h;
            CGFloat maxW = self.mainView.frame.size.width;
            CGFloat maxH = self.mainView.frame.size.height;
            CGFloat bili = maxW/(maxH/3);
            if (videoBili != bili) {
                h = w/bili;
                if ((int)h %2 > 0) {
                    h += 1;
                    w = h*bili;
                }
//                CGFloat nBili = w/h;
//                if (nBili >= bili-0.03 && nBili <= bili+0.03) {
//                }else{
//                    w -= 2;
//                }
            }
        }
        CGRect cropRect = CGRectMake(x, y, w, h);
        LMLog(@"asdfasdf====%@",NSStringFromCGRect(cropRect));

//        LMLog(@"asdfasdf====superView=%@==subView==%@---=====%@  XXX====%@fscrollFrame=====%@",NSStringFromCGRect(subView.superview.frame),NSStringFromCGRect(subView.frame),NSStringFromCGRect(cropRect),NSStringFromCGPoint(subView.playScrollView.origin),NSStringFromCGRect(subView.playScrollView.frame));
        [self.videoExecute setCropRect:cropRect];
        if (index == 0) {
            [self.hud showProgress:[NSString stringWithFormat:@"制作中0%%"] par:0];
        }
        @weakify(self);
        [self.videoExecute setVideoProgressBlock:^(CGFloat currentFramePts, CGFloat percent) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger max = (int)((percent*100)/self.videoArr.count);
                NSInteger showMax = max+(100/self.videoArr.count)*index;
                CGFloat f = (CGFloat)showMax/100;
                [self.hud showProgress:[NSString stringWithFormat:@"制作中%zd%%",showMax/2] par:f/2];
            });
        }];
        
        [self.videoExecute setCompletionBlock:^(NSString * _Nonnull video) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
//                if (index == 1) {
//                    [self createSueeccd:video videoSize:CGSizeMake(1024, 968)];
//                    return;
//                }
                
                [self.cropArr addObject:video];
                if (self.videoArr.count > index) {
                    [self cropAllVideoWithIndex:index+1];
                }
            });
        }];
        [self.videoExecute start];
    }else{
        [self spliceAllVideo];
    }
}

//拼接视频
-(void)spliceAllVideo{
    CGFloat maxW = self.mainView.frame.size.width*3;
    CGFloat maxH = self.mainView.frame.size.height*3;
    CGFloat maxDur = 0;                 //合成后视频时长
    if (self.playStyle == 0) {          //同时播放，视频时长为最长的视频时长
        NSMutableArray *arr = [NSMutableArray new];
        for (VESelectVideoModel *subV in self.videoArr) {
            NSNumber *num = [NSNumber numberWithFloat:subV.videoAss.duration];
            [arr addObject:num];
        }
        maxDur = [[arr valueForKeyPath:@"@max.floatValue"] floatValue];
    }else{                              //顺序播放，视频时长为所有视频时长的总和
        for (VESelectVideoModel *subV in self.videoArr) {
            maxDur += subV.videoAss.duration;
        }
    }
    self.allExecute = [[DrawPadAllExecute alloc] initWithDrawPadSize:CGSizeMake(maxW, maxH) durationS:maxDur];
    
    //增加视频图层
    for (int x = 0; x < self.cropArr.count; x++) {
        NSString *str = self.cropArr[x];
        LSOVideoAsset * asset1 = [[LSOVideoAsset alloc]initWithPath:str];
        LSOVideoOption *option2=[[LSOVideoOption alloc] init];
        option2.audioVolume=self.audioModel.oldSize;
        int begin = 0;          //开始播放时间
        if (self.playStyle == 1) {      //如果是顺序播放，则开始时间为之前所有视频的时长总和
            if (x > 0) {
                for (int y = 0; y < x; y++) {
                    NSString *str2 = self.cropArr[y];
                    LSOVideoAsset * asset2 = [[LSOVideoAsset alloc]initWithPath:str2];
                    begin += asset2.duration;
                }
            }
        }
         LMLog(@"asdfasdf======maxH=%.2f=======%.2f",asset1.width/asset1.height,maxW/(maxH/3));
        option2.holdFirstFrame = YES;
        LSOVideoFramePen *frame1=[self.allExecute addVideoPen:asset1 option:option2 startPadTime:begin endPadTime:maxDur];
        frame1.fillScale = NO;
        [self setVideoFrameWithPen:frame1 andIndex:x w:maxW h:maxH videoAsset:asset1];
    }
    
    //增加水印（增加图片图层）
    if ([LMUserManager sharedManger].userInfo.vipState.intValue != 1) {
        [self.allExecute addViewPen:[self addTextLogoWithSize:CGSizeMake(maxW, maxH)]];
    }

    //增加音乐图层（要在增加完其他图层最后调用）
    if (self.audioModel.audioUrl.length > 0) {
        NSString *audioUrl = self.audioModel.audioUrl;
        if (![audioUrl containsString:@"file://"]) {
            audioUrl = [NSString stringWithFormat:@"file://%@",self.audioModel.audioUrl];
        }
        [self.allExecute addAudio:[NSURL URLWithString:audioUrl] volume:self.audioModel.soundtrackSize loop:YES];
    }
        
     //设置回调
    @weakify(self);
     [self.allExecute setProgressBlock:^(CGFloat progess) {
         @strongify(self);
         dispatch_async(dispatch_get_main_queue(), ^{
             float percent=(float)(progess/maxDur);
             [self.hud showProgress:[NSString stringWithFormat:@"裁剪中%d%%",(int)((percent*50)+50)] par:(percent/2)+0.5];
//             LMLog(@"sdfasdf====superView=%.2f",percent);
         });
     }];
     
     [self.allExecute setCompletionBlock:^(NSString *dstPath) {
         dispatch_async(dispatch_get_main_queue(), ^{
              @strongify(self);
             [self.hud hide];
             [self createSueeccd:dstPath videoSize:CGSizeMake(maxW, maxH)];
         });
     }];
     
     //开始执行
     [self.allExecute start];
}

/// 制作完成
- (void)createSueeccd:(NSString *)videoPath videoSize:(CGSize)videoSize{
    self.doneBtn.userInteractionEnabled = YES;
    [MBProgressHUD hideHUD];
    [self.hud hide];
    [self.player stop];
    [self.allExecute cancel];
    [self.videoExecute stop];
    
    VEVideoSucceedViewController *vc = [[VEVideoSucceedViewController alloc]init];
    vc.videoPath = videoPath;
    vc.videoSize = videoSize;

    [self.navigationController pushViewController:vc animated:YES];
    LMLog(@"dstPathData ==== %@",[NSData dataWithContentsOfFile:videoPath]);
}

/// 设置拼接视频图层的位置
- (void)setVideoFrameWithPen:(LSOVideoFramePen *)frame1 andIndex:(NSInteger)x w:(CGFloat)maxW h:(CGFloat)maxH videoAsset:(LSOVideoAsset *)asset{
//    CGFloat bili = maxW/maxH;
//    CGFloat videoW = asset.width;
//    CGFloat videoH = videoW/bili;
    
    if (self.model.selectId.intValue == 0) {        //上下两个
        frame1.penSize = CGSizeMake(maxW, maxH/2);
        frame1.drawPadSize = CGSizeMake(maxW, maxH/2);
        frame1.scaleHeightValue = maxH/4;
        if (x == 0) {
            frame1.positionY = maxH/8 ;
        }else{
            frame1.positionY = maxH/2-maxH/8;
        }
    }else if (self.model.selectId.intValue == 1){     //左右两个
        frame1.penSize = CGSizeMake(maxW/2, maxH);
        frame1.drawPadSize = CGSizeMake(maxW/2, maxH);
        frame1.scaleWidthValue = maxW/4;
        if (x == 0) {
            frame1.positionX = maxW/8 ;
        }else{
            frame1.positionX = maxW/2-maxW/8;
        }
    }else if (self.model.selectId.intValue == 2){       //上下三个
        frame1.penSize = CGSizeMake(maxW, maxH/3);
        frame1.drawPadSize = CGSizeMake(maxW, maxH/3);
        frame1.scaleHeightValue = maxH/(3*3);
        if (x == 0) {
            frame1.positionY = maxH/(3*3*2) ;
        }else if (x == 1) {
            frame1.positionY = frame1.drawPadSize.height/2;
        }else{
            frame1.positionY = maxH/3-maxH/(3*3*2);
        }
    }else{                                             //四个
        frame1.penSize = CGSizeMake(maxW/2, maxH/2);
        frame1.drawPadSize = CGSizeMake(maxW/2, maxH/2);
        frame1.scaleWidthValue = maxW/4;
        frame1.scaleHeightValue = maxH/4;
        if (x == 0) {
            frame1.positionX = maxW/8 ;
            frame1.positionY = maxH/8 ;
        }else if (x == 1) {
            frame1.positionX =maxW/2-maxW/8;
            frame1.positionY = maxH/8 ;
        }else if (x == 2) {
            frame1.positionX =maxW/8 ;
            frame1.positionY = maxH/2-maxH/8;
        }else{
            frame1.positionX = maxW/2-maxW/8;
             frame1.positionY = maxH/2-maxH/8;
        }
    }
    LMLog(@"asdfasdf======maxH=%.2f ======%.2f ======%.2f asset.height====%.2f  asset.width====%.2f",maxH,frame1.positionY,frame1.penSize.height,asset.height,asset.width);
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
