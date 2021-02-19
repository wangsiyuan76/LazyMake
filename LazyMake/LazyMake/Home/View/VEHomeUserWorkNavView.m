//
//  VEHomeUserWorkNavView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/10.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeUserWorkNavView.h"

@implementation VEHomeUserWorkNavView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backBtn];
        [self addSubview:self.titleLab];
        
        @weakify(self);
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.mas_equalTo(0);
             make.top.mas_equalTo(12 + Height_StatusBar);
             make.width.mas_equalTo(50);
         }];
         
         [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
             @strongify(self);
             make.left.mas_equalTo(20);
             make.right.mas_equalTo(-20);
             make.centerY.mas_equalTo(self.backBtn.mas_centerY);
         }];
    }
    return self;
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"vm_icon_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont boldSystemFontOfSize:17];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (void)clickBackBtn{
    [currViewController().navigationController popViewControllerAnimated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
