//
//  VEUserPhoneLoginViewConteroller.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/18.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserPhoneLoginViewConteroller.h"
#import "VEWebTermsViewController.h"
#import "VEUserApi.h"

#define PUSH_BTN_SIZE  CGSizeMake(296, 38)

@interface VEUserPhoneLoginViewConteroller () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *phoneText;
@property (strong, nonatomic) UITextField *passwordText;
@property (strong, nonatomic) UIButton *doneBtn;
@property (strong, nonatomic) YYLabel *explanationText;

@end

@implementation VEUserPhoneLoginViewConteroller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    self.title = @"手机登录";
    [self.view addSubview:self.phoneText];
    [self.view addSubview:self.passwordText];
    [self.view addSubview:self.doneBtn];
    [self.view addSubview:self.explanationText];
    
    @weakify(self);
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(PUSH_BTN_SIZE);
        make.top.mas_equalTo(self.passwordText.mas_bottom).mas_offset(40);
    }];
    
    [self.explanationText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.doneBtn.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(-20);
    }];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.passwordText resignFirstResponder];
    [self.phoneText resignFirstResponder];
}

- (UITextField *)phoneText{
    if (!_phoneText) {
        _phoneText = [[UITextField alloc]initWithFrame:CGRectMake(15, 10 + Height_NavBar, kScreenWidth - 30, 40)];
        _phoneText.keyboardType = UIKeyboardTypeNumberPad;
        _phoneText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号"attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#ffffff"]}];

        
        _phoneText.font = [UIFont systemFontOfSize:15];
        _phoneText.textColor = [UIColor colorWithHexString:@"ffffff"];
        _phoneText.backgroundColor = MAIN_NAV_COLOR;
        _phoneText.delegate = self;
        _phoneText.clearButtonMode = UITextFieldViewModeAlways;

    }
    return _phoneText;
}

- (UITextField *)passwordText{
    if (!_passwordText) {
        _passwordText = [[UITextField alloc]initWithFrame:CGRectMake(15, 70 + Height_NavBar, kScreenWidth - 30, 40)];
        
        _passwordText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码"attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#ffffff"]}];        
        _passwordText.font = [UIFont systemFontOfSize:15];
        _passwordText.textColor = [UIColor colorWithHexString:@"ffffff"];
        _passwordText.backgroundColor = MAIN_NAV_COLOR;
        _passwordText.delegate = self;
        _passwordText.clearButtonMode = UITextFieldViewModeAlways;

    }
    return _passwordText;
}

- (UIButton *)doneBtn{
    if (!_doneBtn) {
        _doneBtn = [UIButton new];
        [_doneBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _doneBtn.layer.masksToBounds = YES;
        _doneBtn.layer.cornerRadius = 19;
        [_doneBtn addTarget:self action:@selector(clickPushBtn) forControlEvents:UIControlEventTouchUpInside];
        UIImage *iamge = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:PUSH_BTN_SIZE];
        [_doneBtn setBackgroundImage:iamge forState:UIControlStateNormal];
    }
    return _doneBtn;
}

-(YYLabel *)explanationText{
    if (!_explanationText) {
        _explanationText = [YYLabel new];
        _explanationText.numberOfLines = 0;
        _explanationText.preferredMaxLayoutWidth = kScreenWidth - 40;
        _explanationText.textAlignment = NSTextAlignmentCenter;
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#A1A7B2"]};
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"登录即视为同意懒人制作《用户协议》和 《隐私政策》" attributes:attributes];
        //设置高亮色和点击事件
        @weakify(self);
        [text setTextHighlightRange:[[text string] rangeOfString:@"《用户协议》"] color:[UIColor colorWithHexString:@"#1DABFD"] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            [self pushWebProtocolIfPrivacy:NO];
        }];
        
        [text setTextHighlightRange:[[text string] rangeOfString:@"《隐私政策》"] color:[UIColor colorWithHexString:@"#1DABFD"] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
             [self pushWebProtocolIfPrivacy:YES];
         }];
        _explanationText.attributedText = text;
        _explanationText.textAlignment = NSTextAlignmentCenter;
    }
    return _explanationText;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)clickPushBtn{
    if (self.phoneText.text.length == 11) {
        if (self.passwordText.text.length > 0) {
            [MBProgressHUD showMessage:@"登录中..."];
            [VEUserApi phoneLoginForAppWithModel:self.phoneText.text password:self.passwordText.text Completion:^(VEUserModel *  _Nonnull result) {
                [MBProgressHUD hideHUD];
                if (result.state.intValue == 1) {
                    [[LMUserManager sharedManger]archiverUserInfo:result];
                    [[LMUserManager sharedManger]unArchiverUserInfo];
                    [[NSNotificationCenter defaultCenter]postNotificationName:USERLOGINSUCCEED object:nil];
                    if (self.userLoginSucceedBlock) {
                        self.userLoginSucceedBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [MBProgressHUD showError:result.errorMsg];
                }
            } failure:^(NSError * _Nonnull error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:VENETERROR];
            }];
        }else{
            [MBProgressHUD showError:@"请输入密码"];
        }
    }else{
        [MBProgressHUD showError:@"手机格式不正确"];
    }
}


- (void)pushWebProtocolIfPrivacy:(BOOL)IfPrivacy{
    VEWebTermsViewController *webVC = [VEWebTermsViewController new];
    webVC.hidesBottomBarWhenPushed = YES;
    if (IfPrivacy) {
        webVC.loadUrl = WEB_PRIVACY_URL;
        webVC.title = @"隐私政策";
    }else{
        webVC.loadUrl = WEB_PROTOCOL_URL;
        webVC.title = @"用户协议";
    }
    [currViewController().navigationController pushViewController:webVC animated:YES];
    @weakify(self);
    webVC.backBlock = ^{
        @strongify(self);
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
