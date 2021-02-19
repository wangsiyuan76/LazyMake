//
//  VEUserSeetingViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserSeetingViewController.h"
#import "VEUserSeetingCell.h"
#import "VEWebTermsViewController.h"
#import "VEHomeShareView.h"
#import "VEAlertView.h"

@interface VEUserSeetingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *listArr;

@end

@implementation VEUserSeetingViewController

- (void)dealloc{
    LMLog(@"LMUserSeetingViewControlle释放");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_NAV_COLOR;
    //self.navigationController.navigationBar.topItem.title = @"";
    self.title = @"设置";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self createData];
    // Do any additional setup after loading the view.
}

- (void)createData{
    self.listArr = @[/*@[@"推荐给好友",@"给懒人制作好评"],*/@[@"清除缓存",@"用户协议",@"隐私政策",@"当前版本"]];
    [self.tableView reloadData];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView registerClass:[VEUserSeetingCell class] forCellReuseIdentifier:VEUserSeetingCellStr];
        
        if ([LMUserManager sharedManger].isLogin) {
            _tableView.tableFooterView = [self createFootView];
        }
    }
    return _tableView;
}

- (UIView *)createFootView{
    UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    footV.backgroundColor = MAIN_BLACK_COLOR;
    
    UIButton *qutBtn = [UIButton new];
    qutBtn.backgroundColor = [UIColor clearColor];
    [qutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [qutBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    qutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [qutBtn addTarget:self action:@selector(clickQuitBtn) forControlEvents:UIControlEventTouchUpInside];
    [footV addSubview:qutBtn];
    [qutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    return footV;
}

- (void)clickQuitBtn{
    [self quitLogin];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.listArr[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [VEUserSeetingCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
    VEUserSeetingCell *cell = [tableView dequeueReusableCellWithIdentifier:VEUserSeetingCellStr];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentLab.hidden = YES;
    if (!cell) {
        cell = [[VEUserSeetingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEUserSeetingCellStr];
    }
    if (self.listArr.count > indexPath.section) {
        NSArray *arr = self.listArr[indexPath.section];
        if (arr.count > indexPath.row) {
            NSString *str = arr[indexPath.row];
            cell.titleLab.text = str;
            
            //缓存
            if ([str containsString:@"缓存"]) {
                cell.contentLab.hidden = NO;
                cell.contentLab.text = [NSString stringWithFormat:@"%.2fM",[VETool getCacheSize]];
            }
            
            //版本号
            if ([str containsString:@"版本"]) {
                cell.contentLab.hidden = NO;
                cell.contentLab.text = [NSString stringWithFormat:@"V%@",[VETool versionNumber]];
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = MAIN_BLACK_COLOR;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.listArr.count > indexPath.section) {
          NSArray *arr = self.listArr[indexPath.section];
          if (arr.count > indexPath.row) {
              NSString *str = arr[indexPath.row];
              //缓存
              if ([str containsString:@"缓存"]) {
                  [VETool clearFile];
                  [self.tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationFade];
              }
              //用户协议
              else if ([str containsString:@"协议"]) {
                  [self pushTopProtocolWebVCIfPrivacy:NO];
              }
              //隐私政策
              else if ([str containsString:@"隐私"]) {
                  [self pushTopProtocolWebVCIfPrivacy:YES];
              }
              //版本号
              else if ([str containsString:@"版本"]) {
  
              } //推荐给好友
              else if ([str containsString:@"推荐"]) {
                  [self showShareView];
               }
              //好评
              else if ([str containsString:@"好评"]) {
                NSString *itunesurl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8&action=write-review",@"1509907084"];
//                  NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    NSURL *url = [NSURL URLWithString:itunesurl];
                [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
              }
          }
      }
}

/// 弹出分享框shareView
- (void)showShareView{
    VEHomeShareView *shareView = [[VEHomeShareView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    VEHomeTemplateModel *model = [[VEHomeTemplateModel alloc]init];
    model.shareUrl = @"https://share.bizhijingling.com/jingling/lazy/";
    model.shareDes = @"我在懒人视频制作发现一个好看的视频模板，快跟我一起制作吧~";
    model.title = @"懒人视频制作";
    model.thumb = @"https://vp.bizhijingling.com/statics/dynamic/images/lazy_logo.png";
    shareView.showModel = model;
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:shareView];
    [shareView show];
}

- (void)pushTopProtocolWebVCIfPrivacy:(BOOL)IfPrivacy{
    VEWebTermsViewController *webVC = [VEWebTermsViewController new];
    webVC.hidesBottomBarWhenPushed = YES;
    if(IfPrivacy){
        webVC.loadUrl = WEB_PRIVACY_URL;
        webVC.title = @"隐私政策";
    }else{
        webVC.loadUrl = WEB_PROTOCOL_URL;
        webVC.title = @"用户协议";
    }
    [self.navigationController pushViewController:webVC animated:YES];
}

//退出登录
- (void)quitLogin{
    VEAlertView *ale = [[VEAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [ale setContentStr:@"确定退出账号吗？"];
    [win addSubview:ale];
    @weakify(self);
    ale.clickSubBtnBlock = ^(NSInteger btnTag) {
        @strongify(self);
        if (btnTag == 1) {
            [[LMUserManager sharedManger] removeUserData];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:USERLOGINSUCCEED object:nil];
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
