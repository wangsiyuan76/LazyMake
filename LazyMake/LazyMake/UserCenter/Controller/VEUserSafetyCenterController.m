//
//  VEUserSafetyCenterController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/15.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserSafetyCenterController.h"
#import "VEUserSafetyCenterCell.h"
#import "VEUserSafetyModel.h"
#import "VEUserLogoutPopupView.h"
#import "VEUserApi.h"

@interface VEUserSafetyCenterController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listArr;
@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UIView *footView;

@end

@implementation VEUserSafetyCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_NAV_COLOR;
    self.title = @"注销账号";
       
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self createData];
    // Do any additional setup after loading the view.
}

- (void)createData{
    self.listArr = [NSMutableArray new];
    NSArray *titleArr = @[@"账号处于安全状态",@"账号相关信息处理",@"账号异常问题",@"账号注销成功",@"注销审核及说明"];
    NSArray *contentArr = @[@"最近一个月内账号登录无异常，并且未发生被盗、被封等问题；",@"你账号的个人资料、会员天数等，都将被清理，且无法找回；",@"如发现该账号存在违规违法行为，将无法注销操作（需联系客服人员处理好了才可注销）；",@"注销成功后，重新登录账号将会以新账号的形式注册；",@"审核时间为2－3个工作日，如未生效请联系客服人员；"];

    for (int x = 0; x < titleArr.count; x++) {
        VEUserSafetyModel *model = [[VEUserSafetyModel alloc]init];
        model.titleStr = titleArr[x];
        model.contentStr = contentArr[x];
        model.num = [NSString stringWithFormat:@"%d",x+1];
        [self.listArr addObject:model];
    }
    [self.tableView reloadData];
}

- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    }
    return _headView;
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    }
    return _footView;
}

- (void)createTitleLab{
    UILabel *titLab = [UILabel new];
    titLab.font = [UIFont boldSystemFontOfSize:18];
    titLab.textColor = [UIColor colorWithHexString:@"#1DABFD"];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.text = @"申请注销懒人制作账号";
           
    UILabel *contentLab = [UILabel new];
    contentLab.font = [UIFont systemFontOfSize:15];
    contentLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    contentLab.numberOfLines = 0;
    contentLab.text = @"注销账号将是不可恢复的操作，你应自行备份账号相关信息。在提交注销申请之前，请先了解注销事项：";
    
    UILabel *footLab = [UILabel new];
    footLab.font = [UIFont systemFontOfSize:15];
    footLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    footLab.numberOfLines = 0;
    footLab.text = @"请注意，注销你的懒人制作账号并不代表账号注销前的账号行为和相关责任得到豁免或减轻。";
    
    UIButton *doneBtn = [UIButton new];
    [doneBtn setTitle:@"申请注销" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    doneBtn.layer.masksToBounds = YES;
    doneBtn.layer.cornerRadius = 20;
    [doneBtn addTarget:self action:@selector(clickDoneBtn) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:[VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(290, 40)] forState:UIControlStateNormal];
           
    [_headView addSubview:titLab];
    [_headView addSubview:contentLab];
    [_footView addSubview:footLab];
    [_footView addSubview:doneBtn];
    
    [titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(15);
    }];
    
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(titLab.mas_bottom).mas_offset(16);
    }];
    
    [footLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(0);
    }];
    
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(290, 40));
        make.centerX.mas_equalTo(self.footView.mas_centerX);
        make.top.mas_equalTo(footLab.mas_bottom).mas_offset(30);
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView registerClass:[VEUserSafetyCenterCell class] forCellReuseIdentifier:VEUserSafetyCenterCellStr];
        _tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView = self.footView;
        [self createTitleLab];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    VEUserSafetyModel *model = [self.listArr objectAtIndex:indexPath.row];
    return model.cellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VEUserSafetyCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:VEUserSafetyCenterCellStr];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[VEUserSafetyCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEUserSafetyCenterCellStr];
    }
    cell.model = self.listArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = self.view.backgroundColor;
}

- (void)clickDoneBtn{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    VEUserLogoutPopupView *popV = [[VEUserLogoutPopupView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [win addSubview:popV];
    @weakify(self);
    popV.clickSureBtnBlock = ^(NSString * _Nonnull codeStr) {
        @strongify(self);
        [self loginOut:codeStr];
    };
}

- (void)loginOut:(NSString *)codeStr{
    [MBProgressHUD showMessage:@"注销中..."];
    [VEUserApi loginOutWithCode:codeStr Completion:^(VEBaseModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        if (result.state.intValue == 1) {
            [[LMUserManager sharedManger]removeUserData];
            [[NSNotificationCenter defaultCenter]postNotificationName:USERLOGINSUCCEED object:nil];
            [MBProgressHUD showSuccess:@"注销成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:result.errorMsg];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
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
