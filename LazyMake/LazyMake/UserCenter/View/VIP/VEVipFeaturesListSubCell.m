//
//  VEVipFeaturesListSubCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVipFeaturesListSubCell.h"

@interface VEVipFeaturesListSubCell ()

@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *contentLab;

@end

@implementation VEVipFeaturesListSubCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.contentLab];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(2);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(29, 29));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.iconImage.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(3);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
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
        _titleLab.textColor = [UIColor colorWithHexString:@"A1A7B2"];
    }
    return _titleLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:11];
        _contentLab.textColor = [UIColor colorWithHexString:@"A1A7B2"];
    }
    return _contentLab;
}

+(CGFloat)cellHeight{
    return 90;
}

- (void)setModel:(VEVIPMoneyModel *)model{
    _model = model;
    [self.iconImage setImage:[UIImage imageNamed:model.iconName]];
    self.titleLab.text = model.titleStr;
    self.contentLab.text = model.contentStr;
}


@end
