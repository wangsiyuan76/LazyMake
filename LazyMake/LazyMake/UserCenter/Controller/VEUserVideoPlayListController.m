//
//  VEUserVideoPlayListController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/27.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserVideoPlayListController.h"
#import "VEUserVideoPlayCell.h"
#import <AliyunPlayer/AliyunPlayer.h>
#import "VEUserApi.h"

@interface VEUserVideoPlayListController ()<UICollectionViewDelegate,UICollectionViewDataSource,AVPDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) AliListPlayer *listPlayer;
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, assign) BOOL ifStop;                              //是否停止播放
@property (nonatomic, assign) BOOL hasLoadingMore;
@property (nonatomic, strong) UIImageView *videoImage;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation VEUserVideoPlayListController

-(void)dealloc{
    [self.listPlayer pause];
    [self.listPlayer stop];
    self.listPlayer = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.listPlayer && self.ifStop == NO) {
        self.ifStop = NO;
        [self.listPlayer start];
        self.videoImage.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.activityIndicator];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    @weakify(self);
    [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView setContentOffset:CGPointMake(0, 0)];
    });
    [self createVideo];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.listPlayer pause];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.minimumLineSpacing = 0;
        fl.minimumInteritemSpacing = 0;
        fl.itemSize = CGSizeMake(kScreenWidth, [VEUserVideoPlayCell cellHieght]);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[VEUserVideoPlayCell class] forCellWithReuseIdentifier:VEUserVideoPlayCellStr];
        
//        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//        refreshControl.tintColor = [UIColor grayColor];
//        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
//        [refreshControl addTarget:self action:@selector(firstLoadData) forControlEvents:UIControlEventValueChanged];
//        _collectionView.refreshControl = refreshControl;
    }
    return _collectionView;
}

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

- (void)createVideo{
    [AliPlayer setEnableLog:NO];
    self.listPlayer = [[AliListPlayer alloc] init];
    self.listPlayer.preloadCount = 3;
    self.listPlayer.delegate = self;
    self.listPlayer.loop = YES;
    self.listPlayer.autoPlay = YES;
    self.listPlayer.scalingMode = AVP_SCALINGMODE_SCALEASPECTFILL;
    
    for (VEUserWorksListModel *subModel in self.dataArr) {
        [self.listPlayer addUrlSource:subModel.vedio uid:subModel.wID];
    }
    if (self.selectIndex > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            [self.collectionView setContentOffset:CGPointMake(0, self.selectIndex * kScreenHeight) animated:NO];
        });
    }

    //延迟执行
   __block VEUserVideoPlayListController *weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf playVideoWithIndex:weakSelf.selectIndex];
    });
}

#pragma mark - AVPDelegate
- (void)onPlayerEvent:(AliPlayer *)player eventType:(AVPEventType)eventType{
    switch (eventType) {
            case AVPEventPrepareDone: {
                // 准备完成
            }
                break;
            case AVPEventAutoPlayStart:
                // 自动播放开始事件
                break;
            case AVPEventFirstRenderedStart:
                // 首帧显示
                self.playView.hidden = NO;
                break;
            case AVPEventCompletion:
                // 播放完成
                break;
            case AVPEventLoadingStart:
                // 缓冲开始
            [self.activityIndicator startAnimating];
            LMLog(@"缓冲开始");
                break;
            case AVPEventLoadingEnd:
                // 缓冲完成
            [self.activityIndicator stopAnimating];
            LMLog(@"缓冲完成");
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

- (UIView *)playView{
    if (!_playView) {
        _playView = [[UIView alloc]init];
    }
    return _playView;
}

- (UIImageView *)videoImage{
    if (!_videoImage) {
        _videoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_icon_video"]];
    }
    return _videoImage;
}

- (void)loadMoreData{
    self.page ++;
    [self loadUserWorksList];
}

- (void)loadUserWorksList{
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
            for (VEUserWorksListModel *subModel in result.resultArr) {
                [self.listPlayer addUrlSource:subModel.vedio uid:subModel.wID];
            }
            [self.collectionView reloadData];
        }else{
            [MBProgressHUD showError:result.errorMsg];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
    }];
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self.collectionView reloadData];

}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VEUserVideoPlayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEUserVideoPlayCellStr forIndexPath:indexPath];
    cell.index = indexPath.row;
    if (self.dataArr.count > indexPath.row) {
        cell.model = self.dataArr[indexPath.row];
    }
    @weakify(self);
    cell.deleteModelBlock = ^(VEUserWorksListModel * _Nonnull model, NSInteger index) {
        @strongify(self);
        if (self.dataArr.count > index) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [self.dataArr removeObjectAtIndex:index];
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count > indexPath.row) {
        self.ifStop = !self.ifStop;
        if (self.ifStop) {
            [self.listPlayer pause];
            self.videoImage.hidden = NO;
        }else{
            [self.listPlayer start];
            self.videoImage.hidden = YES;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 0) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)animated:YES];
    }
    NSInteger num = scrollView.contentOffset.y/kScreenHeight;
    [self playVideoWithIndex:num];
    LMLog(@"scrollViewDidEndDecelerating===%.2f=======%zd",scrollView.contentOffset.y,num);
}

- (void)playVideoWithIndex:(NSInteger)index{
    if (self.dataArr.count > index) {
        VEUserVideoPlayCell *cell = (VEUserVideoPlayCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [self.playView removeFromSuperview];
        [self.videoImage removeFromSuperview];
        [cell.mainImage addSubview:self.playView];
        [cell.mainImage addSubview:self.videoImage];
        self.playView.frame = CGRectMake(0, 0, cell.mainImage.frame.size.width, cell.mainImage.frame.size.height);
        self.videoImage.frame = CGRectMake((kScreenWidth - 50)/2, (kScreenHeight - 50)/2, 50, 50);
        self.videoImage.hidden = YES;
        LMLog(@"===ddddd=====%@========%@",NSStringFromCGRect(cell.mainImage.frame),NSStringFromCGRect(cell.mainImage.bounds));
        //播放相关
        self.listPlayer.playerView = self.playView;
        VEUserWorksListModel *subModel = self.dataArr[index];
        [self.listPlayer moveTo:subModel.wID];
        
        [self.listPlayer start];
        self.playView.hidden = YES;
        self.ifStop = NO;
        
        //添加统计
        [self addStatisticsDataWithID:subModel.wID];
        
        //加载更多
        if (!self.hasLoadingMore && self.hasMore) {
            if (index > self.dataArr.count - LOAD_MORE_ADVANCE) {
                self.self.hasLoadingMore = YES;
                [self loadMoreData];
            }
        }
    }
}

/// 添加统计
- (void)addStatisticsDataWithID:(NSString *)VID{
    [VEUserApi videoAddCountHits:VID Completion:^(id  _Nonnull result) {
    } failure:^(NSError * _Nonnull error) {
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
