//
//  VEUserMyFeedbackController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserMyFeedbackController.h"
#import "VEUserFeedbackListModel.h"
#import "VEUserMyFeedbackListCell.h"
#import "VEUserReplayCell.h"
#import "VEUserApi.h"
#import "VENoneView.h"

@interface VEUserMyFeedbackController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listData;

@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL hasLoadingMore;          //是否是正在加载更多
@property (assign, nonatomic) BOOL hasMore;          //是否还能加载更多
@property (strong, nonatomic) VENoneView *noneView;


@end

@implementation VEUserMyFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_NAV_COLOR;
    //self.navigationController.navigationBar.topItem.title = @"";
    self.title = @"我的反馈";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noneView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self firstLoad];
    // Do any additional setup after loading the view.
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[VEUserMyFeedbackListCell class] forCellReuseIdentifier:VEUserMyFeedbackListCellStr];
        [_tableView registerClass:[VEUserReplayCell class] forCellReuseIdentifier:VEUserReplayCellStr];
    }
    return _tableView;
}

- (VENoneView *)noneView{
    if (!_noneView) {
        _noneView = [[VENoneView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _noneView.backgroundColor = self.view.backgroundColor;
        [_noneView setLogoImage:@"vm_loading_empty" andTitle:@"暂时没有反馈"];
        _noneView.hidden = YES;
    }
    return _noneView;
}

- (void)showNoneView{
    if (self.listData.count > 0) {
        self.noneView.hidden = YES;
        self.tableView.hidden = NO;
    }else{
        self.noneView.hidden = NO;
        self.tableView.hidden = YES;
    }
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

- (void)loadMainData{
    if (self.page == 1) {
        [MBProgressHUD showMessage:@"加载中..."];
    }
    [VEUserApi myFeedbackListWithPage:self.page Completion:^(VEBaseModel *  _Nonnull result) {
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
        [self showNoneView];
    } failure:^(NSError * _Nonnull error) {
        [self showNoneView];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.listData.count > section) {
        VEUserFeedbackListModel *model = self.listData[section];
        if (model.isReply.boolValue == YES && model.isOpen) {
            return 2;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listData.count > indexPath.section) {
          VEUserFeedbackListModel *model = self.listData[indexPath.section];
           if (indexPath.row == 0) {
               return model.isOpen ? model.openHeight : model.height;
        }
        return model.replayHeight;
    }
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VEUserFeedbackListModel *model;
    if (self.listData.count > indexPath.section) {
            model = self.listData[indexPath.section];
    }
    
    if (indexPath.row == 0) {
        VEUserMyFeedbackListCell *cell = [tableView dequeueReusableCellWithIdentifier:VEUserMyFeedbackListCellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[VEUserMyFeedbackListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEUserMyFeedbackListCellStr];
        }
        cell.model = model;
        return cell;
    }
    VEUserReplayCell *cell = [tableView dequeueReusableCellWithIdentifier:VEUserReplayCellStr];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[VEUserReplayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEUserReplayCellStr];
    }
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        cell.backgroundColor = MAIN_BLACK_COLOR;
    }else{
        cell.backgroundColor = MAIN_NAV_COLOR;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (self.listData.count > indexPath.section) {
            VEUserFeedbackListModel *model = self.listData[indexPath.section];
            model.isOpen = !model.isOpen;
            [self.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationFade];
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
