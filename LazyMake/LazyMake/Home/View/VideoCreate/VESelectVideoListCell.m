//
//  VESelectVideoListCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/15.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VESelectVideoListCell.h"

@implementation VESelectVideoListCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.mainImage];
        [self.contentView addSubview:self.shadowMainImage];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.selectBtn];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.shadowMainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, -1, 0, -1));
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(-2);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (UIImageView *)shadowMainImage{
    if (!_shadowMainImage) {
        _shadowMainImage = [UIImageView new];
        _shadowMainImage.image = [UIImage imageNamed:@"vm_home1_mask"];
        _shadowMainImage.layer.masksToBounds = YES;
        _shadowMainImage.layer.cornerRadius = 8.0f;
    }
    return _shadowMainImage;
}

-(UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [UIImageView new];
        _mainImage.layer.masksToBounds = YES;
        _mainImage.layer.cornerRadius = 8.0f;
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
    }
    return _mainImage;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.font = [UIFont systemFontOfSize:11];
        _timeLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _timeLab;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton new];
        [_selectBtn setImage:[UIImage imageNamed:@"vm_choose_picture_"] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(clickSelectBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (void)clickSelectBtn{
    if (self.clickSelectBtnBlock) {
        self.clickSelectBtnBlock(self.index);
    }
}


@end
