//
//  VEHomeHeadEffectCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeHeadEffectCell.h"
#import "VEHomeHeadEffectEnumCell.h"
#import "VEHomeHeadEffectModel.h"
#import "VESelectVideoController.h"

#define CELLHEIGHT 210

@interface VEHomeHeadEffectCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation VEHomeHeadEffectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(14, 14, 14, 14));
        }];
        [self createData];
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        fl.minimumLineSpacing = 10;
        fl.minimumInteritemSpacing = 10;
        fl.itemSize = CGSizeMake((kScreenWidth - 14 - 14- 10)/2, (CELLHEIGHT - 14 - 14 - 10)/2);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[VEHomeHeadEffectEnumCell class] forCellWithReuseIdentifier:VEHomeHeadEffectEnumCellStr];
    }
    return _collectionView;
}

- (void)createData{
    self.dataArr = [NSMutableArray new];
    NSArray *titleArr = @[@"视频拼接",@"去除水印",@"更换音乐",@"视频加封面"];
    NSArray *subTitleArr = @[@"支持多个视频合成",@"无痕去除视频水印",@"一键更换视频配乐",@"支持片头加封面"];
    NSArray *iconArr = @[@"vm_homepage_tailoring",@"vm_homepage_watermark_1",@"vm_homepage_music_1",@"vm_homepage_cover-1"];
    NSArray *mainImageArr = @[@"vm_homepage_video",@"vm_homepage_watermark",@"vm_homepage_music",@"vm_homepage_cover"];
    for (int x = 0; x < titleArr.count; x++) {
        VEHomeHeadEffectModel *model = [VEHomeHeadEffectModel new];
        model.title = titleArr[x];
        model.subTitle = subTitleArr[x];
        model.iconStr = iconArr[x];
        model.mainBackgroundStr = mainImageArr[x];
        [self.dataArr addObject:model];
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VEHomeHeadEffectEnumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEHomeHeadEffectEnumCellStr forIndexPath:indexPath];
    if (self.dataArr.count > indexPath.row) {
        cell.model = self.dataArr[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LMEditVideoType type = LMEditVideoTypeCrop;
    if (indexPath.row == 0) {
        type = LMEditVideoTypeVideoSplice;
    }else if (indexPath.row == 1) {
        type = LMEditVideoTypeWatermark;
    }else if (indexPath.row == 2){
        type = LMEditVideoTypeChangeAudio;
    }else if (indexPath.row == 3){
        type = LMEditVideoTypeCover;
    }
    VESelectVideoController *vc = [[VESelectVideoController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.videoType = type;
    [currViewController().navigationController pushViewController:vc animated:YES];
}

+ (CGFloat)cellHeight{
    return CELLHEIGHT;
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
