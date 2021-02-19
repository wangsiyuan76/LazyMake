//
//  VEAEVideoEditViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/20.
//  Copyright © 2020 xunruiIos. All rights reserved.
// LSOMediaInfo

#import "VEAEVideoEditViewController.h"
#import <LanSongEditorFramework/LanSongEditor.h>
#import <LanSongFFmpegFramework/LSOVideoEditor.h>
#import <LanSongFFmpegFramework/LSOMediaInfo.h>
#import <CallKit/CallKit.h>
#import "VESelectVideoController.h"
#import "VEAlertView.h"

@interface VEAEVideoEditViewController () <CXCallObserverDelegate>
{
    DrawPadAEPreview *aePreview;
    
    LanSongView2 *lansongView;
    LSOBitmapPen *bmpPen;
    CGSize drawpadSize;
    UILabel *labProgress;
    
   
//    NSURL *bgVideoURL;
//    NSURL *mvColorURL;
//    NSURL *mvMaskURL;
//    NSString *json1Path;
    
    NSString *json2Path;
    NSURL *addAudioURL;
            
    unsigned char *rawBytes;
}

@property (strong, nonatomic) NSMutableArray *imageArr;
@property (nonatomic, strong) VECreateHUD *hud;
@property (strong, nonatomic) DrawPadAEExecute * aeExecute;              //制作时的容器
@property (strong, nonatomic) NSString * outAudioUrl;              //提取音乐的url
@property (nonatomic)CXCallObserver *callCenter;

 //-------Ae中的素材
@property (strong, nonatomic) NSURL *bgVideoURL;
@property (strong, nonatomic) NSURL *mvColorURL;
@property (strong, nonatomic) NSURL *mvMaskURL;
@property (strong, nonatomic) NSString *json1Path;

@end

@implementation VEAEVideoEditViewController

-(void)dealloc{
    [VETool deleteAllLansonBoxDataIfAll:NO];
    [self stopAeExecute];
    [self stopAePreview];
    [self.hud hide];
    NSLog(@"AEPreviewDemoVC  dealloc...");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=MAIN_BLACK_COLOR;
    if (self.showModel.customObj.aeType == LMAEVideoType_Audio) {
        self.title = @"编辑";
    }else{
        self.title = @"导入素材";
    }
    self.bgVideoURL=nil;
    self.json1Path=nil;
    self.mvMaskURL=nil;
    self.mvColorURL=nil;
    self.hud=[[VECreateHUD alloc] init];
    self.playAudio = NO;

    [self createBackBtn];
    [self createDefaultImage];
    [self prepareAeAsset];
    [self createHeadView];
    
    [self.navigationController.navigationBar addSubview:self.shadowNavBtn];
    [self.view addSubview:self.stopImageV];
    [self.view addSubview:self.shadowBtn];
    [self.view addSubview:self.changeView];
    [self.view addSubview:self.audioSizeView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.audioCropView];

    [self loadAudioModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardMiss:) name:UIKeyboardWillHideNotification object:nil];
    
    self.callCenter = [[CXCallObserver alloc] init];
    [self.callCenter setDelegate:self queue:dispatch_get_main_queue()];
    // Do any additional setup after loading the view.
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
    if (self.audioModel.audioUrl.length > 0 || self.hasSelelctMedia == YES) {
        VEAlertView *ale = [[VEAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        UIWindow *win = [UIApplication sharedApplication].keyWindow;   
        [ale setContentStr: @"确定退出制作？"];
        [win addSubview:ale];
        @weakify(self);
        ale.clickSubBtnBlock = ^(NSInteger btnTag) {
            @strongify(self);
            if (btnTag == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - CXCallObserverDelegate
- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call{
    if (!call.outgoing && !call.onHold && !call.hasConnected && !call.hasEnded) {
            LMLog(@"来电");
            [self stopAeExecute];
            [self stopAePreview];
            self.doneBtn.userInteractionEnabled = YES;
       } else if (!call.outgoing && !call.onHold && !call.hasConnected && call.hasEnded) {
           LMLog(@"来电-挂掉(未接通)");
           [self startAEPreview];
       } else if (!call.outgoing && !call.onHold && call.hasConnected && !call.hasEnded) {
           LMLog(@"来电-接通");
       } else if (!call.outgoing && !call.onHold && call.hasConnected && call.hasEnded) {
           LMLog(@"来电-接通-挂掉");
           [self startAEPreview];
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

///初始化音乐相关
- (void)loadAudioModel{
    self.audioModel = [[VEAudioModel alloc]init];
    self.audioModel.oldSize = 1;
    self.audioModel.soundtrackSize = 1;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopAeExecute];
    [self stopAePreview];
    if (self.shadowNavBtn.alpha > 0) {
        self.shadowNavBtn.alpha = 0;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.hasStop) {
        [self startAEPreview];
    }
    self.hasStop = NO;
    if (self.shadowBtn.alpha > 0 && self.shadowNavBtn.alpha == 0) {
        self.shadowNavBtn.alpha = self.shadowBtn.alpha;
    }
}

#pragma mark - 创建View(懒加载)
- (UIImageView *)stopImageV{
    if (!_stopImageV) {
        CGRect imageR = [self createMainSize:CGSizeMake(540, 960)];
        _stopImageV = [[UIImageView alloc]initWithFrame:imageR];
        _stopImageV.backgroundColor = [UIColor redColor];
        [_stopImageV setImageWithURL:[NSURL URLWithString:self.showModel.thumb] options:YYWebImageOptionProgressiveBlur];
        _stopImageV.alpha = 0.f;
    }
    return _stopImageV;
}
//替换文字的view
- (VEChangeTextView *)textView{
    if (!_textView) {
        _textView = [[VEChangeTextView alloc]initWithFrame:CGRectMake(0, kScreenHeight + 20, kScreenWidth, [VEChangeTextView viewHeighCount:self.showModel.customObj.texts.count])];
        _textView.backgroundColor = self.view.backgroundColor;
        self.showSelectF = YES;
        self.textArr = [NSMutableArray new];
        for (LMHomeTemplateAETextModel *textModel in self.showModel.customObj.texts) {
            [self.textArr addObject:textModel.fontText];
        }
        _textView.listArr = self.textArr;
        @weakify(self);
        _textView.clickDoneBtnBlock = ^(BOOL ifSucceed, NSInteger selectIndex, NSArray * _Nonnull changeArr) {
            @strongify(self);
            if (ifSucceed) {
                self.hasSelelctMedia = YES;
            }
            [self textViewChangeClick:ifSucceed selectIndex:selectIndex changeArr:changeArr];
        };
    }
    return _textView;
}

//改变图片，视频的view
- (VEChangeImageVideoView *)changeView{
    if (!_changeView) {
        _changeView = [[VEChangeImageVideoView alloc]initWithFrame:CGRectMake(0, kScreenHeight +70, kScreenWidth, 145)];
        _changeView.backgroundColor = self.view.backgroundColor;
        _changeView.hidden = YES;
        _changeView.superVC = self;
        _changeView.showModel = self.showModel;
        _changeView.aeType = self.showModel.customObj.aeType;
        self.showSelectF = YES;
        _changeView.imageSize = [self setImageSize];
        _changeView.listArr = [self createImageVideoArr];;
        @weakify(self);
        _changeView.clickBtnBlock = ^(BOOL ifSucceed, NSArray * _Nonnull mediaArr) {
            @strongify(self);
            [self imageVideoChangeViewClick:ifSucceed mediaArr:mediaArr];
        };
          
        _changeView.stopVidepBlock = ^(BOOL ifStop) {
            @strongify(self);
            self.hasStop = YES;
            [self stopAePreview];
            [self stopAeExecute];
        };
    }
    return _changeView;;
}

//改变音量的view
-(VEAudioChangeSizeView *)audioSizeView{
    if (!_audioSizeView) {
        _audioSizeView = [[VEAudioChangeSizeView alloc]initWithFrame:CGRectMake(0, kScreenHeight + 20, kScreenWidth, [VEAudioChangeSizeView viewHeightIfAll:self.audioModel.audioUrl?YES:NO] )];
        [_audioSizeView changeHeadIfShow:self.audioModel.audioUrl?YES:NO];
        _audioSizeView.backgroundColor = self.view.backgroundColor;
        self.showSelectF = YES;
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
                 [self startAEPreview];
            }];
        };
        
        _audioSizeView.clickDeleteAudioBlock = ^{
            @strongify(self);
            self.audioModel.audioUrl = nil;
        };
    }
    return _audioSizeView;
}

//音乐裁剪的view
- (VEAudioCropView *)audioCropView{
    if (!_audioCropView) {
        _audioCropView = [[VEAudioCropView alloc]initWithFrame:CGRectMake(0, kScreenHeight + 20 , kScreenWidth, [VEAudioCropView viewHeight])];
        _audioCropView.backgroundColor = self.view.backgroundColor;
        _audioCropView.hidden = YES;
        self.showSelectF = YES;
        @weakify(self);
        _audioCropView.changeSelectTimeBlock = ^(NSInteger beginTime, NSInteger endTime, NSInteger continuedTime, BOOL ifLeft) {
            @strongify(self);
            self.audioModel.previewBeginTime = beginTime;
            self.audioModel.previewEndTime = endTime;
        };
        
        _audioCropView.clickDoneBtnBlock = ^(BOOL ifSucceed) {
            @strongify(self);
            [self audioCropViewClick:ifSucceed];
        };
    }
    return _audioCropView;
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

- (UIButton *)shadowBtn{
    if (!_shadowBtn) {
        _shadowBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _shadowBtn.backgroundColor = [UIColor blackColor];
        _shadowBtn.alpha = 0.f;
        [_shadowBtn addTarget:self action:@selector(clickShadowBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shadowBtn;
}

- (void)clickShadowBtn{
    
}

#pragma mark -- 创建View

//顶部完成按钮
-(void)createHeadView{}
/// 底部菜单按钮
- (void)createBottomView{}

//创建改变图片，视频view的model数组
- (NSArray *)createImageVideoArr{
    return [NSMutableArray new];
}

//创建改变图片，视频view选择图片的大小
- (CGSize)setImageSize{
    return CGSizeZero;
}

#pragma mark - 各个弹出操作框的回调方法
//音乐裁剪view点击完成的回调
- (void)audioCropViewClick:(BOOL)ifSucceed{}
//音乐调整音量view点击完成的回调
- (void)audioSizeViewClick:(BOOL)ifSucceed oldSize:(CGFloat)oldSize videoSize:(CGFloat)videoSize{}
//改变图片和视频view的回调
- (void)imageVideoChangeViewClick:(BOOL)ifSucceed mediaArr:(NSArray *__nullable)mediaArr{}
//改变文字view的回调
- (void)textViewChangeClick:(BOOL)ifSucceed selectIndex:(NSInteger)selectIndex changeArr:(NSArray * _Nonnull)changeArr{}

#pragma mark - view的弹出，回收
///选择图片、视频的view
- (void)createChangeImageVideoView{}
//调整配乐音量的view
- (void)createChangeAudioSizeView{}
//裁剪配乐的view
- (void)cropAudioSizeView{}
//更换文字的view
- (void)createChangeTextView{}
//保存提取音乐的view
- (void)showSaveAudioView{}

#pragma mark - 音乐播放器
/// 跳转选择音乐页面
- (void)pushSelectAudioVC{}
//初始化音乐播放器
//- (void)createAudioPlayer{}
//音乐播放进度回调
- (void)updateProgress{}

#pragma mark - 蓝松相关
/**
 准备各种素材
 */
-(void)prepareAeAsset{   
    if (self.showModel.customObj.aeType == LMAEVideoType_Audio) {
        self.bgVideoURL = [NSURL URLWithString:self.showModel.vidoPath];
    }else{
        NSError *error = [NSError new];
        NSFileManager *fileManager= [NSFileManager defaultManager];
        NSArray *fileList= [[NSArray alloc] init];
        fileList= [fileManager contentsOfDirectoryAtPath:self.showModel.unZipPath error:&error];
        for (NSString *file in fileList) {
            NSString *path = [self.showModel.unZipPath stringByAppendingPathComponent:file];
            if ([file containsString:@"data.json"]) {
                self.json1Path = path;
            }else if ([file containsString:@"mvColor.mp4"]){
                if ([path containsString:@"file:///privat"]) {
                    self.mvColorURL = [NSURL URLWithString:path];
                }else{
                    self.mvColorURL =[NSURL URLWithString:[NSString stringWithFormat:@"file:///private%@",path]];
                }
            }else if ([file containsString:@"mvMask.mp4"]){
                if ([path containsString:@"file:///privat"]) {
                    self.mvMaskURL = [NSURL URLWithString:path];
                }else{
                    self.mvMaskURL =[NSURL URLWithString:[NSString stringWithFormat:@"file:///private%@",path]];
                }
            }else if ([file containsString:@"mvBg.mp4"]){
                if ([path containsString:@"file:///privat"]) {
                    self.bgVideoURL = [NSURL URLWithString:path];
                }else{
                    self.bgVideoURL =[NSURL URLWithString:[NSString stringWithFormat:@"file:///private%@",path]];
                }
            }
        }
    }
}

/// 开始生成预览
-(void)startAEPreview{
//    if(aePreview.isRunning){
//        return;
//    }

    [self stopAePreview];
    [self stopAeExecute];
    self.stopImageV.alpha = 0.f;

    //创建容器(容器是用来放置图层, 所有素材都是一层一层叠加起来处理)
    aePreview=[[DrawPadAEPreview alloc] init];
    
    //增加一层视频层
    if(self.bgVideoURL!=nil){
        [aePreview addBgVideoWithURL:self.bgVideoURL];
    }
    //增加json图层;
    LSOAeView *aeView=[aePreview addAEJsonPath:self.json1Path];
    [self replaceAeAsset:aeView];

    //增加MV图层;
    if(self.mvColorURL!=nil && self.mvMaskURL!=nil){
        [aePreview addMVPen:self.mvColorURL withMask:self.mvMaskURL];
    }
    //容器大小,在增加图层后获取;
    drawpadSize=aePreview.drawpadSize;
    if(lansongView==nil){
        CGSize padSize = CGSizeMake(540, 960);
//        drawpadSize=CGSizeMake(aeView1.jsonWidth, aeView1.jsonHeight);
        if (self.showModel.customObj.aeType == LMAEVideoType_Audio) {
            padSize = self.showModel.vidoSize;
        }
        lansongView = [self createLanSongViewDrawpadSize:padSize];
//        [self.view insertSubview:self.stopImageV belowSubview:self.shadowBtn];
        [self.view insertSubview:lansongView belowSubview:self.stopImageV];
    }
    [aePreview addLanSongView:lansongView];
    
    //增加音乐图层
    if (!self.playAudio) {
        if ([self.audioModel.audioUrl isNotBlank]) {
            NSURL *audio=[NSURL URLWithString:self.audioModel.audioUrl];
            if (self.audioModel.isAddFile) {
                audio=[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",self.audioModel.audioUrl]];
            }
            aePreview.aeAudioVolume = self.audioModel.oldSize;
            [aePreview addAudio:audio volume:self.audioModel.soundtrackSize loop:YES];
//            [aePreview addAudio:audio start:self.audioModel.beginTime end:self.audioModel.endTime pos:0 volume:self.audioModel.soundtrackSize];
        }else{
            aePreview.aeAudioVolume = self.audioModel.oldSize;
            [aePreview addAudio:nil volume:0];
        }
    }else{
        aePreview.aeAudioVolume = self.audioModel.previewOldSize;
        [aePreview addAudio:nil volume:0];
    }
  
    //增加回调
    @weakify(self);
    [aePreview setProgressBlock:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }];

    [aePreview setCompletionBlock:^(NSString *path) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.videoUrl = path;
            [self startAEPreview];  //如果没有编码,则让他循环播放
        });
    }];
    
    //开始执行,
    [aePreview start];
}

/**
 开始制作
 */
-(void)startAeExecute{
    self.stopImageV.alpha = 1;
    [self stopAePreview];
    [self stopAeExecute];
    self.hud=[[VECreateHUD alloc] init];
    [self.hud showProgress:[NSString stringWithFormat:@"制作中:0%%"] par:0];
      //1.创建对象;
      self.aeExecute=[[DrawPadAEExecute alloc] init];

      //增加背景视频层;[可选]
      if(self.bgVideoURL!=nil){
          [self.aeExecute addBgVideoWithURL:self.bgVideoURL];
      }

      //2.增加json层
      if(self.json1Path!=nil){
          LSOAeView *aeView=[self.aeExecute addAEJsonPath:self.json1Path];
          [self replaceAeAsset:aeView];
      }

      //3.再增加mv图层;[可选]
      if(self.mvColorURL!=nil && self.mvMaskURL!=nil){
          [self.aeExecute addMVPen:self.mvColorURL withMask:self.mvMaskURL];
      }
          
      //增加音乐图层
      if ([self.audioModel.audioUrl isNotBlank]) {
          NSURL *audio=[NSURL URLWithString:self.audioModel.audioUrl];
          if (self.audioModel.isAddFile) {
              audio=[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",self.audioModel.audioUrl]];
          }
          self.aeExecute.aeAudioVolume = self.audioModel.oldSize;
          [self.aeExecute addAudio:audio volume:self.audioModel.soundtrackSize loop:YES];
      }else{
          self.aeExecute.aeAudioVolume = self.audioModel.oldSize;
      }
      //    self.aeExecute.aeAudioVolume = 0;
    
      //增加logo
      if ([LMUserManager sharedManger].userInfo.vipState.intValue != 1) {
          //增加logo
          LSOBitmapPen *iamgePen = [self.aeExecute addBitmapPen:[UIImage imageNamed:@"watermark_custom_blue"]];
          iamgePen.position = kLSOPenLeftBottom;
          [iamgePen setDisplayTimeRange:0 endTimeS:CGFLOAT_MAX];
      }

      //4.设置回调
      @weakify(self);
      [self.aeExecute setProgressBlock:^(CGFloat progess) {
          @strongify(self);
          dispatch_async(dispatch_get_main_queue(), ^{
              int percent=(int)(progess*100/self.aeExecute.duration);
              [self.hud showProgress:[NSString stringWithFormat:@"制作中:%d%%",percent] par:(double)percent/100];
          });
      }];

      [self.aeExecute setCompletionBlock:^(NSString *dstPath) {
          @strongify(self);
          dispatch_async(dispatch_get_main_queue(), ^{
              self.doneBtn.userInteractionEnabled = YES;
              [self drawpadCompleted:dstPath];
              [self.hud hide];
              VEVideoSucceedViewController *vc = [[VEVideoSucceedViewController alloc]init];
              vc.videoPath = dstPath;
              vc.videoSize = self.playSize;
              vc.customId = self.showModel.tID;
              [self.navigationController pushViewController:vc animated:YES];
          });
      }];
      
      //5.开始执行
      [self.aeExecute start];
}

/// 创建默认图
- (void)createDefaultImage{
    NSMutableArray *arr = [NSMutableArray new];
    NSInteger count = self.showModel.customObj.images.count;
    if (count > 0) {
        for (int x = 0; x < count; x++) {
            LMChangeImageVideoItemModel *mediaModel = [[LMChangeImageVideoItemModel alloc]init];
            mediaModel.ifSelect = YES;
            if (self.showModel.customObj.aeType == LMAEVideoType_AllVideo || self.showModel.customObj.aeType == LMAEVideoType_TextVideo) {
                mediaModel.coverImage = [UIImage imageNamed:@"vm_placeholder_video"];
            }else if (self.showModel.customObj.aeType == LMAEVideoType_AllPic || self.showModel.customObj.aeType == LMAEVideoType_TextPic) {
                mediaModel.coverImage = [UIImage imageNamed:@"vm_placeholder_pic"];
            }else if (self.showModel.customObj.aeType == LMAEVideoType_PicVideo || self.showModel.customObj.aeType == LMAEVideoType_TextPicVideo) {
                mediaModel.coverImage = [UIImage imageNamed:@"vm_placeholder_pic_video"];
            }
            [arr addObject:mediaModel];
        }
        self.mediaArr = arr;
    }
}

/**
 替换AE中的素材
 */
-(void)replaceAeAsset:(LSOAeView *)aeView{
    if (self.mediaArr.count > 0) {
        for (int x = 0; x < self.mediaArr.count; x++) {
            NSString *imageName = [NSString stringWithFormat:@"image_%d",x];
            LMChangeImageVideoItemModel *mediaModel = self.mediaArr[x];
            if (mediaModel.ifSelect) {
                if (mediaModel.ifVideo) {               //替换视频素材
                    LSOAEVideoSetting *setObj = [LSOAEVideoSetting new];
                    setObj.scaleType = kLSOScaleVideoScale;
                    [aeView updateVideoImageWithKey:imageName url:[NSURL URLWithString:mediaModel.videoUrl] setting:setObj];
                }else{                                  //替换图片素材
                    if (mediaModel.coverImage) {
                        [aeView updateImageWithKey:imageName image:mediaModel.coverImage needCrop:YES] ;
                    }
                }
            }
        }
    }
    
    //更新文字
    if (self.textArr.count > 0) {
        NSArray *arr = [[aeView.textInfoArray reverseObjectEnumerator]allObjects];
        for (int x = 0; x < arr.count; x++) {
            if (self.textArr.count > x) {
                LSOAeText *layer = arr[x];
                NSString *str = self.textArr[x];
                LMHomeTemplateAETextModel *fontModel = self.showModel.customObj.texts[x];

                NSString *fontUrl;
                NSError *error = [NSError new];
                NSFileManager *fileManager= [NSFileManager defaultManager];
                NSArray *fileList= [fileManager contentsOfDirectoryAtPath:self.showModel.unZipPath error:&error];
                for (NSString *file in fileList) {
                    NSString *path = [self.showModel.unZipPath stringByAppendingPathComponent:file];
                    if ([file containsString:fontModel.fontUrl]) {
                        fontUrl = path;
                        break;
                    }
                }
                [aeView updateFontWithText:layer.textContents fontPath:fontUrl];
                [aeView updateTextWithOldText:layer.textContents newText:str];
            }
        }
    }
}

-(void)stopAePreview{
    if (aePreview!=nil) {
        [aePreview cancel];
        [aePreview releaseLSO];
        aePreview=nil;
        self.stopImageV.alpha = 1.f;
    }
}
-(void)stopAeExecute{
    if (self.aeExecute!=nil) {
        [self.aeExecute cancel];
        [self.aeExecute releaseLSO];
        self.aeExecute=nil;
        self.stopImageV.alpha = 1.f;
    }
}

-(void)drawpadCompleted:(NSString *)path{
    self.aeExecute=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//点击完成按钮
- (void)clickDoneBtn{
    self.doneBtn.userInteractionEnabled = NO;
    [self startAeExecute];
}

/**
 根据容器大小, 计算应该显示多少到界面上;
 里面默认位置在:0,60;
 代码请自行修改,以满足你的需求;
 @param padSize 容器大小
 @return 得到的容器显示view
 */
-(LanSongView2 *)createLanSongViewDrawpadSize:(CGSize)padSize{
    if(padSize.width>0  && padSize.height>0){
        LanSongView2  *retView=nil;
        CGFloat bili = padSize.width/padSize.height;      //获取视频款高比
        CGFloat maxH = SCREENH_HEIGHT - Height_NavBar - BOTTOM_VIEW_H - Height_SafeAreaBottom - 10;
        CGFloat h = maxH;                       //获取当前设置屏幕上视频高度
        CGFloat w = h * bili;
        if (w > kScreenWidth - 30) {
            w = kScreenWidth - 30;
            h = w / bili;
        }
        CGFloat lR = (kScreenWidth - w) / 2;                                                                                //视频左右间距
        CGFloat top = Height_NavBar + 20;
        if (padSize.width > padSize.height) {
            top = Height_NavBar + 20 + ((maxH - h)/2);
           }
        retView=[[LanSongView2 alloc] initWithFrame:CGRectMake(lR, top, w,h)];
        self.playSize = CGSizeMake(w, h);
        return retView;
    }else{
        LSOLog_e(@"createLanSongView ERROR,pad size is error !")
        return nil;
    }
}

- (CGRect)createMainSize:(CGSize)padSize{
    if(padSize.width>0  && padSize.height>0){
        CGFloat bili = padSize.width/padSize.height;      //获取视频款高比
        CGFloat maxH = SCREENH_HEIGHT - Height_NavBar - BOTTOM_VIEW_H - Height_SafeAreaBottom - 10;
        CGFloat h = maxH;                       //获取当前设置屏幕上视频高度
        CGFloat w = h * bili;
        if (w > kScreenWidth - 30) {
            w = kScreenWidth - 30;
            h = w / bili;
        }
        CGFloat lR = (kScreenWidth - w) / 2;                                                                                //视频左右间距
        CGFloat top = Height_NavBar + 20;
        if (padSize.width > padSize.height) {
            top = Height_NavBar + 20 + ((maxH - h)/2);
           }
        self.playSize = CGSizeMake(w, h);
        return CGRectMake(lR, top, w, h);
    }else{
        LSOLog_e(@"createLanSongView ERROR,pad size is error !")
        return CGRectZero;
    }
}

- (void)keyboardShow:(NSNotification *)noti{
    CGRect keyboardRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (self.showSelectF) {
        self.textView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.textView.frame = CGRectMake(0, kScreenHeight -[VEChangeTextView viewHeighCount:self.showModel.customObj.texts.count]-keyboardRect.size.height, kScreenWidth, [VEChangeTextView viewHeighCount:self.showModel.customObj.texts.count]);
        }];
    }
}

- (void)keyboardMiss:(NSNotification *)noti{
    if (self.showSelectF) {
        self.textView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.textView.frame = CGRectMake(0, kScreenHeight - Height_SafeAreaBottom-[VEChangeTextView viewHeighCount:self.showModel.customObj.texts.count], kScreenWidth, [VEChangeTextView viewHeighCount:self.showModel.customObj.texts.count]);
        }];
    }
}

/// 跳转选择从视频提取音乐页面
- (void)pushVideoOutAudioVC{
    VESelectVideoController *vc = [VESelectVideoController new];
    vc.videoFrame = self.stopImageV.frame;
    vc.videoType = LMEditVideoTypeVideoOutAudio;
    vc.videoOutUrl = self.showModel.customObj.videoPreview;
    self.hasStop = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    @weakify(self);
    vc.selectVideoOutAudioBlock = ^(NSString * _Nonnull audioPath, NSString * _Nonnull nameStr) {
        @strongify(self);
        self.audioSizeView.audioTitle.text = nameStr;
        self.audioModel.audioUrl = audioPath;
        self.audioModel.isAddFile = YES;
        [self createChangeAudioSizeView];
    };
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
