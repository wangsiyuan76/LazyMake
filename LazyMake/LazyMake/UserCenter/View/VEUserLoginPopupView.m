//
//  VEUserLoginPopupView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserLoginPopupView.h"
#import "VEWebTermsViewController.h"
//#import <UMShare/UMShare.h>
#import "VEUserModel.h"
#import "VEUserApi.h"
#import "VEUserPhoneLoginViewConteroller.h"
#define BTN_SIZE CGSizeMake(250, 40)

@interface LMClickLoginSubView : UIView

@property (strong, nonatomic) UIButton *mainBtn;
@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *titleLab;

@end

@implementation LMClickLoginSubView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainBtn];
        [self addSubview:self.iconImage];
        [self addSubview:self.titleLab];
        
        [self.mainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        @weakify(self);
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.size.mas_equalTo(CGSizeMake(57, 57));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(10);
        }];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.iconImage.mas_bottom).mas_offset(15);
        }];
    }
    return self;
}

- (UIButton *)mainBtn{
    if (!_mainBtn) {
        _mainBtn = [UIButton new];
    }
    return _mainBtn;
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [UIImageView new];
    }
    return _iconImage;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor colorWithHexString:@"1A1A1A"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

@end

@interface VEUserLoginPopupView ()

@property (strong, nonatomic) UIButton *closeBtn;           //关闭按钮
@property (strong, nonatomic) UIButton *shaodwBtn;          //背景阴影
@property (strong, nonatomic) UIView *contentView;          //放主内容的view
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *headLab;
@property (strong, nonatomic) UIButton *qqBtn;
@property (strong, nonatomic) UIButton *wxBtn;
@property (strong, nonatomic) YYLabel *explanationText;

@property (strong, nonatomic) LMClickLoginSubView *qqBtn2;
@property (strong, nonatomic) LMClickLoginSubView *wxBtn2;
@property (strong, nonatomic) UIButton *phoneBtn;

@end

@implementation VEUserLoginPopupView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shaodwBtn];
        [self addSubview:self.contentView];
        [self addSubview:self.closeBtn];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.headLab];
        [self.contentView addSubview:self.wxBtn];
        [self.contentView addSubview:self.qqBtn];
        [self.contentView addSubview:self.qqBtn2];
        [self.contentView addSubview:self.wxBtn2];
        [self.contentView addSubview:self.phoneBtn];
        [self.contentView addSubview:self.explanationText];
        [self setAllViewLayout];
        [self changeType];
    }
    return self;
}

////ddd
- (void)changeType{
    NSString *numStr = [[NSUserDefaults standardUserDefaults]objectForKey:PhoneCloseLogin];
    if (numStr.intValue == 1) {
        self.wxBtn.hidden = YES;
        self.qqBtn.hidden = YES;
        
        self.wxBtn2.hidden = YES;
        self.qqBtn2.hidden = YES;
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(200);
        }];

        @weakify(self);
        [self.explanationText mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.qqBtn.mas_bottom).mas_offset(-20);
        }];
        
    }else{
        self.wxBtn2.hidden = YES;
        self.qqBtn2.hidden = YES;
        self.phoneBtn.hidden = YES;
    }
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.shaodwBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(300);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-30);
        make.height.mas_equalTo(250);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.top.mas_equalTo(32);
        make.height.mas_equalTo(1);
    }];
    
    [self.headLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.lineView.mas_centerY);
        make.width.mas_equalTo(110);
    }];
    
    [self.wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.headLab.mas_bottom).mas_offset(30);
        make.size.mas_equalTo(BTN_SIZE);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.wxBtn.mas_bottom).mas_offset(17);
        make.size.mas_equalTo(BTN_SIZE);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.explanationText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.qqBtn.mas_bottom).mas_offset(18);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(BTN_SIZE.width);
    }];
    
    [self.wxBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(self.headLab.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 90));
    }];
    
    [self.qqBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.wxBtn2.mas_right).mas_offset(-12);
        make.top.mas_equalTo(self.wxBtn2.mas_top);
        make.size.mas_equalTo(CGSizeMake(120, 90));
    }];
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
//        make.top.mas_equalTo(self.wxBtn2.mas_bottom).mas_offset(30);
        make.top.mas_equalTo(80);
        make.size.mas_equalTo(BTN_SIZE);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}

- (LMClickLoginSubView *)qqBtn2{
    if (!_qqBtn2) {
        _qqBtn2 = [[LMClickLoginSubView alloc]initWithFrame:CGRectMake(0, 0, 140, 90)];
        [_qqBtn2.iconImage setImage:[UIImage imageNamed:@"vm_login_qq2"]];
        _qqBtn2.titleLab.text = @"QQ";
        [_qqBtn2.mainBtn addTarget:self action:@selector(loginForQQ) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqBtn2;
}

- (LMClickLoginSubView *)wxBtn2{
    if (!_wxBtn2) {
        _wxBtn2 = [[LMClickLoginSubView alloc]initWithFrame:CGRectMake(0, 0, 140, 90)];
        [_wxBtn2.iconImage setImage:[UIImage imageNamed:@"vm_login_wechat2"]];
        _wxBtn2.titleLab.text = @"微信";
        [_wxBtn2.mainBtn addTarget:self action:@selector(loginForWX) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wxBtn2;
}

- (UIButton *)phoneBtn{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton new];
        [_phoneBtn setTitle:@"手机登录" forState:UIControlStateNormal];
        [_phoneBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        UIImage *image = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:BTN_SIZE];
        [_phoneBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(loginForPhone) forControlEvents:UIControlEventTouchUpInside];
        _phoneBtn.layer.masksToBounds = YES;
        _phoneBtn.layer.cornerRadius = BTN_SIZE.height/2;
    }
    return _phoneBtn;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"vm_login_shut_down"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 12;
    }
    return _contentView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    }
    return _lineView;
}

- (UILabel *)headLab{
    if (!_headLab) {
        _headLab = [UILabel new];
        _headLab.text = @"登录懒人制作";
        _headLab.backgroundColor = self.contentView.backgroundColor;
        _headLab.textAlignment = NSTextAlignmentCenter;
        _headLab.font = [UIFont systemFontOfSize:16];
        _headLab.textColor = [UIColor colorWithHexString:@"#808080"];
    }
    return _headLab;
}

- (UIButton *)qqBtn{
    if (!_qqBtn) {
        _qqBtn = [UIButton new];
        [_qqBtn setTitle:@"QQ登录" forState:UIControlStateNormal];
        [_qqBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _qqBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_qqBtn setImage:[UIImage imageNamed:@"vm_login_qq"] forState:UIControlStateNormal];
        [_qqBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        UIImage *image = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#0E86F6"] endColor:[UIColor colorWithHexString:@"#23A9FC"] ifVertical:NO imageSize:BTN_SIZE];
        [_qqBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_qqBtn addTarget:self action:@selector(loginForQQ) forControlEvents:UIControlEventTouchUpInside];
        _qqBtn.layer.masksToBounds = YES;
        _qqBtn.layer.cornerRadius = BTN_SIZE.height/2;
    }
    return _qqBtn;
}

- (UIButton *)wxBtn{
    if (!_wxBtn) {
        _wxBtn = [UIButton new];
        [_wxBtn setTitle:@"微信登录" forState:UIControlStateNormal];
        [_wxBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _wxBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_wxBtn setImage:[UIImage imageNamed:@"vm_login_wechat"] forState:UIControlStateNormal];
        [_wxBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        UIImage *image = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#08A605"] endColor:[UIColor colorWithHexString:@"#0EC619"] ifVertical:NO imageSize:BTN_SIZE];
        [_wxBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_wxBtn addTarget:self action:@selector(loginForWX) forControlEvents:UIControlEventTouchUpInside];
        _wxBtn.layer.masksToBounds = YES;
        _wxBtn.layer.cornerRadius = BTN_SIZE.height/2;
    }
    return _wxBtn;
}

- (UIButton *)shaodwBtn{
    if (!_shaodwBtn) {
        _shaodwBtn = [UIButton new];
        _shaodwBtn.backgroundColor = [UIColor blackColor];
        _shaodwBtn.alpha = 0.5f;
    }
    return _shaodwBtn;
}


-(YYLabel *)explanationText{
    if (!_explanationText) {
        _explanationText = [YYLabel new];
        _explanationText.numberOfLines = 0;
        _explanationText.preferredMaxLayoutWidth = BTN_SIZE.width;
        
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
    }
    return _explanationText;
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
    self.hidden = YES;
    @weakify(self);
    webVC.backBlock = ^{
        @strongify(self);
        self.hidden = NO;
    };
}

- (void)closeBtnClick{
    [self removeFromSuperview];
}

- (void)loginForQQ{
    [self closeBtnClick];
    [self getAuthWithUserInfoFromQQ];
}

- (void)loginForWX{
    [self closeBtnClick];
    [self getAuthWithUserInfoFromWechat];
}

- (void)loginForPhone{
    self.hidden = YES;
    VEUserPhoneLoginViewConteroller *vc = [[VEUserPhoneLoginViewConteroller alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [currViewController().navigationController pushViewController:vc animated:YES];
    @weakify(self);
    vc.userLoginSucceedBlock = ^{
        @strongify(self);
        if (self.userLoginSucceedBlock) {
            self.userLoginSucceedBlock();
        }
    };
}

- (void)getAuthWithUserInfoFromQQ{
#warning 这里
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:currViewController() completion:^(id result, NSError *error) {
//        if (error) {
//        } else {
//            UMSocialUserInfoResponse *resp = result;
//            NSInteger time = [VETool timeSwitchTimestamp:[resp.expiration stringWithFormat:@"yyyy-MM-dd HH:mm:ss"] andFormatter:@"yyyy-MM-dd HH:mm:ss"];
//
//            NSMutableDictionary *parDic = [[NSMutableDictionary alloc]init];
////            [parDic setObject:resp.uid?:@"" forKey:@"userid"];
//            [parDic setObject:resp.accessToken?:@"" forKey:@"token"];
//            [parDic setObject:@"qq" forKey:@"type"];
//            [parDic setObject:resp.openid?:@"" forKey:@"openid"];
//            [parDic setObject:resp.name?:@"" forKey:@"nickname"];
//            [parDic setObject:[NSString stringWithFormat:@"%zd",time] forKey:@"expires_in"];
//            [parDic setObject:resp.iconurl?:@"" forKey:@"avatar"];
//            [parDic setObject:[VETool phoneUUID]?:@"" forKey:@"devicecode"];
//            [parDic setObject:[VETool versionNumber] forKey:@"version"];
//            NSString *sexNum = @"0";
//            if ([resp.unionGender containsString:@"男"]) {
//                sexNum = @"1";
//            }else if ([resp.unionGender containsString:@"女"]){
//                sexNum = @"2";
//            }
//            [parDic setObject:sexNum forKey:@"sex"];
//            [self loginForAppWithModel:parDic];
//        }
//    }];
}

- (void)loginForAppWithModel:(NSDictionary *)model{
    [MBProgressHUD showMessage:@"登录中..."];
    [VEUserApi loginForAppWithModel:model Completion:^(VEUserModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        if (result.state.intValue == 1) {
            [[LMUserManager sharedManger]archiverUserInfo:result];
            [[LMUserManager sharedManger]unArchiverUserInfo];
            [[NSNotificationCenter defaultCenter]postNotificationName:USERLOGINSUCCEED object:nil];
            if (self.userLoginSucceedBlock) {
                self.userLoginSucceedBlock();
            }
        }else{
            [MBProgressHUD showError:result.errorMsg];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
    }];
}

- (void)getAuthWithUserInfoFromWechat
{
#warning 这里
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:currViewController() completion:^(id result, NSError *error) {
//        if (error) {
//        } else {
//            UMSocialUserInfoResponse *resp = result;
//            NSInteger time = [VETool timeSwitchTimestamp:[resp.expiration stringWithFormat:@"yyyy-MM-dd HH:mm:ss"] andFormatter:@"yyyy-MM-dd HH:mm:ss"];
//
//            NSMutableDictionary *parDic = [[NSMutableDictionary alloc]init];
//            //            [parDic setObject:resp.uid?:@"" forKey:@"userid"];
//            [parDic setObject:resp.accessToken?:@"" forKey:@"token"];
//            [parDic setObject:@"weixin" forKey:@"type"];
//            [parDic setObject:resp.openid?:@"" forKey:@"openid"];
//            [parDic setObject:resp.name?:@"" forKey:@"nickname"];
//            [parDic setObject:[NSString stringWithFormat:@"%zd",time] forKey:@"expires_in"];
//            [parDic setObject:resp.iconurl?:@"" forKey:@"avatar"];
//            [parDic setObject:[VETool phoneUUID]?:@"" forKey:@"devicecode"];
//            [parDic setObject:[VETool versionNumber] forKey:@"version"];
//            NSString *sexNum = @"0";
//            if ([resp.unionGender containsString:@"男"]) {
//                sexNum = @"1";
//            }else if ([resp.unionGender containsString:@"女"]){
//                sexNum = @"2";
//            }
//            [parDic setObject:sexNum forKey:@"sex"];
//            [self loginForAppWithModel:parDic];
//        }
//    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
