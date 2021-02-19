//
//  VEHomeTagListViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/10.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeTagListViewController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "VEHomeContentEnumVideoCell.h"
#import "VEHomeApi.h"
#import "VETemplateDetailController.h"

#define COLLECTION_MARGIN 14

@interface VEHomeTagListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *listData;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL hasLoadingMore;          //是否是正在加载更多
@property (assign, nonatomic) BOOL hasMore;                 //是否可以加载更多

@end

@implementation VEHomeTagListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(RectNavAndStatusHight, COLLECTION_MARGIN, COLLECTION_MARGIN, COLLECTION_MARGIN));
    }];
    [self firstLoadData];
    self.title = self.tagName;
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

#pragma mark - loadData

- (void)firstLoadData{
    if ([self.tagName isNotBlank]) {
        self.page = 1;
        [self loadMainData];
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
    [[VEHomeApi sharedApi]ve_loadTagListPage:self.page tagname:self.tagName Completion:^(VEBaseModel *  _Nonnull result) {
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
    [vc setAllParWithArr:self.listData selectIndex:indexPath.row page:self.page hasMore:self.hasMore laodUrl:@"tags/custom_tag_list" otherDic:@{@"tagname":self.tagName}];
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
