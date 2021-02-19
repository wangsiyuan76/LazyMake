//
//  VEHoneShareSubCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/9.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHoneShareSubCell.h"

@implementation VEHoneShareSubCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.image];
        [self.contentView addSubview:self.titleLab];
        
        @weakify(self);
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.image.mas_bottom).mas_offset(12);
        }];
    }
    return self;
}

- (UIImageView *)image{
    if (!_image) {
        _image = [UIImageView new];
    }
    return _image;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
        _titleLab.font = [UIFont systemFontOfSize:14];
    }
    return _titleLab;
}

@end
