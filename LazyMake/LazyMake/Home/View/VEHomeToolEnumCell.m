//
//  VEHomeToolEnumCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeToolEnumCell.h"
#import "VEHomeToolListViewController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "VEHomeToolSubCell.h"
#import "VESelectVideoController.h"
#import "VEVideoLanSongViewController.h"
#import "VEHomeApi.h"

#define CELLHEIGHT 75
@interface VEHomeToolEnumCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation VEHomeToolEnumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(-6, 0, 0, 0));
        }];
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewLeftAlignedLayout *fl = [[UICollectionViewLeftAlignedLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.minimumLineSpacing = 0;
        fl.minimumInteritemSpacing = 0;
        fl.itemSize = CGSizeMake((kScreenWidth - 0)/5, CELLHEIGHT-10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[VEHomeToolSubCell class] forCellWithReuseIdentifier:VEHomeToolSubCellStr];

    }
    return _collectionView;
}

- (void)loadData{
    self.dataArr = [NSMutableArray new];
    NSArray *titleArr = @[@"区域剪裁",@"提取音频",@"镜像视频",@"视频倒放",@"更多工具"];
    NSArray *imageArr = @[@"vm_home_tailoring",@"vm_home_audio",@"vm_home_mirror",@"vm_home_back",@"vm_home_tool_more"];
    for (int x = 0; x < titleArr.count; x++) {
        VEHomeToolModel *model = [VEHomeToolModel new];
        model.imageName = imageArr[x];
        model.name = titleArr[x];
        [self.dataArr addObject:model];
    }
    [self.collectionView reloadData];
}

- (void)setToolList:(NSArray *)toolList{
    if (toolList.count > 0) {
        _toolList = toolList;
        self.dataArr = [NSMutableArray arrayWithArray:toolList];
        [self.collectionView reloadData];
    }else{
        [self loadData];
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
    VEHomeToolSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEHomeToolSubCellStr forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    if (self.dataArr.count > indexPath.row) {
        cell.model = self.dataArr[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count > indexPath.row) {
        VEHomeToolModel *model = self.dataArr[indexPath.row];
        [self addClickStatistics:model.hitsid];
        if (model.contentid.intValue == 0) {
            [self clickEnumBtn];
        }else {
            [self clickToolCellWithIndex:model.contentid.intValue];
        }
    }
}

+(CGFloat)cellHeight{
    return CELLHEIGHT;
}

- (void)clickEnumBtn{
    VEHomeToolListViewController *vc = [[VEHomeToolListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [currViewController().navigationController pushViewController:vc animated:YES];
}

- (void)clickToolCellWithIndex:(NSInteger)index{
    LMEditVideoType type = LMEditVideoTypeCrop;
    if (index == 4) {
        type = LMEditVideoTypeChangeAudio;
    }else if (index == 6) {
        type = LMEditVideoTypeCover;
    }else if (index == 7){
        type = LMEditVideoTypeCrop;
    }else if (index == 8){
        type = LMEditVideoTypeOutAudio;
    }else if (index == 9){
        type = LMEditVideoTypeMirror;
    }else if (index == 10){
        type = LMEditVideoTypeGIF;
    }else if (index == 11){
        type = LMEditVideoTypeWatermark;
    }else if (index == 12){
        type = LMEditVideoTypeSpeed;
    }else if (index == 13){
        type = LMEditVideoTypeFilter;
    }else if (index == 15){
        type = LMEditVideoTypeBack;
    }else if (index == 16){
//        type = LMEditVideoTypeBack;
    }
    VESelectVideoController *vc = [[VESelectVideoController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.videoType = type;
    [currViewController().navigationController pushViewController:vc animated:YES];
}

/// 添加点击统计
- (void)addClickStatistics:(NSString *)hid{
    [[VEHomeApi sharedApi]ve_loadHomeToolStatistics:hid Completion:^(id  _Nonnull result) {
    } failure:^(NSError * _Nonnull error) {
    }];
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
