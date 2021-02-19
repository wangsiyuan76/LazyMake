//
//  VEHomeTeachListViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeTeachListViewController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "VEHomeApi.h"
#import "VEHomeToolTeachCell.h"
#import "VETeachDetailViewController.h"

@interface VEHomeTeachListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *guideArr;

@end

@implementation VEHomeTeachListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_NAV_COLOR;
    self.title = @"使用教程";
    [self loadTeachData];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)loadTeachData{
    [MBProgressHUD showMessage:@"加载中..."];
    [[VEHomeApi sharedApi]ve_loadTeachDataWithPageSize:@"30" Completion:^(VEBaseModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        if (result.state.intValue == 1) {
            self.guideArr = [NSMutableArray new];
            [self.guideArr addObjectsFromArray:result.resultArr];
            [self.collectionView reloadData];
        }else{
            [MBProgressHUD showError:result.errorMsg];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
    }];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewLeftAlignedLayout *fl = [[UICollectionViewLeftAlignedLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.minimumLineSpacing = 4;
        fl.minimumInteritemSpacing = 0;
        fl.headerReferenceSize = CGSizeMake(kScreenWidth, 15);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = MAIN_NAV_COLOR;
        [_collectionView registerClass:[VEHomeToolTeachCell class] forCellWithReuseIdentifier:VEHomeToolTeachCellStr];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.guideArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = (kScreenWidth-6)/3;
    if (indexPath.row % 3 == 0) {
        w += 6;
    }else if (indexPath.row % 3 == 1) {
        w -= 6;
    }
    return CGSizeMake(w, (kScreenWidth-36)/3);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VEHomeToolTeachCell *teaCell = [collectionView dequeueReusableCellWithReuseIdentifier:VEHomeToolTeachCellStr forIndexPath:indexPath];
    if (self.guideArr.count > indexPath.row) {
        [teaCell setModel:self.guideArr[indexPath.row] andIndex:indexPath.row lineNum:3];
    }
    return teaCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.guideArr.count > indexPath.row) {
        VETeachListModel *model = self.guideArr[indexPath.row];
        VETeachDetailViewController *vc = [[VETeachDetailViewController alloc]init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
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
