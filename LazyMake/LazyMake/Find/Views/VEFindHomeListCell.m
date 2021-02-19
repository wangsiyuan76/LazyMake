//
//  VEFindHomeListCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/19.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEFindHomeListCell.h"
#import "VEUserApi.h"
#import "VEHomeTemplateModel.h"
#import "ZFDownloadManager.h"
#import "SSZipArchive.h"
#import "VETemplateDetailController.h"
#import "VEFindPlayMainViewController.h"
#import "VEAEVideoEditViewController.h"

#define MAKE_BTN_SIZE CGSizeMake(90,30)

@implementation VEFindHomeListCellVideoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainImage];
        [self addSubview:self.mainBtn];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.mainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [UIImageView new];
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
        _mainImage.backgroundColor = [VETool backgroundRandomColor];
    }
    return _mainImage;
}

- (UIButton *)mainBtn{
    if (!_mainBtn) {
        _mainBtn = [UIButton new];
        [_mainBtn addTarget:self action:@selector(clickMainBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mainBtn;
}

- (void)clickMainBtn{
    if (self.clickMainBtnBlock) {
        self.clickMainBtnBlock();
    }
}

@end

@interface VEFindHomeListCell () <ZFDownloadDelegate>

@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UILabel *contentLab;
@property (strong, nonatomic) UIButton *makeBtn;
@property (strong, nonatomic) UILabel *numberLab;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) VEHomeTemplateModel *showModel;
@property (strong, nonatomic) UIImageView *shadowImage;
@property (nonatomic, strong) UIButton *userBtn;
@property (nonatomic, strong) VECreateHUD *hud;

@end

@implementation VEFindHomeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.hud=[[VECreateHUD alloc] init];
        self.contentView.backgroundColor = MAIN_BLACK_COLOR;
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.userBtn];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.mainVideoView];
        [self.contentView addSubview:self.mainPlayBtn];
        [self.contentView addSubview:self.makeBtn];
        [self.contentView addSubview:self.numberLab];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.shadowImage];
        [self.contentView addSubview:self.playStopBtn];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.iconImage.mas_centerY);
        make.left.mas_equalTo(self.iconImage.mas_right).mas_offset(16);
    }];
    
    [self.userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.iconImage.mas_left);
        make.top.mas_equalTo(self.iconImage.mas_top);
        make.bottom.mas_equalTo(self.iconImage.mas_bottom);
        make.right.mas_equalTo(self.titleLab.mas_right);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.iconImage.mas_centerY);
        make.right.mas_equalTo(-16);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.iconImage.mas_left);
        make.top.mas_equalTo(self.iconImage.mas_bottom).mas_offset(8);
        make.right.mas_equalTo(-15);
    }];
    
    [self.mainVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.iconImage.mas_left);
        make.top.mas_equalTo(self.contentLab.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(176, 290));
    }];
    
    [self.shadowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.iconImage.mas_left);
        make.top.mas_equalTo(self.contentLab.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(176, 290));
        
    }];
    
    [self.mainPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.iconImage.mas_left);
        make.top.mas_equalTo(self.contentLab.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(176, 290));
    }];
    
    
    [self.makeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.iconImage.mas_left);
        make.top.mas_equalTo(self.mainVideoView.mas_bottom).mas_offset(16);
        make.size.mas_equalTo(MAKE_BTN_SIZE);
    }];
    
    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.makeBtn.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.playStopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(self.mainVideoView.mas_right).mas_offset(-6);
        make.bottom.mas_equalTo(self.mainVideoView.mas_bottom).mas_offset(-6);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (UIButton *)mainPlayBtn{
    if (!_mainPlayBtn) {
        _mainPlayBtn = [UIButton new];
        [_mainPlayBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_mainPlayBtn setImage:[UIImage imageNamed:@"vm_icon_video"] forState:UIControlStateSelected];
        [_mainPlayBtn addTarget:self action:@selector(clickPlayMainBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mainPlayBtn;
}

- (UIButton *)userBtn{
    if (!_userBtn) {
        _userBtn = [UIButton new];
        [_userBtn addTarget:self action:@selector(clickUserBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userBtn;
}

- (UIImageView *)shadowImage{
    if (!_shadowImage) {
        _shadowImage = [UIImageView new];
        [_shadowImage setImage:[UIImage imageNamed:@"vm_home1_mask"]];
        _shadowImage.contentMode = UIViewContentModeScaleAspectFill;
        _shadowImage.clipsToBounds = YES;
        _shadowImage.layer.cornerRadius = 7.f;
    }
    return _shadowImage;
}

- (UIButton *)playStopBtn{
    if (!_playStopBtn) {
        _playStopBtn = [UIButton new];
        [_playStopBtn setImage:[UIImage imageNamed:@"vm_home1_play"] forState:UIControlStateNormal];
        [_playStopBtn setImage:[UIImage imageNamed:@"vm_home1_suspend"] forState:UIControlStateSelected];
        [_playStopBtn addTarget:self action:@selector(clickPlayBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playStopBtn;
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [UIImageView new];
        [_iconImage setImage:[UIImage imageNamed:@"vm_icon_default_avatar"]];
        _iconImage.contentMode = UIViewContentModeScaleAspectFill;
        _iconImage.layer.masksToBounds = YES;
        _iconImage.layer.cornerRadius = 18;
    }
    return _iconImage;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
    }
    return _titleLab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = MAIN_NAV_COLOR;
    }
    return _lineView;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.font = [UIFont systemFontOfSize:13];
        _timeLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
    }
    return _timeLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    }
    return _contentLab;
}

- (VEFindHomeListCellVideoView *)mainVideoView{
    if (!_mainVideoView) {
        _mainVideoView = [[VEFindHomeListCellVideoView alloc]initWithFrame:CGRectZero];
        _mainVideoView.backgroundColor = [UIColor redColor];
        _mainVideoView.layer.masksToBounds = YES;
        _mainVideoView.layer.cornerRadius = 7.f;
        
    }
    return _mainVideoView;
}

- (UIButton *)makeBtn{
    if (!_makeBtn) {
        _makeBtn = [UIButton new];
        [_makeBtn setTitle:@"制作同款" forState:UIControlStateNormal];
        [_makeBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _makeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_makeBtn addTarget:self action:@selector(clickMakeBtn) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:MAKE_BTN_SIZE];
        [_makeBtn setBackgroundImage:image forState:UIControlStateNormal];
        _makeBtn.layer.masksToBounds = YES;
        _makeBtn.layer.cornerRadius = MAKE_BTN_SIZE.height/2;
    }
    return _makeBtn;
}

- (UILabel *)numberLab{
    if (!_numberLab) {
        _numberLab = [UILabel new];
        _numberLab.textAlignment = NSTextAlignmentRight;
        _numberLab.font = [UIFont systemFontOfSize:13];
        _numberLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
    }
    return _numberLab;
}

- (void)setModel:(VEFindHomeListModel *)model{
    _model = model;
    self.playStopBtn.selected = NO;
    self.mainPlayBtn.selected = NO;
    for (UIView *subView in self.mainVideoView.subviews) {
        if (subView.tag == 10086) {
            [subView removeFromSuperview];
            break;
        }
    }
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"vm_icon_default_avatar"]];
    self.titleLab.text = model.nickname;
    self.timeLab.text = model.inputtime;
    self.contentLab.text = model.title;
    [self.mainVideoView.mainImage setImageWithURL:[NSURL URLWithString:model.thumb] options:YYWebImageOptionProgressiveBlur];
    
    if (model.click_num.integerValue > 10000) {
        CGFloat str = model.click_num.floatValue/10000;
        self.numberLab.text = [NSString stringWithFormat:@"%.1fw浏览量",str];
    }else{
        self.numberLab.text = [NSString stringWithFormat:@"%@浏览量",model.click_num];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)clickMakeBtn{
    [self ve_loadVideoDataWithID:self.model.custom_id];
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

- (void)clickPlayBtn{
    self.playStopBtn.selected = !self.playStopBtn.selected;
    if (self.clickPlayBtnBlock) {
        self.clickPlayBtnBlock(!self.playStopBtn.selected,NO,self.index);
    }
}

- (void)clickUserBtn{
//    VEHomeUserWorksController *vc = [VEHomeUserWorksController new];
//    VEHomeTemplateModel *model = [[VEHomeTemplateModel alloc]init];
//    model.userid = self.model.userid;
//    model.avatar = self.model.avatar;
//    model.nickname = self.model.nickname;
//    vc.model = model;
//    [currViewController().navigationController pushViewController:vc animated:YES];
}

- (void)clickPlayMainBtn{
    self.mainPlayBtn.selected = !self.mainPlayBtn.selected;
    self.playStopBtn.selected = !self.playStopBtn.selected;
    if (self.clickPlayBtnBlock) {
        BOOL ifPush = NO;
        if (self.mainPlayBtn.selected) {
            ifPush = YES;
            self.playStopBtn.hidden = YES;
        }else{
            self.playStopBtn.hidden = NO;
        }
        self.clickPlayBtnBlock(self.mainPlayBtn.selected,ifPush,self.index);
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
                                vc.hidesBottomBarWhenPushed = YES;
                                [currViewController().navigationController pushViewController:vc animated:YES];
                            }else{
                                [MBProgressHUD showSuccess:@"解析失败"];
                            }
                     });
                 }];
      });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
