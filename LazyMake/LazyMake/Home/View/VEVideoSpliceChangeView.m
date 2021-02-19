//
//  VEVideoSpliceChangeView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/21.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVideoSpliceChangeView.h"
#import "VESelectVideoModel.h"


@implementation LMVideoSpliceChangeCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.mainImage];
        [self.contentView addSubview:self.shadowView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.selectView];
        [self.contentView addSubview:self.subBtn];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    [self.subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

}

- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [UIImageView new];
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
        _mainImage.layer.cornerRadius = 5.0f;
    }
    return _mainImage;
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.backgroundColor = [UIColor colorWithHexString:@"#15182A"];
        _shadowView.alpha = 0.6;
        
//        //设置VIP标志的单边圆角
//         UIBezierPath *maskPath;
//         maskPath = [UIBezierPath bezierPathWithRoundedRect:_shadowView.bounds
//                                              byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
//                                                    cornerRadii:CGSizeMake(5, 5)];
//         CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//         maskLayer.frame = _shadowView.bounds;
//         maskLayer.path = maskPath.CGPath;
//         _shadowView.layer.mask = maskLayer;
    }
    return _shadowView;
}

- (UIView *)selectView{
    if (!_selectView) {
        _selectView = [UIView new];
        _selectView.backgroundColor = [UIColor clearColor];
        _selectView.layer.masksToBounds = YES;
        _selectView.layer.cornerRadius = 5.0f;
        _selectView.layer.borderColor = [UIColor colorWithHexString:@"#1DABFD"].CGColor;
        _selectView.layer.borderWidth = 2.0f;
    }
    return _selectView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:12];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _titleLab.text = @"剪裁";
    }
    return _titleLab;
}

- (UIButton *)subBtn{
    if (!_subBtn) {
        _subBtn = [UIButton new];
        [_subBtn addTarget:self action:@selector(clickSubBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subBtn;
}

- (void)clickSubBtn{
    if (self.clickSubBtnBlock) {
        self.clickSubBtnBlock(self.index);
    }
}
@end

@implementation VEVideoSpliceChangeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.playBtn];
        [self addSubview:self.allTimeLab];
        [self addSubview:self.playTimeLab];
        [self addSubview:self.collectionView];
        [self addSubview:self.bottomLab];
        [self setAllViewLayout];
        [self addRecognize];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(8);
        make.width.mas_equalTo (80);
    }];
    
    [self.allTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.playBtn.mas_centerY);
    }];
    
    [self.playTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(self.allTimeLab.mas_left);
        make.centerY.mas_equalTo(self.playBtn.mas_centerY);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.playBtn.mas_bottom).mas_offset(12);
        make.height.mas_equalTo(80);
    }];
    
    [self.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.collectionView.mas_bottom).mas_offset(8);
    }];
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setTitle:@"播放全部" forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"vm_icon_tailor_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"vm_icon_tailor_suspended"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(clickPlayBtn) forControlEvents:UIControlEventTouchUpInside];
        [_playBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        _playBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _playBtn.selected = YES;
    }
    return _playBtn;
}

- (UILabel *)playTimeLab{
    if (!_playTimeLab) {
        _playTimeLab = [UILabel new];
        _playTimeLab.textAlignment = NSTextAlignmentRight;
        _playTimeLab.font = [UIFont systemFontOfSize:12];
        _playTimeLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _playTimeLab.text = @"00:00";
    }
    return _playTimeLab;
}

- (UILabel *)allTimeLab{
    if (!_allTimeLab) {
        _allTimeLab = [UILabel new];
        _allTimeLab.textAlignment = NSTextAlignmentRight;
        _allTimeLab.font = [UIFont systemFontOfSize:12];
        _allTimeLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _allTimeLab.text = @"/00:00";
    }
    return _allTimeLab;
}

- (UILabel *)bottomLab{
    if (!_bottomLab) {
        _bottomLab = [UILabel new];
        _bottomLab.textAlignment = NSTextAlignmentCenter;
        _bottomLab.font = [UIFont systemFontOfSize:14];
        _bottomLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _bottomLab.text = @"长按拖动排序";
    }
    return _bottomLab;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        fl.minimumLineSpacing = 5;
        fl.minimumInteritemSpacing = 5;
        fl.itemSize = CGSizeMake((self.width - ((5)*5))/6 , 78);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[LMVideoSpliceChangeCell class] forCellWithReuseIdentifier:LMVideoSpliceChangeCellStr];
    }
    return _collectionView;
}

- (void)addRecognize{
    UILongPressGestureRecognizer *recognize = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction:)];
    //设置长按响应时间为0.5秒
    recognize.minimumPressDuration = 0.2;
    [self.collectionView addGestureRecognizer:recognize];
}

// 长按手势方法
- (void)longPressGestureAction:(UILongPressGestureRecognizer *)longGesture {
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *aIndexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:aIndexPath];
            if (self.moveCellBlock) {
                self.moveCellBlock(UIGestureRecognizerStateBegan);
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [longGesture locationInView:self.collectionView];
            [self.collectionView updateInteractiveMovementTargetPosition:CGPointMake(point.x, self.collectionView.origin.y+2)];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            // 移动完成关闭cell移动
            [self.collectionView endInteractiveMovement];
            // 移除拖动手势
            [self.collectionView removeGestureRecognizer:longGesture];
            // 为collectionView添加拖动手势
            [self addRecognize];
            if (self.moveCellBlock) {
                self.moveCellBlock(UIGestureRecognizerStateEnded);
            }
        }
            break;
        default:{
            [self.collectionView endInteractiveMovement];
            [self.collectionView removeGestureRecognizer:longGesture];
            [self addRecognize];
        }
            break;
    }
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    VESelectVideoModel *model = self.dataArr[0];
    model.ifSelect = YES;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LMVideoSpliceChangeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LMVideoSpliceChangeCellStr forIndexPath:indexPath];
    cell.index = indexPath.row;
    if (self.dataArr.count > indexPath.row) {
        VESelectVideoModel *model = self.dataArr[indexPath.row];
        cell.mainImage.image = model.showImage;
        cell.selectView.hidden = YES;
        if (model.ifSelect) {
            cell.selectView.hidden = NO;
        }
    }
    @weakify(self);
    cell.clickSubBtnBlock = ^(NSInteger index) {
        @strongify(self);
        [self changeSelectIndex:index];
        if (self.clickCropBtnBlock) {
            self.clickCropBtnBlock(index);
        }
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self changeSelectIndex:indexPath.row];
    if (self.clickCellItemBlock) {
        self.clickCellItemBlock(indexPath.row);
    }
}

// 开始移动的时候调用此方法，可以获取相应的datasource方法设置特殊的indexpath 能否移动,如果能移动返回的是YES ,不能移动返回的是NO
- (BOOL)beginInteractiveMovementForItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

// 更新移动过程的位置
- (void)updateInteractiveMovementTargetPosition:(CGPoint)targetPosition {
    
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    // 删除数据源中初始位置的数据
    id objc = [self.dataArr objectAtIndex:sourceIndexPath.item];
    [self.dataArr removeObject:objc];
    // 将数据插入数据源中新的位置，实现数据源的更新
    [self.dataArr insertObject:objc atIndex:destinationIndexPath.item];
    if (self.changeDataArrNumberBlock) {
        self.changeDataArrNumberBlock(self.dataArr);
    }
}

- (void)setSecondAll:(NSInteger)secondAll{
    _secondAll = secondAll;
    int seconds = secondAll % 60;
    int minutes = (secondAll / 60) % 60;
    self.allTimeLab.text = [NSString stringWithFormat:@"/%.2d:%.2d",minutes,seconds];
}

- (void)clickPlayBtn{
    self.playBtn.selected = !self.playBtn.selected;
    if (self.clickPlayBtnBlock) {
        self.clickPlayBtnBlock(self.playBtn.selected);
    }
}

- (void)changePlayTimeSchedule:(NSInteger)schedule{
    int seconds = schedule % 60;
    int minutes = (schedule / 60) % 60;
    self.playTimeLab.text = [NSString stringWithFormat:@"%.2d:%.2d",minutes,seconds];
}

- (void)changeSelectIndex:(NSInteger)index{
    for (int x = 0; x < self.dataArr.count; x++) {
        VESelectVideoModel *model = self.dataArr[x];
        model.ifSelect = NO;
        if (x == index) {
            model.ifSelect = YES;
        }
    }
    [self.collectionView reloadData];
}


@end
