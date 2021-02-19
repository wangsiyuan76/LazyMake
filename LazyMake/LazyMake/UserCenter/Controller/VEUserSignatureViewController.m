//
//  VEUserSignatureViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserSignatureViewController.h"
#import "VEUserApi.h"

#define PUSH_BTN_SIZE  CGSizeMake(296, 38)
#define MAX_NUMBER 60                       //最大字数限制

@interface VEUserSignatureViewController ()<YYTextViewDelegate>
@property (strong, nonatomic) YYTextView *textView;
@property (strong, nonatomic) UIView *textBackground;
@property (strong, nonatomic) UIButton *pushBtn;
@property (strong, nonatomic) UILabel *numLab;
@property (strong, nonatomic) UILabel *maxLab;
@end

@implementation VEUserSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_NAV_COLOR;
//     //self.navigationController.navigationBar.topItem.title = @"";
     self.title = @"修改个性签名";
    
    [self.view addSubview:self.textBackground];
    [self.textBackground addSubview:self.textView];
    [self.textBackground addSubview:self.maxLab];
    [self.textBackground addSubview:self.numLab];
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
        make.height.mas_equalTo(150);
    }];
    
    [self.maxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.maxLab.mas_centerY);
        make.right.mas_equalTo(self.maxLab.mas_left);
        
    }];
    [self.pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(PUSH_BTN_SIZE);
        make.top.mas_equalTo(self.textBackground.mas_bottom).mas_offset(80);
    }];
}

- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [UILabel new];
        _numLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _numLab.font = [UIFont systemFontOfSize:12];
        _numLab.text = [NSString stringWithFormat:@"%zd/",[LMUserManager sharedManger].userInfo.signature.length];
    }
    return _numLab;
}

- (UILabel *)maxLab{
    if (!_maxLab) {
        _maxLab = [UILabel new];
        _maxLab.textColor = [UIColor colorWithHexString:@"#1DABFD"];
        _maxLab.font = [UIFont systemFontOfSize:12];
        _maxLab.text = [NSString stringWithFormat:@"%d",MAX_NUMBER];
    }
    return _maxLab;
}

- (UIView *)textBackground{
    if (!_textBackground) {
        _textBackground = [UIView new];
        _textBackground.backgroundColor = MAIN_BLACK_COLOR;
    }
    return _textBackground;
}

-(YYTextView *)textView{
    if (!_textView) {
        _textView = [[YYTextView alloc]initWithFrame:CGRectMake(16, 20, kScreenWidth - 32, 100)];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = [UIColor colorWithHexString:@"ffffff"];
        _textView.placeholderFont = [UIFont systemFontOfSize:15];
        _textView.placeholderTextColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _textView.placeholderText = @"请输入新的个性签名";
        _textView.delegate = self;
        _textView.backgroundColor = MAIN_BLACK_COLOR;
        if ([[LMUserManager sharedManger].userInfo.signature isNotBlank]) {
            _textView.text = [LMUserManager sharedManger].userInfo.signature;
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

- (void)clickPushBtn{
    if (self.textView.text.length <= MAX_NUMBER) {
        NSString *str = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (str.length > 0) {
            [MBProgressHUD showMessage:@"修改中..."];
            NSString *pushStr = self.textView.text;
            [VEUserApi changeUserSignature:pushStr Completion:^(VEBaseModel *  _Nonnull result) {
                [MBProgressHUD hideHUD];
                if (result.state.intValue == 1) {
                    [LMUserManager sharedManger].userInfo.signature = pushStr;
                    VEUserModel *model = [LMUserManager sharedManger].userInfo;
                    model.signature = pushStr;
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
            [MBProgressHUD showError:@"内容不能为空"];
        }
    }else{
         [MBProgressHUD showError:[NSString stringWithFormat:@"不能超过%d个字",MAX_NUMBER]];
    }

}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView{
    self.numLab.text = [NSString stringWithFormat:@"%zd/",textView.text.length];
    if (textView.text.length > MAX_NUMBER) {
        self.numLab.textColor = [UIColor redColor];
        textView.text = [textView.text substringToIndex:MAX_NUMBER];

    }else{
        self.numLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
    }
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView{
    return YES;;
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
