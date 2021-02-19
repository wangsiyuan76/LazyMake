//
//  VETemplateBottomView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VETemplateBottomView.h"
#import "JYLabelsSelect.h"
#import "SSZipArchive.h"
#import "ZFDownloadManager.h"
#import "VEVipMainViewController.h"
#import "VEHomeApi.h"
#import "VEAlertView.h"

@interface VETemplateBottomView () <NSURLSessionDelegate,ZFDownloadDelegate>

@property (strong, nonatomic) JYLabelsSelect * labelSelect;
@property (strong, nonatomic) UIImageView *userIconImage;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UIButton *userBtn;
@property (strong, nonatomic) UIButton *makeBtn;
@property (strong, nonatomic) NSMutableArray *hicArr;

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSString *emoticonPackagePath;
@property (assign, nonatomic) BOOL ifLoading;           //是否正在下载中

@end

@implementation VETemplateBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.labelSelect];
        [self addSubview:self.userIconImage];
        [self addSubview:self.userName];
        [self addSubview:self.userBtn];
        [self addSubview:self.makeBtn];
        [self setAllViewLayout];
    }return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.userIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-(28 + Height_SafeAreaBottom));
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.userIconImage.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.userIconImage.mas_centerY);
    }];
    
    [self.userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.userIconImage.mas_left);
        make.top.mas_equalTo(self.userIconImage.mas_top);
        make.bottom.mas_equalTo(self.userIconImage.mas_bottom);
        make.right.mas_equalTo(self.userName.mas_right);
    }];

    [self.makeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.userIconImage.mas_centerY);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(145, 38    ));
    }];
}

- (JYLabelsSelect *)labelSelect{
    if (!_labelSelect) {
        _labelSelect = [[JYLabelsSelect alloc] initWith:CGPointMake(14, 10) width:SCREEN_WIDTH - 30];
        _labelSelect.dataSource = @[];
        _labelSelect.minRowSpace = 8;
        _labelSelect.backgroundColor = [UIColor yellowColor];
        _labelSelect.minMarginSpace = UIEdgeInsetsMake(5, 5, 0, 5);
        @weakify(self);
        _labelSelect.selected = ^(id selectedObject, NSInteger index) {
            @strongify(self);
            if (self.clickTagBlock) {
                UILabel *lab = selectedObject;
                self.clickTagBlock(lab.text, index);
            }
            NSLog(@"_______%@",selectedObject);
        };
        _labelSelect.backgroundColor = [UIColor clearColor];
    }
    return _labelSelect;
}

- (UIImageView *)userIconImage{
    if (!_userIconImage) {
        _userIconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_icon_default_avatar"]];
        _userIconImage.contentMode = UIViewContentModeScaleAspectFill;
        _userIconImage.clipsToBounds = YES;
        _userIconImage.layer.masksToBounds = YES;
        _userIconImage.layer.cornerRadius = 19;
    }
    return _userIconImage;
}

- (UILabel *)userName{
    if (!_userName) {
        _userName = [UILabel new];
        _userName.font = [UIFont systemFontOfSize:15];
        _userName.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _userName;
}

- (UIButton *)userBtn{
    if (!_userBtn) {
        _userBtn = [UIButton new];
        _userBtn.backgroundColor = [UIColor clearColor];
        [_userBtn addTarget:self action:@selector(clickUserBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userBtn;
}

- (UIButton *)makeBtn{
    if (!_makeBtn) {
        _makeBtn = [UIButton new];
        [_makeBtn setTitle:@"开始制作" forState:UIControlStateNormal];
        [_makeBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _makeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_makeBtn addTarget:self action:@selector(clickMakeBtn) forControlEvents:UIControlEventTouchUpInside];
        _makeBtn.layer.masksToBounds = YES;
        _makeBtn.layer.cornerRadius = 19;
        [_makeBtn setImage:[UIImage imageNamed:@"vm_icon_lock"] forState:UIControlStateNormal];
        [_makeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
         
        UIImage *bgImage = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(145, 38)];
        [_makeBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    }
    return _makeBtn;
}

- (void)clickUserBtn{
    if (self.clickUserBlock) {
        self.clickUserBlock();
    }
}

- (void)clickMakeBtn{
    if (self.showModel.isFree.intValue == 0) {
        if ([LMUserManager sharedManger].userInfo.vipState.intValue != 1) {
            [self showVipAlert];
            return;
        }
    }
    self.makeBtn.userInteractionEnabled = NO;
    [self downloadFile];
    if (self.clickMakeBlock) {
        self.clickMakeBlock();
    }
}

- (void)showVipAlert{
    VEAlertView *ale = [[VEAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [ale setContentStr: @"开通会员，可免费制作所有VIP模板哦！"];
    [ale.sureBtn setTitle:@"去开通" forState:UIControlStateNormal];
    [win addSubview:ale];
    @weakify(self);
    ale.clickSubBtnBlock = ^(NSInteger btnTag) {
        @strongify(self);
        if (btnTag == 1) {
            VEVipMainViewController *vc = [VEVipMainViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.comeType = VipMouthType_AEVideo;
            [currViewController().navigationController pushViewController:vc animated:YES];
        }
    };
}

- (void)createTagArr:(NSArray *)tagArr{
    NSMutableArray *hicArr = [NSMutableArray new];
    for (NSString *tagStr in tagArr) {
        UILabel *menuLabel = [UILabel new];
        menuLabel.textAlignment = NSTextAlignmentCenter;
        menuLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        menuLabel.text = tagStr;
        menuLabel.font = [UIFont systemFontOfSize:13];
        CGFloat width = [menuLabel widthOfSizeToFit];
        menuLabel.frame = CGRectMake(0, 0, width + 20, 26);
        menuLabel.layer.cornerRadius = 13.0;
        menuLabel.clipsToBounds = YES;
        menuLabel.backgroundColor = [UIColor clearColor];
        
        menuLabel.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
        menuLabel.layer.borderWidth = 1.0f;
        [hicArr addObject:menuLabel];
    }
    [self.labelSelect addLabels:hicArr];
}

- (void)setShowModel:(VEHomeTemplateModel *)showModel{
    _showModel = showModel;
    if (showModel) {
        [self.labelSelect removeAllLabs];
        [self createTagArr:showModel.tags];
        [self.userIconImage setImageWithURL:[NSURL URLWithString:showModel.avatar] placeholder:[UIImage imageNamed:@"vm_icon_default_avatar"]];
        self.userName.text = showModel.nickname;
        //判断是否收费
        [self updateBtnType];
    }
}

- (void)updateBtnType{
    if (self.showModel.isFree.intValue > 0) {
        [_makeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_makeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    }else{
        if ([LMUserManager sharedManger].userInfo.vipState.intValue == 1) {
            [_makeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [_makeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        }else{
            [_makeBtn setImage:[UIImage imageNamed:@"vm_icon_lock"] forState:UIControlStateNormal];
            [_makeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
        }
    }
}

- (void)downloadFile{
    self.ifLoading = YES;
    [ZFDownloadManager sharedDownloadManager].downloadDelegate = self;
    __block NSString *urlStr = self.showModel.customObj.zipfile;
    NSString *name = [[urlStr componentsSeparatedByString:@"/"] lastObject];
    // 已经下载过一次,直接跳转
     if ([ZFCommonHelper isExistFile:FILE_PATH(name)]) {
         for (ZFFileModel *info in [[ZFDownloadManager sharedDownloadManager].finishedlist mutableCopy]) {
            if ([info.fileName isEqualToString:name]) {
                NSString *fileUrl = FILE_PATH(info.fileName);
                NSData *data = [NSData dataWithContentsOfFile:fileUrl];
                if (data) {
                    [self downLoadSucceedWithPath:fileUrl];
                    return;
                }
            }
         }
    }
    //如果已经下载了一半，则继续下载
    NSString *tempfilePath = [TEMP_PATH(name) stringByAppendingString:@".plist"];
    if ([ZFCommonHelper isExistFile:tempfilePath]) {
        for (ZFHttpRequest *info in [[ZFDownloadManager sharedDownloadManager].downinglist mutableCopy]) {
            if ([info.url.absoluteString isEqualToString:self.showModel.customObj.zipfile]) {
                [[ZFDownloadManager sharedDownloadManager] resumeRequest:info];
                return;
           }
        }
      }
    
    //正常的下载逻辑
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:urlStr filename:name fileimage:nil];
    [ZFDownloadManager sharedDownloadManager].maxCount = 1;
}

- (void)startDownload:(ZFHttpRequest *)request{
    NSLog(@"ZFDon开始下载");
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    LMLog(@"===ZFFileModel==开始===%@",fileInfo.fileName);
}
- (void)updateCellProgress:(ZFHttpRequest *)request{
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    // 下载进度
    float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];
    if (progress > 0 && [fileInfo.fileURL isEqualToString:self.showModel.customObj.zipfile]) {
        [self.makeBtn setTitle:[NSString stringWithFormat:@"已下载%.0f％",100 * (progress)] forState:UIControlStateNormal];
        [self.makeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.makeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    }
}

//下载完成
-(void)finishedDownload:(ZFHttpRequest *)request{
    [self downLoadSucceedWithPath:request.downloadDestinationPath];
    //添加下载统计
    [self addDownLoadHits];
}

//添加下载统计
- (void)addDownLoadHits{
    [[VEHomeApi sharedApi]ve_addDownLoadTongji:self.showModel.tID Completion:^(id  _Nonnull result) {
    } failure:^(NSError * _Nonnull error) {
    }];
}

//下载完成后调用的方法
- (void)downLoadSucceedWithPath:(NSString *)path{
    self.makeBtn.userInteractionEnabled = YES;
    self.ifLoading = NO;
    [self createEmoticonFolder];
    __block NSString *urlStr = self.showModel.customObj.zipfile;
    NSString *name = [[urlStr componentsSeparatedByString:@"/"] lastObject];
    NSString *unName = [name stringByReplacingCharactersInRange:NSMakeRange(name.length-4, 4) withString:@""];
    NSString *unziptoFilePath = [NSString stringWithFormat:@"%@/%@",self.emoticonPackagePath,unName]; //解压到的地址路径
    self.showModel.zipPath = path;
    self.showModel.unZipPath = unziptoFilePath;
    
    [MBProgressHUD showMessage:@"解析中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SSZipArchive unzipFileAtPath:path toDestination:unziptoFilePath progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
               } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self setDoneBtnType];
                       [MBProgressHUD hideHUD];
                        if (succeeded) {
                            [MBProgressHUD showSuccess:@"解析完成"];
                            if (self.doneLoadSucceedBlock) {
                                self.doneLoadSucceedBlock(self.showModel);
                            }
                        }else{
                            [MBProgressHUD showSuccess:@"解析失败"];
                        }
                   });
               }];
    });
}

/**
 *   创建文件夹
 */
- (void)createEmoticonFolder{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //获取沙盒文件路径
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentPaths objectAtIndex:0];
    
    //获取文件夹路径
    NSString *userId = @"LazyMake";
    NSString *emoticonPath = [NSString stringWithFormat:@"%@/AE/%@",documentPath,userId];
    self.emoticonPackagePath = emoticonPath;
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager]fileExistsAtPath:emoticonPath]){
        NSError *error;
        [fileManager createDirectoryAtPath:emoticonPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error){
            LMLog(@"插入失败");
        }
    }else{
        LMLog(@"该文件夹已存在");
    }
}

/// 暂停下载
- (void)stopDonloading{
    [[ZFDownloadManager sharedDownloadManager] pauseAllDownloads];
    self.makeBtn.userInteractionEnabled = YES;
    self.ifLoading = NO;
    [self setDoneBtnType];

}

//删除，撤销当前下载的内容
- (void)deleteDonlondingData{
    if (self.ifLoading) {
        [MBProgressHUD showSuccess:@"下载中，无法重置"];
        return;
    }
    [self setDoneBtnType];
    __block NSString *urlStr = self.showModel.customObj.zipfile;
    NSString *name = [[urlStr componentsSeparatedByString:@"/"] lastObject];
    // 已经下载过一次,删除文件
     if ([ZFCommonHelper isExistFile:FILE_PATH(name)]) {
         for (ZFFileModel *info in [[ZFDownloadManager sharedDownloadManager].finishedlist mutableCopy]) {
            if ([info.fileName isEqualToString:name]) {
                NSString *fileUrl = FILE_PATH(info.fileName);
                NSData *data = [NSData dataWithContentsOfFile:fileUrl];
                if (data) {
                    [[ZFDownloadManager sharedDownloadManager]deleteFinishFile:info];
                    [MBProgressHUD showSuccess:@"重置成功"];
                    return;
                }
            }
         }
    }
    //如果已经下载了一半，则删除下载请求
    NSString *tempfilePath = [TEMP_PATH(name) stringByAppendingString:@".plist"];
    if ([ZFCommonHelper isExistFile:tempfilePath]) {
        for (ZFHttpRequest *info in [[ZFDownloadManager sharedDownloadManager].downinglist mutableCopy]) {
            if ([info.url.absoluteString isEqualToString:self.showModel.customObj.zipfile]) {
                [[ZFDownloadManager sharedDownloadManager]stopRequest:info];
                [[ZFDownloadManager sharedDownloadManager]deleteRequest:info];
                ZFFileModel *fileInfo = [info.userInfo objectForKey:@"File"];
                [[ZFDownloadManager sharedDownloadManager]deleteFinishFile:fileInfo];

                [MBProgressHUD showSuccess:@"重置成功"];
                return;
           }
        }
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"您还未下载该模板，无法重置"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * action) {
                                                             }];
    [alert addAction:cancelAction];
    [currViewController() presentViewController:alert animated:YES completion:nil];
}

-(void)setDoneBtnType{
    [_makeBtn setTitle:@"开始制作" forState:UIControlStateNormal];
    [self updateBtnType];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
