//
//  VEHomeUserWorksController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/10.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeUserWorksController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "VEHomeContentEnumVideoCell.h"
#import "VEHomeApi.h"
#import "VETemplateDetailController.h"
#import "VEHomeUserWorksListHeadView.h"
#import "VEHomeUserWorkNavView.h"

#define COLLECTION_MARGIN 14

@interface VEHomeUserWorksController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *listData;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL hasLoadingMore;          //是否是正在加载更多
@property (assign, nonatomic) BOOL hasMore;                 //是否可以加载更多
@property (strong, nonatomic) UIImageView *headBackGroundImage;
@property (strong, nonatomic) VEHomeUserWorkNavView *navView;

@end

@implementation VEHomeUserWorksController

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
    [self.view addSubview:self.headBackGroundImage];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.navView];
    [self setAllViewLayout];
    
    if (self.model) {
        self.userID = self.model.userid;
    }
    [self firstLoadData];

    // Do any additional setup after loading the view.
}

- (void)setAllViewLayout{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(-Height_StatusBar, COLLECTION_MARGIN, COLLECTION_MARGIN, COLLECTION_MARGIN));
    }];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(Height_NavBar);
    }];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewLeftAlignedLayout *fl = [[UICollectionViewLeftAlignedLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.minimumLineSpacing = 4;
        fl.minimumInteritemSpacing = 4;
        fl.headerReferenceSize = CGSizeMake(kScreenWidth - COLLECTION_MARGIN * 2, [VEHomeUserWorksListHeadView viewHeight]);
        fl.itemSize = CGSizeMake((kScreenWidth - (COLLECTION_MARGIN*2) - 4)/2, [VEHomeContentEnumVideoCell cellHeight]);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[VEHomeContentEnumVideoCell class] forCellWithReuseIdentifier:VEHomeContentEnumVideoCellStr];
        [_collectionView registerClass:[VEHomeUserWorksListHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:VEHomeUserWorksListHeadViewStr];
    }
    return _collectionView;
}

- (VEHomeUserWorkNavView *)navView{
    if (!_navView) {
        _navView = [[VEHomeUserWorkNavView alloc]initWithFrame:CGRectZero];
        _navView.backgroundColor = MAIN_NAV_COLOR;
        _navView.titleLab.text = self.model.nickname;
        _navView.alpha = 0;
    }
    return _navView;
}

- (UIImageView *)headBackGroundImage{
    if (!_headBackGroundImage) {
        _headBackGroundImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_personalcenter_bg"]];
        _headBackGroundImage.frame = CGRectMake(0, 0, kScreenWidth, [VEHomeUserWorksListHeadView viewHeight]-10);
    }
    return _headBackGroundImage;
}

#pragma mark - loadData

- (void)firstLoadData{
    if ([self.userID isNotBlank]) {
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
    [[VEHomeApi sharedApi]ve_loadUserWorksListPage:self.page userID:self.userID Completion:^(VEBaseModel *  _Nonnull result) {
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

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        VEHomeUserWorksListHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:VEHomeUserWorksListHeadViewStr forIndexPath:indexPath];
        headerView.model = self.model;
        headerView.backgroundColor = [UIColor clearColor];
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
    VEHomeContentEnumVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEHomeContentEnumVideoCellStr forIndexPath:indexPath];
    if (self.listData.count > indexPath.row) {
        cell.model = self.listData[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VETemplateDetailController *vc = [[VETemplateDetailController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc setAllParWithArr:self.listData selectIndex:indexPath.row page:self.page hasMore:self.hasMore laodUrl:@"user/homepage_list" otherDic:@{@"friend_id":self.userID}];
    [currViewController().navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.navView.alpha = scrollView.contentOffset.y/Height_NavBar;
    self.headBackGroundImage.top = -(scrollView.contentOffset.y+Height_StatusBar);

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
