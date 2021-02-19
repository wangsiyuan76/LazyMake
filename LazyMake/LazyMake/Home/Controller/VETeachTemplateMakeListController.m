//
//  VETeachTemplateMakeListController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VETeachTemplateMakeListController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "VEHomeContentEnumVideoCell.h"
#import "VEHomeApi.h"
#import "VETemplateDetailController.h"
#import "MJRefresh.h"
#import "VENoneView.h"

#define COLLECTION_MARGIN 14

@interface VETeachTemplateMakeListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *listData;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL hasLoadingMore;          //是否是正在加载更多
@property (assign, nonatomic) BOOL hasMore;                 //是否可以加载更多
@property (strong, nonatomic) VENoneView *noneView;

@end

@implementation VETeachTemplateMakeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    self.title = @"模板制作";
    [self.view addSubview:self.collectionView];
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
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(firstLoadData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        _collectionView.mj_header = header;
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
    [[VEHomeApi sharedApi]ve_loadHomeHomeClassPage:self.page Completion:^(VEBaseModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        [self.collectionView.mj_header endRefreshing];
        if (result.state.intValue == 1) {
            self.hasMore = result.hasMore;
            if (self.page == 1) {
                [self.listData removeAllObjects];
                self.listData = [NSMutableArray new];
                [self.listData addObjectsFromArray:result.resultArr];
            }else{
                //过滤重复数据
                NSArray *arr = [NSArray arrayWithArray:self.listData];
                for (VEHomeTemplateModel *subModel2 in result.resultArr) {
                    BOOL hasSave = YES;
                     for (VEHomeTemplateModel *subModel in arr) {
                         if ([subModel2.tID isEqualToString:subModel.tID]) {
                             hasSave = NO;
                             break;
                         }
                     }
                    if (hasSave == YES) {
                        [self.listData addObject:subModel2];
                    }
                }
            }
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
        [self.collectionView.mj_header endRefreshing];
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
    [vc setAllParWithArr:self.listData selectIndex:indexPath.row page:self.page hasMore:self.hasMore laodUrl:@"custom/recommend_custom" otherDic:@{}];
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
