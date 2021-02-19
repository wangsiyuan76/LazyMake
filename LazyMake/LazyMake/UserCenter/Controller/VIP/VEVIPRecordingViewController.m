//
//  VEVIPRecordingViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVIPRecordingViewController.h"
#import "VEVIPRecordingCell.h"
#import "VEVipRecordingModel.h"
#import "VEUserBlankCell.h"
#import "VEUserApi.h"

@interface VEVIPRecordingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listData;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL hasLoadingMore;          //是否是正在加载更多
@property (assign, nonatomic) BOOL hasMore;          //是否还能加载更多

@end

@implementation VEVIPRecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    //self.navigationController.navigationBar.topItem.title = @"";
    self.title = @"购买记录";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self firstLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - LoadData
- (void)firstLoad{
    self.page = 1;
    [self loadMainData];
}
- (void)moreLoad{
    self.page ++;
    [self loadMainData];
}

/// 加载推荐数据
- (void)loadMainData{
    if (self.page == 1) {
        [MBProgressHUD showMessage:@"加载中..."];
    }
    [VEUserApi loadVIPRecordingPage:self.page Completion:^(VEBaseModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        if (result.state.intValue == 1) {
            self.hasMore = result.hasMore;
            if (self.page == 1) {
                [self.listData removeAllObjects];
                self.listData = [NSMutableArray new];
            }
            [self.listData addObjectsFromArray:result.resultArr];
            [self.tableView reloadData];
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

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.allowsSelection = NO;
        [_tableView registerClass:[VEVIPRecordingCell class] forCellReuseIdentifier:VEVIPRecordingCellStr];
        [_tableView registerClass:[VEUserBlankCell class] forCellReuseIdentifier:VEUserBlankCellStr];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count > 0 ? self.listData.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listData.count > 0) {
        return [VEVIPRecordingCell cellHeight];
    }
    return [VEUserBlankCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listData.count > 0) {
        VEVIPRecordingCell *cell = [tableView dequeueReusableCellWithIdentifier:VEVIPRecordingCellStr];
        if (!cell) {
            cell = [[VEVIPRecordingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEVIPRecordingCellStr];
        }
        if (self.listData.count > indexPath.row) {
            cell.model = self.listData[indexPath.row];
        }
        return cell;
    }else{
        VEUserBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:VEUserBlankCellStr];
        if (!cell) {
            cell = [[VEUserBlankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEUserBlankCellStr];
        }
        [cell setLogoImage:@"vm_loading_empty" andTitle:@"暂时没有购买记录"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = self.view.backgroundColor;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取当前显示的cell,提前加载分页数据
    if (!self.hasLoadingMore && self.hasMore) {
        NSArray *array = [self.tableView visibleCells]; //获取的cell不完成正确
        if (array.count > 0) {
            UITableViewCell *cell1 = array.firstObject;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell1];
            if (indexPath.row >= self.listData.count - LOAD_MORE_ADVANCE) {
                self.hasLoadingMore = YES;
                [self moreLoad];
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
