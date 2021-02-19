//
//  VEHomeMainController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeMainController.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "VEHomeClassSubViewController.h"
#import "VEHomeHeadFeaturesView.h"
#import "VEHomePopupView.h"
#import "VEHomeApi.h"
#import "VEHomeToolModel.h"
#import "VESearchViewConteroller.h"
#import "VEVipMainViewController.h"
#import "VEWebTermsViewController.h"
#import "VESelectVideoController.h"
#import "VEUserApi.h"
#import "VEMainGuideView.h"

#define HEAD_HEIGHT 300

@interface VEHomeMainController () <UIScrollViewDelegate,TYTabPagerBarDelegate,TYTabPagerBarDataSource,TYPagerControllerDelegate,TYPagerControllerDataSource>

@property (nonatomic, strong) NSMutableArray *classArr;                 //分类的数组
@property (strong, nonatomic) UIScrollView *scrollView;                 //scrollView
@property (strong, nonatomic) VEHomeHeadFeaturesView *headHomeView;         //顶部的菜单数据
@property (nonatomic, weak) TYTabPagerBar *homeTabBar;                      //标签分类的tabBar
@property (nonatomic, weak) TYPagerController *homePagerController;         //底部的主数据
@property (nonatomic, assign) BOOL canScroller;                         //scrollView是否可以滚动的标志
@property (nonatomic, assign) BOOL hasChangeSelect;

@property (nonatomic, assign) BOOL ifClickSureBtn;
@property (nonatomic, assign) BOOL ifRecommendData;
@end

@implementation VEHomeMainController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.hasChangeSelect) {
        self.tabBarController.selectedIndex = 1;
        self.hasChangeSelect = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scrollView];
    [VETool deleteAllLansonBoxDataIfAll:YES];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:FindVideoPlayKey];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:AETemplateVideoPlayKey];
    self.canScroller = YES;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self createHomeNavStyle];
    [self loadNetTimeData];
    [self addHomeHeadView];
    [self addTabPageBar];
    [self addPagerController];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollDidBegin) name:TABLELEAVETOP object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushDataSucceed) name:PushDataSucceed object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popoutViewSureBtn) name:@"ClickPopoutViewSureBtn" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recommendDataLoad) name:@"RecommendDataLoad" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadNetTimeData) name:USERLOGINSUCCEED object:nil];
    
    /*otherotherotherotherotherotherotherother*/
    [self addOtherBtnLaLa];
    [self createMoreBlock];
    [self showOtherArrWithData:@""];
}

- (void)popoutViewSureBtn{
    self.ifClickSureBtn = YES;
    if (self.ifRecommendData) {
         [self showGuideView];
    }
}

- (void)recommendDataLoad{
    self.ifRecommendData = YES;
    NSNumber *num = [[NSUserDefaults standardUserDefaults]objectForKey:@"AGREEPROTOCOL"];
    if (self.ifClickSureBtn || num.boolValue == YES) {
        [self showGuideView];
    }
}

//添加新手引导
- (void)showGuideView{
    NSNumber *num = [[NSUserDefaults standardUserDefaults]objectForKey:@"HOMEGUIDEVIEW"];
    if (num.boolValue == NO) {
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        VEMainGuideView *guideV = [[VEMainGuideView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [guideV.subImage setImage:[UIImage imageNamed:@"vm_home1_prompt"]];
        guideV.subImage.frame = CGRectMake((kScreenWidth - 240)/2, Height_NavBar+300, 240, 82);
        [win addSubview:guideV];
        [guideV showAll];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"HOMEGUIDEVIEW"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

/// 创建首次加载时的弹框
- (void)createPopupView{
    [VEHomePopupView showInViewWithSuperView:self];
}

- (void)pushDataSucceed{
    self.hasChangeSelect = YES;
}

#pragma mark - 导航栏样式
/**
 自定义导航栏按钮样式
 */
- (void)createHomeNavStyle{
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    UIButton *lab = [UIButton new];
    [lab setTitle:@"首页" forState:UIControlStateNormal];
    [lab setTitleColor:[UIColor colorWithHexString:@"1DABFD"] forState:UIControlStateNormal];
    lab.titleLabel.font =  [UIFont systemFontOfSize:20];
    [lab addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:lab];
    self.navigationItem.leftBarButtonItem = barBtn;
    
    UIButton *rightBtn = [UIButton new];
    [rightBtn setImage:[UIImage imageNamed:@"vm_homepage_vip"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    UIButton *searchBtn = [UIButton new];
    [searchBtn setImage:[UIImage imageNamed:@"vm_homepage_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchBtnBar = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItems = @[rightBtnBar,searchBtnBar];
}

- (void)leftBtnClick{
    [[NSNotificationCenter defaultCenter]postNotificationName:VEHOMETOP object:nil];
    [self.scrollView setContentOffset:CGPointMake(0, -Height_NavBar) animated:YES];
    self.scrollView.scrollEnabled = YES;
    self.canScroller = YES;
}

- (void)rightBtnClick{
    VEVipMainViewController *vc = [VEVipMainViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchBtnClick{
    VESearchViewConteroller *vc = [[VESearchViewConteroller alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - LoadData
/// 获取服务端的时间
- (void)loadNetTimeData{
    [MBProgressHUD showMessage:@"加载中..."];
    [[VEHomeApi sharedApi]ve_updateNetTimeCompletionon:^(VEBaseModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        if (result.state.integerValue == 1) {
            //获取本地的时间戳
            NSString *timeStr = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSInteger timeInt = [VETool timeSwitchTimestamp:timeStr andFormatter:@"yyyy-MM-dd HH:mm:ss"];
            NSInteger netTime = result.msg.integerValue;
            //计算两个时间戳的时间差
            int timeInterval = [VETool compareTwoTime:timeInt time2:netTime];
            if ((abs(timeInterval)) >= 5) {
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:timeInterval] forKey:TIME_INTERVAL];
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:0] forKey:TIME_INTERVAL];

            }
            [self loadHomeToolListData];
            [self loadHomeClassificationData];
            [self loadQQData];
        }
        [self createPopupView];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
        [self performSelector:@selector(loadNetTimeData) withObject:nil afterDelay:3.0];
    }];
}

/// 获取中间工具列表数据
- (void)loadHomeToolListData{
    [[VEHomeApi sharedApi]ve_loadHomeToolListCompletion:^(LMHomeToolListModel *  _Nonnull result) {
        if (result.state.integerValue == 1) {
            self.headHomeView.toolList = result.spaceid143;
        }
    } failure:^(NSError * _Nonnull error) {
         [MBProgressHUD showError:VENETERROR];
    }];
}

/// 获取分类类别数据
- (void)loadHomeClassificationData{
    self.classArr = [NSMutableArray new];
    [[VEHomeApi sharedApi]ve_loadClassificationDataCompletion:^(VEBaseModel *  _Nonnull result) {
        if (result.state.integerValue == 1) {
            self.classArr = [NSMutableArray arrayWithArray:result.resultArr];
            //插入推荐数据
            VEHomeToolModel *toolModel = [VEHomeToolModel new];
            toolModel.classifyName = @"推荐";
            toolModel.classifyId = @"0";
            [self.classArr insertObject:toolModel atIndex:0];
            
            [self.homeTabBar reloadData];
            [self.homePagerController reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
         [MBProgressHUD showError:VENETERROR];
    }];
}

//请求qq客服类信息
- (void)loadQQData{
    [VEUserApi loadQQNumberCompletion:^(id  _Nonnull result) {
    } failure:^(NSError * _Nonnull error) {}];
}

#pragma mark - 创建各个VIew
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, HEAD_HEIGHT + kScreenHeight);
    }
    return _scrollView;;
}

- (void)addTabPageBar {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.scrollView addSubview:tabBar];
    _homeTabBar = tabBar;
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.layout.prefetchItemCount = 1;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    pagerController.view.backgroundColor = [UIColor blackColor];
    [pagerController registerClass:[VEHomeClassSubViewController class] forControllerWithReuseIdentifier:@"ViewControllerID"];
    [self addChildViewController:pagerController];
    [self.scrollView addSubview:pagerController.view];
    _homePagerController = pagerController;
}

- (void)addHomeHeadView{
    self.headHomeView = [[VEHomeHeadFeaturesView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, HEAD_HEIGHT)];
    self.headHomeView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.headHomeView];
}

- (void)scrollDidBegin{
    self.scrollView.scrollEnabled = YES;
    self.canScroller = YES;
    [self.scrollView setContentOffset:CGPointMake(0, -Height_NavBar) animated:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _homeTabBar.frame = CGRectMake(10, CGRectGetHeight(self.headHomeView.frame), CGRectGetWidth(self.view.frame)-20, 30);
    _homePagerController.view.frame = CGRectMake(0, CGRectGetMaxY(_homeTabBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetHeight(_homeTabBar.frame)-Height_TabBar);
}

#pragma mark - TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return _classArr.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    if (self.classArr.count > index) {
         VEHomeToolModel *model = _classArr[index];
        cell.titleLabel.text = model.classifyName;
    }
    return cell;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    VEHomeToolModel *model = _classArr[index];
    CGFloat w = (kScreenWidth - 20) / _classArr.count;
    CGFloat maxW = [pagerTabBar cellWidthForTitle:model.classifyName];
    CGFloat rW = maxW > w ? maxW : w;
    return rW;
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_homePagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return _classArr.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    VEHomeClassSubViewController *VC = [[VEHomeClassSubViewController alloc]init];
    if (self.classArr.count > index) {
        VC.toolModel = self.classArr[index];
    }
    if (self.canScroller == NO) {       //防止拉上去后，切换后不能滑动
        [VC scrollEndScrolld];
    }
    return VC;
}

- (void)pagerController:(TYPagerController *)pagerController viewWillAppear:(UIViewController *)viewController forIndex:(NSInteger)index{
    NSLog(@"--------%zd",index);
}

- (void)pagerController:(TYPagerController *)pagerController viewDidAppear:(UIViewController *)viewController forIndex:(NSInteger)index{
    VEHomeClassSubViewController *vc = (VEHomeClassSubViewController *)viewController;
    if (self.canScroller) {//防止全部展示后，底部还能滑动
         [vc endScroll];
    }
}

#pragma mark - TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_homeTabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_homeTabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

#pragma mark - UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView && self.canScroller) {
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        LMLog(@"========%.2f",contentOffsetY);
        if (contentOffsetY >= (250-Height_StatusBar)) {
            [self.scrollView setContentOffset:CGPointMake(0, 250-Height_StatusBar) animated:YES];
            self.canScroller = NO;
            self.scrollView.scrollEnabled = NO;
//            [self.pagerController reloadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:VETABLETOP object:nil];
        }
    }
}

#pragma mark - Other
- (void)addOtherBtnLaLa{
    [[VEHomeApi sharedApi]ve_addOtherDataLaLalaCompletion:^(id  _Nonnull result) {
    } failure:^(NSError * _Nonnull error) {
    }];
}

- (void)createMoreBlock{
    NSString *str = [[NSString alloc]init];
    [str stringByAppendingFormat:@"sdsd"];
    [str stringByAppendingFormat:@"sdsd2"];
    [str stringByAppendingFormat:@"sdsd3"];
    LMLog(@"str====%@",str);
}

- (NSArray *)showOtherArrWithData:(NSString *)str{
    NSMutableArray *arr = [NSMutableArray new];
    [arr addObject:@"1"];
    [arr addObject:@"2"];
    [arr addObject:@"3"];
    [arr replaceObjectAtIndex:1 withObject:@"4"];
    return arr;
}

- (void)loadAllLabData{
    NSString * totalText = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_1" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    totalText = [totalText substringToIndex:totalText.length - 1];//去掉文本最后的一个/n符
    NSString * showText = [NSString stringWithFormat:@"%@收起",totalText];
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:showText];
    NSDictionary * attDic = @{
                                       NSFontAttributeName : [UIFont systemFontOfSize:15],
                                       NSForegroundColorAttributeName : [UIColor darkGrayColor]
                                       };
    [attString setAttributes:attDic range:NSMakeRange(0, showText.length)];
    [attString setAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]} range:NSMakeRange(showText.length - 2, 2)];
             
    //这里要用delegate，block不好处理，每次都要重新写这个方法，因为attributedText有变动了
    NSString * showText2 = [NSString stringWithFormat:@"%@展开",[totalText substringToIndex:80]];
    NSMutableAttributedString * attString2 = [[NSMutableAttributedString alloc] initWithString:showText];
    NSDictionary * attDic2 = @{
                NSFontAttributeName : [UIFont systemFontOfSize:15],
                NSForegroundColorAttributeName : [UIColor darkGrayColor]
                };
    [attString2 setAttributes:attDic2 range:NSMakeRange(0, showText2.length)];
    [attString2 setAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]} range:NSMakeRange(showText.length - 2, 2)];
         
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
