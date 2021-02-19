//
//  VETemplateDetailController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VETemplateDetailController.h"
#import "VETemplateCardFlowLayout.h"
#import "VETemplateCardCollectionCell.h"
#import "VETemplateNavHeadView.h"
#import "VETemplateBottomView.h"
#import "VEHomeShareView.h"
#import "VEHomeApi.h"
#import "VEHomeTagListViewController.h"
#import "VEHomeUserWorksController.h"
#import "VEAlertView.h"
#import "VEAEVideoEditViewController.h"
#import <AliyunPlayer/AliyunPlayer.h>
#import "VEMainGuideView.h"

@interface LMTemplateDetailTapView : UIView
@property (strong, nonatomic) UIImageView *playImage;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end
@implementation LMTemplateDetailTapView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.playImage];
        [self addSubview:self.activityIndicator];

        @weakify(self);
        [self.playImage mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    return self;
}

- (UIImageView *)playImage{
    if (!_playImage) {
        _playImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_icon_video"]];
        _playImage.hidden = YES;
    }return _playImage;
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
@end

@interface VETemplateDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,AVPDelegate>
@property (strong, nonatomic) UIImageView *bgImageV;                    //背景毛玻璃
@property (strong, nonatomic) UIImageView *shaodwImage;
@property (strong, nonatomic) UICollectionView *cardCollectionVIew;     //中间collection
@property (strong, nonatomic) VETemplateNavHeadView *headNavView;       //顶部nav
@property (strong, nonatomic) VETemplateBottomView *bottomView;         //底部的信息
@property (assign, nonatomic) CGFloat startX;                           //开始滚动距离
@property (assign, nonatomic) CGFloat endX;                             //结束滚动距离
@property (assign, nonatomic) NSInteger currentIndex;                   //当前滚动cell的index
@property (strong, nonatomic) VEHomeTemplateModel *showModel;           //当前展示的model对象
@property (assign, nonatomic) BOOL hasLoadingMore;                      //是否正在加载更多

@property (nonatomic, strong) AliListPlayer *listPlayer;
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) LMTemplateDetailTapView *stateView;
@property (nonatomic, assign) BOOL ifStop;                              //是否停止播放
@property (nonatomic, assign) CGSize cardSize;                          //cell的size
@property (nonatomic, strong) NSMutableArray *allCellArr;                          //cell的size
@property (assign, nonatomic) BOOL hasPlaying;
@property (nonatomic, strong) VEMainGuideView *guideV;                  //引导view
@property (nonatomic, assign) NSInteger guideIndex;                  //引导view

@end

@implementation VETemplateDetailController

- (void)dealloc{
    LMLog(@"VETemplateDetailController释放");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.ifStop = YES;
    [self.listPlayer pause];
    self.stateView.playImage.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    self.hasPlaying = [[NSUserDefaults standardUserDefaults]objectForKey:AETemplateVideoPlayKey];

    self.allCellArr = [NSMutableArray new];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySucceed) name:@"UserVipStateChange" object:nil];
    //创建视图
    [self createUI];
    [self showGuideView];
}

//添加新手引导
- (void)showGuideView{
    NSNumber *num = [[NSUserDefaults standardUserDefaults]objectForKey:@"TEMPLATEDETAILGUIDEVIEW"];
    num = [NSNumber numberWithInt:0];
    if (num.boolValue == NO) {
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        self.guideV = [[VEMainGuideView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [self.guideV.subImage setImage:[UIImage imageNamed:@"vm_guide_template"]];
        self.guideV.subImage.frame = CGRectMake((kScreenWidth - 168 - 70), kScreenHeight - Height_SafeAreaBottom - 93 - 80, 168, 93);
        [win addSubview:self.guideV];
        [self.guideV showAll];
        self.guideIndex = 1;
        @weakify(self);
        self.guideV.clickMainBtnBlock = ^{
            @strongify(self);
            if (self.guideIndex == 1) {
                [self.guideV.subImage setImage:[UIImage imageNamed:@"vm_guide_template_"]];
//                self.guideV.subImage.frame = CGRectMake((kScreenWidth - 208 - 48), Height_NavBar, 208, 78);
                self.guideV.subImage.frame = CGRectMake((kScreenWidth - 208), Height_NavBar, 208, 78);
                self.guideIndex ++;
            }else{
                self.guideIndex ++;
                [self.guideV hiddenAll];
                if ([VETool netWorkIsWifi] || self.hasPlaying){
                    [self.listPlayer start];
                    self.stateView.playImage.hidden = YES;
                    self.ifStop = NO;
                    self.hasPlaying = YES;
                }
            }
        };
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"TEMPLATEDETAILGUIDEVIEW"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}


#pragma mark - CreateUI
-(void)createUI{
    [self.view addSubview:self.bgImageV];
    [self.view addSubview:self.shaodwImage];
    [self.view addSubview:self.cardCollectionVIew];
    [self.view addSubview:self.headNavView];
    [self.view addSubview:self.bottomView];

    [self.headNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_offset(0);
        make.height.mas_equalTo(Height_NavBar);
    }];
    
    [self.cardCollectionVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(Height_NavBar);
        make.bottom.mas_equalTo(-(130 + Height_SafeAreaBottom));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(120 + Height_SafeAreaBottom);
    }];
    
        
    //滚动到点击的位置
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createVideo];
        if (self.listData.count > self.selectIndex) {
            NSInteger maxIndex  = [self.cardCollectionVIew numberOfItemsInSection:0] - 1;
            self.currentIndex = self.selectIndex;
            self.currentIndex = self.currentIndex >= maxIndex ? maxIndex : self.currentIndex;
            [self.cardCollectionVIew scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            [self getShowCellDataWithIndex:self.currentIndex];
        }
    });
}

- (void)createVideo{
    [AliPlayer setEnableLog:NO];
    self.listPlayer = [[AliListPlayer alloc] init];
    self.listPlayer.preloadCount = 3;
    self.listPlayer.delegate = self;
    self.listPlayer.loop = YES;
    self.listPlayer.autoPlay = YES;
    self.listPlayer.scalingMode = AVP_SCALINGMODE_SCALEASPECTFILL;
    for (VEHomeTemplateModel *subModel in self.listData) {
        [self.listPlayer addUrlSource:subModel.customObj.videoPreview uid:subModel.tID];
    }
}
#pragma mark - AVPDelegate
- (void)onPlayerEvent:(AliPlayer *)player eventType:(AVPEventType)eventType{
    switch (eventType) {
            case AVPEventPrepareDone: {
                // 准备完成
                [self.stateView.activityIndicator stopAnimating];
                if ((![VETool netWorkIsWifi] && !self.hasPlaying) || self.guideIndex == 1) {
                    [self.listPlayer pause];
                }
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
                if (!self.ifStop) {
                    [self.stateView.activityIndicator startAnimating];
                }
                // 缓冲开始
                break;
            case AVPEventLoadingEnd:
                // 缓冲完成
                [self.stateView.activityIndicator stopAnimating];
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

- (void)onPlayerStatusChanged:(AliPlayer*)player oldStatus:(AVPStatus)oldStatus newStatus:(AVPStatus)newStatus{
    NSLog(@"onPlayerStatusChanged=====%zd",newStatus);
    if (newStatus == AVPStatusInitialzed) {
        [self.stateView.activityIndicator stopAnimating];
    }
    if (newStatus == AVPStatusPaused || newStatus == AVPStatusStopped) {
        if (!self.ifStop) {
            [self.stateView.activityIndicator startAnimating];
        }
    }
}

- (void)paySucceed{
    [self.bottomView updateBtnType];
}
#pragma mark - 创建view
- (UIImageView *)shaodwImage{
    if (!_shaodwImage) {
        _shaodwImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _shaodwImage.image = [UIImage imageNamed:@"vm_mengban_h"];
    }
    return _shaodwImage;;
}

- (UIImageView *)bgImageV{
    if (!_bgImageV) {
        _bgImageV = [[UIImageView alloc]initWithFrame:self.view.bounds];
        [VETool blurEffect:_bgImageV];//设置毛玻璃效果
    }
    return _bgImageV;;
}

- (LMTemplateDetailTapView *)stateView{
    if (!_stateView) {
        _stateView = [[LMTemplateDetailTapView alloc]init];
    }
    return _stateView;
}

- (UIView *)playView{
    if (!_playView) {
        _playView = [[UIView alloc]init];
        _playView.layer.masksToBounds = YES;
        _playView.layer.cornerRadius = 12;
        
        _playView.backgroundColor = [UIColor clearColor];
//        _playView.alpha = 0.5f;
    }
    return _playView;
}
- (UICollectionView *)cardCollectionVIew{
    if (!_cardCollectionVIew) {
        VETemplateCardFlowLayout *layout = [[VETemplateCardFlowLayout alloc]init];
//        layout.itemSize = self.cardSize;

        _cardCollectionVIew  = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _cardCollectionVIew.delegate=self;
        _cardCollectionVIew.dataSource=self;
        _cardCollectionVIew.backgroundColor = [UIColor clearColor];
        _cardCollectionVIew.showsHorizontalScrollIndicator=NO;
        [_cardCollectionVIew registerClass:[VETemplateCardCollectionCell class] forCellWithReuseIdentifier:VETemplateCardCollectionCellStr];
    }
    return _cardCollectionVIew;
}

- (VETemplateNavHeadView *)headNavView{
    if (!_headNavView) {
        _headNavView = [[VETemplateNavHeadView alloc]initWithFrame:CGRectZero];
        _headNavView.backgroundColor = [UIColor clearColor];
//        _headNavView.titleLab.text = @"标题名称";
        
        @weakify(self);
        _headNavView.clickNavBtnBlock = ^(NSInteger btnTag) {
            @strongify(self);
            if (btnTag == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }else if (btnTag == 2) {
                [self.bottomView deleteDonlondingData];
            }
            else if(btnTag == 3){
                [self showShareView];
            }
        };
    }
    return _headNavView;;
}

- (VETemplateBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[VETemplateBottomView alloc]initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor clearColor];
        @weakify(self);
        _bottomView.clickTagBlock = ^(id  _Nonnull selectedObject, NSInteger index) {
            @strongify(self);
            if (self.showModel.tags.count > index) {
                VEHomeTagListViewController *vc = [VEHomeTagListViewController new];
                vc.tagName = self.showModel.tags[index];
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        
        _bottomView.clickMakeBlock = ^{
//            @strongify(self);
//            [self downloadFile];
        };
        
        _bottomView.doneLoadSucceedBlock = ^(VEHomeTemplateModel * _Nonnull model) {
            @strongify(self);
            VEAEVideoEditViewController *vc = [VEAEVideoEditViewController new];
            vc.showModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        _bottomView.clickUserBlock = ^{
            @strongify(self);
            VEHomeUserWorksController *vc = [VEHomeUserWorksController new];
            vc.model = self.showModel;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _bottomView;
}

#pragma mark - LoadData
- (void)setAllParWithArr:(NSArray *)arr selectIndex:(NSInteger)selectIndex page:(NSInteger)page hasMore:(BOOL)hasMore laodUrl:(NSString *)loadUrl otherDic:(NSDictionary *)parDic{
    self.listData = [NSMutableArray arrayWithArray:arr];
    self.selectIndex = selectIndex;
    self.page = page;
    self.hasMore = hasMore;
    self.loadUrl = loadUrl;
    self.parDic = parDic;
}

- (void)loadMoreData{
    if (self.hasMore && !self.hasLoadingMore) {
        self.page ++;
        [self loadMainData];
    }
}
- (void)loadMainData{
    [[VEHomeApi sharedApi]ve_detailLoadListPage:self.page pushUrl:self.loadUrl otherDic:self.parDic Completion:^(VEBaseModel *  _Nonnull result) {
        if (result.state.intValue == 1) {
            self.hasMore = result.hasMore;
            if (self.page == 1) {
                [self.listData removeAllObjects];
                self.listData = [NSMutableArray new];
                [self.listData addObjectsFromArray:result.resultArr];
            }else{
                //过滤重复数据
                NSArray *arr = [NSArray arrayWithArray:self.listData];
                NSMutableArray *saveArr = [NSMutableArray  new];
                for (VEHomeTemplateModel *subModel2 in result.resultArr) {
                    BOOL hasSave = YES;
                     for (VEHomeTemplateModel *subModel in arr) {
                         if ([subModel2.tID isEqualToString:subModel.tID]) {
                             hasSave = NO;
                             break;
                         }
                     }
                    if (hasSave == YES) {
                        [saveArr addObject:subModel2];
                    }
                }
                [self.listData addObjectsFromArray:saveArr];
                //播放列表中添加
                for (VEHomeTemplateModel *subModel in saveArr) {
                    [self.listPlayer addUrlSource:subModel.customObj.videoPreview uid:subModel.tID];
                }
            }

            [self.cardCollectionVIew reloadData];
            if (self.page > 1) {
                self.hasLoadingMore = NO;
            }
        }
    } failure:^(NSError * _Nonnull error) {
    }];
}

//添加统计
- (void)addStatistics{
    [[VEHomeApi sharedApi]ve_detailCountHits:self.showModel.tID Completion:^(id  _Nonnull result) {
    } failure:^(NSError * _Nonnull error) {
    }];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VETemplateCardCollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:VETemplateCardCollectionCellStr forIndexPath:indexPath];
    if (self.listData.count > indexPath.row) {
        cell.model = self.listData[indexPath.row];
    }
    if (cell) {
        if (self.allCellArr.count > indexPath.row) {
            [self.allCellArr replaceObjectAtIndex:indexPath.row withObject:cell];
        }else{
            [self.allCellArr addObject:cell];
        }
    }
    return cell;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.startX = scrollView.contentOffset.x;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.ifStop = !self.ifStop;
    if (self.ifStop) {
        [self.listPlayer pause];
        self.stateView.playImage.hidden = NO;
    }else{
        if (![VETool netWorkIsWifi] && !self.hasPlaying) {
            [self showNotWifiPlayAlert];
        }else{
            [self.listPlayer start];
            self.stateView.playImage.hidden = YES;
        }
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.endX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cellToCenter];
    });
}

-(void)cellToCenter{
    //最小滚动距离
    float  dragMinDistance = self.cardCollectionVIew.bounds.size.width/20.0f;
    if (self.startX - self.endX >= dragMinDistance) {
        self.currentIndex -= 1; //向右
    }else if (self.endX - self.startX >= dragMinDistance){
        self.currentIndex += 1 ;//向左
    }
    //获取当前cell
    NSInteger maxIndex  = [self.cardCollectionVIew numberOfItemsInSection:0] - 1;
    self.currentIndex = self.currentIndex <= 0 ? 0 :self.currentIndex;
    self.currentIndex = self.currentIndex >= maxIndex ? maxIndex : self.currentIndex;
    [self.cardCollectionVIew scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    //将cell数据赋值
    [self getShowCellDataWithIndex:self.currentIndex];
}

//给当前展示的页面赋值
- (void)getShowCellDataWithIndex:(NSInteger)index{
    if (self.listData.count > index) {
        self.showModel = self.listData[index];
        [self.bgImageV setImageWithURL:[NSURL URLWithString:self.showModel.thumb] options:YYWebImageOptionProgressiveBlur];
        self.bottomView.showModel = self.showModel;
        [self addStatistics];
        if (index >= self.listData.count - LOAD_MORE_ADVANCE) {
            [self loadMoreData];
            self.hasLoadingMore = YES;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showPlayerView:index];
        });
    }
}

//创建播放器
- (void)showPlayerView:(NSInteger)index{
    [self.bottomView stopDonloading];
    if ([self.listPlayer.currentUid isEqualToString:self.showModel.tID]) {
        return;
    }

    VETemplateCardCollectionCell *cell = (VETemplateCardCollectionCell *)[self.cardCollectionVIew cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (!cell) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.cardCollectionVIew layoutIfNeeded];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.cardCollectionVIew layoutIfNeeded];
                VETemplateCardCollectionCell *cell2 = (VETemplateCardCollectionCell *)[self.cardCollectionVIew cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                [self createPlayerWithCell:cell2 ifHiddenPlayView:NO];
            });
        });
    }else{
        [self createPlayerWithCell:cell ifHiddenPlayView:YES];
    }
}

- (void)createPlayerWithCell:(VETemplateCardCollectionCell *)cell ifHiddenPlayView:(BOOL)hiddenPlayV{
    [self.playView removeFromSuperview];
    [self.stateView removeFromSuperview];
    [cell.imageIV addSubview:self.playView];
    [cell.imageIV addSubview:self.stateView];
    self.playView.frame = CGRectMake(0, 0, cell.imageIV.frame.size.width, cell.imageIV.frame.size.height);
    self.stateView.frame = CGRectMake(0, 0, cell.imageIV.frame.size.width, cell.imageIV.frame.size.height);

    //    LMLog(@"===index=====%zd========%@ =====%@",index,NSStringFromCGRect(cell.imageIV.bounds),cell);
        //播放相关
    self.listPlayer.playerView = self.playView;
    [self.listPlayer moveTo:self.showModel.tID];
    self.headNavView.titleLab.text = self.showModel.title;
    self.playView.hidden = hiddenPlayV;

    if ((![VETool netWorkIsWifi] && !self.hasPlaying) || self.guideIndex == 1) {
        [self.listPlayer pause];
        self.ifStop = YES;
        self.stateView.playImage.hidden = NO;
    }else{
        [self.listPlayer start];
        self.stateView.playImage.hidden = YES;
        self.ifStop = NO;
    }
}

/// 弹出分享框shareView
- (void)showShareView{
    VEHomeShareView *shareView = [[VEHomeShareView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    shareView.showModel = self.showModel;
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:shareView];
    [shareView show];
}

- (void)showNotWifiPlayAlert{
    VEAlertView *ale = [[VEAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [ale setContentStr: @"当前为非wifi环境，继续观看将会消耗较多流量，确定继续？"];
    [win addSubview:ale];
    @weakify(self);
    ale.clickSubBtnBlock = ^(NSInteger btnTag) {
        @strongify(self);
        if (btnTag == 1) {
            [self.listPlayer start];
            self.stateView.playImage.hidden = YES;
            self.ifStop = NO;
            self.hasPlaying = YES;
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:AETemplateVideoPlayKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else{
            [self.listPlayer pause];
            self.ifStop = YES;
            self.stateView.playImage.hidden = NO;
        }
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
