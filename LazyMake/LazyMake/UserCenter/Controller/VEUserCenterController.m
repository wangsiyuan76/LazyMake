//
//  VEUserCenterController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserCenterController.h"
#import "VEUserCenterHeadView.h"
#import "VEUserCenterTitleSubView.h"
#import "VEUserWorksListCell.h"
#import "VEUserCenterEnumModel.h"
#import "VEUserCenterEnumCell.h"
#import "VEVipMainViewController.h"
#import "VEUserSeetingViewController.h"
#import "VEUserFeedbackViewController.h"
#import "VEUserLoginPopupView.h"
#import "VEUserDataViewController.h"
#import "VEUserApi.h"
#include <objc/runtime.h>
#import "VEUserWorksListViewController.h"
#import "VEUserMessageListViewController.h"
#import "VEUserCenterDataModel.h"

#import "ZZGestureLockView.h"
#import "GXCardView.h"
#import "RFTagCloudView.h"
@interface VEUserCenterController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) VEUserCenterHeadView *headView;           //顶部的用户信息
@property (strong, nonatomic) NSMutableArray *enumArr;                  //底部更多功能数组
@property (strong, nonatomic) NSArray *worksList;                       //用户作品数组
@property (nonatomic, assign) BOOL hasChangeSelect;

@end

@implementation VEUserCenterController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.hasChangeSelect) {
        self.tabBarController.selectedIndex = 1;
        self.hasChangeSelect = NO;
    }
    self.navigationController.navigationBarHidden = YES;
    [self updateVipState];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadUserCenterData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadUserWorksList) name:LoadUserWorks object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadAllData) name:USERLOGINSUCCEED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushDataSucceed) name:PushDataSucceed object:nil];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(-Height_StatusBar, 0, 0, 0));
    }];
    [self createEnumData];
    [self checkUserTokenOut];
    [self loadUserWorksList];
    
    /*other  -------other*/
    [self addOtherZZGestureLockView];
    [self addOtherGXCardView];
    [self addOtherRFTagCloudView];
    // Do any additional setup after loading the view.
}

- (void)pushDataSucceed{
    self.hasChangeSelect = YES;
}

//请求我的作品列表
- (void)loadUserWorksList{
    if ([LMUserManager sharedManger].isLogin) {
        [MBProgressHUD showMessage:@"加载中..."];
        [VEUserApi loadUserWorks:1 Completion:^(VEBaseModel *  _Nonnull result) {
            [MBProgressHUD hideHUD];
            if (result.state.intValue == 1) {
                self.worksList = result.resultArr;
                [self.tableView reloadData];
            }else{
                [MBProgressHUD showError:result.errorMsg];
            }
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:VENETERROR];
        }];
    }
}

//加载个人中心数据
- (void)loadUserCenterData{
    if ([LMUserManager sharedManger].isLogin) {
        [VEUserApi loadUserCenterDataCompletion:^(VEUserCenterDataModel *  _Nonnull result) {
            if (result.state.intValue == 1) {
                VEUserModel *model = [LMUserManager sharedManger].userInfo;
                model.nickname = result.nickname;
                model.endDay = result.end_day;
                model.avatar = result.avatar;
                model.vipState = result.vip_state;
                model.trialPeriod = result.trial_period;
                [[LMUserManager sharedManger]archiverUserInfo:model];
                [[LMUserManager sharedManger]unArchiverUserInfo];
                //小红点逻辑
                if (self.enumArr.count > 0 ) {
                    for (int x = 0; x < self.enumArr.count; x++) {
                        VEUserCenterEnumModel *model = self.enumArr[x];
                        if ([model.titleStr containsString:@"反馈"]) {
                            if (result.feedback_dot.intValue > 0) {
                                model.isRed = YES;
                            }else{
                                model.isRed = NO;
                            }
                            [self.enumArr replaceObjectAtIndex:x withObject:model];
                        }else if ([model.titleStr containsString:@"消息"]) {
                            if (result.live_msg.intValue > 0) {
                                model.isRed = YES;
                            }else{
                                model.isRed = NO;
                            }
                            [self.enumArr replaceObjectAtIndex:x withObject:model];
                        }
                    }
                }
                [self.headView reloadData];
                [self.tableView reloadData];
            }else{
                if (result.state.intValue == 401) {
                    [MBProgressHUD showError:result.errorMsg];
                }
            }
        } failure:^(NSError * _Nonnull error) {
        }];
    }else{
        if (self.enumArr.count > 0 ) {
             for (int x = 0; x < self.enumArr.count; x++) {
                 VEUserCenterEnumModel *model = self.enumArr[x];
                 if ([model.titleStr containsString:@"反馈"]) {
                     model.isRed = NO;
                     [self.enumArr replaceObjectAtIndex:x withObject:model];
                 }else if ([model.titleStr containsString:@"消息"]) {
                     model.isRed = NO;
                     [self.enumArr replaceObjectAtIndex:x withObject:model];
                 }
             }
         }
        if (self.worksList.count > 0) {
            self.worksList = [NSArray new];
        }
        [self.tableView reloadData];
    }
}

/// 弹出登录框
- (void)showUserLoginView{
    VEUserLoginPopupView *loginView = [[VEUserLoginPopupView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:loginView];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headView;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView registerClass:[VEUserCenterTitleSubView class] forHeaderFooterViewReuseIdentifier:VEUserCenterTitleSubViewStr];
        [_tableView registerClass:[VEUserWorksListCell class] forCellReuseIdentifier:VEUserWorksListCellStr];
        [_tableView registerClass:[VEUserCenterEnumCell class] forCellReuseIdentifier:VEUserCenterEnumCellStr];
        
        UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        footV.backgroundColor = self.view.backgroundColor;
        _tableView.tableFooterView = footV;
    }
    return _tableView;
}

- (VEUserCenterHeadView *)headView{
    if (!_headView) {
        _headView = [[VEUserCenterHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
        _headView.backgroundColor = self.view.backgroundColor;
        @weakify(self);
        _headView.clickVIPBtnBlock = ^{
            @strongify(self);
            [self pushToVIPVC];
        };
        
        _headView.clickUserDataBtnBlock = ^{
            @strongify(self);
            if ([LMUserManager sharedManger].isLogin) {
                VEUserDataViewController *vc = [VEUserDataViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self showUserLoginView];
            }
        };
    }
    return _headView;
}

/// 创建底部菜单功能数据
- (void)createEnumData{
    self.enumArr = [NSMutableArray new];
    NSArray *titleArr = @[@"VIP会员",@"意见反馈",@"消息通知",@"一键加群",@"设置"];
    NSArray *imageArr = @[@"vm_homepage_my_vip",@"vm_homepage_my_idea",@"vm_home4_message",@"vm_homepage_my_qq",@"vm_homepage_my_set"];
    NSString *numStr = [[NSUserDefaults standardUserDefaults]objectForKey:PhoneCloseLogin];
    if (numStr.intValue == 1) {
        titleArr = @[@"VIP会员",@"意见反馈",@"消息通知",@"设置"];
        imageArr = @[@"vm_homepage_my_vip",@"vm_homepage_my_idea",@"vm_home4_message",@"vm_homepage_my_set"];
    }
    for (int x = 0; x < titleArr.count; x++) {
        VEUserCenterEnumModel *model = [VEUserCenterEnumModel new];
        model.titleStr = titleArr[x];
        model.imageStr = imageArr[x];
        model.isRed = NO;
        if (x == 2) {               //群聊信息
//            model.isRed = YES;
        }
        if (x == 0) {
            model.rightTitle = @"去开通";
            model.rightColor = @"1DABFD";
        }
        if (x == 3) {
            if (numStr.intValue != 1) {
                NSString *numStr = [[NSUserDefaults standardUserDefaults]objectForKey:QQGroupNumber];
                model.rightTitle = numStr?:@"24136852";
                model.rightColor = @"A1A7B2";
            }
        }
        [self.enumArr addObject:model];
    }
    [self.tableView reloadData];
}

/// 更新会员状态
- (void)updateVipState{
    if (self.enumArr.count > 0 ) {
        for (int x = 0; x < self.enumArr.count; x++) {
            VEUserCenterEnumModel *model = self.enumArr[x];
            if ([model.titleStr containsString:@"会员"]) {
                if ([LMUserManager sharedManger].userInfo.vipState.intValue == 0) {
                    model.rightTitle = @"去开通";
                    model.rightColor = @"1DABFD";
                }else if ([LMUserManager sharedManger].userInfo.vipState.intValue == 1){
                    model.rightTitle = @"已开通";
                    model.rightColor = @"#A1A7B2";
                }else if ([LMUserManager sharedManger].userInfo.vipState.intValue == 2){
                    model.rightTitle = @"已过期";
                    model.rightColor = @"1DABFD";
                }
                [self.enumArr replaceObjectAtIndex:x withObject:model];
                break;
            }
        }
    }
    [self.headView reloadData];
    [self.tableView reloadData];
}

- (void)loadAllData{
    [self loadUserCenterData];
    [self updateVipState];
    [self loadUserWorksList];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.worksList.count < 1) {
            return CGFLOAT_MIN;
        }
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.worksList.count < 1) {
            return CGFLOAT_MIN;
        }
        return [VEUserWorksListCell cellHeight];
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    VEUserCenterTitleSubView *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:VEUserCenterTitleSubViewStr];
    headV.contentView.backgroundColor = self.view.backgroundColor;
    if (!headV) {
        headV = [[VEUserCenterTitleSubView alloc]initWithReuseIdentifier:VEUserCenterTitleSubViewStr];
    }
    if (section == 0) {
        headV.titleLab.text = @"我的作品";
        headV.rightBtn.hidden = NO;
    }else{
        headV.titleLab.text = @"其他服务";
        headV.rightBtn.hidden = YES;
    }
    if (self.worksList.count < 1) {
        headV.titleLab.text = @"";
        headV.rightBtn.hidden = YES;
    }
    @weakify(self);
    headV.clickRightBtnBlock = ^{
        @strongify(self);
        if ([LMUserManager sharedManger].isLogin) {
            VEUserWorksListViewController *worksVC = [[VEUserWorksListViewController alloc]init];
            worksVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:worksVC animated:YES];
        }
    };
    return headV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.worksList.count < 1) {
            return 0;
        }
        return 1;
    }
    return self.enumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        VEUserWorksListCell *cell = [tableView dequeueReusableCellWithIdentifier:VEUserWorksListCellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[VEUserWorksListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEUserWorksListCellStr];
        }
        cell.worksList = self.worksList;
        return cell;
    }else{
        VEUserCenterEnumCell *cell = [tableView dequeueReusableCellWithIdentifier:VEUserCenterEnumCellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[VEUserCenterEnumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEUserCenterEnumCellStr];
        }
        if (self.enumArr.count > indexPath.row) {
            cell.model = self.enumArr[indexPath.row];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = self.view.backgroundColor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {               //会员中心
            [self pushToVIPVC];
        }
        else if (indexPath.row == 1) {               //意见反馈
            VEUserFeedbackViewController *vc = [VEUserFeedbackViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            if (self.enumArr.count > indexPath.row) {
                VEUserCenterEnumModel *subModel = self.enumArr[indexPath.row];
                vc.hasRed = subModel.isRed;
            }
        }
        else if (indexPath.row == 2) {               //通知消息
            if ([LMUserManager sharedManger].isLogin) {
                VEUserMessageListViewController *vc = [[VEUserMessageListViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self showUserLoginView];
            }
        }
        else if (indexPath.row == 3) {               //一键加群
            NSString *numStr = [[NSUserDefaults standardUserDefaults]objectForKey:PhoneCloseLogin];
            if (numStr.intValue == 1) {
                VEUserSeetingViewController *vc = [VEUserSeetingViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self pushQQ];
            }
        }
        else if (indexPath.row == 4) {               //设置
            VEUserSeetingViewController *vc = [VEUserSeetingViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 0){
        if ([LMUserManager sharedManger].isLogin) {
            VEUserWorksListViewController *worksVC = [[VEUserWorksListViewController alloc]init];
            [self.navigationController pushViewController:worksVC animated:YES];
        }
    }
}

///跳转VIP页面
- (void)pushToVIPVC{
    VEVipMainViewController *vc = [VEVipMainViewController new];
    vc.comeType = VipMouthType_UserCenter;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 验证用户信息是否过期
- (void)checkUserTokenOut{
    if ([LMUserManager sharedManger].isLogin) {
        [VEUserApi checkUserTokenCompletion:^(VEBaseModel *  _Nonnull result) {
            if (result.state.intValue < 1) {
                [[LMUserManager sharedManger]removeUserData];
                [self showUserLoginView];
            }else{
                [self.headView reloadData];
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)pushQQ{
    NSString *numStr = [[NSUserDefaults standardUserDefaults]objectForKey:QQGroupNumber];
    NSString *keyStr = [[NSUserDefaults standardUserDefaults]objectForKey:QQGroupNumberKey];
    NSString *qq_number = numStr?:@"24136853";
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", qq_number,keyStr];
    
//    NSString *qq=[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qq_number];
    NSURL *url = [NSURL URLWithString:urlStr];
   [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
}

#pragma mark - Other
- (void)addOtherZZGestureLockView{
    //add lockview
    ZZGestureLockView *lockView = [[ZZGestureLockView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-245)/2.0, 150, 245, 245)];
    lockView.itemWidth = 60;
    lockView.miniPasswordLength = 4;
    lockView.normalLineColor = [UIColor colorWithRed:252/255.0 green:222/255.0 blue:117/255.0 alpha:1];
    lockView.warningLineColor = [UIColor colorWithRed:249/255.0 green:78/255.0 blue:92/255.0 alpha:1];
//     lockView.delegate = self;
     //add label
     UILabel *resultLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
     resultLabel.center = CGPointMake(([UIScreen mainScreen].bounds.size.width)/2.0, [UIScreen mainScreen].bounds.size.height-150);
     resultLabel.font = [UIFont systemFontOfSize:16];
     resultLabel.textAlignment = NSTextAlignmentCenter;
     resultLabel.text = @"密码：";
}

- (void)addOtherGXCardView{
    GXCardView *cardView = [[GXCardView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    cardView.visibleCount = 5;
    cardView.lineSpacing = 15.0;
    cardView.interitemSpacing = 10.0;
    cardView.maxAngle = 15.0;
    cardView.maxRemoveDistance = 100.0;
    //    self.cardView.isRepeat = YES; // 新加入
    [cardView registerNib:[UINib nibWithNibName:NSStringFromClass([GXCardViewCell class]) bundle:nil] forCellReuseIdentifier:@"GXCardViewCell"];
    [cardView reloadData];
}

- (void)addOtherRFTagCloudView{
    NSArray *colorArray=@[[UIColor redColor],[UIColor blackColor],[UIColor yellowColor],[UIColor grayColor],[UIColor greenColor],[UIColor orangeColor],[UIColor cyanColor],[UIColor cyanColor],[UIColor purpleColor]];
    NSArray *words = @[@"北京",@"火影忍者",@"足球小子",@"超人",@"葫芦娃大战蜘蛛精",@"super man",@"welcome to china",@"上海",@"海贼王",@"会说话的汤姆猫",@"大头儿子小头爸爸",@"少林足球",@"妖精的尾巴",@"咸蛋超人",@"蜘蛛侠",@"葫芦娃",@"北京",@"火影忍者",@"足球小子",@"超人",@"葫芦娃大战蜘蛛精",@"super man",];
    
    RFTagCloudView *tagView = [[RFTagCloudView alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
    [tagView drawCloudWithWords:words colors:colorArray rowHeight:30];
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
