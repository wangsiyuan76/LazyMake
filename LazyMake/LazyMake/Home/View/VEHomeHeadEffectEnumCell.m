//
//  VEHomeHeadEffectEnumCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeHeadEffectEnumCell.h"

@interface VEHomeHeadEffectEnumCell ()

@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *subTitleLab;

@end

@implementation VEHomeHeadEffectEnumCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.mainImage];
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.subTitleLab];
        [self setAllViewLayout];
    }
    return self;
}

- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [UIImageView new];
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
        _mainImage.layer.masksToBounds = YES;
        _mainImage.layer.cornerRadius = 6.0f;
    }
    return _mainImage;
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [UIImageView new];
        _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImage;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _titleLab.font = [UIFont systemFontOfSize:16];
    }
    return _titleLab;
}

- (UILabel *)subTitleLab{
    if (!_subTitleLab) {
        _subTitleLab = [UILabel new];
        _subTitleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _subTitleLab.font = [UIFont systemFontOfSize:10];
    }
    return _subTitleLab;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(6);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.iconImage.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-10);
    }];

    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(6);
    }];
}

- (void)setModel:(VEHomeHeadEffectModel *)model{
    _model = model;
    [self.mainImage setImage:[UIImage imageNamed:model.mainBackgroundStr]];
    [self.iconImage setImage:[UIImage imageNamed:model.iconStr]];
    [self.titleLab setText:model.title];
    [self.subTitleLab setText:model.subTitle];
}

@end
