//
//  VECutoutCollectionReusableView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VECutoutCollectionReusableView.h"
#import "VEUserLoginPopupView.h"

@implementation VECutoutCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.mainSlectSize = [[self class] createHeadSelectSize];
        [self addSubview:self.selectView];
        [self addSubview:self.explanationLab];
        [self addSubview:self.makeBtn];
        [self addSubview:self.bottomLab];
        self.backgroundColor = [UIColor colorWithHexString:@"0B0E22"];
        [self setAllViewLayout];
        if ([LMUserManager sharedManger].userInfo.vipState.integerValue == 1) {
            [self vipHiddenExplanationLab];
        }
    }
    return self;
}
- (void)vipHiddenExplanationLab{
    self.explanationLab.hidden = YES;
    [self.makeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.explanationLab.mas_top);
    }];
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.explanationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.selectView.mas_bottom).mas_offset(20);
    }];
    
    [self.makeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(self.mainSlectSize.size.width, 38));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.explanationLab.mas_bottom).mas_offset(15);
    }];
    
    [self.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.makeBtn.mas_bottom).mas_offset(20);
    }];
}

- (VECutoutImageSelectView *)selectView{
    if (!_selectView) {
        _selectView = [[VECutoutImageSelectView alloc]initWithFrame:self.mainSlectSize];
    }
    return _selectView;
}

- (YYLabel *)explanationLab{
    if (!_explanationLab) {
        _explanationLab = [YYLabel new];
        UIColor *color = [UIColor colorWithHexString:@"#A1A7B2"];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:13], NSForegroundColorAttributeName: color};
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"普通用户每天免费抠图1次，会员则无限制" attributes:attributes];
        [text setTextHighlightRange:[[text string] rangeOfString:@"会员则无限制"] color:[UIColor colorWithHexString:@"#1DABFD"] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [self showLoginView];
            LMLog(@"ddddddd");
        }];
        _explanationLab.attributedText = text;
        _explanationLab.textAlignment = NSTextAlignmentCenter;
    }
    return _explanationLab;
}

- (UIButton *)makeBtn{
    if (!_makeBtn) {
        _makeBtn = [UIButton new];
        [_makeBtn setTitle:@"开始抠图" forState:UIControlStateNormal];
        _makeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        UIImage *image = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(self.mainSlectSize.size.width, 38)];
        [_makeBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_makeBtn addTarget:self action:@selector(clickMakeBtn) forControlEvents:UIControlEventTouchUpInside];
        _makeBtn.layer.masksToBounds = YES;
        _makeBtn.layer.cornerRadius = 19;
    }
    return _makeBtn;
}

- (UILabel *)bottomLab{
    if (!_bottomLab) {
        _bottomLab = [UILabel new];
        _bottomLab.font = [UIFont systemFontOfSize:17];
        _bottomLab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _bottomLab.textAlignment = NSTextAlignmentCenter;
        _bottomLab.text = @"— 相关模板 —";
    }
    return _bottomLab;
}

+ (CGRect)createHeadSelectSize{
    CGFloat leftJuli = 70;
    if ([LMUserManager sharedManger].userInfo.vipState.integerValue == 1) {
         leftJuli = 50;
    }
    CGSize mainSize = CGSizeMake(290, 475);
    CGFloat bili = mainSize.width/mainSize.height;
    CGFloat newW = kScreenWidth/bili;
    if (newW > kScreenWidth - (leftJuli*2)) {
        newW = kScreenWidth - (leftJuli*2);
    }
    CGFloat newH = newW/bili;
    CGFloat leftS = leftJuli-14;
    return CGRectMake(leftS, 15, newW, newH);
}

+ (CGFloat)mainHeight{
    CGRect rect = [[self class]createHeadSelectSize];
    if ([LMUserManager sharedManger].userInfo.vipState.integerValue == 1) {
        return rect.size.height + 130;
    }
    return rect.size.height + 160;
}

/// 弹出登录框
- (void)showLoginView{
    VEUserLoginPopupView *loginView = [[VEUserLoginPopupView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:loginView];
}

- (void)clickMakeBtn{
    if (self.clickMakeBtnBlock) {
        self.clickMakeBtnBlock();
    }
}

@end
