//
//  VENoneView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/27.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VENoneView.h"

@implementation VENoneView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.logoImage];
        [self addSubview:self.titleLab];
        
        @weakify(self);
        [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-(kScreenHeight/4));
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.logoImage.mas_bottom).mas_offset(15);
        }];
    }
    return self;
}

- (UIImageView *)logoImage{
    if (!_logoImage) {
        _logoImage = [UIImageView new];
        _logoImage.contentMode = UIViewContentModeScaleAspectFill;
        _logoImage.clipsToBounds = YES;
    }
    return _logoImage;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
    }
    return _titleLab;
}

+ (CGFloat)cellHeight{
    return kScreenHeight - Height_NavBar;
}

- (void)setLogoImage:(NSString *)imageName andTitle:(NSString *)titleStr{
    [self.logoImage setImage:[UIImage imageNamed:imageName]];
    self.titleLab.text = titleStr;
    
    CGSize imageSize = [UIImage imageNamed:imageName].size;
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imageSize);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
