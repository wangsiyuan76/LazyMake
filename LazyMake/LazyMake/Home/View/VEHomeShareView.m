//
//  VEHomeShareView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/9.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeShareView.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "VEHoneShareSubCell.h"
//#import <UMShare/UMShare.h>
#import "SDWebImageDownloader.h"

#define CONTENT_HEIGHT 170

@interface VEHomeShareView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *footBtn;
@property (strong, nonatomic) UIButton *shadowBtn;
@property (strong, nonatomic) NSArray *shareTitleArr;
@property (strong, nonatomic) NSArray *shareImageArr;

@end

@implementation VEHomeShareView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shadowBtn];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.footBtn];
        [self.contentView addSubview:self.collectionView];
        [self setAllViewLayout];
        [self createShareData];
    }
    return self;
}

- (void)setAllViewLayout{
    [self.shadowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.footBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    
    @weakify(self);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.footBtn.mas_top);
    }];
}

- (UIButton *)shadowBtn{
    if (!_shadowBtn) {
        _shadowBtn = [UIButton new];
        _shadowBtn.backgroundColor = [UIColor blackColor];
        _shadowBtn.alpha = 0.5f;
        [_shadowBtn addTarget:self action:@selector(clickCancelAll) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shadowBtn;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(15, kScreenHeight + CONTENT_HEIGHT + Height_SafeAreaBottom + 20, kScreenWidth - 30, CONTENT_HEIGHT)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 10.0f;
    }
    return _contentView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewLeftAlignedLayout *fl = [[UICollectionViewLeftAlignedLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.minimumLineSpacing = 0;
        fl.minimumInteritemSpacing = 0;
        fl.itemSize = CGSizeMake((kScreenWidth-30-16)/4, 100);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[VEHoneShareSubCell class] forCellWithReuseIdentifier:VEHoneShareSubCellStr];
    }
    return _collectionView;
}

- (UIButton *)footBtn{
    if (!_footBtn) {
        _footBtn = [UIButton new];
        [_footBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_footBtn setTitleColor:[UIColor colorWithHexString:@"#A1A7B2"] forState:UIControlStateNormal];
        [_footBtn setBackgroundColor:[UIColor colorWithHexString:@"#F0F0F0"]];
        _footBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_footBtn addTarget:self action:@selector(clickCancelAll) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footBtn;
}

- (void)createShareData{
    self.shareTitleArr = @[@"微信",@"朋友圈",@"QQ",@"其他",];
    self.shareImageArr = @[@"vm_icon_share_wechat",@"vm_template_share_pyq",@"vm_icon_share_qq",@"vm_template_share_qt",];
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shareTitleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VEHoneShareSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEHoneShareSubCellStr forIndexPath:indexPath];
    if (self.shareTitleArr.count > indexPath.row) {
        cell.titleLab.text = self.shareTitleArr[indexPath.row];
    }
    if (self.shareImageArr.count > indexPath.row) {
        [cell.image setImage:[UIImage imageNamed:self.shareImageArr[indexPath.row]]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self clickCancel];
#warning 这里
//    if (indexPath.row == 0) {
//        [self shareDataWithType:UMSocialPlatformType_WechatSession];
//    }else if (indexPath.row == 1) {
//        [self shareDataWithType:UMSocialPlatformType_WechatTimeLine];
//    }else if (indexPath.row == 2) {
//        [self shareDataWithType:UMSocialPlatformType_QQ];
//    }else if (indexPath.row == 3) {
//        [self showSystemShareView];
//    }
}
- (void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(15, kScreenHeight - CONTENT_HEIGHT - Height_SafeAreaBottom - 20, kScreenWidth - 30, CONTENT_HEIGHT);
    }];
}

- (void)clickCancelAll{
    [self clickCancel];
    [self showCancelBlock];
}
- (void)clickCancel{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(15, kScreenHeight + CONTENT_HEIGHT + Height_SafeAreaBottom - 20, kScreenWidth - 30, CONTENT_HEIGHT);
    }completion:^(BOOL finished) {

        [self.shadowBtn removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)showCancelBlock{
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

#warning 这里
//- (void)shareDataWithType:(UMSocialPlatformType)shareType{
//    [MBProgressHUD showMessage:@"加载中..."];
//    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:self.showModel.thumb] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUD];
//        });
//        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.showModel.title descr:self.showModel.shareDes thumImage:image?:self.showModel.thumb];
//        shareObject.webpageUrl = self.showModel.shareUrl;
//        messageObject.shareObject = shareObject;
//        [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:currViewController() completion:^(id data, NSError *error) {
//            [self showCancelBlock];
//            if (error) {
//                NSDictionary *dic = error.userInfo;
//                NSString *errMsg = @"分享失败";
//                if ([dic.allKeys containsObject:@"message"]) {
//                    errMsg = [dic objectForKey:@"message"];
//                }
//                [MBProgressHUD showError:[NSString stringWithFormat:@"%@",errMsg]];
//            }
//        }];
//    }];
//
//}

/// 弹出系统分享框
- (void)showSystemShareView{
    NSString *testToShare = self.showModel.shareDes;
    UIImage *imageToShare = [UIImage imageNamed:@"vm_icon_default_avatar"];
    NSURL *urlToShare = [NSURL URLWithString:self.showModel.shareUrl];
    NSArray *activityItems = @[testToShare,imageToShare,urlToShare];
    UIActivityViewController *activityVc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    //activityVc.excludedActivityTypes=@[UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [currViewController() presentViewController:activityVc animated:YES completion:nil];
    activityVc.completionWithItemsHandler = ^(UIActivityType _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        [self showCancelBlock];
        if (completed) {
            NSLog(@"分享成功");
        }else{
            NSLog(@"分享取消");
        }
        };
//    系统的分享文字默认是英文的，要想改成中文的，修改info.plist中的 Localization native development region字段为China即可
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
