//
//  VESelectMoreGridSelectController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/5.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VESelectMoreGridSelectController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "VESelectVideoController.h"
#import "VEMoreGridVideoModel.h"

static NSString *LMSelectMoreGridSelectCellStr = @"LMSelectMoreGridSelectCell";

@interface LMSelectMoreGridSelectCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UILabel *mainLab;

@end

@implementation LMSelectMoreGridSelectCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.mainImage];
        [self.contentView addSubview:self.mainLab];
        
        @weakify(self);
        [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(102);
        }];
        
        [self.mainLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.mainImage.mas_bottom).mas_offset(12);
        }];
    }

    return self;
}

- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [UIImageView new];
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
        _mainImage.layer.masksToBounds = YES;
        _mainImage.layer.cornerRadius = 5;
    }
    return _mainImage;
}

- (UILabel *)mainLab{
    if (!_mainLab) {
        _mainLab = [UILabel new];
        _mainLab.font = [UIFont systemFontOfSize:14];
        _mainLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _mainLab.textAlignment = NSTextAlignmentCenter;
    }
    return _mainLab;
}

@end



@interface VESelectMoreGridSelectController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@end

@implementation VESelectMoreGridSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    self.title = @"选择模板";
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 14, 0, 14));
    }];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)loadData{
    self.dataArr = [NSMutableArray new];
    NSArray *imageArr = @[@"vm_detail_2",@"vm_detail_2_",@"vm_detail_3",@"vm_detail_4"];
    NSArray *titleArr = @[@"上下分屏",@"左右分屏",@"3分屏",@"4分屏"];
    for (int x = 0; x < imageArr.count; x++) {
        VEMoreGridVideoModel *dic = [VEMoreGridVideoModel new];
        dic.imageName = imageArr[x];
        dic.titleStr = titleArr[x];
        dic.selectId = [NSString stringWithFormat:@"%d",x];
        if (x == 0 || x == 1) {
            dic.maxNum = 2;
        }else if(x == 2){
            dic.maxNum = 3;
        }else if(x == 3){
            dic.maxNum = 4;
        }

        [self.dataArr addObject:dic];
    }
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewLeftAlignedLayout *fl = [[UICollectionViewLeftAlignedLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.minimumLineSpacing = 10;
        fl.minimumInteritemSpacing = 10;
        fl.headerReferenceSize = CGSizeMake(kScreenWidth, 20);
        fl.itemSize = CGSizeMake((kScreenWidth - (14*2) - 30)/4,130);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = self.view.backgroundColor;
        [_collectionView registerClass:[LMSelectMoreGridSelectCell class] forCellWithReuseIdentifier:LMSelectMoreGridSelectCellStr];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LMSelectMoreGridSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LMSelectMoreGridSelectCellStr forIndexPath:indexPath];
    if (self.dataArr.count > indexPath.row) {
        VEMoreGridVideoModel *dic = self.dataArr[indexPath.row];
        [cell.mainImage setImage:[UIImage imageNamed:dic.imageName]];
        cell.mainLab.text = dic.titleStr;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count > indexPath.row) {
        VEMoreGridVideoModel *dic = self.dataArr[indexPath.row];
        VESelectVideoController *selectVC = [VESelectVideoController new];
        selectVC.moreGridModel = dic;
        selectVC.modelArr = self.dataArr;
        selectVC.selectModelIndex = indexPath.row;
        selectVC.videoType = LMEditVideoTypeVideoLattice;
        [self.navigationController pushViewController:selectVC animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
