//
//  VEUserFeedbackViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserFeedbackViewController.h"
#import "VEUserMyFeedbackController.h"
#import "VEUserApi.h"
#import "VEUserLoginPopupView.h"
#define PUSH_BTN_SIZE  CGSizeMake(296, 38)

@interface VEUserFeedbackViewController () <YYTextViewDelegate>

@property (strong, nonatomic) YYTextView *textView;
@property (strong, nonatomic) UIView *textBackground;

@property (strong, nonatomic) YYTextView *qqText;
@property (strong, nonatomic) UIView *qqTextBackground;

@property (strong, nonatomic) UIButton *pushBtn;
@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) UIView *radView;      //我的反馈小红点

@end

@implementation VEUserFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_NAV_COLOR;
    //self.navigationController.navigationBar.topItem.title = @"";
    self.title = @"意见反馈";
    [self addRightBtn];
    
    [self.view addSubview:self.textBackground];
    [self.view addSubview:self.qqTextBackground];
    [self.textBackground addSubview:self.textView];
    [self.qqTextBackground addSubview:self.qqText];
    [self.view addSubview:self.pushBtn];
    [self.view addSubview:self.shadowView];
    [self setAllViewLayout];
    // Do any additional setup after loading the view.
}

- (void)addRightBtn{
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, Height_NavBar-Height_StatusBar)];
    [rightBtn setTitle:@"我的反馈" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"1DABFD"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, Height_NavBar-Height_StatusBar)];
    rightView.backgroundColor = [UIColor clearColor];
    [rightView addSubview:rightBtn];
    
    self.radView = [[UIView alloc]initWithFrame:CGRectMake(2, 10, 8, 8)];
    self.radView.backgroundColor = [UIColor redColor];
    self.radView.layer.cornerRadius = 4;
    self.radView.hidden = !self.hasRed;
    [rightView addSubview:self.radView];

    UIBarButtonItem *rightBtnBar = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightBtnBar;
}

- (void)setHasRed:(BOOL)hasRed{
    _hasRed = hasRed;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
    [self.qqText resignFirstResponder];
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.textBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(Height_NavBar);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    
    [self.qqTextBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.textBackground.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(46);
    }];
    
    [self.pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(PUSH_BTN_SIZE);
        make.top.mas_equalTo(self.qqTextBackground.mas_bottom).mas_offset(76);
    }];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(PUSH_BTN_SIZE);
        make.top.mas_equalTo(self.qqTextBackground.mas_bottom).mas_offset(76);
    }];
    
}

- (UIView *)textBackground{
    if (!_textBackground) {
        _textBackground = [UIView new];
        _textBackground.backgroundColor = MAIN_BLACK_COLOR;
    }
    return _textBackground;
}

- (UIView *)qqTextBackground{
    if (!_qqTextBackground) {
        _qqTextBackground = [UIView new];
        _qqTextBackground.backgroundColor = MAIN_BLACK_COLOR;
    }
    return _qqTextBackground;
}

-(YYTextView *)textView{
    if (!_textView) {
        _textView = [[YYTextView alloc]initWithFrame:CGRectMake(16, 15, kScreenWidth - 32, 170)];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = [UIColor colorWithHexString:@"ffffff"];
        _textView.placeholderFont = [UIFont systemFontOfSize:15];
        _textView.placeholderTextColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _textView.placeholderText = @"输入你所遇到的详细问题或建议";
        _textView.backgroundColor = MAIN_BLACK_COLOR;
        _textView.delegate = self;
    }
    return _textView;
}

-(YYTextView *)qqText{
    if (!_qqText) {
        _qqText = [[YYTextView alloc]initWithFrame:CGRectMake(16,  8, kScreenWidth - 32, 36)];
        _qqText.font = [UIFont systemFontOfSize:15];
        _qqText.textColor = [UIColor colorWithHexString:@"ffffff"];
        _qqText.placeholderFont = [UIFont systemFontOfSize:15];
        _qqText.placeholderTextColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _qqText.placeholderText = @"输入正确的QQ号/手机号(必填)";
        _qqText.backgroundColor = MAIN_BLACK_COLOR;
        _qqText.scrollEnabled = NO;
        _qqText.keyboardType = UIKeyboardTypeNumberPad;
        _qqText.delegate = self;
    }
    return _qqText;
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

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.4;
        _shadowView.layer.masksToBounds = YES;
        _shadowView.layer.cornerRadius = 19;
        _shadowView.userInteractionEnabled = YES;
        @weakify(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            NSString *contentStr = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *qqStr = [self.qqText.text stringByReplacingOccurrencesOfString:@" " withString:@""];

            if (qqStr.length < 5 || qqStr.length > 13) {
                [MBProgressHUD showError:@"请输入正确的QQ号"];
                return;
            }else if(contentStr.length < 2){
                [MBProgressHUD showError:@"内容不能少于2个字"];
                return;
            }
        }];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

#pragma mark - YYTextViewDelegate
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView{
    NSString *contentStr = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *qqStr = [self.qqText.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (qqStr.length >= 5 && contentStr.length >= 2 && qqStr.length <= 13) {
        self.shadowView.hidden = YES;
    }else{
        self.shadowView.hidden = NO;
    }
}

- (void)clickRightBtn{
    if ([LMUserManager sharedManger].isLogin) {
        VEUserMyFeedbackController *vc = [VEUserMyFeedbackController new];
        self.radView.hidden = YES;
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

- (void)clickPushBtn{
    if ([LMUserManager sharedManger].isLogin) {
        [MBProgressHUD showMessage:@"提交中"];
        [VEUserApi feedbackWithContent:self.textView.text qqStr:self.qqText.text Completion:^(VEBaseModel *  _Nonnull result) {
            [MBProgressHUD hideHUD];
            if (result.state.intValue == 1) {
                [MBProgressHUD showSuccess:@"提交成功"];
                [self clickRightBtn];
            }else{
                [MBProgressHUD showError:result.errorMsg];
            }
        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:VENETERROR];
        }];
    }else{
        [self showLoginView];
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
