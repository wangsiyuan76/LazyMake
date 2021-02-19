//
//  VEMoreLatticeVideoSortView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEMoreLatticeVideoSortView.h"
#import "VEVideoSpliceChangeView.h"
#import "VESelectVideoModel.h"

@implementation VEMoreLatticeVideoSortView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.sureBtn];
        [self addSubview:self.cancleBtn];
        [self addSubview:self.titleLab];
        [self addSubview:self.title1];
        [self addSubview:self.title2];
        [self addSubview:self.togetherBtn];
        [self addSubview:self.orderBtn];
        [self addSubview:self.collectionView];
        [self addSubview:self.bottomLab];
        [self addRecognize];
        [self setAllViewLayout];
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
    
    [self.title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(self.cancleBtn.mas_bottom).mas_offset(30);
    }];
    
    [self.title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(self.title1.mas_bottom).mas_offset(54);
    }];
    
    [self.togetherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.title1.mas_right).mas_offset(15);
        make.size.mas_equalTo(CGSizeMake(90, 30));
        make.centerY.mas_equalTo(self.title1.mas_centerY);
    }];
    
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.togetherBtn.mas_right).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(90, 30));
        make.centerY.mas_equalTo(self.title1.mas_centerY);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.title1.mas_right).mas_offset(15);
        make.top.mas_equalTo(self.togetherBtn.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(70);
    }];
    
    [self.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.title1.mas_right).mas_offset(15);
        make.top.mas_equalTo(self.collectionView.mas_bottom).mas_offset(8);
    }];
}

- (void)createDataArr:(NSArray *)dataArr{
    NSMutableArray *subArr = [NSMutableArray new];
    [subArr addObjectsFromArray:dataArr];
    self.dataArr = subArr;
    [self.collectionView reloadData];
}

#pragma mark - 创建view
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
        _titleLab.text = @"排序";
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _titleLab;
}

- (UILabel *)title1{
    if (!_title1) {
        _title1 = [UILabel new];
        _title1.text = @"播放模式";
        _title1.textColor = [UIColor colorWithHexString:@"ffffff"];
        _title1.font = [UIFont systemFontOfSize:15];
    }
    return _title1;
}

- (UILabel *)title2{
    if (!_title2) {
        _title2 = [UILabel new];
        _title2.text = @"播放顺序";
        _title2.textColor = [UIColor colorWithHexString:@"ffffff"];
        _title2.font = [UIFont systemFontOfSize:15];
    }
    return _title2;
}

- (UIButton *)togetherBtn{
    if (!_togetherBtn) {
        _togetherBtn = [UIButton new];
        [_togetherBtn setTitle:@"同时播放" forState:UIControlStateNormal];
        [_togetherBtn setTitleColor:[UIColor colorWithHexString:@"#0C0E23"] forState:UIControlStateNormal];
        [_togetherBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
        _togetherBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_togetherBtn setBackgroundColor:[UIColor colorWithHexString:@"#1DABFD"]];
        [_togetherBtn addTarget:self action:@selector(clcikTogetherBtn) forControlEvents:UIControlEventTouchUpInside];
        self.playStyle = 0;
        _togetherBtn.selected = YES;
        _togetherBtn.layer.masksToBounds = YES;
        _togetherBtn.layer.cornerRadius = 15;
    }
    return _togetherBtn;
}

- (UIButton *)orderBtn{
    if (!_orderBtn) {
        _orderBtn = [UIButton new];
        [_orderBtn setTitle:@"顺序播放" forState:UIControlStateNormal];
        [_orderBtn setTitleColor:[UIColor colorWithHexString:@"#0C0E23"] forState:UIControlStateNormal];
        [_orderBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateSelected];
        _orderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_orderBtn setBackgroundColor:[UIColor colorWithHexString:@"#A1A7B2"]];
        [_orderBtn addTarget:self action:@selector(clcikOrderBtn) forControlEvents:UIControlEventTouchUpInside];
        _orderBtn.layer.masksToBounds = YES;
        _orderBtn.layer.cornerRadius = 15;
    }
    return _orderBtn;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        fl.minimumLineSpacing = 5;
        fl.minimumInteritemSpacing = 5;
        fl.itemSize = CGSizeMake(50 , 70);
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

- (UILabel *)bottomLab{
    if (!_bottomLab) {
        _bottomLab = [UILabel new];
        _bottomLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _bottomLab.text = @"(可长按拖动)";
        _bottomLab.font = [UIFont systemFontOfSize:11];
    }
    return _bottomLab;
}

#pragma mark - 点击事件
- (void)clickSureBtn{
    if (self.clickSureBtnBlock) {
        self.clickSureBtnBlock(YES,self.playStyle,self.dataArr);
    }
}

- (void)clickCancelBtn{
    if (self.clickSureBtnBlock) {
        self.clickSureBtnBlock(NO,self.playStyle,self.dataArr);
    }
}

- (void)clcikTogetherBtn{
    self.togetherBtn.selected = YES;
    self.orderBtn.selected = NO;
    [self.togetherBtn setBackgroundColor:[UIColor colorWithHexString:@"#1DABFD"]];
    [self.orderBtn setBackgroundColor:[UIColor colorWithHexString:@"#A1A7B2"]];
    self.playStyle = 0;
}

- (void)clcikOrderBtn{
    self.orderBtn.selected = YES;
    self.togetherBtn.selected = NO;
    [self.orderBtn setBackgroundColor:[UIColor colorWithHexString:@"#1DABFD"]];
    [self.togetherBtn setBackgroundColor:[UIColor colorWithHexString:@"#A1A7B2"]];
    self.playStyle = 1;
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
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [longGesture locationInView:self.collectionView];
            [self.collectionView updateInteractiveMovementTargetPosition:CGPointMake(point.x, 38)];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            // 移动完成关闭cell移动
            [self.collectionView endInteractiveMovement];
            [self.collectionView reloadData];
            [self performSelector:@selector(reloadCollectionView) withObject:nil afterDelay:0.3];
        }
            break;
        default:{
            [self.collectionView endInteractiveMovement];
        }
            break;
    }
}

- (void)reloadCollectionView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
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
    cell.titleLab.text = [NSString stringWithFormat:@"%zd",indexPath.row+1];
    LMLog(@"asfasdfasdfasd======%@",cell.titleLab.text);
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
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self changeSelectIndex:indexPath.row];
//    if (self.clickCellItemBlock) {
//        self.clickCellItemBlock(indexPath.row);
//    }
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

- (void)createPlayStyle:(NSInteger)playStyle{
    if (playStyle == 0) {
        [self clcikTogetherBtn];
    }else{
        [self clcikOrderBtn];
    }
}

@end
