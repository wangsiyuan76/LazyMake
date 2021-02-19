//
//  VEHomeUserWorksListHeadView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/10.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeUserWorksListHeadView.h"

#define ICON_SIZE CGSizeMake(60, 60)

@interface VEHomeUserWorksListHeadView ()

@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UIImageView *userIcon;
@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) UILabel *userNameLab;
@property (strong, nonatomic) UIButton *backBtn;

@end

@implementation VEHomeUserWorksListHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        [self addSubview:self.mainImage];
        [self addSubview:self.userIcon];
        [self addSubview:self.shadowView];
        [self addSubview:self.userNameLab];
        [self addSubview:self.backBtn];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, -10, 0));
    }];
    
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-10);
        make.size.mas_equalTo(ICON_SIZE);
    }];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.userIcon.mas_centerX);
        make.centerY.mas_equalTo(self.userIcon.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(ICON_SIZE.width + 8, ICON_SIZE.height + 8));
    }];
    
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.shadowView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(12 + Height_StatusBar);
        make.width.mas_equalTo(20);
    }];
}

- (UIImageView *)mainImage{
    if (!_mainImage) {
//        _mainImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_personalcenter_bg"]];
    }
    return _mainImage;
}

- (UIImageView *)userIcon{
    if (!_userIcon) {
        _userIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_icon_default_avatar"]];
        _userIcon.contentMode = UIViewContentModeScaleAspectFill;
        _userIcon.clipsToBounds = YES;
        _userIcon.layer.masksToBounds = YES;
        _userIcon.layer.cornerRadius = ICON_SIZE.width/2;
    }
    return _userIcon;
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _shadowView.alpha = 0.4;
        _shadowView.layer.masksToBounds = YES;
        _shadowView.layer.cornerRadius = (ICON_SIZE.width + 8)/2;
    }
    return _shadowView;
}

- (UILabel *)userNameLab{
    if (!_userNameLab) {
        _userNameLab = [UILabel new];
        _userNameLab.textAlignment = NSTextAlignmentCenter;
        _userNameLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _userNameLab.font = [UIFont systemFontOfSize:17];
    }
    return _userNameLab;
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"vm_icon_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)clickBackBtn{
    [currViewController().navigationController popViewControllerAnimated:YES];
}

- (void)setModel:(VEHomeTemplateModel *)model{
    _model = model;
    self.userNameLab.text = model.nickname;
    [self.userIcon setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"vm_icon_default_avatar"]];
}

+ (CGFloat)viewHeight{
    return 180;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
