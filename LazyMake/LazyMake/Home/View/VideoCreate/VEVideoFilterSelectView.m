//
//  VEVideoFilterSelectView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/17.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVideoFilterSelectView.h"
#import "UICollectionViewLeftAlignedLayout.h"

static NSString *LMVideoFilterSelectCellStr = @"LMVideoFilterSelectCell";

@interface LMVideoFilterSelectModel : NSObject
@property (strong, nonatomic) NSString *imageStr;
@property (strong, nonatomic) NSString *titleStr;
@property (assign, nonatomic) BOOL ifSelect;
@end
@implementation LMVideoFilterSelectModel
@end


@interface LMVideoFilterSelectCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) VEFilterSelectModel *model;
@property (assign, nonatomic) NSInteger index;
@end

@implementation LMVideoFilterSelectCell

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
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(18);
    }];
    
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
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor blackColor];
        _bottomView.alpha = 0.5f;
//        UIBezierPath *maskPath;
//        maskPath = [UIBezierPath bezierPathWithRoundedRect:_bottomView.bounds
//                                        byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopRight)
//                                               cornerRadii:CGSizeMake(8, 8)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = _bottomView.bounds;
//        maskLayer.path = maskPath.CGPath;
//        _bottomView.layer.mask = maskLayer;
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

- (void)setModel:(VEFilterSelectModel *)model{
    _model = model;
    [self.mainImage setImage:[UIImage imageNamed:model.imageStr]];
    self.titleLab.text = model.titleStr;
    if (model.ifSelect) {
        _lineView.hidden = NO;
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#1DABFD"];
        if (self.index == 0) {
            [self.mainImage setImage:[UIImage imageNamed:@"vm_detail_filter_p"]];
        }
    }else{
        _lineView.hidden = YES;
        _bottomView.backgroundColor = [UIColor blackColor];
        if (self.index == 0) {
            [self.mainImage setImage:[UIImage imageNamed:@"vm_detail_filter_n"]];
        }
    }
}

@end
@interface VEVideoFilterSelectView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) UIButton *cancleBtn;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *listArr;
@property (strong, nonatomic) VEFilterSelectModel *selectModel;
@end

@implementation VEVideoFilterSelectView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cancleBtn];
        [self addSubview:self.sureBtn];
        [self addSubview:self.titleLab];
        [self addSubview:self.collectionView];
        [self setAllViewLayout];
        [self loadData];
        
    }
    return self;
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
        _titleLab.text = @"滤镜";
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
        [_collectionView registerClass:[LMVideoFilterSelectCell class] forCellWithReuseIdentifier:LMVideoFilterSelectCellStr];

    }
    return _collectionView;
}

- (void)clickSureBtn{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(YES, self.selectIndex,self.selectModel);
    }
    
}

- (void)clickCancelBtn{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(NO, self.selectIndex,self.selectModel);
    }
}

- (void)loadData{
    self.listArr = [VEFilterSelectModel createFilterDataArr];
    self.selectIndex = 0;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LMVideoFilterSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LMVideoFilterSelectCellStr forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.index = indexPath.row;
    if (self.listArr.count > indexPath.row) {
        cell.model = self.listArr[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (LMVideoFilterSelectModel *model  in self.listArr) {
         model.ifSelect = NO;
    }
    if (self.listArr.count > indexPath.row) {
        VEFilterSelectModel *model = self.listArr[indexPath.row];
        self.selectModel = model;
        model.ifSelect = YES;
        if (self.clickSubFilBlock) {
            self.clickSubFilBlock(model);
        }
    }
    [self.collectionView reloadData];
    self.selectIndex = indexPath.row;
}

- (void)setOldSelect:(NSInteger)oldSelect{
    _oldSelect = oldSelect;
    self.selectIndex = oldSelect;
    for (LMVideoFilterSelectModel *model  in self.listArr) {
         model.ifSelect = NO;
    }
    if (self.listArr.count > oldSelect) {
        VEFilterSelectModel *model = self.listArr[oldSelect];
        self.selectModel = model;
        model.ifSelect = YES;
    }
    [self.collectionView reloadData];
}


@end
