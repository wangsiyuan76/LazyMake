//
//  VEChangeImageVideoView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/22.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEChangeImageVideoView.h"
#import "TZImagePickerController.h"
#import "VESelectVideoController.h"
#import "VEAlertSheetView.h"
#import "VEAETemplateCutoutController.h"

static NSString *LMChangeImageVideoItemCellStr = @"LMChangeImageVideoItemCell";
@implementation LMChangeImageVideoItemModel
@end

@interface LMChangeImageVideoItemCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) LMChangeImageVideoItemModel *model;
@property (assign, nonatomic) NSInteger index;
@end

@implementation LMChangeImageVideoItemCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.mainImage];
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.lineView];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.height.mas_equalTo(18);
//    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.right.mas_equalTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
     }];
}

- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [UIImageView new];
        _mainImage.layer.masksToBounds = YES;
        _mainImage.layer.cornerRadius = 7.0f;
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
    }
    return _mainImage;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 86-18, 66, 18)];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#1DABFD"];
        _bottomView.alpha = 0.5f;
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:_bottomView.bounds
                                        byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(5,5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _bottomView.bounds;
        maskLayer.path = maskPath.CGPath;
        _bottomView.layer.mask = maskLayer;
    }
    return _bottomView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor clearColor];
        _lineView.layer.masksToBounds = YES;
        _lineView.layer.cornerRadius = 7.0f;
        _lineView.layer.borderColor = [UIColor colorWithHexString:@"#1DABFD"].CGColor;
        _lineView.layer.borderWidth = 2.0f;
    }
    return _lineView;
}

- (void)setModel:(LMChangeImageVideoItemModel *)model{
    _model = model;
    
    [self.mainImage setImage:model.coverImage];
    self.titleLab.text = model.titleStr;
    if (model.ifSelect) {
        _lineView.hidden = NO;
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#1DABFD"];
        _bottomView.alpha = 0.5f;
    }else{
        _lineView.hidden = YES;
//        _bottomView.backgroundColor = MAIN_BLACK_COLOR;
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#3B3C4E"];
        _bottomView.alpha = 1;
    }
}

@end

@interface VEChangeImageVideoView () <UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>

@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) UIButton *cancleBtn;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger selectIndex;
@end

@implementation VEChangeImageVideoView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cancleBtn];
        [self addSubview:self.sureBtn];
        [self addSubview:self.titleLab];
        [self addSubview:self.collectionView];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setListArr:(NSArray *)listArr{
    _listArr = listArr;
    [self.collectionView reloadData];
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.cancleBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.sureBtn.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(13);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(86);
    }];
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        [_sureBtn setImage:[UIImage imageNamed:@"vm_icon_popover_complete"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton new];
        [_cancleBtn setImage:[UIImage imageNamed:@"vm_icon_popover_close"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont boldSystemFontOfSize:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"替换图片";
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _titleLab;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        fl.minimumLineSpacing = 10;
        fl.minimumInteritemSpacing = 10;
        fl.itemSize = CGSizeMake(66, 86);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[LMChangeImageVideoItemCell class] forCellWithReuseIdentifier:LMChangeImageVideoItemCellStr];

    }
    return _collectionView;
}

- (void)clickSureBtn{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(YES, self.listArr);
    }
    
}

- (void)clickCancelBtn{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(NO, self.listArr);
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LMChangeImageVideoItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LMChangeImageVideoItemCellStr forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.index = indexPath.row;
    if (self.listArr.count > indexPath.row) {
        cell.model = self.listArr[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndex = indexPath.row;
    if (self.aeType == LMAEVideoType_TextPicVideo || self.aeType == LMAEVideoType_PicVideo) {
        [self showImageOrVideoAlert];
    }else if(self.aeType == LMAEVideoType_AllPic || self.aeType == LMAEVideoType_TextPic){
        [self changePhotoIfVideo:NO];
    }else if(self.aeType == LMAEVideoType_AllVideo || self.aeType == LMAEVideoType_TextVideo){
        [self selectVideo];
    }
}

- (void)showImageOrVideoAlert{
    
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    VEAlertSheetView *ale = [[VEAlertSheetView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) titleArr:@[@"选择图片",@"选择视频",@"取消"]  titleStr:@""];
    [win addSubview:ale];
    [ale show];
    ale.clickSubBtnBlock = ^(BOOL ifCancle, NSInteger btnTag) {
        if (btnTag == 0) {
            [self changePhotoIfVideo:NO];
        }else if(btnTag == 1){
            [self selectVideo];
        }
    };
    
//       //显示弹出框列表选择
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
//                                                                   message:nil
//                                                            preferredStyle:UIAlertControllerStyleActionSheet];
//
//    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {
//                                                              //响应事件
//                                                              NSLog(@"action = %@", action);
//                                                          }];
//    UIAlertAction* nanAct = [UIAlertAction actionWithTitle:@"选择图片" style:UIAlertActionStyleDefault
//                                                         handler:^(UIAlertAction * action) {
//                                                             //响应事件
//                                                            [self changePhotoIfVideo:NO];
//                                                         }];
//    UIAlertAction* nvAct = [UIAlertAction actionWithTitle:@"选择视频" style:UIAlertActionStyleDefault
//                                                         handler:^(UIAlertAction * action) {
//                                                             //响应事件
//                                                             [self selectVideo];
//                                                         }];
//    
//    [nanAct setValue:[UIColor colorWithHexString:@"#1A1A1A"] forKey:@"titleTextColor"];
//    [nvAct setValue:[UIColor colorWithHexString:@"#1A1A1A"] forKey:@"titleTextColor"];
//    [cancelAction setValue:[UIColor colorWithHexString:@"#A1A7B2"] forKey:@"titleTextColor"];
//
//    [alert addAction:nanAct];
//    [alert addAction:nvAct];
//    [alert addAction:cancelAction];
//    [currViewController() presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 添加图片和视频
//添加图片
- (void)changePhotoIfVideo:(BOOL)ifVideo{
    if (self.stopVidepBlock) {
        self.stopVidepBlock(YES);
    }
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.ifUsedTZCrop = YES;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    if (self.showModel.oneCutout.integerValue != 1) {
        imagePickerVc.customAspectRatio = CGSizeMake(self.imageSize.width, self.imageSize.height);
    }
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [currViewController() presentViewController:imagePickerVc animated:YES completion:nil];
    @weakify(self);
    imagePickerVc.noTZCropBlock = ^(UIImage *cropImage) {
        @strongify(self);
        if (self.listArr.count > self.selectIndex) {
            LMChangeImageVideoItemModel *model = self.listArr[self.selectIndex];
            model.ifSelect = YES;
            model.coverImage = cropImage;
            model.ifVideo = NO;
        }
        [self.collectionView reloadData];
        if (self.showModel.oneCutout.integerValue == 1 || self.showModel.customObj.oneCutout.integerValue == 1) {
            [self cutoutImageWithImage:cropImage];
        }
    };
}

- (void)selectVideo{
    if (self.stopVidepBlock) {
        self.stopVidepBlock(YES);
    }
    VESelectVideoController *vc = [[VESelectVideoController alloc]init];
    vc.videoType = LMEditVideoTypeSelect;
    vc.cropBili = CGSizeMake(self.imageSize.width, self.imageSize.height);
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [currViewController() presentViewController:nav animated:YES completion:nil];
    @weakify(self);
    vc.dismissSelectBlock = ^(VESelectVideoModel * _Nonnull videoModel, NSString * _Nonnull videoPath) {
        @strongify(self);
        if (self.listArr.count > self.selectIndex) {
            LMChangeImageVideoItemModel *model = self.listArr[self.selectIndex];
            model.ifSelect = YES;
            model.coverImage = videoModel.showImage;
            model.ifVideo = YES;
            model.videoUrl = [NSString stringWithFormat:@"file://%@",videoPath];
            model.startTime = videoModel.beginTime;
            model.endTime = videoModel.endTime;
        }
        [self.collectionView reloadData];
    };
}

- (void)cutoutImageWithImage:(UIImage *)image{
    VEAETemplateCutoutController *cutVC = [[VEAETemplateCutoutController alloc]init];
    cutVC.selectImage = image;
    cutVC.showModel = self.showModel;
    [self.superVC.navigationController pushViewController:cutVC animated:NO];
    @weakify(self);
    cutVC.selectBlock = ^(UIImage * _Nonnull selectImage, BOOL hasChange) {
        @strongify(self);
        if (hasChange) {
            if (self.listArr.count > self.selectIndex) {
                LMChangeImageVideoItemModel *model = self.listArr[self.selectIndex];
                model.ifSelect = YES;
                model.coverImage = selectImage;
                model.ifVideo = NO;
            }
            [self.collectionView reloadData];
        }
    };
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
