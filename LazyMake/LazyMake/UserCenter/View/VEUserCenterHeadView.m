//
//  VEUserCenterHeadView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserCenterHeadView.h"

@interface VEUserCenterHeadView ()

@property (strong, nonatomic) UIImageView *mainHomeImage;           //背景
@property (strong, nonatomic) UIImageView *iconHomeView;            //头像
@property (strong, nonatomic) UIView *iconShadowView;           //头像后面的阴影
@property (strong, nonatomic) UILabel *nameLab;                 //昵称
@property (strong, nonatomic) UILabel *contentLab;              //昵称底部的内容
@property (strong, nonatomic) UIButton *vipBtn;                 //会员按钮
@property (strong, nonatomic) UIButton *dataBtn;                //用户资料进入按钮
@property (strong, nonatomic) UIButton *vipBtn2;                //会员按钮

@end

@implementation VEUserCenterHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.mainHomeImage];
        [self addSubview:self.iconHomeView];
        [self insertSubview:self.iconShadowView belowSubview:self.iconHomeView];
        [self addSubview:self.nameLab];
        [self addSubview:self.vipBtn];
        [self addSubview:self.vipBtn2];
        [self addSubview:self.dataBtn];
        [self addSubview:self.contentLab];
        [self setAllViewLayout];
        [self reloadData];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.mainHomeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.iconHomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.bottom.mas_equalTo(-34);
        make.size.mas_equalTo(CGSizeMake(58, 58));
    }];
    
    [self.iconShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.iconHomeView.mas_centerX);
        make.centerY.mas_equalTo(self.iconHomeView.mas_centerY);
        make.width.mas_equalTo(self.iconHomeView.mas_width).mas_offset(10);
        make.height.mas_equalTo(self.iconHomeView.mas_height).mas_equalTo(10);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.iconShadowView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.iconHomeView.mas_top).mas_offset(6);
        make.right.mas_equalTo(-80);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.iconShadowView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.nameLab.mas_bottom).mas_offset(6);
        make.right.mas_equalTo(-100);
    }];
    
    [self.vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.iconHomeView.mas_centerY);
        make.right.mas_equalTo(-24);
    }];
    
    [self.vipBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.iconHomeView.mas_centerY);
        make.right.mas_equalTo(-24);
        make.size.mas_equalTo(CGSizeMake(46, 46));

    }];
    
    [self.dataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-100);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.iconShadowView.layer.cornerRadius = self.iconShadowView.frame.size.height/2;
    });
}

- (UIImageView *)mainHomeImage{
    if (!_mainHomeImage) {
        _mainHomeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_home_my_bg"]];
        _mainHomeImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainHomeImage.clipsToBounds = YES;
    }
    return _mainHomeImage;
}

- (UIImageView *)iconHomeView{
    if (!_iconHomeView) {
         _iconHomeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_icon_default_avatar"]];
         _iconHomeView.contentMode = UIViewContentModeScaleAspectFill;
         _iconHomeView.clipsToBounds = YES;
         _iconHomeView.layer.masksToBounds = YES;
         _iconHomeView.layer.cornerRadius = 29.0f;
    }
    return _iconHomeView;
}

- (UIView *)iconShadowView{
    if (!_iconShadowView) {
        _iconShadowView = [UIView new];
        _iconShadowView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _iconShadowView.alpha = 0.3f;
    }
    return _iconShadowView;
}

- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [UILabel new];
        _nameLab.font = [UIFont systemFontOfSize:18];
        _nameLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _nameLab.text = @"点击登录/注册";
    }
    return _nameLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:13];
        _contentLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _contentLab.text = @"更多精彩等你体验...";
    }
    return _contentLab;
}

- (UIButton *)vipBtn{
    if (!_vipBtn) {
        _vipBtn = [UIButton new];
        [_vipBtn setImage:[UIImage imageNamed:@"vm_icon_next_"] forState:UIControlStateNormal];
        [_vipBtn setTitle:@"开通会员" forState:UIControlStateNormal];
        [_vipBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _vipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_vipBtn addTarget:self action:@selector(clickVIPBtn) forControlEvents:UIControlEventTouchUpInside];
        [VETool changeBtnStyleWithType:LMBtnImageTitleType_ImagRight distance:8 andBtn:_vipBtn];
    }
    return _vipBtn;
}

- (UIButton *)vipBtn2{
    if (!_vipBtn2) {
        _vipBtn2 = [UIButton new];
        [_vipBtn2 setImage:[UIImage imageNamed:@"vm_vip_p"] forState:UIControlStateNormal];
        _vipBtn2.hidden = YES;
        [_vipBtn2 addTarget:self action:@selector(clickVIPBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vipBtn2;
}

- (UIButton *)dataBtn{
    if (!_dataBtn) {
        _dataBtn = [UIButton new];
        [_dataBtn addTarget:self action:@selector(clickUserDataBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dataBtn;
}

- (void)clickVIPBtn{
    if (self.clickVIPBtnBlock) {
        self.clickVIPBtnBlock();
    }
}

- (void)clickUserDataBtn{
    if (self.clickUserDataBtnBlock) {
        self.clickUserDataBtnBlock();
    }
}

- (void)reloadData{
    [self.iconHomeView setImageWithURL:[NSURL URLWithString:[LMUserManager sharedManger].userInfo.avatar] placeholder:[UIImage imageNamed:@"vm_icon_default_avatar"]];
    self.nameLab.text = [[LMUserManager sharedManger].userInfo.nickname isNotBlank]?[LMUserManager sharedManger].userInfo.nickname:@"点击登录/注册";
    if ([LMUserManager sharedManger].isLogin) {
        if ([LMUserManager sharedManger].userInfo.vipState.intValue == 1) {
            self.contentLab.text = [NSString stringWithFormat:@"还剩%d天",[LMUserManager sharedManger].userInfo.endDay.intValue];
        }else if ([LMUserManager sharedManger].userInfo.vipState.intValue == 0) {
            self.contentLab.text = @"当前未开通会员";
        }else if ([LMUserManager sharedManger].userInfo.vipState.intValue == 2) {
            self.contentLab.text = @"会员已过期";
        }
    }else{
        self.contentLab.text = @"更多精彩等你体验...";
    }

    
    if ([LMUserManager sharedManger].userInfo.vipState.intValue == 1) {
        [_vipBtn2 setImage:[UIImage imageNamed:@"vm_vip_p"] forState:UIControlStateNormal];
        _vipBtn2.hidden = NO;
        _vipBtn.hidden = YES;
    }else if ([LMUserManager sharedManger].userInfo.vipState.intValue == 2){
        [_vipBtn2 setImage:[UIImage imageNamed:@"vm_vip_n"] forState:UIControlStateNormal];
        _vipBtn2.hidden = NO;
        _vipBtn.hidden = YES;
    }else{
        _vipBtn2.hidden = YES;
        _vipBtn.hidden = NO;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
