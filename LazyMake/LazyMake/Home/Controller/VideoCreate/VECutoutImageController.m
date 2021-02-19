//
//  VECutoutImageController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/1.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VECutoutImageController.h"
#import "VEHomeApi.h"
#import "VECutoutImageSelectView.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "VEHomeContentEnumVideoCell.h"
#import "VECutoutCollectionReusableView.h"
#import "VEVideoSucceedViewController.h"
#import "VEAlertView.h"
#import "VEVipMainViewController.h"
#import "VEHomeApi.h"
#import "VETemplateDetailController.h"

@interface VECutoutImageController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) VECutoutImageSelectView *selectView;
@property (assign, nonatomic) CGFloat lastRotation;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSString *baiduToken;
@property (assign, nonatomic) CGRect mainSlectSize;
@property (strong, nonatomic) UIImage *selectImage;

@property (strong, nonatomic) NSMutableArray *listData;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL hasLoadingMore;          //是否是正在加载更多
@property (assign, nonatomic) BOOL hasMore;                 //是否可以加载更多

@end

@implementation VECutoutImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    self.title = @"人像抠图";
    self.baiduToken = [[NSUserDefaults standardUserDefaults]objectForKey:BaiDuAiKeyToken];
    [self createHeadSelectSize];
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    [self firstLoadData];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 14, 0, 14));
    }];
    // Do any additional setup after loading the view.
}

- (void)createHeadSelectSize{
    CGSize mainSize = CGSizeMake(290, 475);
    CGFloat bili = mainSize.width/mainSize.height;
    CGFloat bili2 = 375/mainSize.width;
    CGFloat newW = kScreenWidth/bili2;
    if (newW > kScreenWidth - (14*2)) {
        newW = kScreenWidth - (14*2);
    }
    CGFloat newH = newW/bili;
    CGFloat leftS = (kScreenWidth-newW-(14*2))/2;
    self.mainSlectSize = CGRectMake(leftS, 15, newW, newH);
    
}

- (VECutoutImageSelectView *)selectView{
    if (!_selectView) {
        _selectView = [[VECutoutImageSelectView alloc]initWithFrame:self.mainSlectSize];
    }
    return _selectView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewLeftAlignedLayout *fl = [[UICollectionViewLeftAlignedLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.minimumLineSpacing = 3;
        fl.minimumInteritemSpacing = 3;
        fl.headerReferenceSize = CGSizeMake(kScreenWidth, [VECutoutCollectionReusableView mainHeight]);
        fl.footerReferenceSize = CGSizeMake(kScreenWidth,20);
        fl.itemSize = CGSizeMake((kScreenWidth - (14*2) - 6)/3, [VEHomeContentEnumVideoCell cellHeightSmall]);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[VEHomeContentEnumVideoCell class] forCellWithReuseIdentifier:VEHomeContentEnumVideoCellStr];
        [_collectionView registerClass:[VECutoutCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    }
    return _collectionView;
}

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
    [[VEHomeApi sharedApi]ve_loadTagListPage:self.page tagname:@"抠图" Completion:^(VEBaseModel *  _Nonnull result) {
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

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        VECutoutCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        @weakify(self);
        headerView.selectView.changeSelectImageBlock = ^(UIImage * _Nonnull selectImage) {
            @strongify(self);
            self.selectImage = selectImage;
        };
        
        headerView.clickMakeBtnBlock = ^{
            @strongify(self);
            [self makeDoon];
        };
        return headerView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerView.backgroundColor = MAIN_NAV_COLOR;
        if (indexPath.section == 2) {
            footerView.backgroundColor = [UIColor colorWithHexString:@"0B0E22"];
        }
        return footerView;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VEHomeContentEnumVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEHomeContentEnumVideoCellStr forIndexPath:indexPath];
    [cell changeSmallStyle];
    if (self.listData.count > indexPath.row) {
        cell.model = self.listData[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VETemplateDetailController *vc = [[VETemplateDetailController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc setAllParWithArr:self.listData selectIndex:indexPath.row page:self.page hasMore:self.hasMore laodUrl:@"tags/custom_tag_list" otherDic:@{@"tagname":@"抠图"}];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取当前显示的cell,提前加载分页数据
    if (!self.hasLoadingMore && self.listData.count > LOAD_MORE_ADVANCE && self.hasMore) {
        NSArray *array = [self.collectionView visibleCells]; //获取的cell不完成正确
        if (array.count > 0) {
            UICollectionViewCell *cell1 = array.lastObject;
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell1];
            if (indexPath.row >= self.listData.count - 9) {
                self.hasLoadingMore = YES;
                [self loadMoreData];
            }
        }
    }
}

//普通会员一天只能使用一次，判断今天是否使用过
- (BOOL)hasPlay{
    if ([LMUserManager sharedManger].userInfo.vipState.intValue != 1) {
        NSDate *date = [NSDate date];
        NSString *str = [NSString stringWithFormat:@"%zd年%zd月%zd日",date.year,date.month,date.day];
        NSString *oldStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LMCutoutImageDate"];
        if ([oldStr isEqualToString:str]) {
            [self showVipAlert];
            return NO;
        }
        [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"LMCutoutImageDate"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return YES;
    }
    return YES;
}

- (void)showVipAlert{
    VEAlertView *ale = [[VEAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [ale setContentStr: @"开通会员，可无限制使用!"];
    [ale.sureBtn setTitle:@"去开通" forState:UIControlStateNormal];
    [win addSubview:ale];
    @weakify(self);
    ale.clickSubBtnBlock = ^(NSInteger btnTag) {
        @strongify(self);
        if (btnTag == 1) {
            VEVipMainViewController *vc = [VEVipMainViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.comeType = VipMouthType_AEVideo;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
}

//百度ai，人像抠图
- (void)makeDoon{
    if (!self.selectImage) {
        [MBProgressHUD showError:@"请添加一张图片"];
        return;
    }
    if (![self hasPlay]) {
        return;
    }
    [VETool baiduCutoutImageWithImage:self.selectImage loadingStr:nil Completion:^(UIImage * _Nonnull image) {
        VEVideoSucceedViewController *vc = [[VEVideoSucceedViewController alloc]init];
        vc.showImage = image;
        vc.videoSize = image.size;
        vc.ifImage = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSString * _Nonnull errorStr) {
         [MBProgressHUD showError:errorStr];
    }];
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
