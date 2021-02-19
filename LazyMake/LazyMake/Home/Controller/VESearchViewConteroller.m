//
//  VESearchViewConteroller.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VESearchViewConteroller.h"
#import "JYLabelsSelect.h"
#import "VEHomeContentEnumVideoCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "VESearchHistoryCollectionCell.h"
#import "VEHomeSearchTitleReusableView.h"
#import "VESearchListViewController.h"
#import "VEHomeApi.h"
#import "VETemplateDetailController.h"
#import "VEHomeSearchHeadView.h"

#define COLLECTION_MARGIN 14

@interface VESearchViewConteroller () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) VESearchHistoryCollectionCell *hicCell;

@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) NSMutableArray *historyData;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL hasLoadingMore;          //是否是正在加载更多
@property (assign, nonatomic) BOOL hasMore;          //是否还能加载更多
@property (strong, nonatomic) VEHomeSearchHeadView *headView;

@end

@implementation VESearchViewConteroller

- (void)dealloc{
    LMLog(@"VESearchViewConteroller 页面释放");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    //self.navigationController.navigationBar.topItem.title = @"";
//    [self createNavSearchView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.headView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(RectNavAndStatusHight, COLLECTION_MARGIN, COLLECTION_MARGIN, COLLECTION_MARGIN));
    }];
    [self firstLoadData];
    
    NSArray *hisArr = [[NSUserDefaults standardUserDefaults]objectForKey:SEARCHHISTORYKEY];
    self.historyData = [NSMutableArray arrayWithArray:hisArr];
    if (self.historyData.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hicCell createCellHeightWithTagArr:self.historyData];
            [self.collectionView reloadData];
        });
    }
    
    // Do any additional setup after loading the view.
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewLeftAlignedLayout *fl = [[UICollectionViewLeftAlignedLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.minimumLineSpacing = 4;
        fl.minimumInteritemSpacing = 4;
//        fl.headerReferenceSize = CGSizeMake(kScreenWidth - COLLECTION_MARGIN * 2, 60);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_collectionView registerClass:[VEHomeContentEnumVideoCell class] forCellWithReuseIdentifier:VEHomeContentEnumVideoCellStr];
        [_collectionView registerClass:[VESearchHistoryCollectionCell class] forCellWithReuseIdentifier:VESearchHistoryCollectionCellStr];
        [_collectionView registerClass:[VEHomeSearchTitleReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:VEHomeSearchTitleReusableViewStr];
    }
    return _collectionView;
}

- (VEHomeSearchHeadView *)headView{
    if (!_headView) {
        _headView = [[VEHomeSearchHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Height_NavBar)];
        _headView.backgroundColor = [UIColor colorWithHexString:@"#15182A"];
        @weakify(self);
        _headView.clickSearchBlock = ^(NSString * _Nonnull searchContent) {
            @strongify(self);
            if ([searchContent isNotBlank]) {
                if (searchContent.length > 0) {
                    [self searchContent:searchContent];
                    return;
                }
            }
            [MBProgressHUD showError:@"请输入搜索内容"];
        };
    }
    return _headView;
}

#pragma mark - LoadData
- (void)firstLoadData{
    self.page = 1;
    [self loadMainData];
}
- (void)loadMoreData{
    self.page ++;
    [self loadMainData];
}

- (void)loadMainData{
    if (self.page == 1) {
           [MBProgressHUD showMessage:@"加载中..."];
       }
    [[VEHomeApi sharedApi]ve_loadHotSearchListPage:self.page Completion:^(VEBaseModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        if (result.state.intValue == 1) {
            self.hasMore = result.hasMore;
            if (self.page == 1) {
                [self.listData removeAllObjects];
                self.listData = [NSMutableArray new];
            }
            [self.listData addObjectsFromArray:result.resultArr];
            [self.collectionView reloadData];
            if (self.page > 1) {
                self.hasLoadingMore = NO;
            }
        }else{
            [MBProgressHUD showError:result.errorMsg];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.listData.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.historyData.count < 1) {
            return  CGSizeMake(kScreenWidth - COLLECTION_MARGIN * 2, 2);;
        }
        return CGSizeMake(kScreenWidth - COLLECTION_MARGIN * 2, self.hicCell.cellHeight > 20 ? self.hicCell.cellHeight : 20);
    }
    return CGSizeMake((kScreenWidth - (COLLECTION_MARGIN*2) - 4)/2, [VEHomeContentEnumVideoCell cellHeight]);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat h = CGFLOAT_MIN;
    if (self.historyData.count > 0 || section == 1) {
        h = 60;
    }
    return CGSizeMake(kScreenWidth - COLLECTION_MARGIN * 2, h);
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        VEHomeSearchTitleReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:VEHomeSearchTitleReusableViewStr forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor clearColor];
        if (indexPath.section == 0) {
            if (self.historyData.count > 0) {
                headerView.titleLab.text = @"最近搜索";
                headerView.clearBtn.hidden = NO;
            }else{
                headerView.titleLab.text = @"";
                headerView.clearBtn.hidden = YES;
            }
       
        }else{
            headerView.titleLab.text = @"热门模板";
            headerView.clearBtn.hidden = YES;
        }
        @weakify(self);
        headerView.cleanBtnBlock = ^{
            @strongify(self);
            [self.historyData removeAllObjects];
            self.historyData = [NSMutableArray new];
            [self.hicCell createCellHeightWithTagArr:self.historyData];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            [[NSUserDefaults standardUserDefaults]setObject:@[] forKey:SEARCHHISTORYKEY];
            [[NSUserDefaults standardUserDefaults]synchronize];
        };
        return headerView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerView.backgroundColor = MAIN_NAV_COLOR;
        if (indexPath.section == 1) {
            footerView.backgroundColor = [UIColor clearColor];
        }
        return footerView;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.hicCell = [collectionView dequeueReusableCellWithReuseIdentifier:VESearchHistoryCollectionCellStr forIndexPath:indexPath];
        @weakify(self);
        self.hicCell.labelSelect.selected = ^(id selectedObject, NSInteger index) {
            @strongify(self);
            UILabel *lab = selectedObject;
            [self searchContent:lab.text];
          };
        return self.hicCell;
    }else{
        VEHomeContentEnumVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEHomeContentEnumVideoCellStr forIndexPath:indexPath];
        if (self.listData.count > indexPath.row) {
            cell.model = self.listData[indexPath.row];
        }
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取当前显示的cell,提前加载分页数据
    if (!self.hasLoadingMore && self.hasMore) {
        NSArray *array = [self.collectionView visibleCells]; //获取的cell不完成正确
        if (array.count > 0) {
            UICollectionViewCell *cell1 = array.firstObject;
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell1];
            if (indexPath.row >= self.listData.count - LOAD_MORE_ADVANCE) {
                self.hasLoadingMore = YES;
                [self loadMoreData];
            }
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        VETemplateDetailController *vc = [[VETemplateDetailController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [vc setAllParWithArr:self.listData selectIndex:indexPath.row page:self.page hasMore:self.hasMore laodUrl:@"search/hot_custom" otherDic:@{}];
        [currViewController().navigationController pushViewController:vc animated:YES];
    }
}

- (void)searchContent:(NSString *)content{
    VESearchListViewController *listVC = [VESearchListViewController new];
    listVC.searchContent = content;
    listVC.historyArr = self.historyData;
    [self.navigationController pushViewController:listVC animated:NO];
    
    @weakify(self);
    listVC.willBackBlock = ^(NSMutableArray * _Nonnull hisArr) {
        @strongify(self);
        self.historyData = hisArr;
        [self.hicCell createCellHeightWithTagArr:self.historyData];
        [self.collectionView reloadData];
        
        [[NSUserDefaults standardUserDefaults]setObject:[NSArray arrayWithArray:hisArr] forKey:SEARCHHISTORYKEY];
        [[NSUserDefaults standardUserDefaults]synchronize];
    };
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
