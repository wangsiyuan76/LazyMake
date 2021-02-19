//
//  VEHomeClassSubViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeClassSubViewController.h"
#import "VEHomeContentEnumVideoCell.h"
#import "VETemplateDetailController.h"
#import "VEMediaListController.h"
#import "VEHomeApi.h"
#import "VEMainGuideView.h"
#import "XDTextBtnView.h"

@interface VEHomeClassSubViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionMainView;
@property (assign, nonatomic) BOOL canScroll;

@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray *arrListData;
@property (assign, nonatomic) BOOL hasLoadingMore;          //是否是正在加载更多
@property (assign, nonatomic) BOOL hasMore;          //是否还能加载更多
@property (assign, nonatomic) BOOL hasReturn;          //是否有进来过当前页面

@end

@implementation VEHomeClassSubViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    if (self.hasReturn && self.arrListData.count < 1) {
        [self firstLoadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canScroll = YES;
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.collectionMainView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollEndScrolld) name:VETABLETOP object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endScroll) name:VEHOMETOP object:nil];
    [self firstLoadData];
    
/*other ----- other ------ other ------- other*/
    [self createOtherTagView];
}

- (void)showGuideView{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RecommendDataLoad" object:nil];
}

#pragma mark - LoadData
- (void)loadAllMainData{
    if (self.toolModel) {       //ve_loadHomeHomeClassPage
        if (self.toolModel.classifyId.intValue == 0) {
            [self loadCycleData];
        }else{
            [self loadOtherData];
        }
    }
}

- (void)firstLoadData{
    self.page = 1;
    [self loadAllMainData];
}
- (void)moreLoadData{
    self.page ++;
    [self loadAllMainData];
}

/// 加载推荐数据
- (void)loadCycleData{
    if (self.page == 1) {
        [MBProgressHUD showMessage:@"加载中..."];
    }
    [[VEHomeApi sharedApi]ve_loadHomeHomeClassPage:self.page Completion:^(VEBaseModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        if (result.state.intValue == 1) {
            self.hasMore = result.hasMore;
            if (self.page == 1) {
                [self.arrListData removeAllObjects];
                self.arrListData = [NSMutableArray new];
                [self.arrListData addObjectsFromArray:result.resultArr];
                [self showGuideView];
            }else{
                //过滤重复数据
                NSArray *arr = [NSArray arrayWithArray:self.arrListData];
                for (VEHomeTemplateModel *subModel2 in result.resultArr) {
                    BOOL hasSave = YES;
                     for (VEHomeTemplateModel *subModel in arr) {
                         if ([subModel2.tID isEqualToString:subModel.tID]) {
                             hasSave = NO;
                             break;
                         }
                     }
                    if (hasSave == YES) {
                        [self.arrListData addObject:subModel2];
                    }
                }
            }
            [self.collectionMainView reloadData];
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

- (void)loadOtherData{
    if (self.page == 1) {
        [MBProgressHUD showMessage:@"加载中..."];
    }
    [[VEHomeApi sharedApi]ve_loadClassListDataPage:self.page classID:self.toolModel.classifyId Completion:^(VEBaseModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        self.hasReturn = YES;
        if (result.state.intValue == 1) {
            self.hasMore = result.hasMore;
            if (self.page == 1) {
                [self.arrListData removeAllObjects];
                self.arrListData = [NSMutableArray new];
                [self.arrListData addObjectsFromArray:result.resultArr];
            }else{
                //过滤重复数据
                NSArray *arr = [NSArray arrayWithArray:self.arrListData];
                for (VEHomeTemplateModel *subModel2 in result.resultArr) {
                    BOOL hasSave = YES;
                     for (VEHomeTemplateModel *subModel in arr) {
                         if ([subModel2.tID isEqualToString:subModel.tID]) {
                             hasSave = NO;
                             break;
                         }
                     }
                    if (hasSave == YES) {
                        [self.arrListData addObject:subModel2];
                    }
                }
            }
            if (self.page > 1) {
                self.hasLoadingMore = NO;
            }
              [self.collectionMainView reloadData];
        }else{
            [MBProgressHUD showError:result.errorMsg];
        }
    } failure:^(NSError * _Nonnull error) {
        self.hasReturn = YES;
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
    }];
}

- (void)loadTestArr{
    self.arrListData = [NSMutableArray new];
    for (int x = 0; x < 40; x++) {
        VEHomeTemplateModel *model = [VEHomeTemplateModel new];
        model.views = [NSString stringWithFormat:@"%d",x];
        [self.arrListData addObject:model];
    }
    [self.collectionMainView reloadData];
}

- (UICollectionView *)collectionMainView{
    if (!_collectionMainView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.minimumLineSpacing = 4;
        fl.minimumInteritemSpacing = 4;
        fl.itemSize = CGSizeMake((kScreenWidth - 14 - 14- 4)/2, [VEHomeContentEnumVideoCell cellHeight]);
        _collectionMainView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionMainView.frame = CGRectMake(14, 14, kScreenWidth - 28, kScreenHeight - 28 - 30 - Height_NavBar - Height_TabBar);
        _collectionMainView.delegate = self;
        _collectionMainView.dataSource = self;
        _collectionMainView.scrollEnabled = NO;
        _collectionMainView.showsVerticalScrollIndicator = NO;
        _collectionMainView.showsHorizontalScrollIndicator = NO;
        _collectionMainView.backgroundColor = [UIColor clearColor];
        [_collectionMainView registerClass:[VEHomeContentEnumVideoCell class] forCellWithReuseIdentifier:VEHomeContentEnumVideoCellStr];
    }
    return _collectionMainView;
}

- (void)scrollEndScrolld{
    self.collectionMainView.scrollEnabled = YES;
    self.canScroll = YES;
}

- (void)endScroll{
    [self.collectionMainView scrollToTop];
    self.collectionMainView.scrollEnabled = NO;
    self.canScroll = NO;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrListData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VEHomeContentEnumVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEHomeContentEnumVideoCellStr forIndexPath:indexPath];
    if (self.arrListData.count > indexPath.row) {
        cell.model = self.arrListData[indexPath.row];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{ 
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if (contentOffsetY < -10 && self.canScroll) {
        [[NSNotificationCenter defaultCenter]postNotificationName:TABLELEAVETOP object:nil];
        self.collectionMainView.scrollEnabled = NO;
        self.canScroll = NO;
    }
    
    //获取当前显示的cell,提前加载分页数据
    if (!self.hasLoadingMore && self.hasMore) {
        NSArray *array = [self.collectionMainView visibleCells];
        if (array.count > 0) {
            UICollectionViewCell *cell1 = array.firstObject;
            NSIndexPath *indexPath = [self.collectionMainView indexPathForCell:cell1];
            if (indexPath.row >= self.arrListData.count - LOAD_MORE_ADVANCE) {
                self.hasLoadingMore = YES;
                [self moreLoadData];
            }
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VETemplateDetailController *vc = [[VETemplateDetailController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    if (self.toolModel.classifyId.integerValue == 0) {
        [vc setAllParWithArr:self.arrListData selectIndex:indexPath.row page:self.page hasMore:self.hasMore laodUrl:@"custom/recommend_custom" otherDic:@{}];
    }else{
        [vc setAllParWithArr:self.arrListData selectIndex:indexPath.row page:self.page hasMore:self.hasMore laodUrl:@"custom/classify_list_info" otherDic:@{@"classify_id":self.toolModel.classifyId}];
    }
    [currViewController().navigationController pushViewController:vc animated:YES];
}

#pragma mark - Other
- (void)createOtherTagView{
    XDTextBtnView *textBtnView = [[XDTextBtnView alloc] initWithFrame:CGRectMake(0, 100.0, self.view.bounds.size.width, 300.0)];
    textBtnView.isSingle = YES;//单选
//        textBtnView.delegate = self;
    textBtnView.textFontSize = 14.0;
    textBtnView.borderColor = [UIColor purpleColor];
    textBtnView.btnHeight = 30.0;
    textBtnView.borderWidth = 1.2;
    textBtnView.textColor = [UIColor purpleColor];
    textBtnView.selectTextColor = [UIColor whiteColor];
    textBtnView.backgroundColor = [UIColor whiteColor];
    textBtnView.selectBackgroundColor = [UIColor purpleColor];
    textBtnView.cornerRadius = textBtnView.btnHeight * 0.5;
    textBtnView.textArr = @[@"书",@"玩具",@"车",@"房子",@"便利店", @"键盘", @"鼠标", @"显示器"];
    textBtnView.defultIndexArr = @[@"2",@"4"];
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
