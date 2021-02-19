//
//  VESelectVideoController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/15.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VESelectVideoController.h"
#import "VESelectVideoListCell.h"
#import <Photos/PHAsset.h>
#import <Photos/PHFetchOptions.h>
#import <Photos/Photos.h>
#import "VEVideoEditViewController.h"
#import <LanSongEditorFramework/LanSongEditor.h>
#import "VEVideoLanSongViewController.h"
#import "VEHomeTemplateModel.h"
#import "VEAEVideoEditViewController.h"
#import "VEVideoSucceedViewController.h"
#import "VEVideoEditSpeedViewController.h"
#import "VEAudioCropViewController.h"
#import "VEVideoSelectSpliceView.h"
#import "VECutoutImageController.h"
#import "VESelectMoreGridSelectController.h"
#define TITLE_VIEW_H 34

@implementation PHAsset (PLSImagePickerHelpers)

- (NSURL *)movieURL {
    __block NSURL *url = nil;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    if (self.mediaType == PHAssetMediaTypeVideo) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionOriginal;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = YES;
        
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:self options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            url = urlAsset.URL;
            dispatch_semaphore_signal(semaphore);
        }];
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return url;
}

/**
 获取视频略缩图
 */
- (UIImage *)imageURL:(PHAsset *)phAsset targetSize:(CGSize)targetSize {
    __block UIImage *image = nil;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    //    options.networkAccessAllowed = YES;
    //    options.synchronous = YES;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    PHImageManager *manager = [PHImageManager defaultManager];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.normalizedCropRect = CGRectMake(0, 0, targetSize.width, targetSize.height);
    
    [manager requestImageForAsset:phAsset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        image = result;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return image;
}

/// 获取视频时长
- (void)loadVideoTime:(VESelectVideoModel *)model completeBlock:(void(^)(void))completeBlock{
    if (self.mediaType == PHAssetMediaTypeVideo) {
        PHVideoRequestOptions *videoOptions = [[PHVideoRequestOptions alloc] init];
        videoOptions.version = PHVideoRequestOptionsVersionOriginal;
        videoOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        videoOptions.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestAVAssetForVideo:model.phData options:videoOptions resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
              if ([asset isKindOfClass:[AVURLAsset class]]) {
                  AVURLAsset* urlAsset = (AVURLAsset*)asset;
                  model.ifLoading = NO;
                  model.videoUrl = urlAsset.URL.absoluteString;
                  
                  model.videoAss = [[LSOVideoAsset alloc] initWithURL:urlAsset.URL];
                  //获取视频时长
                  long int second = urlAsset.duration.value/urlAsset.duration.timescale;
                  model.second = second;
                  NSNumber *size;
                  [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
                  model.fileSize = [size floatValue]/(1024.0*1024.0);
                  int seconds = second % 60;
                  int minutes = (second / 60) % 60;
                  int hours = second / 3600;
                  model.timeStr = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hours,minutes,seconds];
                  
                  //获取视频的长宽高
                  NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
                  if (tracks.count > 0) {
                      AVAssetTrack *videoTrack = tracks[0];
                      CGSize videoSize = CGSizeApplyAffineTransform(videoTrack.naturalSize, videoTrack.preferredTransform);
                      videoSize = CGSizeMake(fabs(videoSize.width), fabs(videoSize.height));
                      model.videoSize = videoSize;
                      if (completeBlock) {
                          completeBlock();
                      }
                  }
            }}];
    }
}

@end
@interface VESelectVideoController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) PHAssetMediaType mediaType;
@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) VEVideoSelectSpliceView *selectView;

//当前页面裁剪音乐相关
@property (strong, nonatomic) VEAudioCropView *audioCropView;           //配乐裁剪view
@property (assign, nonatomic) BOOL showSelectF;                         //是否弹出
@property (strong, nonatomic) UIButton *shadowBtn;                      //背景遮罩btn
@property (strong, nonatomic) UIButton *shadowNavBtn;                   //背景遮罩btn
@property (nonatomic, assign) double endTime;
@property (assign, nonatomic) double audioDur;                          //音频时长
@property (nonatomic, strong) NSString *cropUrl;                        //音频裁剪后的地址
@property (strong, nonatomic) NSString *audioPath;                      //音频地址
@property (strong, nonatomic) NSString *temporaryAudioPath;              //临时音频地址
@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation VESelectVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    self.title = @"选择视频";
    self.assets = [NSMutableArray array];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.selectView];
    [self setAllViewLayout];
    if (self.videoType == LMEditVideoTypeSelect || self.videoType == LMEditVideoTypeSelectNo) {
        [self createBackBtn];   
    }
    if (self.videoType == LMEditVideoTypeVideoOutAudioCrop) {
        [self.navigationController.navigationBar addSubview:self.shadowNavBtn];
        [self.view addSubview:self.shadowBtn];
        [self.view addSubview:self.audioCropView];
    }
        
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized) {
        [self fetchAssetsWithMediaType:PHAssetMediaTypeVideo];
    }else if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusRestricted || PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusDenied){
        [self showAlert];
    }else{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized){//允许
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self fetchAssetsWithMediaType:PHAssetMediaTypeVideo];
                });
            }else{//拒绝
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:@"用户已拒绝"];
                });
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

- (void)showAlert{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"请在“设置”中为APP打开权限"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * action) {}];
    UIAlertAction* nanAct = [UIAlertAction actionWithTitle:@"去打开" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
                                                             }];

    [alert addAction:nanAct];
    [alert addAction:cancelAction];
    [currViewController() presentViewController:alert animated:YES completion:nil];
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
    if (self.videoType == LMEditVideoTypeSelect || self.videoType == LMEditVideoTypeSelectNo) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setAllViewLayout{
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(Height_NavBar);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(TITLE_VIEW_H);
    }];
    
    @weakify(self);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.titleView.mas_centerX);
        make.centerY.mas_equalTo(self.titleView.mas_centerY);
    }];
       
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(self.titleView.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(-10);
    }];
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _titleLab.alpha = 0.8f;
        
        if (self.videoType == LMEditVideoTypeBack) {
            _titleLab.text = @"任意选择一个视频进行倒放";
        }else if (self.videoType == LMEditVideoTypeMirror){
            _titleLab.text = @"任意选择一个视频制作镜像";
        }else if (self.videoType == LMEditVideoTypeSpeed){
            _titleLab.text = @"任意选择一个视频加减速";
        }else if (self.videoType == LMEditVideoTypeGIF){
            _titleLab.text = @"任意选择一个视频生成GIF";
        }else if (self.videoType == LMEditVideoTypeWatermark){
            _titleLab.text = @"任意选择一个视频去除水印";
        }else if (self.videoType == LMEditVideoTypeCrop){
            _titleLab.text = @"任意选择一个视频裁剪";
        }else if (self.videoType == LMEditVideoTypeChangeAudio){
            _titleLab.text = @"任意选择一个视频更换音乐";
        }else if (self.videoType == LMEditVideoTypeCover){
            _titleLab.text = @"任意选择一个视频增加封面";
        }else if (self.videoType == LMEditVideoTypeFilter){
            _titleLab.text = @"任意选择一个视频增加滤镜";
        }else if (self.videoType == LMEditVideoTypeOutAudio){
            _titleLab.text = @"任意选择一个视频提取音乐";
        }else if (self.videoType == LMEditVideoTypeSelect){
            _titleLab.text = @"任意选择一个视频";
        }else if (self.videoType == LMEditVideoTypeVideoOutAudio || self.videoType == LMEditVideoTypeVideoOutAudioCrop){
            _titleLab.text = @"任意选择一个视频提取音乐";
        }else if (self.videoType == LMEditVideoTypeVideoSplice){
            _titleLab.text = @"任意选择2-6个视频进行拼接";
            _selectView.hidden = NO;
        }else if (self.videoType == LMEditVideoTypeVideoLattice){
            _selectView.hidden = NO;
            _titleLab.text = [NSString stringWithFormat:@"任意选择%zd个视频进行拼接",self.moreGridModel.maxNum];
        }else if (self.videoType == LMEditVideoTypeSelectNo){
            _titleLab.text = @"任意选择一个视频";
        }
    }
    return _titleLab;
}

- (UIButton *)shadowNavBtn{
    if (!_shadowNavBtn) {
        _shadowNavBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, -Height_StatusBar, kScreenWidth, Height_NavBar)];
        _shadowNavBtn.backgroundColor = [UIColor blackColor];
        _shadowNavBtn.alpha = 0.f;
    }
    return _shadowNavBtn;
}

- (UIButton *)shadowBtn{
    if (!_shadowBtn) {
        _shadowBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _shadowBtn.backgroundColor = [UIColor blackColor];
        _shadowBtn.alpha = 0.f;
    }
    return _shadowBtn;
}

//音乐裁剪的view
- (VEAudioCropView *)audioCropView{
    if (!_audioCropView) {
        CGFloat top = kScreenHeight + 20;
        _audioCropView = [[VEAudioCropView alloc]initWithFrame:CGRectMake(0,top , kScreenWidth, [VEAudioCropView viewHeight])];
        _audioCropView.backgroundColor = self.view.backgroundColor;
        _audioCropView.titleLab.font = [UIFont systemFontOfSize:16];
        _audioCropView.titleLab.text = [NSString stringWithFormat:@"建议裁剪时长大于%zds",self.minS];
        @weakify(self);
        _audioCropView.changeSelectTimeBlock = ^(NSInteger beginTime, NSInteger endTime, NSInteger continuedTime, BOOL ifLeft) {
            @strongify(self);
            if ((endTime - beginTime) > self.minS) {
                self.audioCropView.titleLab.text = [NSString stringWithFormat:@"建议裁剪时长小于%zds",self.maxS];
            }else{
                self.audioCropView.titleLab.text = [NSString stringWithFormat:@"建议裁剪时长大于%zds",self.minS];
            }
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
            self.temporaryAudioPath = str;
            [self playAudioWithUrl:str];
        };
        
        _audioCropView.clickDoneBtnBlock = ^(BOOL ifSucceed) {
            @strongify(self);
            self.showSelectF = NO;
            [self cropAudioSizeView];
            [self.player stop];
            if (ifSucceed) {
                self.cropUrl = self.temporaryAudioPath;
                NSString*currentDateString = [VETool getCurrentTimesFormat:@"yyyyMMddHHmmss"];
                if (self.selectVideoOutAudioBlock) {
                    [self.navigationController popViewControllerAnimated:YES];
                    self.selectVideoOutAudioBlock(self.cropUrl,currentDateString);
                }
            }
        };
    }
    return _audioCropView;
}

- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [UIView new];
        _titleView.backgroundColor = [UIColor colorWithHexString:@"#1DABFD"];
        _titleView.alpha = 0.3f;
    }
    return _titleView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat w = ((kScreenWidth - 28 - 6) / 3) - 1;
        layout.itemSize = CGSizeMake(w, 185);
        layout.minimumInteritemSpacing = 3.0;
        layout.minimumLineSpacing = 3.0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[VESelectVideoListCell class] forCellWithReuseIdentifier:VESelectVideoListCellStr];
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _collectionView;
}

- (VEVideoSelectSpliceView *)selectView{
    if (!_selectView) {
        _selectView = [[VEVideoSelectSpliceView alloc]initWithFrame:CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEVideoSelectSpliceView viewHeight])];
        _selectView.backgroundColor = self.view.backgroundColor;
        _selectView.hidden = YES;
        _selectView.videoType = self.videoType;
        _selectView.model = self.moreGridModel;
        _selectView.modelArr = self.modelArr;
        _selectView.selectModelIndex = self.selectModelIndex;
        @weakify(self);
        _selectView.deleteAllBlock = ^{
            @strongify(self);
            [UIView animateWithDuration:0.2 animations:^{
                self.selectView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEVideoSelectSpliceView viewHeight]);
            }];
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.bottom.mas_equalTo(-(10));
            }];
        };
    }
    return _selectView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [self fetchAssetsWithMediaType:self.mediaType];
                } else {
                }
            });
        }];
    } else if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusDenied) {
    } else {
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VESelectVideoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VESelectVideoListCellStr forIndexPath:indexPath];
    cell.index = indexPath.row;
    if (self.videoType == LMEditVideoTypeVideoSplice || self.videoType == LMEditVideoTypeVideoLattice) {
        cell.selectBtn.hidden = NO;
        @weakify(self);
        cell.clickSelectBtnBlock = ^(NSInteger index) {
            @strongify(self);
            [self addVideoWithIndex:index];
        };
    }else{
        cell.selectBtn.hidden = YES;
    }
    if (self.dataArr.count > indexPath.row) {
        VESelectVideoModel *model = self.dataArr[indexPath.row];
        cell.mainImage.image = model.showImage;
        cell.timeLab.text = model.timeStr;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArr.count > indexPath.row) {
        VESelectVideoModel *model = self.dataArr[indexPath.row];
        if (model.ifLoading) {
//            [MBProgressHUD showError:@"正从iCloud同步数据"];
            [MBProgressHUD showMessage:@"iCloud同步数据中..."];
            [model.phData loadVideoTime:model completeBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    [self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
                });
            }];
        }else{
            if (self.videoType == LMEditVideoTypeFilter) {
                VEVideoLanSongViewController *VC = [[VEVideoLanSongViewController alloc]init];
                VC.videoModel = model;
                VC.videoType = self.videoType;
                [currViewController().navigationController pushViewController:VC animated:YES];
            }else if (self.videoType == LMEditVideoTypeSpeed || self.videoType == LMEditVideoTypeVideoSplice || self.videoType == LMEditVideoTypeVideoLattice) {
                VEVideoEditSpeedViewController *VC= [[VEVideoEditSpeedViewController alloc]init];
                VC.videoModel = model;
                VC.videoType = self.videoType;
                [self.navigationController pushViewController:VC animated:YES];
            }else if (self.videoType == LMEditVideoTypeVideoOutAudio) {
                VEAudioCropViewController *VC= [[VEAudioCropViewController alloc]init];
                VC.videoPath = self.videoOutUrl;
                VC.videoFrame = self.videoFrame;
                VC.videoOutPath = model.videoUrl;
                VC.ifAddF = YES;
                VC.hasOut = YES;
                VC.audioDur = model.videoAss.duration;
                [self.navigationController pushViewController:VC animated:YES];
                
                @weakify(self);
                VC.cropAudioBlock = ^(NSString * _Nonnull audioPath, BOOL ifAddFile) {
                    @strongify(self);
                    NSString*currentDateString = [VETool getCurrentTimesFormat:@"yyyyMMddHHmmss"];
                    if (self.selectVideoOutAudioBlock) {
                        self.selectVideoOutAudioBlock(audioPath,currentDateString);
                    }
                };
            }else if(self.videoType == LMEditVideoTypeVideoCatout){
                VECutoutImageController *vc = [[VECutoutImageController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else if(self.videoType == LMEditVideoTypeSelectNo){
                if (self.dismissSelectBlock) {
                    self.dismissSelectBlock(model, model.videoUrl);
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }else if(self.videoType == LMEditVideoTypeVideoOutAudioCrop){
                [self pushVideoCropVCWithModel:model];
            }else{
                VEVideoEditViewController *VC = [[VEVideoEditViewController alloc]init];
                VC.videoModel = model;
                VC.videoType = self.videoType;
                VC.cropBili = self.cropBili;
                [self.navigationController pushViewController:VC animated:YES];
                VC.dismissSelectBlock = ^(VESelectVideoModel * _Nonnull videoModel, NSString * _Nonnull videoPath) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    if (self.dismissSelectBlock) {
                        self.dismissSelectBlock(videoModel, videoPath);
                    }
                };
            }
        }
    }
}

//当前页面裁剪音乐布局
- (void)pushVideoCropVCWithModel:(VESelectVideoModel *)subModel{
    self.showSelectF = YES;
    self.audioCropView.allTime = subModel.videoAss.duration;
    self.audioDur = subModel.videoAss.duration;
    self.endTime = subModel.videoAss.duration;
    
    NSString *changeAudilUrl = subModel.videoUrl;
    if ([subModel.videoUrl containsString:@"file://"]) {
        changeAudilUrl = [subModel.videoUrl stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    }
    NSString *audioUrl = [LSOVideoEditor executeGetAudioTrack:changeAudilUrl];
    self.audioPath = audioUrl;
    self.cropUrl = audioUrl;
    self.temporaryAudioPath = audioUrl;
    [self cropAudioSizeView];
    [self playAudioWithUrl:audioUrl];
}

//获取本地相册数据
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
- (void)fetchAssetsWithMediaType:(PHAssetMediaType)mediaType {
    CGFloat scale = [UIScreen mainScreen].scale;
    //            CGFloat scale = 1;
    CGFloat w = (([UIScreen mainScreen].bounds.size.width-32) / 3) - 1;
    CGSize size = CGSizeMake(w * scale, w * scale);
    
    [MBProgressHUD showMessage:@"加载中..."];
    WS(weakSelf)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.includeHiddenAssets = NO;
        fetchOptions.includeAllBurstAssets = NO;
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO],
                                         [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:mediaType options:fetchOptions];
        
        NSMutableArray *assets = [[NSMutableArray alloc] init];
        weakSelf.dataArr = [[NSMutableArray alloc] init];
        [fetchResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PHAsset *asset = (PHAsset *)obj;
            if(obj!=nil){
                VESelectVideoModel *model = [VESelectVideoModel new];
                model.phData = obj;
                model.ifLoading = YES;
                [assets addObject:obj];
                  
                UIImage *image1=[asset imageURL:asset targetSize:size];
                if(image1!=nil){
                    model.showImage = image1;
                }else{
                    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
                    option.resizeMode = PHImageRequestOptionsResizeModeFast;
                    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(((kScreenWidth - 28 - 6) / 3), 200) contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                         UIImage *iamge = result;
                         model.showImage = iamge;
                     }];
                }
//                [asset loadVideoTime:model completeBlock:^{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.collectionView reloadData];
//                    });
//                }];
                [self.dataArr addObject:model];
            }
        }];

        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            weakSelf.assets = assets;
            [weakSelf.collectionView reloadData];
        });
    });
}

- (void)delayMethod{
    [self fetchAssetsWithMediaType:PHAssetMediaTypeVideo];
}

- (void)addVideoWithIndex:(NSInteger)index{
    if (self.dataArr.count > index) {
        VESelectVideoModel *model = self.dataArr[index];
        if (model.ifLoading) {
//            [MBProgressHUD showError:@"正从iCloud同步数据"]2;
            [MBProgressHUD showMessage:@"iCloud同步数据中..."];
            [model.phData loadVideoTime:model completeBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    [self addVideoWithIndex:index];
                });
            }];
            return;
        }
        if (self.videoType == LMEditVideoTypeVideoSplice) {
            [self.selectView inseartObj:model maxNumber:6];
        }else{
            [self.selectView inseartObj:model maxNumber:self.moreGridModel.maxNum];
        }
        self.selectView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.selectView.frame = CGRectMake(0, kScreenHeight-[VEVideoSelectSpliceView viewHeight], kScreenWidth, [VEVideoSelectSpliceView viewHeight]);
        }];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.bottom.mas_equalTo(-([VEVideoSelectSpliceView viewHeight]));
        }];
    }
}

//播放音乐
- (void)playAudioWithUrl:(NSString *)audioUrl{
    [self.player stop];
    self.player = nil;
    if (![audioUrl containsString:@"file://"]) {
        audioUrl = [NSString stringWithFormat:@"file://%@",audioUrl];
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:audioUrl] error:nil];
    self.player.numberOfLoops = -1;
    self.player.volume = 1;
    [self.player prepareToPlay];
    [self.player play];
}

//裁剪配乐的view
- (void)cropAudioSizeView{
    if (self.showSelectF) {
        self.audioCropView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.shadowBtn.alpha = BTN_ALPHA;
            self.shadowNavBtn.alpha = BTN_ALPHA;
            self.audioCropView.frame = CGRectMake(0, kScreenHeight - Height_SafeAreaBottom-[VEAudioCropView viewHeight], kScreenWidth, [VEAudioCropView viewHeight]+Height_SafeAreaBottom);
        }];
    }else{
        [self.player stop];
        [UIView animateWithDuration:0.3 animations:^{
            self.shadowBtn.alpha = 0;
            self.shadowNavBtn.alpha = 0;
            self.audioCropView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEAudioCropView viewHeight]+Height_SafeAreaBottom);
        }completion:^(BOOL finished) {
            self.audioCropView.hidden = YES;
        }];
    }
}

@end
