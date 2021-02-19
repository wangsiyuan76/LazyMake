//
//  VETeachDetailViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VETeachDetailViewController.h"
#import <AliyunPlayer/AliyunPlayer.h>
#import "VECreateHUD.h"
#import "VEHomeShareView.h"
#import "VEHomeTemplateModel.h"
#import "VESelectVideoController.h"
#import "VETeachTemplateMakeListController.h"
#import "VESelectMoreGridSelectController.h"
#import "VEHomeApi.h"
#import "VECutoutImageController.h"

#define BOTTOM_VIEW_H 86

@interface VETeachDetailViewController () <AVPDelegate>

@property (assign, nonatomic) BOOL hasNow;              //是否在当前页面
@property (nonatomic, strong) VECreateHUD *hud;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) AliPlayer *player;
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIButton *makeBtn;

@end

@implementation VETeachDetailViewController

- (void)dealloc{
    [self.player pause];
    [self.player stop];
    self.player = nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.hasNow = NO;
    self.playBtn.selected = YES;
    [self.hud hide];
    self.hud = nil;
    [self.player pause];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.hasNow = YES;
    self.hud = [[VECreateHUD alloc]init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_NAV_COLOR;
    self.title = self.model.title;
    [self.view addSubview:self.playView];
    [self.view addSubview:self.playBtn];
    [self.view addSubview:self.makeBtn];
    [self createVideo];
    [self createDoneBtn];
    [self addTeachStatistics];
    [MBProgressHUD showMessage:@"加载中..."];
    // Do any additional setup after loading the view.
}

- (void)addTeachStatistics{
    [[VEHomeApi sharedApi]ve_teachDataStatisticsWithID:self.model.tID Completion:^(id  _Nonnull result) {
    } failure:^(NSError * _Nonnull error) {
    }];
}

- (void)createDoneBtn{
    self.doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 26)];
    [self.doneBtn setImage:[UIImage imageNamed:@"vm_icon_share"] forState:UIControlStateNormal];
    [self.doneBtn addTarget:self action:@selector(clickShareBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchBtnBar = [[UIBarButtonItem alloc]initWithCustomView:self.doneBtn];
    self.navigationItem.rightBarButtonItem = searchBtnBar;
}

- (void)createVideo{
    [AliPlayer setEnableLog:NO];
    self.player = [[AliPlayer alloc] init];
    self.player.delegate = self;
    self.player.loop = YES;
    self.player.autoPlay = YES;
    self.player.scalingMode = AVP_SCALINGMODE_SCALEASPECTFIT;
    self.player.playerView = self.playView;
    
    AVPUrlSource *soucre = [[AVPUrlSource alloc]urlWithString:self.model.vedio];
    [self.player setUrlSource:soucre];
    [self.player prepare];
    [self.player start];
}

- (UIView *)playView{
    if (!_playView) {
        _playView = [[UIView alloc]initWithFrame:[self createVideoSize]];
        _playView.backgroundColor = [UIColor clearColor];
    }
    return _playView;
}

- (UIButton *)makeBtn{
    if (!_makeBtn) {
        _makeBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - 145)/2, self.playView.bottom + 34, 145, 36)];
        [_makeBtn setTitle:@"去制作" forState:UIControlStateNormal];
        [_makeBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _makeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _makeBtn.layer.masksToBounds = YES;
        _makeBtn.layer.cornerRadius = 18;
        [_makeBtn addTarget:self action:@selector(clickMakeBtn) forControlEvents:UIControlEventTouchUpInside];
        UIImage *bacImage = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(145, 36)];
        [_makeBtn setBackgroundImage:bacImage forState:UIControlStateNormal];
    }
    return _makeBtn;
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

- (void)clickPalyBtb{
    self.playBtn.selected = !self.playBtn.selected;
    if (self.playBtn.selected) {
        [self.player pause];
    }else{
        [self.player start];
    }
}

/// 设置视频的宽高  1080  1920
- (CGRect)createVideoSize{
    CGSize videoSize = CGSizeMake(1080, 1920);
    CGFloat bili = videoSize.width/videoSize.height;      //获取视频款高比
    CGFloat maxH = SCREENH_HEIGHT - Height_NavBar - BOTTOM_VIEW_H - Height_SafeAreaBottom - 30;
    CGFloat h = maxH;                       //获取当前设置屏幕上视频高度
    CGFloat w = h * bili;
    if (w > kScreenWidth - 44) {
        w = kScreenWidth - 44;
        h = w / bili;
    }

    CGFloat lR = (kScreenWidth - w) / 2;                                                                                //视频左右间距
    CGFloat top = Height_NavBar + 20;
    if (videoSize.width > videoSize.height) {
        top = Height_NavBar + 20 + ((maxH - h)/2);
    }
    
    return CGRectMake(lR, top, w, h);
}

#pragma mark - AVPDelegate
- (void)onPlayerEvent:(AliPlayer *)player eventType:(AVPEventType)eventType{
    switch (eventType) {
            case AVPEventPrepareDone: {
                // 准备完成
                [MBProgressHUD hideHUD];
            }
                break;
            case AVPEventAutoPlayStart:
                // 自动播放开始事件
                break;
            case AVPEventFirstRenderedStart:
                // 首帧显示
                [MBProgressHUD hideHUD];
                self.playView.hidden = NO;
                break;
            case AVPEventCompletion:
                // 播放完成
                break;
            case AVPEventLoadingStart:
                // 缓冲开始
            LMLog(@"缓冲开始");
             [MBProgressHUD showMessage:@"加载中"];
                break;
            case AVPEventLoadingEnd:
                // 缓冲完成
             [MBProgressHUD hideHUD];
            LMLog(@"缓冲完成");
                break;
            case AVPEventSeekEnd:
                // 跳转完成
                break;
            case AVPEventLoopingStart:
                // 循环播放开始
                [MBProgressHUD hideHUD];
                break;
            default:
                break;
        }
}

- (void)clickShareBtn{
    [self.player pause];
    self.playBtn.selected = YES;
    VEHomeTemplateModel *shareModel = [[VEHomeTemplateModel alloc]init];
    shareModel.shareDes = self.model.title;
    shareModel.title = @"懒人制作";
    shareModel.shareUrl = self.model.vedio;
    shareModel.thumb = self.model.thumb;
    VEHomeShareView *shareView = [[VEHomeShareView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    shareView.showModel = shareModel;
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:shareView];
    [shareView show];
    @weakify(self);
    shareView.cancleBlock = ^{
        @strongify(self);
        [self.player start];
        self.playBtn.selected = NO;
    };
}

- (void)clickMakeBtn{
    if (self.model.type.integerValue == 14) {
        VETeachTemplateMakeListController *makeVC = [[VETeachTemplateMakeListController alloc]init];
        [self.navigationController pushViewController:makeVC animated:YES];
        return;
    }

    LMEditVideoType type = LMEditVideoTypeCrop;
    //0:无;1:编辑;2:弹幕;3:多格;4:换音乐;5:抠图;6:加封面;7:裁剪;8:取音频;9:镜像;10:生成GIF;11:去水印;12:加减速;13:加滤镜;14:模板制作 16:视频拼接
    if (self.model.type.integerValue == 0) {
    }else if (self.model.type.integerValue == 1) {
    }else if (self.model.type.integerValue == 2) {
        [MBProgressHUD showError:@"功能开发中..."];
        return;
    }else if (self.model.type.integerValue == 3) {
        type = LMEditVideoTypeVideoLattice;
    }else if (self.model.type.integerValue == 4) {
        type = LMEditVideoTypeChangeAudio;
    }else if (self.model.type.integerValue == 5) {
        type = LMEditVideoTypeVideoCatout;
    }else if (self.model.type.integerValue == 6) {
        type = LMEditVideoTypeCover;
    }else if (self.model.type.integerValue == 7) {
        type = LMEditVideoTypeCrop;
    }else if (self.model.type.integerValue == 8) {
        type = LMEditVideoTypeOutAudio;
    }else if (self.model.type.integerValue == 9) {
        type = LMEditVideoTypeMirror;
    }else if (self.model.type.integerValue == 10) {
        type = LMEditVideoTypeGIF;
    }else if (self.model.type.integerValue == 11) {
        type = LMEditVideoTypeWatermark;
    }else if (self.model.type.integerValue == 12) {
        type = LMEditVideoTypeSpeed;
    }else if (self.model.type.integerValue == 13) {
        type = LMEditVideoTypeFilter;
    }else if (self.model.type.integerValue == 16) {
        type = LMEditVideoTypeVideoSplice;
    }
    if (type == LMEditVideoTypeVideoLattice) {
        VESelectMoreGridSelectController *vc = [[VESelectMoreGridSelectController alloc]init];
        [currViewController().navigationController pushViewController:vc animated:YES];
    }else if (type == LMEditVideoTypeVideoCatout) {
        VECutoutImageController *vc = [[VECutoutImageController alloc]init];
        [currViewController().navigationController pushViewController:vc animated:YES];
    }else{
        VESelectVideoController *vc = [[VESelectVideoController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.videoType = type;
        [currViewController().navigationController pushViewController:vc animated:YES];
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
