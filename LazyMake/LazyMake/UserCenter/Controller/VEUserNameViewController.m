//
//  VEUserNameViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserNameViewController.h"
#import "VEUserApi.h"
#define PUSH_BTN_SIZE  CGSizeMake(296, 38)

@interface VEUserNameViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textView;
@property (strong, nonatomic) UIView *textBackground;
@property (strong, nonatomic) UIButton *pushBtn;

@end

@implementation VEUserNameViewController

 - (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_NAV_COLOR;
     //self.navigationController.navigationBar.topItem.title = @"";
     self.title = @"修改昵称";
    
    [self.view addSubview:self.textBackground];
    [self.textBackground addSubview:self.textView];
    [self.view addSubview:self.pushBtn];
    [self setAllViewLayout];
    // Do any additional setup after loading the view.
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.textBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(Height_NavBar);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
    [self.pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(PUSH_BTN_SIZE);
        make.top.mas_equalTo(self.textBackground.mas_bottom).mas_offset(80);
    }];
}

- (UIView *)textBackground{
    if (!_textBackground) {
        _textBackground = [UIView new];
        _textBackground.backgroundColor = MAIN_BLACK_COLOR;
    }
    return _textBackground;
}

-(UITextField *)textView{
    if (!_textView) {
        _textView = [[UITextField alloc]initWithFrame:CGRectMake(16, 0, kScreenWidth - 32, 60)];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.text = @"请输入新的昵称";
        _textView.textColor = [UIColor colorWithHexString:@"ffffff"];
        _textView.backgroundColor = MAIN_BLACK_COLOR;
        _textView.delegate = self;
        _textView.clearButtonMode = UITextFieldViewModeAlways;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 60)];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setImage:[UIImage imageNamed:@"vm_icon_popover_delete_"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickCleanBtn) forControlEvents:UIControlEventTouchUpInside];
        _textView.rightView = btn;
        _textView.rightViewMode = UITextFieldViewModeAlways;
        
        if ([[LMUserManager sharedManger].userInfo.nickname isNotBlank]) {
            _textView.text = [LMUserManager sharedManger].userInfo.nickname;
        }
    }
    return _textView;
}

- (UIButton *)pushBtn{
    if (!_pushBtn) {
        _pushBtn = [UIButton new];
        [_pushBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_pushBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _pushBtn.layer.masksToBounds = YES;
        _pushBtn.layer.cornerRadius = 19;
        [_pushBtn addTarget:self action:@selector(clickPushBtn) forControlEvents:UIControlEventTouchUpInside];
        UIImage *iamge = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:PUSH_BTN_SIZE];
        [_pushBtn setBackgroundImage:iamge forState:UIControlStateNormal];
    }
    return _pushBtn;
}

- (void)clickCleanBtn{
    self.textView.text = @"";
    [self.textView becomeFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([self.textView.text isEqualToString:@"请输入新的昵称"]) {
        self.textView.text = @"";
    }
    return YES;
}

- (void)clickPushBtn{
    if ([self.textView.text isNotBlank] && ![self.textView.text isEqualToString:@"请输入新的昵称"]) {
        [MBProgressHUD showMessage:@"修改中..."];
        NSString *pushStr = self.textView.text;
        [VEUserApi changeUserNickName:pushStr Completion:^(VEBaseModel *  _Nonnull result) {
            [MBProgressHUD hideHUD];
            if (result.state.intValue == 1) {
                [LMUserManager sharedManger].userInfo.nickname = pushStr;
                VEUserModel *model = [LMUserManager sharedManger].userInfo;
                model.nickname = pushStr;
                [[LMUserManager sharedManger]archiverUserInfo:model];
                [[LMUserManager sharedManger]unArchiverUserInfo];
                if (self.changeSucceedBlock) {
                    self.changeSucceedBlock(pushStr);
                }
                [MBProgressHUD showSuccess:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:result.errorMsg];
            }
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:VENETERROR];
        }];
    }else{
        [MBProgressHUD showError:@"请输入昵称"];
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
