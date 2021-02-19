//
//  VECreateSucceedBottomView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/17.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VECreateSucceedBottomView.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+ScallGif.h"

//#import <UMShare/UMShare.h>
//#import <DouyinOpenSDK/DouyinOpenSDKShare.h>
//#import <TencentOpenAPI/TencentOAuth.h>

static NSString *LMCreateSucceedBottomEnumCellStr = @"LMCreateSucceedBottomEnumCell";

@interface LMCreateSucceedBottomEnumCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *textLab;

@end

@implementation LMCreateSucceedBottomEnumCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.textLab];
        
        @weakify(self);
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        
        [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.iconImage.mas_bottom).mas_offset(8);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }
    return self;
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [UIImageView new];
    }
    return _iconImage;
}

- (UILabel *)textLab{
    if (!_textLab) {
        _textLab = [UILabel new];
        _textLab.font = [UIFont systemFontOfSize:14];
        _textLab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _textLab.textAlignment = NSTextAlignmentCenter;
    }
    return _textLab;
}

@end
 
@implementation VECreateSucceedBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.doneBtn];
        [self addSubview:self.pushBtn];
        [self addSubview:self.vipBtn];
        [self addSubview:self.titleLab];
        [self addSubview:self.collectionView];
        [self setAllViewLayout];
        [self loadData];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addSaveVideoNot:) name:SavePhotoVideoSucceedKey object:nil];
    }
    return self;
}

- (void)addSaveVideoNot:(NSNotification*) notification{
    NSString *idStr = notification.object;
    self.photoId = idStr;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(8);
        make.centerX.mas_equalTo(self.mas_centerX).mas_offset(-60);
        make.size.mas_equalTo(CGSizeMake(105, 30));
    }];
    
    [self.pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(8);
        make.centerX.mas_equalTo(self.mas_centerX).mas_offset(60);
        make.size.mas_equalTo(CGSizeMake(105, 30));
    }];
    
    [self.vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(30);
        make.height.mas_equalTo(16);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.vipBtn.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(16);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(70);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(14);
    }];
}

- (UIButton *)doneBtn{
    if (!_doneBtn) {
        _doneBtn = [UIButton new];
        [_doneBtn setTitle:@"会员去水印" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _doneBtn.layer.masksToBounds = YES;
        _doneBtn.layer.cornerRadius = 15.0f;
        [_doneBtn setBackgroundImage:[VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(105, 30)] forState:UIControlStateNormal];
        _doneBtn.tag = 0;
        [_doneBtn addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}

- (UIButton *)pushBtn{
    if (!_pushBtn) {
        _pushBtn = [UIButton new];
        [_pushBtn setTitle:@"我要上传" forState:UIControlStateNormal];
        [_pushBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _pushBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _pushBtn.layer.masksToBounds = YES;
        _pushBtn.layer.cornerRadius = 15.0f;
        _pushBtn.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
        _pushBtn.layer.borderWidth = 1.0f;
        _pushBtn.tag = 1;
        _pushBtn.backgroundColor = [UIColor clearColor];
        [_pushBtn addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushBtn;
}

- (UIButton *)vipBtn{
    if (!_vipBtn) {
        _vipBtn = [UIButton new];
        [_vipBtn setTitle:@"去除水印？点击开通会员" forState:UIControlStateNormal];
        [_vipBtn setTitleColor:[UIColor colorWithHexString:@"#1DABFD"] forState:UIControlStateNormal];
        _vipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _vipBtn.tag = 2;
        [_vipBtn addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];
        _vipBtn.hidden = YES;
    }
    return _vipBtn;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"视频已保存到相册";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _titleLab.font = [UIFont systemFontOfSize:15];
        
//        _titleLab.hidden = YES;
    }
    return _titleLab;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewLeftAlignedLayout *fl = [[UICollectionViewLeftAlignedLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.minimumLineSpacing = 0;
        fl.minimumInteritemSpacing = 0;
//        fl.itemSize = CGSizeMake((kScreenWidth - 60)/3, 70);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[LMCreateSucceedBottomEnumCell class] forCellWithReuseIdentifier:LMCreateSucceedBottomEnumCellStr];
        
        _collectionView.hidden = YES;

    }
    return _collectionView;
}

- (void)loadData{
    self.shareTitleArr = @[@"抖音",@"QQ",@"微信"];
    self.shareImageArr = @[@"vm_icon_share_douyin",@"vm_icon_share_qq",@"vm_icon_share_wechat"];
    [self.collectionView reloadData];
}

- (void)setIfImage:(BOOL)ifImage{
    _ifImage = ifImage;
    if (ifImage) {
        self.shareTitleArr = @[@"QQ",@"微信"];
        self.shareImageArr = @[@"vm_icon_share_qq",@"vm_icon_share_wechat"];
    }
    [self.collectionView reloadData];
}

- (void)setIfHiddenWearerBtn:(BOOL)ifHiddenWearerBtn{
    _ifHiddenWearerBtn = ifHiddenWearerBtn;
    if (ifHiddenWearerBtn) {
        self.doneBtn.hidden = YES;
        
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shareTitleArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth - 60)/self.shareTitleArr.count, 70);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LMCreateSucceedBottomEnumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LMCreateSucceedBottomEnumCellStr forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    if (self.shareImageArr.count > indexPath.row) {
        cell.iconImage.image = [UIImage imageNamed:self.shareImageArr[indexPath.row]];
        cell.textLab.text = self.shareTitleArr[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
#warning 这里
//    if (indexPath.row == 0) {
//        if (self.ifImage) {
//            [self shareGifImageWithUrl:[NSURL URLWithString:self.videoPath] type:UMSocialPlatformType_QQ];
//        }else{
//            [self sharedDouyin];
//        }
//    }else if (indexPath.row == 1){
//        if (self.ifImage) {
//            [self shareGifImageWithUrl:[NSURL URLWithString:self.videoPath] type:UMSocialPlatformType_WechatSession];
//        }else{
//            [self shareUMDataType:UMSocialPlatformType_QQ index:indexPath.row];
//        }
//    }else if (indexPath.row == 2){
//        [self shareUMDataType:UMSocialPlatformType_WechatSession index:indexPath.row];
//    }
}

- (void)setIfAe:(BOOL)ifAe{
    _ifAe = ifAe;
    if (!ifAe) {
        self.pushBtn.hidden = YES;
        self.doneBtn.hidden = YES;
        @weakify(self);
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.vipBtn.mas_bottom).mas_offset(-10);
        }];
        
        //判断是否有会员去水印
//        if ([LMUserManager sharedManger].userInfo.vipState.intValue == 1) {
//            self.doneBtn.hidden = YES;
//        }else{
//            self.doneBtn.hidden = NO;
//            [self.doneBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.centerX.mas_equalTo(self.mas_centerX);
//            }];
//        }

    }else{
        self.pushBtn.hidden = NO;
        //判断是否有会员去水印
        self.doneBtn.hidden = YES;
        @weakify(self);
        [self.pushBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
             make.centerX.mas_equalTo(self.mas_centerX);
        }];
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.vipBtn.mas_bottom).mas_offset(8);
        }];
//        if ([LMUserManager sharedManger].userInfo.vipState.intValue == 1) {
//            self.doneBtn.hidden = YES;
//            [self.pushBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//                 make.centerX.mas_equalTo(self.mas_centerX);
//            }];
//        }else{
//            self.doneBtn.hidden = NO;
//            [self.doneBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.centerX.mas_equalTo(self.mas_centerX).mas_offset(-60);
//            }];
//        }
    }
}

#warning 这里
//- (void)shareUMDataType:(UMSocialPlatformType)shareType index:(NSInteger)index{
//    //压缩视频
//     [MBProgressHUD showMessage:@"启动中"];
//    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",self.videoPath]] options:nil];
//    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
//    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
//            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
//            //输出URL
//            exportSession.outputURL = [NSURL fileURLWithPath:[VETool creatSandBoxFilePathIfNoExist]];
//            //优化网络
//            exportSession.shouldOptimizeForNetworkUse = true;
//            //转换后的格式
//            exportSession.outputFileType = AVFileTypeMPEG4;
//            //异步导出
//            [exportSession exportAsynchronouslyWithCompletionHandler:^{
//                // 如果导出的状态为完成
//                if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [MBProgressHUD hideHUD];
//                        if (index == 0) {
//                            [self sharedDouyin];
//                        }else{
//                            [self shareDataWithUrl:exportSession.outputURL type:shareType];
//                        }
//                    });
//                 }else{
//                     [MBProgressHUD hideHUD];
//                     [MBProgressHUD showError:@"视频压缩失败"];
//                }
//                NSLog(@"%@",exportSession.error);
//            }];
//    }else{
//        [MBProgressHUD hideHUD];
//    }
//}

- (void)clickSubBtn:(UIButton *)btn{
    if (self.clickSubBtnBlock) {
        self.clickSubBtnBlock(btn.tag);
    }
}

#warning 这里
//- (void)shareDataWithUrl:(NSURL *)fileUrl type:(UMSocialPlatformType)shareType{
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    if (shareType == UMSocialPlatformType_WechatSession) {
//        UMShareFileObject *shareObject = [[UMShareFileObject alloc]init];
//        shareObject.fileExtension = @".mp4";
//        shareObject.fileData = [NSData dataWithContentsOfURL:fileUrl];
//        messageObject.shareObject = shareObject;
//    }else if (shareType == UMSocialPlatformType_QQ){
//        UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:@"懒人制作" descr:@"" thumImage:[UIImage imageNamed:@"vm_icon_music_empty"]];
//        shareObject.videoUrl = fileUrl.absoluteString;
//        shareObject.videoStreamUrl = fileUrl.absoluteString;
//        messageObject.shareObject = shareObject;
//
////        NSString *previewPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"video.jpg"];
////        NSData* previewData = [NSData dataWithContentsOfFile:previewPath];
////        NSString *utf8String = @"http://www.163.com";
////        QQApiVideoObject *videoObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:utf8String ? : @""]
////        title:@"QQ互联测试"
////        description:@"QQ互联测试分享"
////        previewImageData:previewData];
////        [videoObj setFlashURL:[NSURL URLWithString:@"http://v.qq.com/cover/5/53x6bbyb07ebl3s/n0013r8esy6.html"]];
////        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:videoObj];
////        //将内容分享到qq
////        //QQApiSendResultCode sent = [QQApiInterface sendReq:req];
////        //将被容分享到qzone
////        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
//    }
//    [MBProgressHUD hideHUD];
//    [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:currViewController() completion:^(id data, NSError *error) {
//        if (error) {
//            NSDictionary *dic = error.userInfo;
//            NSString *errMsg = @"分享失败";
//            if ([dic.allKeys containsObject:@"message"]) {
//                errMsg = [dic objectForKey:@"message"];
//            }
//            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",errMsg]];
//        }
//    }];
//}

#warning 这里
////分享gif图片
//- (void)shareGifImageWithUrl:(NSURL *)fileUrl type:(UMSocialPlatformType)shareType{
//    if (self.showImage) {
//        [self shareImageWithType:shareType];
//        return;
//    }
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    if (shareType == UMSocialPlatformType_WechatSession) {
//        [MBProgressHUD showMessage:@"启动中"];
//        UMShareEmotionObject *shareD= [ UMShareEmotionObject shareObjectWithTitle:@"懒人制作" descr:@"" thumImage:[UIImage imageNamed:@"vm_icon_music_empty"]];
//        dispatch_queue_t queue2 = dispatch_queue_create("CONCURRENT", DISPATCH_QUEUE_CONCURRENT);
//        dispatch_async(queue2, ^{
//          [UIImage scallGIFWithData:[NSData dataWithContentsOfFile:fileUrl.absoluteString] scallSize:CGSizeMake(self.imageSize.width * 0.4, self.imageSize.height * 0.4) succeedBlock:^(NSData *resultData) {
//               dispatch_async(dispatch_get_main_queue(), ^{
//                   shareD.emotionData = resultData;
//                   messageObject.shareObject = shareD;
//                   [MBProgressHUD hideHUD];
//                   [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:currViewController() completion:^(id data, NSError *error) {
//                       if (error) {
//                           NSDictionary *dic = error.userInfo;
//                           NSString *errMsg = @"分享失败";
//                           if ([dic.allKeys containsObject:@"message"]) {
//                               errMsg = [dic objectForKey:@"message"];
//                           }
//                           [MBProgressHUD showError:[NSString stringWithFormat:@"%@",errMsg]];
//                       }
//                   }];
//               });
//           }];
//        });
//    }else{
//        [MBProgressHUD showMessage:@"启动中"];
//        dispatch_queue_t queue2 = dispatch_queue_create("CONCURRENT", DISPATCH_QUEUE_CONCURRENT);
//        dispatch_async(queue2, ^{
//          [UIImage scallGIFWithData:[NSData dataWithContentsOfFile:fileUrl.absoluteString] scallSize:CGSizeMake(self.imageSize.width * 0.4, self.imageSize.height * 0.4) succeedBlock:^(NSData *resultData) {
//              dispatch_async(dispatch_get_main_queue(), ^{
//                  [MBProgressHUD hideHUD];
//                  UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"懒人制作" descr:@"" thumImage:[UIImage imageNamed:@"vm_icon_music_empty"]];
//                  shareObject.shareImage = resultData;
//                  messageObject.shareObject = shareObject;
//                  [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:currViewController() completion:^(id data, NSError *error) {
//                      if (error) {
//                          NSDictionary *dic = error.userInfo;
//                          NSString *errMsg = @"分享失败";
//                          if ([dic.allKeys containsObject:@"message"]) {
//                              errMsg = [dic objectForKey:@"message"];
//                          }
//                          [MBProgressHUD showError:[NSString stringWithFormat:@"%@",errMsg]];
//                      }
//                  }];
//              });
//          }];
//        });
//    }
//}
////分享普通人物抠图图片
//- (void)shareImageWithType:(UMSocialPlatformType)shareType{
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    UMShareImageObject *imageShare = [UMShareImageObject shareObjectWithTitle:@"懒人制作" descr:@"" thumImage:[UIImage imageNamed:@"vm_icon_music_empty"]];
//    imageShare.shareImage = self.showImage;
//    messageObject.shareObject = imageShare;
//    [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:currViewController() completion:^(id data, NSError *error) {
//        if (error) {
//            NSDictionary *dic = error.userInfo;
//            NSString *errMsg = @"分享失败";
//            if ([dic.allKeys containsObject:@"message"]) {
//                errMsg = [dic objectForKey:@"message"];
//            }
//            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",errMsg]];
//        }
//    }];
//}
//
//-(void)sharedDouyin{
//    if (self.photoId.length < 1) {
//        [MBProgressHUD showError:@"视频保存相册失败，无法分享抖音"];
//        return;
//    }
//    
//    NSURL *url = [NSURL URLWithString:@"douyinopensdk://"];
//    NSURL *url2 = [NSURL URLWithString:@"douyinsharesdk://"];
//    if (![[UIApplication sharedApplication]canOpenURL:url] && ![[UIApplication sharedApplication]canOpenURL:url2]) {
//        [MBProgressHUD showError:@"未安装抖音APP"];
//        return;
//    }
//        
//    DouyinOpenSDKShareRequest *req = [[DouyinOpenSDKShareRequest alloc] init];
//    req.mediaType = BDOpenPlatformShareMediaTypeVideo;
//    if (self.ifImage) {
//        req.mediaType = BDOpenPlatformShareMediaTypeImage;
//    }
//    req.state = @"f45a90ffafe28d291f259d3dac1ab510";
//    req.localIdentifiers = @[self.photoId];
//    
////    NSMutableDictionary *m_dic = @{}.mutableCopy;
////      m_dic[@"identifier"] = self.microAppId?:@"";
////      m_dic[@"title"] = self.microAppTitle?:@"";
////      m_dic[@"desc"] = self.microAppDesc?:@"";
////      m_dic[@"startPageURL"] = self.microAppUrl?:@"";
////      // 小程序，在分享的视频右下角显示抖音小程序入口, 非必须属性
////      req.extraInfo = @{@"mpInfo" : m_dic.copy};
//    
//    [req sendShareRequestWithCompleteBlock:^(BDOpenPlatformShareResponse * _Nonnull respond) {
//        if (respond.errCode == BDOpenPlatformSuccess) {
//            //  Share Succeed
//        } else if (respond.errCode == BDOpenPlatformErrorCodeCommon) {
//            [MBProgressHUD showError:@"网络问题"];
//        }else if (respond.errCode == BDOpenPlatformErrorCodeUserCanceled) {
//            [MBProgressHUD showError:@"用户已取消"];
//        }else if (respond.errCode == BDOpenPlatformErrorCodeSendFailed) {
//            [MBProgressHUD showError:@"发送失败"];
//        }else if (respond.errCode == BDOpenPlatformErrorCodeAuthDenied) {
//            [MBProgressHUD showError:@"没有权限"];
//        }else if (respond.errCode == BDOpenPlatformErrorCodeUnsupported) {
//            [MBProgressHUD showError:@"不支持分享抖音"];
//        }
//    }];
//}

- (CGFloat)fileSize:(NSURL *)path
{
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
