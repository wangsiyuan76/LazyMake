
//
//  VEFindVideoPlayCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/20.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEFindVideoPlayCell.h"
#import "VEUserApi.h"
#import "VETemplateDetailController.h"
#import "VEHomeTemplateModel.h"
#import "SSZipArchive.h"
#import "VEAEVideoEditViewController.h"

@implementation VEFindVideoPlayCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.hud=[[VECreateHUD alloc] init];
        [self.contentView addSubview:self.mainImage];
        [self.contentView addSubview:self.shadowImage];
        [self.contentView addSubview:self.backBtn];
        [self.contentView addSubview:self.userIconBtn];
        [self.contentView addSubview:self.userNamaLab];
        [self.contentView addSubview:self.againBtn];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.shadowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(5+Height_StatusBar);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];

    @weakify(self);
    [self.userIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    
    [self.userNamaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.userIconBtn.mas_centerY);
        make.left.mas_equalTo(self.userIconBtn.mas_right).mas_offset(12);
    }];
    
    [self.againBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.userIconBtn.mas_centerY);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
}

- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [UIImageView new];
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
    }
    return _mainImage;
}

- (UIImageView *)shadowImage{
    if (!_shadowImage) {
        _shadowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_mengban_h"]];
    }
    return _shadowImage;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"vm_icon_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)againBtn{
    if (!_againBtn) {
        _againBtn = [UIButton new];
        [_againBtn setTitle:@"制作同款" forState:UIControlStateNormal];
        [_againBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _againBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _againBtn.layer.masksToBounds = YES;
        _againBtn.layer.cornerRadius = 15;
        UIImage *image = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(90, 30)];
        [_againBtn setBackgroundImage:image forState:UIControlStateNormal];

        [_againBtn addTarget:self action:@selector(clickAgainBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _againBtn;
}

- (UIImageView *)userIconBtn{
    if (!_userIconBtn) {
        _userIconBtn = [UIImageView new];
        _userIconBtn.layer.masksToBounds = YES;
        _userIconBtn.layer.cornerRadius  = 18.0f;
    }
    return _userIconBtn;
}

- (UILabel *)userNamaLab{
    if (!_userNamaLab) {
        _userNamaLab = [UILabel new];
        _userNamaLab.font = [UIFont systemFontOfSize:14];
        _userNamaLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _userNamaLab;
}

- (void)setModel:(VEFindHomeListModel *)model{
    _model = model;
    self.userNamaLab.text = model.nickname;
    [self.userIconBtn setImageWithURL:[NSURL URLWithString:model.avatar] options:YYWebImageOptionProgressiveBlur];
    [self.mainImage setImageWithURL:[NSURL URLWithString:model.thumb?:@""] options:YYWebImageOptionProgressiveBlur];
}


- (void)clickBackBtn{
    [currViewController().navigationController popViewControllerAnimated:YES];
}

- (void)clickAgainBtn{
    [self ve_loadVideoDataWithID:self.model.custom_id];
}

+ (CGFloat)cellHieght{
    return kScreenHeight;
}

- (void)ve_loadVideoDataWithID:(NSString *)mID{
    [MBProgressHUD showMessage:@"加载中..."];
    [VEUserApi searchAEDataWithID:mID Completion:^(VEHomeTemplateModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        if (result.state.intValue == 1) {
            self.showModel = result;
            [self downloadFile:result];
        }else{
            [MBProgressHUD showError:result.errorMsg];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
    }];
}

- (void)downloadFile:(VEHomeTemplateModel *)model{
    if (model.isFree.integerValue > 0) {//如果免费。则直接下载
        [ZFDownloadManager sharedDownloadManager].downloadDelegate = self;
        __block NSString *urlStr = model.customObj.zipfile;
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
                if ([info.url.absoluteString isEqualToString:model.customObj.zipfile]) {
                    [[ZFDownloadManager sharedDownloadManager] resumeRequest:info];
                    return;
                }
            }
        }
        
        //正常的下载逻辑
        [[ZFDownloadManager sharedDownloadManager] downFileUrl:urlStr filename:name fileimage:nil];
        [ZFDownloadManager sharedDownloadManager].maxCount = 1;
    }else{
        VETemplateDetailController *vc = [[VETemplateDetailController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [vc setAllParWithArr:@[model] selectIndex:0 page:1 hasMore:NO laodUrl:@"" otherDic:@{}];
        [currViewController().navigationController pushViewController:vc animated:YES];
    }
}

#pragma mrk - 下载
- (void)startDownload:(ZFHttpRequest *)request{
    NSLog(@"ZFDon开始下载");
//     ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    
}

- (void)updateCellProgress:(ZFHttpRequest *)request{
     ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    // 下载进度
    float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];
    if (progress > 0 && [fileInfo.fileURL isEqualToString:self.showModel.customObj.zipfile]) {
        [self.hud showProgress:[NSString stringWithFormat:@"下载中:%.0f％",100 * (progress)] par:progress];
    }
}

//下载哇擦
-(void)finishedDownload:(ZFHttpRequest *)request{
    [self.hud hide];
    [self downLoadSucceedWithPath:request.downloadDestinationPath];
}

- (void)downLoadSucceedWithPath:(NSString *)path{
    [VETool createAEDataFolderBlock:^(BOOL ifSucceed, NSString * _Nonnull fileUrl, NSError * _Nonnull error) {
        if (ifSucceed) {
            [self unzipWithPath:path unzipPath:fileUrl];
        }else{
            [MBProgressHUD showError:@"文件创建失败"];
        }
    }];
}

//解压
- (void)unzipWithPath:(NSString *)filePath unzipPath:(NSString *)unzipPath{
    __block NSString *urlStr = self.showModel.customObj.zipfile;
      NSString *name = [[urlStr componentsSeparatedByString:@"/"] lastObject];
      NSString *unName = [name stringByReplacingCharactersInRange:NSMakeRange(name.length-4, 4) withString:@""];
      NSString *unziptoFilePath = [NSString stringWithFormat:@"%@/%@",unzipPath,unName]; //解压到的地址路径
      self.showModel.zipPath = filePath;
      self.showModel.unZipPath = unziptoFilePath;
      
      [MBProgressHUD showMessage:@"解析中..."];
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [SSZipArchive unzipFileAtPath:filePath toDestination:unziptoFilePath progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
                 } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                     LMLog(@"----------完成,=========");
                     dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUD];
                            if (succeeded) {
                                [MBProgressHUD showSuccess:@"解析完成"];
                                VEAEVideoEditViewController *vc = [VEAEVideoEditViewController new];
                                vc.showModel = self.showModel;
                                [currViewController().navigationController pushViewController:vc animated:YES];
                            }else{
                                [MBProgressHUD showSuccess:@"解析失败"];
                            }
                     });
                 }];
      });
}

@end
