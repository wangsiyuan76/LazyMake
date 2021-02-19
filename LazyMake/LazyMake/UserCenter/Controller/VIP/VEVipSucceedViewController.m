//
//  VEVipSucceedViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVipSucceedViewController.h"
#import "VEVIPSucceedEnumListCell.h"
#import "VEVIPSucceedHeadView.h"
#import "VEVIPSucceedPopupView.h"

@interface VEVipSucceedViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) VEVIPSucceedHeadView *headView;

@end

@implementation VEVipSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    //self.navigationController.navigationBar.topItem.title = @"";
    self.title = @"充值结果";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self loadData];
    [self createPopupView];
    // Do any additional setup after loading the view.
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.allowsSelection = NO;
        [_tableView registerClass:[VEVIPSucceedEnumListCell class] forCellReuseIdentifier:VEVIPSucceedEnumListCellStr];
        _tableView.tableHeaderView = self.headView;
    }
    return _tableView;
}

- (VEVIPSucceedHeadView *)headView{
    if (!_headView) {
        _headView = [[VEVIPSucceedHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
        _headView.backgroundColor = self.view.backgroundColor;
    }
    return _headView;
}

/// 弹出成功的提示框
- (void)createPopupView{
    VEVIPSucceedPopupView *popV = [[VEVIPSucceedPopupView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:popV];
    
    if ([LMUserManager sharedManger].userInfo.vipState.intValue == 1) {
        popV.titleLab.text = @"恭喜您，成为VIP会员";
    }else{
        NSMutableAttributedString *attrName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@，成为VIP会员",[LMUserManager sharedManger].userInfo.nickname]];
        UIColor *color = [UIColor colorWithHexString:@"#1DABFD"];
        [attrName addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,[LMUserManager sharedManger].userInfo.nickname.length)];
        popV.titleLab.attributedText = attrName;
    }
    
    
    if ([self.model.endNum isNotBlank]) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"截止%@到期",self.model.endNum]];
        UIColor *color = [UIColor colorWithHexString:@"E70000"];
        [attrString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(2,10)];
        popV.endTimeLab.attributedText = attrString;
    }
}

- (void)loadData{
    self.listData = [NSMutableArray new];
    NSArray *titleArr = @[@"购买期限",@"充值方式",@"支付时间",@"到期时间"];
    for (int x = 0; x < titleArr.count; x++) {
        VEVipShopSucceedModel *model = [VEVipShopSucceedModel new];
        model.titleStr = titleArr[x];
        model.isBlue = NO;
        if (x == 0) {
            model.contentStr = self.model.timeStr;
        }else if(x == 1){
            model.contentStr = @"苹果内购";
        }else if(x == 2){
            model.contentStr = [VETool getCurrentTimesFormat:@"YYYY-MM-dd HH:mm:ss"];
        }else if (x == 3){
            model.contentStr = self.model.endNum;
            model.isBlue = YES;
        }
        [self.listData addObject:model];
    }
    
    self.headView.imageView.image = [UIImage imageNamed:@"vm_check_successful"];
    self.headView.titleLab.text = [NSString stringWithFormat:@"￥%@",self.model.moneyStr];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [VEVIPSucceedEnumListCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VEVIPSucceedEnumListCell *cell = [tableView dequeueReusableCellWithIdentifier:VEVIPSucceedEnumListCellStr];
    if (!cell) {
        cell = [[VEVIPSucceedEnumListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEVIPSucceedEnumListCellStr];
    }
    if (self.listData.count > indexPath.row) {
        cell.model = self.listData[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
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
