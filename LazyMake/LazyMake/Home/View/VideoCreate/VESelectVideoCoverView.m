//
//  VESelectVideoCoverView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/23.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VESelectVideoCoverView.h"
#import <AVFoundation/AVFoundation.h>
#define IMAGE_MAX 6

static NSString *LMVideoCoverChoseCellStr = @"LMVideoCoverChoseCell";

@interface LMVideoCoverChoseCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) UIView *borderView;
@end

@implementation LMVideoCoverChoseCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.mainImage];
        [self.contentView addSubview:self.shadowView];
        [self.contentView addSubview:self.borderView];
        [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [UIImageView new];
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
    }
    return _mainImage;
}

- (UIView *)borderView{
    if (!_borderView) {
        _borderView = [UIView new];
        _borderView.backgroundColor = [UIColor clearColor];
        _borderView.layer.borderColor = [UIColor colorWithHexString:@"#1DABFD"].CGColor;
        _borderView.layer.borderWidth = 2.0f;
    }
    return _borderView;
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.backgroundColor = [UIColor colorWithHexString:@"#1DABFD"];
        _shadowView.alpha = 0.3f;
    }
    return _shadowView;
}

@end

@interface LMVideoCoverChoseView : UIView

@property (copy, nonatomic) void (^clickSubBtnBlock)(NSInteger btnTag);
@property (strong, nonatomic) UIButton *btn1;
@property (strong, nonatomic) UIButton *btn2;
@property (strong, nonatomic) UIImageView *selectImage;

@end

@implementation LMVideoCoverChoseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.selectImage];
        [self addSubview:self.btn1];
        [self addSubview:self.btn2];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_centerX);
    }];
    
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.btn1.mas_right);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (UIButton *)btn1{
    if (!_btn1) {
        _btn1 = [UIButton new];
        [_btn1 setTitle:@"视频提取" forState:UIControlStateNormal];
        [_btn1 setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn1.tag = 1;
        [_btn1 addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn1;
}

- (UIButton *)btn2{
    if (!_btn2) {
        _btn2 = [UIButton new];
        [_btn2 setTitle:@"本地图片" forState:UIControlStateNormal];
        [_btn2 setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn2.tag = 2;
        [_btn2 addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn2;
}

- (UIImageView *)selectImage{
    if (!_selectImage) {
        _selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 86, 26)];
        UIImage *image = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(86, 26)];
        [_selectImage setImage:image];
        _selectImage.layer.masksToBounds = YES;
        _selectImage.layer.cornerRadius = 13.f;
    }
    return _selectImage;
}

- (void)clickSubBtn:(UIButton *)btn{
    CGRect imageF = CGRectMake(0, 0, 86, 26);
    if (btn.tag == 2) {
        imageF = CGRectMake(86, 0, 86, 26);
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.selectImage.frame = imageF;
    }];
    
    if (self.clickSubBtnBlock) {
        self.clickSubBtnBlock(btn.tag);
    }
}

@end

@interface VESelectVideoCoverView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) LMVideoCoverChoseView *selectView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UILabel *contentLab;
@property (assign, nonatomic) NSInteger selectIndex;
@property (strong, nonatomic) UIButton *addImageBtn;

@end

@implementation VESelectVideoCoverView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.selectView];
        [self addSubview:self.collectionView];
        [self addSubview:self.contentLab];
        [self addSubview:self.addImageBtn];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(172, 26));
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo((kScreenWidth - (51 * 6))/2);
        make.right.mas_equalTo(-((kScreenWidth - (51 * 6))/2));
        make.top.mas_equalTo(self.selectView.mas_bottom).mas_offset(12);
        make.height.mas_equalTo(60);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.collectionView.mas_bottom).mas_offset(8);
    }];
    
    [self.addImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.selectView.mas_bottom).mas_offset(26);
        make.size.mas_equalTo(CGSizeMake(130, 30));
    }];
    
}

- (LMVideoCoverChoseView *)selectView{
    if (!_selectView) {
        _selectView = [[LMVideoCoverChoseView alloc]initWithFrame:CGRectZero];
        _selectView.backgroundColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _selectView.layer.masksToBounds = YES;
        _selectView.layer.cornerRadius = 13;
        
        @weakify(self);
        _selectView.clickSubBtnBlock = ^(NSInteger btnTag) {
            @strongify(self);
            UIImage *image;
            if (self.imageList.count > self.selectIndex) {
                image = self.imageList[self.selectIndex];
            }
            if (self.clickSubBtnBlock) {
                self.clickSubBtnBlock(btnTag,image);
            }
            if (btnTag == 1) {
                self.collectionView.hidden = NO;
                self.contentLab.hidden = NO;
                self.addImageBtn.hidden = YES;
            }else{
                self.collectionView.hidden = YES;
                self.contentLab.hidden = YES;
                self.addImageBtn.hidden = NO;
            }
        };
    }
    return _selectView;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.text = @"(点击选择一张作为封面图）";
    }
    return _contentLab;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        fl.minimumLineSpacing = 0;
        fl.minimumInteritemSpacing = 0;
        fl.itemSize = CGSizeMake(51, 60);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[LMVideoCoverChoseCell class] forCellWithReuseIdentifier:LMVideoCoverChoseCellStr];

    }
    return _collectionView;
}

- (UIButton *)addImageBtn{
    if (!_addImageBtn) {
        _addImageBtn = [UIButton new];
        [_addImageBtn setTitle:@"添加图片" forState:UIControlStateNormal];
        [_addImageBtn setImage:[UIImage imageNamed:@"vm_detail_editor_add"] forState:UIControlStateNormal];
        [_addImageBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
        [_addImageBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _addImageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _addImageBtn.layer.masksToBounds = YES;
        _addImageBtn.layer.cornerRadius = 15;
        _addImageBtn.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
        _addImageBtn.layer.borderWidth = 1.0f;
        _addImageBtn.hidden = YES;
        [_addImageBtn addTarget:self action:@selector(clickAddImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImageBtn;
}

- (void)setAllImageArr:(NSArray *)allImageArr{
    _allImageArr = allImageArr;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageList = [NSMutableArray new];
        NSInteger otherNum = 1;
        if (allImageArr.count / IMAGE_MAX > 1) {
            otherNum = allImageArr.count / IMAGE_MAX;
        }
        for (int x = 0; x <= allImageArr.count-otherNum; x+=otherNum) {
            [self.imageList addObject:allImageArr[x]];
        }
        if (self.loadAllImageBlock) {
            self.loadAllImageBlock(self.imageList);
        }
        [self.collectionView reloadData];
        [MBProgressHUD hideHUD];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [self.collectionView reloadData];
        });
    });
}

- (void)clickAddImage{
    if (self.clickAddImageBlock) {
        self.clickAddImageBlock();
    }
}


- (void)setVideoUrl:(NSString *)videoUrl{
    _videoUrl = videoUrl;
}

#pragma mark - UICollcetionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LMVideoCoverChoseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LMVideoCoverChoseCellStr forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    if (self.imageList.count > indexPath.row) {
        [cell.mainImage setImage:self.imageList[indexPath.row]];
    }
    if (self.selectIndex == indexPath.row) {
        cell.shadowView.hidden = NO;
        cell.borderView.hidden = NO;
    }else{
        cell.shadowView.hidden = YES;
        cell.borderView.hidden = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndex = indexPath.row;
    [self.collectionView reloadData];
    if (self.imageList.count > indexPath.row) {
        if (self.clickSubImageBlock) {
            self.clickSubImageBlock(self.imageList[indexPath.row]);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
