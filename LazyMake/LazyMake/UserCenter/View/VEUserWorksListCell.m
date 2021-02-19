//
//  VEUserWorksListCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserWorksListCell.h"
#import "VEUserWorksSubCell.h"
#import "VEUserVideoPlayListController.h"

@interface VEUserWorksListCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIView *segmentationView;                 //底部的分割view
@end

@implementation VEUserWorksListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.segmentationView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(4, 14, 24, 14));
        }];
        [self.segmentationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(10);
        }];
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.minimumLineSpacing = 4;
        fl.minimumInteritemSpacing = 4;
        fl.itemSize = CGSizeMake((kScreenWidth - 14 - 14- 8)/3, [VEUserWorksSubCell cellHeight]);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[VEUserWorksSubCell class] forCellWithReuseIdentifier:VEUserWorksSubCellStr];
    }
    return _collectionView;
}

- (UIView *)segmentationView{
    if (!_segmentationView) {
        _segmentationView = [UIView new];
        _segmentationView.backgroundColor = MAIN_NAV_COLOR;
    }
    return _segmentationView;
}

+ (CGFloat)cellHeight{
    return [VEUserWorksSubCell cellHeight] + 30;
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.worksList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VEUserWorksSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEUserWorksSubCellStr forIndexPath:indexPath];
    [cell showViewIfHome:YES];
    if (self.worksList.count > indexPath.row) {
        cell.model = self.worksList[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.worksList.count > indexPath.row) {
        VEUserVideoPlayListController *playVC = [[VEUserVideoPlayListController alloc]init];
        playVC.selectIndex = indexPath.row;
        playVC.hidesBottomBarWhenPushed = YES;
        playVC.page = 1;
        playVC.hasMore = NO;
        playVC.dataArr = [NSMutableArray arrayWithArray:self.worksList];
        [currViewController().navigationController pushViewController:playVC animated:YES];
    }
}


- (void)setWorksList:(NSArray *)worksList{
    _worksList = worksList;
    [self.collectionView reloadData];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
