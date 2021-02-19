//
//  VEHomeToolSubCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/1.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeToolSubCell.h"

@interface VEHomeToolSubCell ()

@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *labText;

@end

@implementation VEHomeToolSubCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.labText];
        
        @weakify(self);
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(26, 24));
        }];
        [self.labText mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(self.iconImage.mas_bottom).mas_offset(10);
        }];
    }
    return self;
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [UIImageView new];
        _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImage;
}

- (UILabel *)labText{
    if (!_labText) {
        _labText = [UILabel new];
        _labText.font = [UIFont systemFontOfSize:13];
        _labText.textColor = [UIColor colorWithHexString:@"ffffff"];
        _labText.textAlignment = NSTextAlignmentCenter;
    }
    return _labText;
}

- (void)setModel:(VEHomeToolModel *)model{
    _model = model;
    self.labText.hidden = NO;
    self.iconImage.hidden = NO;
    self.labText.text = model.name;

    if ([model.hitsid isNotBlank]) {
        [self.iconImage setImageWithURL:[NSURL URLWithString:model.thumb] options:YYWebImageOptionProgressiveBlur];
    }else{
        self.iconImage.image = [UIImage imageNamed:model.imageName];
    }
}

- (void)hiddenAll{
    self.labText.hidden = YES;
    self.iconImage.hidden = YES;
}


@end
