//
//  VEVipMainUserDataCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVipMainUserDataCell.h"

@interface VEVipMainUserDataCell ()

@property (strong, nonatomic) UIImageView *iconView;            //头像
@property (strong, nonatomic) UIView *iconShadowView;           //头像后面的阴影
@property (strong, nonatomic) UILabel *nameLab;                 //昵称
@property (strong, nonatomic) UILabel *contentLab;              //昵称底部的内容
@property (strong, nonatomic) UIImageView *diamondImage;        //右侧的钻石图

@end

@implementation VEVipMainUserDataCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
     
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.iconView];
        [self.contentView insertSubview:self.iconShadowView belowSubview:self.iconView];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.diamondImage];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.iconShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.iconView.mas_centerX);
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
        make.width.mas_equalTo(self.iconView.mas_width).mas_offset(6);
        make.height.mas_equalTo(self.iconView.mas_height).mas_equalTo(6);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.iconShadowView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.iconView.mas_top).mas_offset(0);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.iconShadowView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.nameLab.mas_bottom).mas_offset(6);
    }];
    
    [self.diamondImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(-14);
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.iconShadowView.layer.cornerRadius = self.iconShadowView.frame.size.height/2;
    });
}

- (UIImageView *)iconView{
    if (!_iconView) {
         _iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_icon_default_avatar"]];
         _iconView.contentMode = UIViewContentModeScaleAspectFill;
         _iconView.clipsToBounds = YES;
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.cornerRadius = 20.f;
        [_iconView setImageWithURL:[NSURL URLWithString:[LMUserManager sharedManger].userInfo.avatar] placeholder:[UIImage imageNamed:@"vm_icon_default_avatar"]];
    }
    return _iconView;
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
        _nameLab.text = [LMUserManager sharedManger].userInfo.nickname?:@"用户昵称";
    }
    return _nameLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:13];
        _contentLab.textColor = [UIColor colorWithHexString:@"A1A7B2"];
        _contentLab.text = @"当前未开通会员";
    }
    return _contentLab;
}

- (UIImageView *)diamondImage{
    if (!_diamondImage) {
        _diamondImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_vip_p"]];
    }
    return _diamondImage;
}

- (void)changeVipState{
    if ([LMUserManager sharedManger].userInfo.vipState.intValue == 1) {
        [_diamondImage setImage:[UIImage imageNamed:@"vm_vip_p"]];
        _contentLab.text = @"VIP会员";
    }else if ([LMUserManager sharedManger].userInfo.vipState.intValue == 0) {
        _contentLab.text = @"当前未开通会员";
        [_diamondImage setImage:[UIImage imageNamed:@"vm_vip_n"]];
    }else{
        _contentLab.text = @"会员已过期";
        [_diamondImage setImage:[UIImage imageNamed:@"vm_vip_n"]];
    }
}

+ (CGFloat)cellHeight{
    return 80;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
