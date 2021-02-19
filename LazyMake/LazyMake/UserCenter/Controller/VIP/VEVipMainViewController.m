//
//  VEVipMainViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVipMainViewController.h"
#import "VEVipMainUserDataCell.h"
#import "VEVipPackageCell.h"
#import "VEVIPMoneyModel.h"
#import "VEVipFeaturesListCell.h"
#import "VEVipExplanationCell.h"
#import "VEVIPRecordingViewController.h"
#import "VEVipSucceedViewController.h"
#import "VEVipFailureViewController.h"
#import "VEUserApi.h"
#import "VEVIPMoneyModel.h"
#import "VEUserLoginPopupView.h"
#import "VEPayApiHandle.h"

@interface VEVipMainViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *moneyArr;         //购买类型的数组
@property (strong, nonatomic) VEVIPMoneyModel *selectModel;

@end

@implementation VEVipMainViewController

- (void)dealloc{
    LMLog(@"VEVipMainViewController释放");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    //self.navigationController.navigationBar.topItem.title = @"";
    self.title = @"开通VIP会员";
    
    UIButton *rightBtn = [UIButton new];
    [rightBtn setTitle:@"购买记录" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"1DABFD"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnBar;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySucceed) name:@"APPPaySucceed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payFail) name:@"APPPayFailure" object:nil];
    [self loadData];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    // Do any additional setup after loading the view.
}

- (void)loadData{
    [MBProgressHUD showMessage:@"加载中..."];
    [VEUserApi loadPayListCompletion:^(LMVIPMoneyIconModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        if (result.state.intValue == 1) {
            self.moneyArr = [NSMutableArray arrayWithArray:result.tariff];
            if (self.moneyArr.count > 0) {
                VEVIPMoneyModel *subModel = self.moneyArr[0];
                subModel.ifSelect = YES;
            }
            [self.tableView reloadData];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.allowsSelection = NO;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView registerClass:[VEVipMainUserDataCell class] forCellReuseIdentifier:VEVipMainUserDataCellStr];
        [_tableView registerClass:[VEVipPackageCell class] forCellReuseIdentifier:VEVipPackageCellStr];
        [_tableView registerClass:[VEVipFeaturesListCell class] forCellReuseIdentifier:VEVipFeaturesListCellStr];
        [_tableView registerClass:[VEVipExplanationCell class] forCellReuseIdentifier:VEVipExplanationCellStr];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if ([LMUserManager sharedManger].isLogin) {
            return 1;
        }
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([LMUserManager sharedManger].isLogin) {
            return [VEVipMainUserDataCell cellHeight];
        }
        return CGFLOAT_MIN;
    }else if(indexPath.section == 1){
        return [VEVipPackageCell cellHeight];
    }else if(indexPath.section == 2){
        return [VEVipFeaturesListCell cellHeight];
    }
    return [VEVipExplanationCell cellHeightIndex:indexPath.section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4) {
        return CGFLOAT_MIN;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *footV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footID"];
    if (!footV) {
        footV = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"footID"];
    }
    footV.contentView.backgroundColor = MAIN_NAV_COLOR;
    return footV;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headID"];
    if (!headV) {
        headV = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"headID"];
    }
    return headV;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self headCellTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    if (indexPath.section == 1) {
        return [self moneyCellTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    if (indexPath.section == 2) {
        return [self enumCellTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return [self explanationCellTableView:tableView cellForRowAtIndexPath:indexPath];
}

//顶部用户数据的cell
- (UITableViewCell *)headCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VEVipMainUserDataCell *cell = [tableView dequeueReusableCellWithIdentifier:VEVipMainUserDataCellStr];
    if (!cell) {
        cell = [[VEVipMainUserDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEVipMainUserDataCellStr];
    }
    [cell changeVipState];
    return cell;
}

//中间金额的cell
- (UITableViewCell *)moneyCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VEVipPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:VEVipPackageCellStr];
    if (!cell) {
        cell = [[VEVipPackageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEVipPackageCellStr];
    }
    if (cell.moneyArr.count < 1) {
        cell.moneyArr = self.moneyArr;
    }
    
    @weakify(self);
    cell.clickSureBtnBlock = ^(VEVIPMoneyModel * _Nonnull selectModel) {
        @strongify(self);
        [self clickSureShopBtn:selectModel];
    };
    return cell;
}

//功能菜单的cell
- (UITableViewCell *)enumCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VEVipFeaturesListCell *cell = [tableView dequeueReusableCellWithIdentifier:VEVipFeaturesListCellStr];
    if (!cell) {
        cell = [[VEVipFeaturesListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEVipFeaturesListCellStr];
    }
    return cell;
}

//说明的cell
- (UITableViewCell *)explanationCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VEVipExplanationCell *cell = [tableView dequeueReusableCellWithIdentifier:VEVipExplanationCellStr];
    if (!cell) {
        cell = [[VEVipExplanationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEVipExplanationCellStr];
    }
    [cell creatContentWithIndex:indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    cell.backgroundColor = self.view.backgroundColor;
}

- (void)clickRightBtn{
    if ([LMUserManager sharedManger].isLogin) {
        VEVIPRecordingViewController *vc = [VEVIPRecordingViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self showLoginView];
    }
}

/// 弹出登录框
- (void)showLoginView{
    VEUserLoginPopupView *loginView = [[VEUserLoginPopupView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:loginView];
}

/// 进行内购
- (void)clickSureShopBtn:(VEVIPMoneyModel *)model{
    //判断是否登录
    if (![LMUserManager sharedManger].isLogin) {
        VEUserLoginPopupView *loginView = [[VEUserLoginPopupView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        [win addSubview:loginView];
        @weakify(self);
        loginView.userLoginSucceedBlock = ^{
            @strongify(self);
            [self payVipWithModel:model];
        };
    }else{
        [self payVipWithModel:model];
//        [self paySucceed];
    }
}

- (void)payVipWithModel:(VEVIPMoneyModel *)model{
    self.selectModel = model;
    [MBProgressHUD showMessage:@"加载中..."];
      [VEUserApi pushVipWithID:model.moneyID paytype:@"4" payMouth:[NSString stringWithFormat:@"%zd",self.comeType] Completion:^(LMVIPMoneyPushModel *  _Nonnull result) {
          [MBProgressHUD hideHUD];
          if (result.state.intValue == 1) {
              [[VEPayApiHandle sharedHPPHandle] buyAppProduct:model.appleTariff orderNum:result.goodsid];
          }else{
              [MBProgressHUD showError:model.errorMsg];
          }
  
      } failure:^(NSError * _Nonnull error) {
          [MBProgressHUD hideHUD];
          [MBProgressHUD showError:VENETERROR];
      }];
}


- (void)paySucceed{
    VEUserModel *model = [LMUserManager sharedManger].userInfo;
    model.vipState = @"1";
    [[LMUserManager sharedManger]archiverUserInfo:model];
    [[LMUserManager sharedManger]unArchiverUserInfo];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UserVipStateChange" object:nil];

    VEVipSucceedViewController *vc = [VEVipSucceedViewController new];
    vc.model = self.selectModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)payFail{
    VEVipFailureViewController *vc = [VEVipFailureViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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
