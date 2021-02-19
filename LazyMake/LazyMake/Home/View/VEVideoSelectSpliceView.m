//
//  VEVideoSelectSpliceView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/21.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVideoSelectSpliceView.h"
#import "VEVideoPreviewViewController.h"
#import "VEMoreGridVideoController.h"

static NSString *LMVideoSelectSpliceCellStr = @"LMVideoSelectSpliceCell";

@interface LMVideoSelectSpliceCell : UICollectionViewCell

@property (copy, nonatomic) void (^clickDeleteBtnBlock)(NSInteger index);
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UILabel *timeLab;
@property (assign, nonatomic) NSInteger index;

@end

@implementation LMVideoSelectSpliceCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.mainImage];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.deleteBtn];
        [self setAllViewLayout];
    }return self;
}

- (void)setAllViewLayout{
    [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-4);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.right.mas_equalTo(-2);
        make.top.mas_equalTo(2);
    }];
}

- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [UIImageView new];
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
        _mainImage.layer.masksToBounds = YES;
        _mainImage.layer.cornerRadius = 7.0f;
        
        _mainImage.backgroundColor = [UIColor redColor];
    }
    return _mainImage;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _timeLab.font = [UIFont systemFontOfSize:11];
        _timeLab.textAlignment = NSTextAlignmentRight;
        _timeLab.text = @"dddd";
    }
    return _timeLab;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
        [_deleteBtn setImage:[UIImage imageNamed:@"vm_choose_picture_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (void)clickDeleteBtn{
    if (self.clickDeleteBtnBlock) {
        self.clickDeleteBtnBlock(self.index);
    }
}

@end

@implementation VEVideoSelectSpliceView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArr = [NSMutableArray new];
        [self addSubview:self.titleView];
        [self addSubview:self.titleLab];
        [self addSubview:self.mainView];
        [self.mainView addSubview:self.numLab];
        [self.mainView addSubview:self.nextBtn];
        [self.mainView addSubview:self.collectionView];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
//    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.size.mas_equalTo(CGSizeMake(146, 36));
//        make.top.mas_equalTo(15);
//        make.centerX.mas_equalTo(self.mas_centerX);
//    }];
//
//    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.size.mas_equalTo(CGSizeMake(146, 36));
//        make.top.mas_equalTo(15);
//        make.centerX.mas_equalTo(self.mas_centerX);
//    }];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_offset(0);
    }];
    
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(60, 24));
        make.centerY.mas_equalTo(self.numLab.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.numLab.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(-(10+Height_SafeAreaBottom));
    }];
}

- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [UIView new];
        _titleView.backgroundColor = [UIColor colorWithHexString:@"#15182A"];
        _titleView.layer.masksToBounds = YES;
        _titleView.layer.cornerRadius = 18.f;
    }
    return _titleView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"最多选择6个视频";
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [UIView new];
        _mainView.backgroundColor  = [UIColor colorWithHexString:@"#15182A"];
    }
    return _mainView;
}

- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [UILabel new];
        _numLab.font = [UIFont systemFontOfSize:14];
        _numLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _numLab.text = @"选择视频0个";
    }
    return _numLab;
}

-(UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton new];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = 12;
        [_nextBtn addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(60, 24)];
        [_nextBtn setBackgroundImage:image forState:UIControlStateNormal];
        
    }
    return _nextBtn;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        fl.minimumLineSpacing = 10;
        fl.minimumInteritemSpacing = 10;
        fl.itemSize = CGSizeMake(74, 78);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[LMVideoSelectSpliceCell class] forCellWithReuseIdentifier:LMVideoSelectSpliceCellStr];
        
    }
    return _collectionView;
}

-(void)inseartObj:(VESelectVideoModel *)obj maxNumber:(NSInteger)maxNumber{
    if (obj) {
        if (self.dataArr.count >= maxNumber) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"最多选择%zd个视频",maxNumber]];
            return;
        }
        if (obj.ifLoading) {
            [MBProgressHUD showError:@"正在同步数据"];
            return;
        }
        [self.dataArr addObject:obj];
        [self.collectionView reloadData];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"选择视频%zd个",self.dataArr.count]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1DABFD"] range:NSMakeRange(4, 1)];
        self.numLab.attributedText = str;
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LMVideoSelectSpliceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LMVideoSelectSpliceCellStr forIndexPath:indexPath];
    cell.index = indexPath.row;
    if (self.dataArr.count > indexPath.row) {
        VESelectVideoModel *model = self.dataArr[indexPath.row];
        cell.mainImage.image = model.showImage;
        if (model.timeStr.length > 7) {
            cell.timeLab.text = [model.timeStr substringWithRange:NSMakeRange(3, model.timeStr.length-3)];
        }
    }
    @weakify(self);
    cell.clickDeleteBtnBlock = ^(NSInteger index) {
        @strongify(self);
        [self deleteDataWithIndex:index];
    };
    return cell;
}

- (void)deleteDataWithIndex:(NSInteger)index{
    if (self.dataArr.count > index) {
        [self.dataArr removeObjectAtIndex:index];
        [self.collectionView reloadData];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"选择视频%zd个",self.dataArr.count]];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1DABFD"] range:NSMakeRange(4, 1)];
    self.numLab.attributedText = str;
    
    if (self.dataArr.count < 1) {
        if (self.deleteAllBlock) {
            self.deleteAllBlock();
        }
    }
}

+ (CGFloat)viewHeight{
    return 140+Height_SafeAreaBottom;
}

- (void)clickNextBtn{
    NSInteger maxNum = 2;
    if (self.videoType == LMEditVideoTypeVideoLattice) {
        maxNum = self.model.maxNum;
    }
    if (self.dataArr.count < maxNum) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"至少选择%zd个视频",maxNum]];
        return;
    }
    NSMutableArray *arr = [NSMutableArray new];
    for (int x = 0; x < self.dataArr.count; x++) {
        VESelectVideoModel *obj = self.dataArr[x];
        VESelectVideoModel *model = [[VESelectVideoModel alloc]init];
        model.showImage = obj.showImage;
        model.timeStr = obj.timeStr;
        model.videoUrl = obj.videoUrl;
        model.ifLoading = obj.ifLoading;
        model.fileSize = obj.fileSize;
        model.phData = obj.phData;
        model.num = obj.num;
        model.second = obj.second;
        model.videoSize = obj.videoSize;
        model.videoAss = obj.videoAss;
        model.showVideoSize = obj.showVideoSize;
        [arr addObject:model];
    }
    if (self.videoType == LMEditVideoTypeVideoSplice) {
        VEVideoPreviewViewController *videoVC = [[VEVideoPreviewViewController alloc]init];
        videoVC.dataArr = arr;

        //    [videoVC.dataArr addObjectsFromArray:self.dataArr];
        [currViewController().navigationController pushViewController:videoVC animated:YES];
    }else{
        VEMoreGridVideoController *vc = [[VEMoreGridVideoController alloc]init];
        vc.videoArr = arr;
        vc.model = self.model;
        vc.modelArr = self.modelArr;
        vc.selectModelIndex = self.selectModelIndex;
        [currViewController().navigationController pushViewController:vc animated:YES];
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
