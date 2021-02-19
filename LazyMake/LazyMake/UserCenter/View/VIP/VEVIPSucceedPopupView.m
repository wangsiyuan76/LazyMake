//
//  VEVIPSucceedPopupView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVIPSucceedPopupView.h"

@interface VEVIPSucceedPopupView ()

@property (strong, nonatomic) UIView *contentView;          //中间主数据的存放view
@property (strong, nonatomic) UIView *lineView;             //分割线
@property (strong, nonatomic) UIButton *shadowBtn;          //底部半透明的阴影按钮

@end

@implementation VEVIPSucceedPopupView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shadowBtn];
        [self addSubview:self.contentView];
        [self addSubview:self.topImage];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.endTimeLab];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.knowBtn];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.shadowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(295, 220));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-20);
    }];
    
    [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_top).mas_offset(8);
        make.size.mas_equalTo(CGSizeMake(115, 115));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(56);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(12);
    }];
    
    [self.endTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.contentLab.mas_bottom).mas_offset(16);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.endTimeLab.mas_bottom).mas_offset(16);
        make.height.mas_equalTo(1);
    }];
    
    [self.knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (UIButton *)shadowBtn{
    if (!_shadowBtn) {
        _shadowBtn = [UIButton new];
        _shadowBtn.backgroundColor = [UIColor blackColor];
        _shadowBtn.alpha = 0.5f;
    }
    return _shadowBtn;
}

-(UIImageView *)topImage{
    if (!_topImage) {
        _topImage = [UIImageView new];
        _topImage.image = [UIImage imageNamed:@"vm_icon_windows_vip"];
    }
    return _topImage;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 10;
    }
    return _contentView;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:21];
        _titleLab.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

-(UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.text = @"立即享有会员所有福利";
    }
    return _contentLab;
}

-(UILabel *)endTimeLab{
    if (!_endTimeLab) {
        _endTimeLab = [UILabel new];
        _endTimeLab.font = [UIFont systemFontOfSize:17];
        _endTimeLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _endTimeLab.textAlignment = NSTextAlignmentCenter;
    }
    return _endTimeLab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _lineView;
}

-(UIButton *)knowBtn{
    if (!_knowBtn) {
        _knowBtn = [UIButton new];
        [_knowBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        [_knowBtn setTitleColor:[UIColor colorWithHexString:@"#1DABFD"] forState:UIControlStateNormal];
        _knowBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_knowBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _knowBtn;
}

- (void)clickSureBtn{
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
