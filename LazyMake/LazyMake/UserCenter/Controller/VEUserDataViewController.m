//
//  VEUserDataViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserDataViewController.h"
#import "VEUserSeetingCell.h"
#import "VEUserSignatureViewController.h"
#import "VEUserNameViewController.h"
#import "VEUserApi.h"
#import "TZImagePickerController.h"
#import "VEUserApi.h"
#import "VEUserSafetyCenterController.h"
#import "VEAlertSheetView.h"

@interface VEUserDataViewController ()<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *listArr;

@end

@implementation VEUserDataViewController

- (void)dealloc{
    LMLog(@"VEUserDataViewController 释放");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_NAV_COLOR;
    //self.navigationController.navigationBar.topItem.title = @"";
    self.title = @"个人资料";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self createData];
    // Do any additional setup after loading the view.
}

- (void)createData{
    self.listArr = @[@[@"头像"],@[@"UID",@"登录账号",@"昵称",@"性别",@"个性签名"],@[@"安全中心"]];
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
    }
    return _tableView;
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
    if (indexPath.section == 0) {
        return 60;
    }
    return [VEUserSeetingCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
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
            cell.iconImage.hidden = YES;
            [cell showArrowImage:NO];
            cell.contentLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
            if (indexPath.section == 0) {
                [cell setUserIconWithImageUrl:[LMUserManager sharedManger].userInfo.avatar];
            }else if(indexPath.section == 1){
                cell.contentLab.hidden = NO;
                if (indexPath.row == 0) {
                    cell.contentLab.text = [LMUserManager sharedManger].userInfo.userid;
                    [cell showArrowImage:YES];
                }else if (indexPath.row == 1) {
                    cell.contentLab.text = [LMUserManager sharedManger].userInfo.mobile;
                    [cell showArrowImage:YES];
                }else if(indexPath.row == 2){
                    cell.contentLab.text = [LMUserManager sharedManger].userInfo.nickname;
                }else if(indexPath.row == 3){
                    cell.contentLab.text = [LMUserManager sharedManger].userInfo.sexStr;
                }else if(indexPath.row == 4){
                    if ([[LMUserManager sharedManger].userInfo.signature isNotBlank]) {
                        cell.contentLab.text = [LMUserManager sharedManger].userInfo.signature;
                    }else{
                        cell.contentLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
                        cell.contentLab.text = @"请输入内容";
                    }
                }
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = MAIN_BLACK_COLOR;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {                   //头像
        [self changePhoto];
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {                   //登录方式
            
        }else if (indexPath.row == 2){              //昵称
            [self pushToUserNickNameVC];
        }else if (indexPath.row == 3){              //性别
            [self changeSex];
        }else if (indexPath.row == 4) {             //个性签名
            [self pushToUserSignVC];
        }
    }else{
        [self pushSafetyCenter];
    }
}

/// 跳转修改个人签名
- (void)pushToUserSignVC{
    VEUserSignatureViewController *vc = [[VEUserSignatureViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    @weakify(self);
    vc.changeSucceedBlock = ^(NSString * _Nonnull content) {
        @strongify(self);
        [self.tableView reloadData];
    };
}

/// 跳转修改个人昵称
- (void)pushToUserNickNameVC{
    VEUserNameViewController *vc = [[VEUserNameViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    @weakify(self);
    vc.changeSucceedBlock = ^(NSString * _Nonnull content) {
        @strongify(self);
        [self.tableView reloadData];
    };
}

//跳转安全中心
- (void)pushSafetyCenter{
    VEUserSafetyCenterController *vc = [[VEUserSafetyCenterController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/// 修改性别
- (void)changeSex{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    VEAlertSheetView *ale = [[VEAlertSheetView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) titleArr:@[@"男",@"女",@"取消"]  titleStr:@""];
    [win addSubview:ale];
    [ale show];
    ale.clickSubBtnBlock = ^(BOOL ifCancle, NSInteger btnTag) {
        if (btnTag == 0) {
            [self changeUserSex:@"1"];
        }else if(btnTag == 1){
            [self changeUserSex:@"2"];
        }
    };
}

//修改性别
- (void)changeUserSex:(NSString *)sexStr{
    [MBProgressHUD showMessage:@"修改中..."];
    [VEUserApi changeUserSex:sexStr Completion:^(VEBaseModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        if (result.state.intValue == 1) {
            [LMUserManager sharedManger].userInfo.sex = sexStr;
            VEUserModel *model = [LMUserManager sharedManger].userInfo;
            model.sex = sexStr;
            [[LMUserManager sharedManger]archiverUserInfo:model];
            [[LMUserManager sharedManger]unArchiverUserInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            [MBProgressHUD showSuccess:@"修改成功"];
        }else{
            [MBProgressHUD showError:result.errorMsg];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
    }];
}

//修改头像
- (void)changePhoto{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.ifUsedTZCrop = YES;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickerVc.customAspectRatio = CGSizeMake(1, 1);
    [currViewController() presentViewController:imagePickerVc animated:YES completion:nil];
    @weakify(self);
    imagePickerVc.noTZCropBlock = ^(UIImage *cropImage) {
        @strongify(self);
        LMLog(@"=====%@",cropImage);
         if (cropImage) {
             [MBProgressHUD showMessage:@"修改中..."];
             [VEUserApi changeUserIcon:cropImage Completion:^(VEBaseModel *  _Nonnull result) {
                 if (!result.isLoading) {
                     [MBProgressHUD hideHUD];
                     if (result.state.intValue == 1) {
                         [LMUserManager sharedManger].userInfo.avatar = result.msg;
                         VEUserModel *model = [LMUserManager sharedManger].userInfo;
                         model.avatar = result.msg;
                         [[LMUserManager sharedManger]archiverUserInfo:model];
                         [[LMUserManager sharedManger]unArchiverUserInfo];
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self.tableView reloadData];
                         });
                     }else{
                         [MBProgressHUD showError:result.errorMsg];
                     }
                 }

             } failure:^(NSError * _Nonnull error) {
                 [MBProgressHUD hideHUD];
                 [MBProgressHUD showError:VENETERROR];
             }];
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
