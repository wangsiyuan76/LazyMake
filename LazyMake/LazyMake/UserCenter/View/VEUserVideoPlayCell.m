//
//  VEUserVideoPlayCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/27.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserVideoPlayCell.h"
#import "VEUserApi.h"
#import "VEHomeTemplateModel.h"
#import "ZFDownloadManager.h"
#import "SSZipArchive.h"
#import "VEAEVideoEditViewController.h"
#import "VETemplateDetailController.h"
#import "VECreateHUD.h"

@interface VEUserVideoPlayCell () <ZFDownloadDelegate>

@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *deleBtn;
@property (strong, nonatomic) UIButton *againBtn;
@property (strong, nonatomic) UILabel *againLab;
@property (strong, nonatomic) VEHomeTemplateModel *showModel;
@property (nonatomic, strong) VECreateHUD *hud;
@property (strong, nonatomic) UIImageView *shadowImage;
@end

@implementation VEUserVideoPlayCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.hud=[[VECreateHUD alloc] init];
        [self.contentView addSubview:self.mainImage];
        [self.contentView addSubview:self.shadowImage];
        [self.contentView addSubview:self.backBtn];
        [self.contentView addSubview:self.deleBtn];
        [self.contentView addSubview:self.againBtn];
        [self.contentView addSubview:self.againLab];
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
    
    [self.deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(5+Height_StatusBar);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    @weakify(self);
    [self.againBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-90);
        make.size.mas_equalTo(CGSizeMake(40, 50));
    }];

    [self.againLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.againBtn.mas_centerX);
        make.top.mas_equalTo(self.againBtn.mas_bottom).mas_offset(-8);
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

- (UIButton *)deleBtn{
    if (!_deleBtn) {
        _deleBtn = [UIButton new];
        [_deleBtn setImage:[UIImage imageNamed:@"vm_icon_delete_white"] forState:UIControlStateNormal];
        [_deleBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
        _deleBtn.hidden = YES;
    }
    return _deleBtn;
}

- (UIButton *)againBtn{
    if (!_againBtn) {
        _againBtn = [UIButton new];
        [_againBtn setImage:[UIImage imageNamed:@"vm_icon_make_again"] forState:UIControlStateNormal];
        [_againBtn addTarget:self action:@selector(clickAgainBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _againBtn;
}

- (UILabel *)againLab{
    if (!_againLab) {
        _againLab = [UILabel new];
        _againLab.font = [UIFont systemFontOfSize:11];
        _againLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _againLab.text = @"再次制作";
    }
    return _againLab;
}

- (void)setModel:(VEUserWorksListModel *)model{
    _model = model;
    [self.mainImage setImageWithURL:[NSURL URLWithString:model.thumb?:@""] options:YYWebImageOptionProgressiveBlur];
}

+ (CGFloat)cellHieght{
    return kScreenHeight;
}

- (void)clickDeleteBtn{
    UIAlertController *ale = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除后视频将无法恢复，确定删除？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cacleA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *sureA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [MBProgressHUD showMessage:@"删除中..."];
//        [VEUserApi deleteUserWorksID:self.model.wID Completion:^(id  _Nonnull result) {
//            [MBProgressHUD hideHUD];
//            [self deleteSucceed];
//        } failure:^(NSError * _Nonnull error) {
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showError:VENETERROR];
//        }];
    }];
    [ale addAction:cacleA];
    [ale addAction:sureA];
    [currViewController() presentViewController:ale animated:YES completion:nil];
}

- (void)deleteSucceed{
    if (self.deleteModelBlock) {
        self.deleteModelBlock(self.model, self.index);
    }
}

- (void)clickBackBtn{
    [currViewController().navigationController popViewControllerAnimated:YES];
}

#pragma mark - 下载相关
- (void)clickAgainBtn{
    [MBProgressHUD showMessage:@"加载中..."];
    [VEUserApi searchAEDataWithID:self.model.custom_id Completion:^(VEHomeTemplateModel *  _Nonnull result) {
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

- (void)startDownload:(ZFHttpRequest *)request{
    NSLog(@"ZFDon开始下载");
//     ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    
}

- (void)updateCellProgress:(ZFHttpRequest *)request{
     ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    // 下载进度
    float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];
    if (progress > 0 && [fileInfo.fileURL isEqualToString:self.showModel.customObj.zipfile]) {
        [self.hud showProgress:[NSString stringWithFormat:@"已下载:%.0f％",100 * (progress)] par:progress];
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
