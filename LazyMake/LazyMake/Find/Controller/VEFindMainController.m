
//
//  LMFineMainViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEFindMainController.h"
#import "VEFindHomeListCell.h"
#import "VEFindApi.h"
#import "VEFindHomeListModel.h"
#import "VENoneView.h"
#import <AliyunPlayer/AliyunPlayer.h>
#import "VEUserApi.h"
#import "VEHomeTemplateModel.h"
#import "VEFindPlayMainViewController.h"
#import "VEAlertView.h"
#import "MJRefresh.h"

#import "TBCityIconFont.h"
#import "UIImage+TBCityIconFont.h"
#import "VFCaptchaView.h"

@interface VEFindMainController () <UITableViewDelegate,UITableViewDataSource,AVPDelegate>

@property (strong, nonatomic) VENoneView *noneDataView;
@property (nonatomic, strong) AliListPlayer *listPlayer;
@property (nonatomic, strong) UIView *playMainView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) VEFindHomeListCell *lastPlayCell;
@property (assign, nonatomic) BOOL hasLoadData;             //是否加载过数据，如果没有加载过并且数组数据为空，则一进入界面开始加载数据

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listData;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL hasLoadingMore;          //是否是正在加载更多
@property (assign, nonatomic) BOOL hasMore;                 //是否还能加载更多
@property (assign, nonatomic) BOOL firstLoad;          //是否是第一次加载
@property (assign, nonatomic) BOOL ifNowVC;          //是否在当前页面
@property (assign, nonatomic) BOOL hasPlaying;

@end

@implementation VEFindMainController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.ifNowVC = NO;
    self.lastPlayCell.playStopBtn.selected = NO;
    self.lastPlayCell.playStopBtn.hidden = YES;
    self.lastPlayCell.mainPlayBtn.selected = YES;
    [self.listPlayer pause];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.ifNowVC = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.hasLoadData && self.listData.count < 1) {
        [self firstLoad];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.noneDataView];
    self.firstLoad = YES;
    [self createNavStyle];
    [self firstLoadData];
    [self createVideo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadAllData) name:LoadUserWorks object:nil];
    
    /*otherotherotherotherotherotherother*/
    [self addOtherUsedTBCityIconFont];
    // Do any additional setup after loading the view.
}

- (void)reloadAllData{
    [self firstLoadData];
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
    [VEFindApi ve_loadFindListDataWithPage:self.page Completion:^(VEBaseModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        self.hasLoadData = YES;
        [self.tableView.refreshControl endRefreshing];
        [self.tableView.mj_header endRefreshing];
        self.hasLoadingMore = NO;
        self.hasMore = result.hasMore;
        if (result.state.intValue == 1) {
            if (self.page == 1) {
                [self.listData removeAllObjects];
                self.listData = [[NSMutableArray alloc]init];
                [self.listData addObjectsFromArray:result.resultArr];
                for (VEFindHomeListModel *subModel in self.listData) {
                    [self.listPlayer addUrlSource:subModel.vedio uid:subModel.wID];
                }
            }else{
                //过滤重复数据
                NSArray *arr = [NSArray arrayWithArray:self.listData];
                NSMutableArray *playArr = [NSMutableArray new];
                for (VEFindHomeListModel *subModel2 in result.resultArr) {
                    BOOL hasSave = YES;
                     for (VEFindHomeListModel *subModel in arr) {
                         if ([subModel2.wID isEqualToString:subModel.wID]) {
                             hasSave = NO;
                             break;
                         }
                     }
                    if (hasSave == YES) {
                        [self.listData addObject:subModel2];
                        [playArr addObject:subModel2];
                    }
                }
                for (VEFindHomeListModel *subModel in playArr) {
                    [self.listPlayer addUrlSource:subModel.vedio uid:subModel.wID];
                }
            }
            [self showNoneView];
            [self.tableView reloadData];
            if (self.page == 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self playVideoWithIndex:0 ifReload:YES];
                });
            }
            self.firstLoad = NO;
        }else{
            [self showNoneView];
            [MBProgressHUD showError:result.errorMsg];
        }
    } failure:^(NSError * _Nonnull error) {
        self.hasLoadData = YES;
        [self showNoneView];
        [self.tableView.refreshControl endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
    }];
}

/**
 自定义导航栏按钮样式
 */
- (void)createNavStyle{
    UIButton *lab = [UIButton new];
    [lab setTitle:@"发现" forState:UIControlStateNormal];
    [lab setTitleColor:[UIColor colorWithHexString:@"1DABFD"] forState:UIControlStateNormal];
    lab.titleLabel.font =  [UIFont systemFontOfSize:20];
    [lab addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:lab];
    self.navigationItem.leftBarButtonItem = barBtn;
}

#pragma mark - createView
- (UIActivityIndicatorView *)activityIndicator{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
        _activityIndicator.color = [UIColor lightGrayColor];
        //设置背景颜色
        _activityIndicator.backgroundColor = [UIColor clearColor];
        _activityIndicator.hidesWhenStopped = YES;
    }
    return _activityIndicator;
}

- (UIView *)playMainView{
    if (!_playMainView) {
        _playMainView = [[UIView alloc]init];
        _playMainView.layer.masksToBounds = YES;
        _playMainView.layer.cornerRadius = 12;
        _playMainView.tag = 10086;
        _playMainView.backgroundColor = [UIColor clearColor];
//        _playView.alpha = 0.5f;
    }
    return _playMainView;
}

- (void)createVideo{
    [AliPlayer setEnableLog:NO];
    self.listPlayer = [[AliListPlayer alloc] init];
    self.listPlayer.preloadCount = 3;
    self.listPlayer.delegate = self;
    self.listPlayer.loop = YES;
    self.listPlayer.autoPlay = YES;
    self.listPlayer.scalingMode = AVP_SCALINGMODE_SCALEASPECTFILL;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-Height_TabBar) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[VEFindHomeListCell class] forCellReuseIdentifier:VEFindHomeListCellStr];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(firstLoadData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        _tableView.mj_header = header;
    }
    return _tableView;
}

- (VENoneView *)noneDataView{
    if (!_noneDataView) {
        _noneDataView = [[VENoneView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _noneDataView.backgroundColor = self.view.backgroundColor;
        [_noneDataView setLogoImage:@"vm_loading_empty" andTitle:@"暂无数据"];
        _noneDataView.hidden = YES;
    }
    return _noneDataView;
}

- (void)showNoneView{
    if (self.listData.count > 0) {
        self.noneDataView.hidden = YES;
    }else{
        self.noneDataView.hidden = NO;
    }
}

- (void)leftBtnClick{
    [self.tableView scrollToRow:0 inSection:0 atScrollPosition:UITableViewScrollPositionTop animated:YES];

//    __block VEFindMainController *weakSelf = self;
//     dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
//     dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//         [weakSelf playVideoWithIndex:0 ifReload:NO];
//     });
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 450;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VEFindHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:VEFindHomeListCellStr];
    cell.index = indexPath.row;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[VEFindHomeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEFindHomeListCellStr];
    }
    if (self.listData.count > indexPath.row) {
        cell.model = self.listData[indexPath.row];
    }
    cell.mainPlayBtn.selected = NO;
    cell.playStopBtn.hidden = NO;

    @weakify(self);
    cell.clickPlayBtnBlock = ^(BOOL ifPlay, BOOL ifPushDetail, NSInteger index) {
        @strongify(self);
        if (ifPlay) {
            [self.listPlayer pause];
        }else{
            if ([VETool netWorkIsWifi] || self.hasPlaying) {
                [self startFindPlayerIndex:index];
            }else{
                [self showNotWifiPlayAlertIndex:index];
            }
        }
        if (ifPushDetail) {
            [self pushToDetailPlayVC:index];
        }
    };
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取当前显示的cell,提前加载分页数据
    [self.listPlayer pause];
    if (!self.hasLoadingMore && self.hasMore) {
        NSArray *array = [self.tableView indexPathsForVisibleRows];
        if (array.count > 0) {
            NSIndexPath *indexPath = array.firstObject;
            if (indexPath.row >= self.listData.count - 3) {
                self.hasLoadingMore = YES;
                [self loadMoreData];
            }
        }
    }
}   

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offSetY = scrollView.contentOffset.y + CGRectGetHeight(self.tableView.frame) / 2;
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:CGPointMake(0, offSetY)];
    [self playVideoWithIndex:indexPath.row ifReload:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        CGFloat offSetY = scrollView.contentOffset.y + CGRectGetHeight(self.tableView.frame) / 2;
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:CGPointMake(0, offSetY)];
        [self playVideoWithIndex:indexPath.row ifReload:NO];
    }
}

- (void)playVideoWithIndex:(NSInteger)index ifReload:(BOOL)ifLoad{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    if (self.listData.count > indexPath.row) {
        VEFindHomeListModel *model = self.listData[indexPath.row];
        if ([self.listPlayer.currentUid isEqualToString:model.wID] && !ifLoad) {
            if ([VETool netWorkIsWifi] || self.hasPlaying) {
                [self.listPlayer start];
            }

            return;
        }
        if (self.lastPlayCell) {
            self.lastPlayCell.playStopBtn.selected = NO;
            self.lastPlayCell.mainPlayBtn.selected = NO;
        }
        VEFindHomeListCell *cell = (VEFindHomeListCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [self.playMainView removeFromSuperview];
            [self.activityIndicator removeFromSuperview];
            self.activityIndicator = nil;
            self.playMainView = nil;
            [cell.mainVideoView addSubview:self.playMainView];
            [cell.mainVideoView addSubview:self.activityIndicator];
            self.activityIndicator.frame = CGRectMake((cell.mainVideoView.frame.size.width-50)/2, (cell.mainVideoView.frame.size.height-50)/2, 50, 50);
            self.playMainView.frame = CGRectMake(0, 0, cell.mainVideoView.frame.size.width, cell.mainVideoView.frame.size.height);
            //播放相关
            self.listPlayer.playerView = self.playMainView;
            [self.listPlayer moveTo:model.wID];
            self.lastPlayCell  = cell;
            if (index == 0 && ifLoad){
                self.playMainView.hidden = NO;
            }else{
                self.playMainView.hidden = YES;
            }
            
            //如果不在当前页面，则暂停播放
            if (!self.ifNowVC) {
                self.lastPlayCell.playStopBtn.selected = NO;
                self.lastPlayCell.playStopBtn.hidden = YES;
                self.lastPlayCell.mainPlayBtn.selected = YES;
                [self.listPlayer pause];
            }
            //如果不在网络状态下也停止播放
            if (![VETool netWorkIsWifi] && !self.hasPlaying) {
                self.lastPlayCell.playStopBtn.selected = NO;
                self.lastPlayCell.playStopBtn.hidden = NO;
                self.lastPlayCell.mainPlayBtn.selected = NO;
                self.playMainView.hidden = YES;
                [self.listPlayer pause];
            }else{
                self.lastPlayCell.playStopBtn.selected = YES;
                self.lastPlayCell.mainPlayBtn.selected = NO;
                self.lastPlayCell.playStopBtn.hidden = NO;
                [self.listPlayer start];
            }
        }
    }
}

- (void)pushToDetailPlayVC:(NSInteger)index{
    VEFindPlayMainViewController *vc = [[VEFindPlayMainViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.dataArr = [NSMutableArray arrayWithArray:self.listData];
    vc.selectIndex = index;
    vc.page = self.page;
    vc.hasMore = self.hasMore;
    [currViewController().navigationController pushViewController:vc animated:YES];
}

- (void)startFindPlayerIndex:(NSInteger)index{
    [self.listPlayer start];
    //判断这个cell上有没有播放器，如果没有的话，则添加
    NSIndexPath *subIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    VEFindHomeListCell *subCell = (VEFindHomeListCell *)[self.tableView cellForRowAtIndexPath:subIndexPath];
    BOOL hasPlayV = NO;
    for (UIView *subView in subCell.mainVideoView.subviews) {
        if (subView.tag == 10086) {
            hasPlayV = YES;
            break;
        }
    }
    if (hasPlayV == NO) {
        [self playVideoWithIndex:index ifReload:YES ];
    }
}

- (void)showNotWifiPlayAlertIndex:(NSInteger)index{
    VEAlertView *ale = [[VEAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [ale setContentStr: @"当前为非wifi环境，继续观看将会消耗较多流量，确定继续？"];
    [win addSubview:ale];
    @weakify(self);
    ale.clickSubBtnBlock = ^(NSInteger btnTag) {
        @strongify(self);
        if (btnTag == 1) {
            self.playMainView.hidden = NO;
            self.hasPlaying = YES;
            [self startFindPlayerIndex:index];
        }else{
            NSIndexPath *subIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
            VEFindHomeListCell *subCell = (VEFindHomeListCell *)[self.tableView cellForRowAtIndexPath:subIndexPath];
            subCell.playStopBtn.selected = NO;
            subCell.playStopBtn.hidden = NO;
            subCell.mainPlayBtn.selected = NO;
        }
    };
}

#pragma mark - AVPDelegate
- (void)onPlayerEvent:(AliPlayer *)player eventType:(AVPEventType)eventType{
    switch (eventType) {
            case AVPEventPrepareDone: {
                // 准备完成
                [self.activityIndicator stopAnimating];
                if (![VETool netWorkIsWifi] && !self.hasPlaying) {
                    [self.listPlayer pause];
                }
            }
                break;
            case AVPEventAutoPlayStart:
                // 自动播放开始事件
                break;
            case AVPEventFirstRenderedStart:
                // 首帧显示
                if ([VETool netWorkIsWifi] || self.hasPlaying) {
                    self.playMainView.hidden = NO;
                }
                break;
            case AVPEventCompletion:
                // 播放完成
                break;
            case AVPEventLoadingStart:
                [self.activityIndicator startAnimating];
                // 缓冲开始
                break;
            case AVPEventLoadingEnd:
                // 缓冲完成
                [self.activityIndicator stopAnimating];
                break;
            case AVPEventSeekEnd:
                // 跳转完成
                break;
            case AVPEventLoopingStart:
                // 循环播放开始
                break;
            default:
                break;
        }
}






#pragma mark - Other
- (void)addOtherUsedTBCityIconFont{
//    [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e61f", 100, [UIColor redColor])];
    UILabel *label1 = [UILabel new];
    UILabel *label2 = [UILabel new];
    UIButton *button1 = [UIButton new];
    UIButton *button2 = [UIButton new];

    /*---------------------label------------------------------------------------*/
    /*label图片和文字一行显示*/
    label1.font = [UIFont fontWithName:@"iconfont" size:30];//字体的名字一定要是iconfont
    label1.text = @" hahha \U0000e620";
    [label1 setTextColor:[UIColor redColor]];
        
    /*图片和文字不在同一行*/
    label2.font = [UIFont fontWithName:@"iconfont" size:30];//字体的名字一定要是iconfont
    //配置上两个对应图标
    label2.text = @" hahha\n \U0000e620";
    label2.numberOfLines=0;
    //配置图标颜色
    [label2 setTextColor:[UIColor cyanColor]];

    //   /*---------------------button------------------------------------------------*///
    //    /*图片和文字在同一行 图片和文字分开设置
//    [button1 setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e637", 30, [UIColor yellowColor])] forState:UIControlStateNormal];
    [button1 setTitle:@"哈哈" forState:UIControlStateNormal];
    [button1 setTintColor:[UIColor orangeColor]];
    /*
    图片和文字在同一行 图片和文字一块设置
    [self.button setTitle:@"哈哈 \U0000e637" forState:UIControlStateNormal];
    self.button.titleLabel.font=[UIFont fontWithName:@"iconfont" size:19];
    */
        
    //图片和文字不在同一行 图片和文字一块设置
    [button2 setTitle:@"\U0000e637 \n\n 哈哈" forState:UIControlStateNormal];//这样设置图片和文字会里的有点近可以通过设置行间距 或者多加一个\n 调整图片和文字的间距
    button2.titleLabel.numberOfLines=0;
    button2.titleLabel.textAlignment=NSTextAlignmentCenter;
    button2.titleLabel.font=[UIFont fontWithName:@"iconfont" size:19];
    [button2 setTintColor:[UIColor greenColor]];
}

- (void)loadOtherVFCaptchaView{
    VFCaptchaView *captchaView = [[VFCaptchaView alloc] initWithFrame:CGRectMake(20.f, 40.f, SCREEN_WIDTH - 40.f, 40) success:^(NSString *verificationCode) {
         NSString *title = @"Verification Succeeded!";
         NSString *message = @"🤗";
         NSString *cancelButtonTitle = @"Yeah";
         // do things on verification success

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil]];
//        [self presentViewController:alertController animated:YES completion:nil];
         
     } failure:^{
         // do things on verification failure
         NSString *title = @"Verification Failed!";
         NSString *message = @"😂";
         NSString *cancelButtonTitle = @"Try Again";
         // do things on verification success
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
         [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil]];
//             [self presentViewController:alertController animated:YES completion:nil];

     } withAnalyser:^BOOL(NSString *verificationCode) {
         return [verificationCode isEqualToString:@""];
     }];
     [captchaView setCaptchaCode:@"ImagineADog"];
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
