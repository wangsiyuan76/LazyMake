//
//  VEUserLogoutPopupView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/15.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserLogoutPopupView.h"
#import "VEUserApi.h"

@implementation VEUserLogoutPopupView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shadowBtn];
        [self addSubview:self.conentView];
        [self.conentView addSubview:self.textF];
        [self.conentView addSubview:self.codeLab];
        [self.conentView addSubview:self.activityIndicator];
        [self.conentView addSubview:self.titleLab];
        [self.conentView addSubview:self.cancelBtn];
        [self.conentView addSubview:self.sureBtn];
        [self.conentView addSubview:self.line1];
        [self.conentView addSubview:self.line2];
        [self setAllViewLayout];
        [self loadCode];
        [self.textF becomeFirstResponder];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.shadowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.conentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(295, 158));
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-70);
    }];
    
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(155, 35));
    }];
    
    [self.codeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.textF.mas_right).mas_offset(8);
        make.right.mas_equalTo(-24);
        make.centerY.mas_equalTo(self.textF.mas_centerY);
        make.height.mas_equalTo(self.textF.mas_height);
    }];
    
    [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.codeLab.mas_centerX);
        make.centerY.mas_equalTo(self.codeLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.textF.mas_bottom).mas_offset(14);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.mas_equalTo(52);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(147);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(20);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.mas_equalTo(self.cancelBtn.mas_height);
        make.left.mas_equalTo(self.cancelBtn.mas_right);
        make.width.mas_equalTo(self.cancelBtn.mas_width);
        make.top.mas_equalTo(self.cancelBtn.mas_top);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.cancelBtn.mas_top);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.cancelBtn.mas_right);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(self.cancelBtn.mas_top);
     }];
}

- (UIView *)conentView{
    if (!_conentView) {
        _conentView = [UIView new];
        _conentView.backgroundColor = [UIColor whiteColor];
        _conentView.layer.masksToBounds = YES;
        _conentView.layer.cornerRadius = 8.0f;
    }
    return _conentView;
}

- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc]init];
        _textF.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
        _textF.placeholder = @"请输入验证码";
        _textF.font = [UIFont systemFontOfSize:13];
        
        UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
        leftV.backgroundColor = _textF.backgroundColor;
        _textF.leftViewMode = UITextFieldViewModeAlways;
        _textF.leftView = leftV;
    }
    return _textF;
}

- (UILabel *)codeLab{
    if (!_codeLab) {
        _codeLab = [UILabel new];
        _codeLab.font = [UIFont systemFontOfSize:13];
        _codeLab.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
        _codeLab.textAlignment = NSTextAlignmentCenter;
        _codeLab.userInteractionEnabled = YES;
        _codeLab.textColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadCode)];
        [_codeLab addGestureRecognizer:tap];
    }
    return _codeLab;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.backgroundColor = [UIColor colorWithHexString:@"#1A1A1A"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.text = @"确定注销后将不可再登录，是否确定";
    }
    return _titleLab;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#1DABFD"] forState:UIControlStateNormal];
        _sureBtn.backgroundColor = [UIColor clearColor];
        [_sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#1DABFD"] forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIView *)line1{
    if (!_line1) {
        _line1 = [UIView new];
        _line1.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _line1;
}

- (UIView *)line2{
    if (!_line2) {
        _line2 = [UIView new];
        _line2.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _line2;
}

- (UIButton *)shadowBtn{
    if (!_shadowBtn) {
        _shadowBtn = [UIButton new];
        _shadowBtn.backgroundColor = [UIColor blackColor];
        _shadowBtn.alpha = 0.5f;
    }
    return _shadowBtn;
}

- (UIActivityIndicatorView *)activityIndicator{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
        _activityIndicator.color = [UIColor lightGrayColor];
        //设置背景颜色
        _activityIndicator.backgroundColor = [UIColor clearColor];
        _activityIndicator.hidesWhenStopped = YES;
    }
    return _activityIndicator;
}

- (void)loadCode{
    self.codeLab.userInteractionEnabled = NO;
    [self.activityIndicator startAnimating];
    [VEUserApi loginOutCodeCompletion:^(VEBaseModel *  _Nonnull result) {
        [self.activityIndicator stopAnimating];
        self.codeLab.userInteractionEnabled = YES;
        if (result.state.intValue == 1) {
            self.codeLab.text = result.msg;
        }else{
            [MBProgressHUD showSuccess:result.errorMsg];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        self.codeLab.userInteractionEnabled = YES;
        [MBProgressHUD showError:VENETERROR];
    }];
}

- (void)clickSureBtn{
    LMLog(@"self.textF.text======%@,,,self.codeLab.text======%@",self.textF.text,self.codeLab.text);
    NSString *str = [self.textF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (str.length == self.codeLab.text.length) {
        if (self.clickSureBtnBlock) {
            self.clickSureBtnBlock(self.textF.text);
        }
        [self.shadowBtn removeFromSuperview];
        [self removeFromSuperview];
    }else{
        [MBProgressHUD showError:@"验证码不正确"];
    }
}

- (void)clickCancleBtn{
    [self.shadowBtn removeFromSuperview];
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
