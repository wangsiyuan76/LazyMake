//
//  VESearchListViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VESearchListViewController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "VEHomeContentEnumVideoCell.h"
#import "VEHomeApi.h"
#import "VETemplateDetailController.h"
#import "VEHomeSearchHeadView.h"
#import "VENoneView.h"
#define COLLECTION_MARGIN 14

@interface VESearchListViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *listData;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL hasLoadingMore;          //是否是正在加载更多
@property (assign, nonatomic) BOOL hasMore;                 //是否可以加载更多
@property (strong, nonatomic) VEHomeSearchHeadView *headView;
@property (strong, nonatomic) VENoneView *noneView;
@end

@implementation VESearchListViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (self.willBackBlock) {
        self.willBackBlock(self.historyArr);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.noneView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(RectNavAndStatusHight, COLLECTION_MARGIN, COLLECTION_MARGIN, COLLECTION_MARGIN));
    }];
    [self firstLoadData];
    // Do any additional setup after loading the view.
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewLeftAlignedLayout *fl = [[UICollectionViewLeftAlignedLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.minimumLineSpacing = 4;
        fl.minimumInteritemSpacing = 4;
        fl.headerReferenceSize = CGSizeMake(kScreenWidth - COLLECTION_MARGIN * 2, 20);
        fl.itemSize = CGSizeMake((kScreenWidth - (COLLECTION_MARGIN*2) - 4)/2, [VEHomeContentEnumVideoCell cellHeight]);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:[VEHomeContentEnumVideoCell class] forCellWithReuseIdentifier:VEHomeContentEnumVideoCellStr];
    }
    return _collectionView;
}

- (VENoneView *)noneView{
    if (!_noneView) {
        _noneView = [[VENoneView alloc]initWithFrame:CGRectMake(0, Height_NavBar, kScreenWidth, kScreenHeight-Height_NavBar)];
        _noneView.backgroundColor = self.view.backgroundColor;
        [_noneView setLogoImage:@"vm_loading_empty" andTitle:@"暂时没有相关作品"];
        _noneView.hidden = YES;
    }
    return _noneView;
}

- (VEHomeSearchHeadView *)headView{
    if (!_headView) {
        _headView = [[VEHomeSearchHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, Height_NavBar)];
        _headView.backgroundColor = [UIColor colorWithHexString:@"#15182A"];
        _headView.searchText.text = self.searchContent;
        @weakify(self);
        _headView.clickSearchBlock = ^(NSString * _Nonnull searchContent) {
            @strongify(self);
            if ([searchContent isNotBlank]) {
                if (searchContent.length > 0) {
                    self.searchContent = searchContent;
                    [self firstLoadData];
                    return;
                }
            }
            [MBProgressHUD showError:@"请输入搜索内容"];
        };
        
        _headView.clickBackBlock = ^{
            @strongify(self);
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
        };
    }
    return _headView;
}

- (void)showNoneView{
    if (self.listData.count > 0) {
        self.noneView.hidden = YES;
        self.collectionView.hidden = NO;
    }else{
        self.noneView.hidden = NO;
        self.collectionView.hidden = YES;
    }
}

#pragma mark - loadData

- (void)firstLoadData{
    if ([self.searchContent isNotBlank]) {
        self.page = 1;
        [self loadMainData];
        
        //判断数组中是否已包含数据
        for (NSString *subStr in self.historyArr) {
            if ([subStr isEqualToString:self.searchContent]) {
                [self.historyArr removeObject:subStr];
                break;
            }
        }
        [self.historyArr insertObject:self.searchContent atIndex:0];
    }
}

- (void)loadMoreData{
    self.page ++;
    [self loadMainData];
}

- (void)loadMainData{
    if (self.page == 1) {
          [MBProgressHUD showMessage:@"加载中..."];
    }
    [[VEHomeApi sharedApi]ve_loadSearchListPage:self.page searchWord:self.searchContent Completion:^(VEBaseModel *  _Nonnull result) {
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
        [self showNoneView];
    } failure:^(NSError * _Nonnull error) {
        [self showNoneView];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VEHomeContentEnumVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEHomeContentEnumVideoCellStr forIndexPath:indexPath];
    if (self.listData.count > indexPath.row) {
        cell.model = self.listData[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VETemplateDetailController *vc = [[VETemplateDetailController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc setAllParWithArr:self.listData selectIndex:indexPath.row page:self.page hasMore:self.hasMore laodUrl:@"search/index" otherDic:@{@"word":self.searchContent}];
    [currViewController().navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取当前显示的cell,提前加载分页数据
    if (!self.hasLoadingMore && self.listData.count > LOAD_MORE_ADVANCE && self.hasMore) {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
