//
//  VEUserWorksListViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/27.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserWorksListViewController.h"
#import "VEUserVideoPlayListController.h"
#import "VEUserWorksSubCell.h"
#import "VEUserApi.h"
#import "VENoneView.h"

@interface VEUserWorksListViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) BOOL hasLoadingMore;          //是否是正在加载更多
@property (assign, nonatomic) BOOL hasMore;          //是否还能加载更多
@property (strong, nonatomic) VENoneView *noneView;
@end

@implementation VEUserWorksListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的作品";
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.noneView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(Height_NavBar + 20, 14, 24, 14));
    }];
    [self firstLoadData];

    // Do any additional setup after loading the view.
}

- (VENoneView *)noneView{
    if (!_noneView) {
        _noneView = [[VENoneView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _noneView.backgroundColor = self.view.backgroundColor;
        [_noneView setLogoImage:@"vm_loading_empty" andTitle:@"暂时没有发布作品"];
        _noneView.hidden = YES;
    }
    return _noneView;
}

- (void)firstLoadData{
    self.page = 1;
    [self loadUserWorksList];
}

- (void)loadMoreData{
    self.page ++;
    [self loadUserWorksList];
}

- (void)loadUserWorksList{
    if (self.page == 1) {
        [MBProgressHUD showMessage:@"加载中..."];
    }
    [VEUserApi loadUserWorks:self.page Completion:^(VEBaseModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        if ([self.collectionView.refreshControl isRefreshing]) {
            [self.collectionView.refreshControl endRefreshing];
        }
        if (result.state.intValue == 1) {
            self.hasMore = result.hasMore;
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
                self.dataArr = [NSMutableArray new];
            }
            if (self.page > 1) {
                self.hasLoadingMore = NO;
            }
            [self.dataArr addObjectsFromArray:result.resultArr];
            [self showNoneView];
            [self.collectionView reloadData];
        }else{
            [MBProgressHUD showError:result.errorMsg];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [self showNoneView];
        [self.collectionView.refreshControl endRefreshing];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
    }];
}

- (void)showNoneView{
    if (self.dataArr.count > 0) {
        self.noneView.hidden = YES;
        self.collectionView.hidden = NO;
    }else{
        self.noneView.hidden = NO;
        self.collectionView.hidden = YES;
    }
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
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[VEUserWorksSubCell class] forCellWithReuseIdentifier:VEUserWorksSubCellStr];
        
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        refreshControl.tintColor = [UIColor grayColor];
        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
        [refreshControl addTarget:self action:@selector(firstLoadData) forControlEvents:UIControlEventValueChanged];
        _collectionView.refreshControl = refreshControl;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VEUserWorksSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEUserWorksSubCellStr forIndexPath:indexPath];
    [cell showViewIfHome:NO];
    if (self.dataArr.count > indexPath.row) {
        cell.model = self.dataArr[indexPath.row];
    }
    @weakify(self);
    cell.clickDeleBtnBlock = ^(NSInteger index) {
        @strongify(self);
        [self deleteModelWithIndex:index];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count > indexPath.row) {
        VEUserVideoPlayListController *playVC = [[VEUserVideoPlayListController alloc]init];
        playVC.selectIndex = indexPath.row;
        playVC.page = self.page;
        playVC.hasMore = self.hasMore;
        [self.navigationController pushViewController:playVC animated:YES];
        playVC.dataArr = [NSMutableArray arrayWithArray:self.dataArr];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取当前显示的cell,提前加载分页数据
    if (!self.hasLoadingMore && self.hasMore) {
        NSArray *array = [self.collectionView visibleCells]; //获取的cell不完成正确
        if (array.count > 0) {
            UICollectionViewCell *cell1 = array.firstObject;
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell1];
            if (indexPath.row >= self.dataArr.count - LOAD_MORE_ADVANCE) {
                self.hasLoadingMore = YES;
                [self loadMoreData];
            }
        }
    }
}

- (void)deleteModelWithIndex:(NSInteger)index{
    if (self.dataArr.count > index) {
        VEUserWorksListModel *model = self.dataArr[index];
        [MBProgressHUD showMessage:@"删除中..."];
         [VEUserApi deleteUserWorksID:model.wID Completion:^(VEBaseModel *  _Nonnull result) {
             [MBProgressHUD hideHUD];
             if (result.state.intValue == 1) {
                 [MBProgressHUD showSuccess:@"删除成功"];
                 [self.dataArr removeObjectAtIndex:index];
                 [self.collectionView reloadData];
                 [[NSNotificationCenter defaultCenter]postNotificationName:LoadUserWorks object:nil];
                 [self showNoneView];
             }else{
                 [MBProgressHUD showError:result.errorMsg];
             }
         } failure:^(NSError * _Nonnull error) {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:VENETERROR];
         }];
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
