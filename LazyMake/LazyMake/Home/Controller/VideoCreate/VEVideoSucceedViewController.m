//
//  VEVideoSucceedViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/17.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVideoSucceedViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <LanSongEditorFramework/LanSongEditor.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "VECreateSucceedBottomView.h"
#import "VEPushMediaViewController.h"
#import <photos/Photos.h>
#import <LanSongFFmpegFramework/LSOVideoEditor.h>
#import "VEVipMainViewController.h"
#import "VEUserLoginPopupView.h"
#import <SDWebImage/UIImage+GIF.h>
#import <CoreGraphics/CGImage.h>
#import "UIImage+ScallGif.h"

#define BOTTOM_VIEW_H 160

@interface VEVideoSucceedViewController () <NSStreamDelegate>
{
    LSOXAssetInfo *mInfo;
}

//监控进度
@property (nonatomic,strong)NSTimer *avTimer;
@property (nonatomic, strong) VECreateSucceedBottomView *bottomView;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) UIImageView *mainImage;

@property (strong, nonatomic) AVPlayer *myPlayer;//播放器
@property (strong, nonatomic) AVPlayerItem *item;//播放单元
@property (strong, nonatomic) AVPlayerLayer *playerLayer;//播放界面（layer）
@property (nonatomic, strong) UIButton *playBtn;


@end

@implementation VEVideoSucceedViewController

- (void)dealloc{
    if (!self.ifImage) {
        [self.myPlayer pause];
        [self.myPlayer.currentItem cancelPendingSeeks];
        [self.myPlayer.currentItem.asset cancelLoading];
        [self.playerLayer removeFromSuperlayer];
        self.playerLayer=nil;
        self.myPlayer = nil;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    //删除视频压缩后的文件
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建目录
    NSString *createPath = [NSString stringWithFormat:@"%@/Video", pathDocuments];
    BOOL fileExists = [fileManager fileExistsAtPath:createPath];
    if (fileExists) {
        NSError *err;
        [fileManager removeItemAtPath:createPath error:&err];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!self.ifImage) {
        self.playBtn.selected = YES;
        [self.myPlayer pause];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"制作完成";
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    [self createDoneBtn];
    [self createBtooomView];

    if (self.ifImage) {
        [self.view addSubview:self.mainImage];
        [self createGIF];
        
        #ifdef DEBUG
        #else
        [VETool saveImage:[NSURL URLWithString:self.videoPath] toCollectionWithName:@"LazyMake" andImage:self.showImage];
        #endif
    }else{
        [self createVideo];
        [self.view addSubview:self.playBtn];
        
        #ifdef DEBUG
        #else
        [VETool savePhotosVideo:self.videoPath];
        #endif
    }
}

- (void)createVideo{
    NSURL *mediaURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",self.videoPath]];
    self.item = [AVPlayerItem playerItemWithURL:mediaURL];
    self.myPlayer = [AVPlayer playerWithPlayerItem:self.item];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
    self.playerLayer.frame = [self createVideoSize];
    self.playerLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:self.playerLayer];
    [self.myPlayer play];
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:self.myPlayer.currentItem];
}

- (void)moviePlayDidEnd:(NSNotification *)notifi{
    AVPlayerItem*item = [notifi object];
    [item seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {}];
    [self.myPlayer play];
}

- (void)createBtooomView{
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(BOTTOM_VIEW_H);
        make.bottom.mas_equalTo(-Height_SafeAreaBottom);
    }];
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

- (UIImageView *)mainImage{
    if (!_mainImage) {
        CGRect mainFrame = [self createVideoSize];
        _mainImage = [[UIImageView alloc]initWithFrame:mainFrame];
        _mainImage.backgroundColor = [UIColor clearColor];
        _mainImage.contentMode = UIViewContentModeScaleAspectFit;
        if (self.showImage) {
            _mainImage.center = CGPointMake(kScreenWidth/2, mainFrame.size.height/2 + mainFrame.origin.y );
        }
    }
    return _mainImage;
}

- (VECreateSucceedBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[VECreateSucceedBottomView alloc]initWithFrame:CGRectZero];
        _bottomView.ifAe = NO;
        _bottomView.videoPath = self.videoPath;
//        _bottomView.ifHiddenWearerBtn = self.ifHiddenWearerBtn;
        _bottomView.ifHiddenWearerBtn = YES;
        _bottomView.showImage = self.showImage;
        _bottomView.ifImage = self.ifImage;
        _bottomView.imageSize = self.videoSize;
        if ([self.customId isNotBlank]) {
            _bottomView.ifAe = YES;
        }
        @weakify(self);
        _bottomView.clickSubBtnBlock = ^(NSInteger btnTag) {
            @strongify(self);
            if (btnTag == 0) {      //会员去水印
                [self goToVip];
            }else if(btnTag == 1){  //上传视频
                [self pushDetailVC];
            }
        };
    }
    return _bottomView;
}

- (void)clickPalyBtb{
    self.playBtn.selected = !self.playBtn.selected;
    if (self.playBtn.selected) {
        [self.myPlayer pause];
    }else{
        [self.myPlayer play];
    }
}


- (void)pushDetailVC{
    if ([LMUserManager sharedManger].isLogin) {
        VEPushMediaViewController *VC = [[VEPushMediaViewController alloc]init];
        VC.videoSize = self.videoSize;
        VC.vidoeUrl = self.videoPath;
        VC.customId = self.customId;
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        VEUserLoginPopupView *loginView = [[VEUserLoginPopupView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        [win addSubview:loginView];
    }
}

- (void)createDoneBtn{
     UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 26)];
     [doneBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor colorWithHexString:@"#1DABFD"] forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [doneBtn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchBtnBar = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem = searchBtnBar;
}

/// 设置视频的宽高
- (CGRect)createVideoSize{
     mInfo=[[LSOXAssetInfo alloc] initWithPath:self.videoPath];
    CGFloat bili;      //获取视频款高比
    if (mInfo.width > 0) {
        bili = mInfo.width/mInfo.height;
    }else{
        bili = self.videoSize.width/self.videoSize.height;
    }
    CGFloat maxH = SCREENH_HEIGHT - Height_NavBar - BOTTOM_VIEW_H - Height_SafeAreaBottom - 30;
    //获取当前设置屏幕上视频高度
    CGFloat h = maxH;
    CGFloat w = h * bili;
    if (w > kScreenWidth - 30) {
        w = kScreenWidth - 30;
        h = w / bili;
    }
    //视频左右间距
    CGFloat lR = (kScreenWidth - w) / 2;
    CGFloat top = Height_NavBar + 20;
    if (self.videoSize.width > self.videoSize.height) {
          top = Height_NavBar + 20 + ((maxH - h)/2);
    }

    return CGRectMake(lR, top, w, h);
}

- (void)backHome{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/// 会员去水印
- (void)goToVip{
    VEVipMainViewController *vc = [VEVipMainViewController new];
    if ([self.customId isNotBlank]) {
        vc.comeType = VipMouthType_AEVideo;
    }else{
        vc.comeType = VipMouthType_CreateVideo;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createGIF {
    if (self.showImage) {
        self.mainImage.image = self.showImage;
    }else{
        [MBProgressHUD showMessage:@"GIF图片压缩中"];
        dispatch_async(dispatch_queue_create(0, 0), ^{
            [UIImage scallGIFWithData:[NSData dataWithContentsOfFile:self.videoPath] scallSize:CGSizeMake(self.videoSize.width * 0.5, self.videoSize.height * 0.5) succeedBlock:^(NSData *resultData) {
                UIImage *image = [UIImage sd_imageWithGIFData:resultData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    self.mainImage.image = image;
                });
            }];
        });
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
