//
//  VEVideoLanSongViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/17.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVideoLanSongViewController.h"
#import "VEVideoFilterSelectView.h"
#import "VECreateBottomFeaturesView.h"
#import <LanSongEditorFramework/LanSongEditor.h>
#import <LanSongFFmpegFramework/LSOVideoEditor.h>
#import "VEVideoSucceedViewController.h"
#import "VECreateHUD.h"

#define BOTTOM_VIEW_H 140

@interface VEVideoLanSongViewController (){
    LanSongView2  *lansongView;
    NSString *srcPath;
    
    BOOL  isSelectFilter;
    NSString *dstPath;
}
@property (nonatomic, strong) VEVideoFilterSelectView *filterView;    //选择滤镜的view
@property (nonatomic, assign) BOOL showSelectF;    //选择滤镜的view
@property LanSongOutput<LanSongInput> *currentFilter;     //当前使用的滤镜
@property LanSongOutput<LanSongInput> *oldFilter;        //上次使用的滤镜

@property (nonatomic, strong) DrawPadVideoPreview *drawpadPreview;
@property (nonatomic, strong) DrawPadVideoExecute  *drawpadExecute;
@property (nonatomic, assign) NSInteger  oldSelect;

@property (nonatomic, strong) VECreateHUD *hud;
@property (nonatomic, strong) UIButton *doneBtn;
@end

@implementation VEVideoLanSongViewController

//--------------------一下是ui界面.
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    isSelectFilter=NO;
    if(self.drawpadPreview==nil){
        [self startPreview];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (isSelectFilter==NO) {
        [self stopDrawpad];
    }
}

-(void)dealloc{
//    self.filterListVC=nil;
    dstPath=nil;
    self.drawpadPreview=nil;
    
    [LSOFileUtil deleteFile:dstPath];
    NSLog(@"Demo3PenFilterVC dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_NAV_COLOR;
    srcPath = self.videoModel.videoAss.videoPath;
    self.hud=[[VECreateHUD alloc] init];
    lansongView=[self createLanSongViewDrawpadSize:self.videoModel.videoAss.videoSize];
    [self.view addSubview:lansongView];
    [self createFiltersBottomView];
    [self initView];
    [self.view addSubview:self.filterView];

    // Do any additional setup after loading the view.
}

/// 滤镜底部按钮
- (void)createFiltersBottomView{
    VECreateBottomFeaturesView *subV = [[VECreateBottomFeaturesView alloc]initWithFrame:CGRectMake(0, kScreenHeight - Height_SafeAreaBottom - BOTTOM_VIEW_H , self.view.width, BOTTOM_VIEW_H) titleArr:@[@"滤镜"] imageArr:@[@"vm_detail_material_filter"]];
    subV.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:subV];
    @weakify(self);
    subV.clickBtnBlock = ^(NSInteger btnTag) {
        @strongify(self);
        self.showSelectF = YES;
        [self createFilterView];
    };
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
        CGFloat maxH = SCREENH_HEIGHT - Height_NavBar - BOTTOM_VIEW_H - Height_SafeAreaBottom - 20;
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
        return retView;
    }else{
        LSOLog_e(@"createLanSongView ERROR,pad size is error !")
        return nil;
    }
}

- (VEVideoFilterSelectView *)filterView{
    if (!_filterView) {
        _filterView = [[VEVideoFilterSelectView alloc]initWithFrame:CGRectMake(0, kScreenHeight +20, kScreenWidth, 145)];
        _filterView.backgroundColor = self.view.backgroundColor;
        _filterView.hidden = YES;
        
        @weakify(self);
        _filterView.clickBtnBlock = ^(BOOL ifSucceed, NSInteger selectIndex, VEFilterSelectModel * _Nonnull model) {
            @strongify(self);
            self.showSelectF = YES;
            if (ifSucceed) {
                self.oldFilter = model.selectedFilter;
                self.oldSelect = selectIndex;
        //            self.oldFilter = model.selectedFilter;
        //            [self.drawpadPreview.videoPen switchFilter:model.selectedFilter]; //切换滤镜.
            }else{
                self.currentFilter = self.oldFilter;
                [self.drawpadPreview.videoPen switchFilter:self.currentFilter]; //切换滤镜.
            }
                        
            [UIView animateWithDuration:0.2 animations:^{
                self.filterView.frame = CGRectMake(0, kScreenHeight+70, kScreenWidth, 145);
            }completion:^(BOOL finished) {
                self.filterView.hidden = YES;
            }];
        };
        _filterView.clickSubFilBlock = ^(VEFilterSelectModel * _Nonnull model) {
            @strongify(self);
            self.currentFilter = model.selectedFilter;
            [self.drawpadPreview.videoPen switchFilter:model.selectedFilter]; //切换滤镜.
        };
    }
    return _filterView;
}

/// 视频滤镜选择的view
- (void)createFilterView{
//    if (!self.filterView) {
//        self.filterView = [[VEVideoFilterSelectView alloc]initWithFrame:CGRectMake(0, kScreenHeight +20, kScreenWidth, 145)];
//        self.filterView.backgroundColor = self.view.backgroundColor;
//        [self.view addSubview:self.filterView];
//        self.showSelectF = YES;
//    }
    if (self.showSelectF) {
        self.filterView.hidden = NO;
        self.filterView.oldSelect = self.oldSelect;
        [UIView animateWithDuration:0.2 animations:^{
            self.filterView.frame = CGRectMake(0, kScreenHeight - Height_SafeAreaBottom-145, kScreenWidth, 145);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.filterView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, 145);
        }completion:^(BOOL finished) {
            self.filterView.hidden = YES;
        }];
    }
}

/**
 开始前台容器
 */
-(void)startPreview{
    //创建容器
    self.drawpadPreview=[[DrawPadVideoPreview alloc] initWithPath:srcPath drawPadSize:lansongView.frame.size];
    self.drawpadPreview.videoPen.loopPlay=YES;
    self.drawpadPreview.videoPen.scaleWH=lansongView.frame.size.width/self.videoModel.videoAss.width;
    [self.drawpadPreview addLanSongView:lansongView];
    [self.drawpadPreview setProgressBlock:^(CGFloat progress) {
//        [weakSelf progressBlock:progress];
    }];
    
    isSelectFilter=NO;
    [self.drawpadPreview start];
    
    if (self.currentFilter) {
        [self.drawpadPreview.videoPen switchFilter:self.currentFilter]; //切换滤镜.
        
    }

    LMLog(@"=====self.drawpadPreview=====%@",NSStringFromCGSize(self.drawpadPreview.drawpadSize));
}

/**
 后台处理后, 调用这里
 */
-(void)drawpadCompleted:(NSString *)path{
    dstPath=path;
    isSelectFilter=NO;
    self.drawpadExecute=nil;
}
/**
 停止drawpad的执行.
 */
-(void)stopDrawpad{
    isSelectFilter=NO;
    if(self.drawpadPreview!=nil){
        [self.drawpadPreview cancel];
        self.drawpadPreview=nil;
    }
}

-(void) startPreview:(NSString *)dstPath{
    [self drawpadCompleted:dstPath];
}

/// 制作完成
- (void)createSueeccd:(NSString *)videoPath{
    VEVideoSucceedViewController *vc = [[VEVideoSucceedViewController alloc]init];
    vc.videoPath = videoPath;
    vc.videoSize = self.videoModel.videoSize;
    [self.navigationController pushViewController:vc animated:YES];
        LMLog(@"dstPath ==== %@",videoPath);
}

//布局其他界面
-(void)initView{
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

/**
 开始后台容器执行.
 filter 滤镜可以和执行前台预览时的共用同一个对象.
 */
-(void)doneBtnClick{
    self.doneBtn.userInteractionEnabled = NO;
    self.hud=[[VECreateHUD alloc] init];
    [self stopDrawpad];
    self.drawpadExecute=[[DrawPadVideoExecute alloc] initWithPath:srcPath];
    [self.drawpadExecute.videoPen switchFilter:(LanSongFilter *)self.currentFilter];     //增加滤镜
    
    if ([LMUserManager sharedManger].userInfo.vipState.intValue != 1) {
        //增加logo
        [self.drawpadExecute addViewPen:[self addTextLogoWithSize:CGSizeMake(self.videoModel.videoAss.width, self.videoModel.videoAss.height)]];
    }

    [self.hud showProgress:[NSString stringWithFormat:@"制作中0%%"] par:0];
    @weakify(self);
    [self.drawpadExecute setProgressBlock:^(CGFloat progess) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            int percent=(int)(progess*100/self.drawpadExecute.duration);
            [self.hud showProgress:[NSString stringWithFormat:@"制作中%d%%",percent] par:(double)percent/100];
        });
    }];
    [self.drawpadExecute setCompletionBlock:^(NSString *dstPath) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.doneBtn.userInteractionEnabled = YES;
            [self.hud hide];
            [self createSueeccd:dstPath];
            [self startPreview:dstPath];
        });
    }];
    [self.drawpadExecute start];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//-----------测试客户的
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
