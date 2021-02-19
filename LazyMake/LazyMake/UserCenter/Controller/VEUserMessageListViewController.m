//
//  VEUserMessageListViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/6.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserMessageListViewController.h"
#import "VEUserMessageCell.h"
#import "VENoneView.h"
#import "MJRefreshAutoNormalFooter.h"
#import "VEUserApi.h"
#import "VEUserMessageModel.h"

@interface VEUserMessageListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) VENoneView *noneView;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation VEUserMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    self.title = @"消息通知";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noneView];
    [self firstLoadData];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    // Do any additional setup after loading the view.
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[VEUserMessageCell class] forCellReuseIdentifier:VEUserMessageCellStr];
        _tableView.backgroundColor = self.view.backgroundColor;
        
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        refreshControl.tintColor = [UIColor grayColor];
        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
        [refreshControl addTarget:self action:@selector(firstLoadData) forControlEvents:UIControlEventValueChanged];
        _tableView.refreshControl = refreshControl;
        
        MJRefreshAutoNormalFooter *foot = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [foot endRefreshingWithNoMoreData];
        [foot setTitle:@"" forState:MJRefreshStateNoMoreData];
        _tableView.mj_footer = foot;
    }
    return _tableView;
}

- (VENoneView *)noneView{
    if (!_noneView) {
        _noneView = [[VENoneView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _noneView.backgroundColor = self.view.backgroundColor;
        [_noneView setLogoImage:@"vm_loading_empty" andTitle:@"暂时没有通知消息"];
        _noneView.hidden = YES;
    }
    return _noneView;
}
- (void)firstLoadData{
    self.page = 1;
    [self loadUserWorksList];
}

- (void)loadMoreData{
    self.page ++;
    [self loadUserWorksList];
}

- (void)loadUserWorksList{
    if (self.page == 1) {
        [MBProgressHUD showMessage:@"加载中..."];
    }
    [VEUserApi loadUserMessageList:self.page Completion:^(VEUserMessageModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        if ([self.tableView.refreshControl isRefreshing]) {
            [self.tableView.refreshControl endRefreshing];
        }
        [self.tableView.mj_footer endRefreshing];
        if (result.state.intValue == 1) {
            if (result.hasMore) {
                [self.tableView.mj_footer resetNoMoreData];
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
                self.dataArr = [NSMutableArray new];
            }

            [self.dataArr addObjectsFromArray:result.resultArr];
            [self showNoneView];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:result.errorMsg];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [self showNoneView];
        [self.tableView.refreshControl endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
    }];
}

- (void)showNoneView{
    if (self.dataArr.count > 0) {
        self.noneView.hidden = YES;
        self.tableView.hidden = NO;
    }else{
        self.noneView.hidden = NO;
        self.tableView.hidden = YES;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count > indexPath.row) {
        VEUserMessageModel *model = self.dataArr[indexPath.row];
        return [VEUserMessageCell cellHeightWithContent:model.content];
    }
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VEUserMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:VEUserMessageCellStr];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[VEUserMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEUserMessageCellStr];
    }
    if (self.dataArr.count > indexPath.row) {
        VEUserMessageModel *model = self.dataArr[indexPath.row];
        cell.contentStr = model.content;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    cell.backgroundColor = self.view.backgroundColor;
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
