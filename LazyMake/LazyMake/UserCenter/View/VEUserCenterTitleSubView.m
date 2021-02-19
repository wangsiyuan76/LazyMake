//
//  VEUserCenterTitleSubView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserCenterTitleSubView.h"

@implementation VEUserCenterTitleSubView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLab];
        [self addSubview:self.rightBtn];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(14);
        }];
            
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(-24);
        }];
    }
    return self;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = [UIColor colorWithHexString:@"1DABFD"];
        _titleLab.font = [UIFont systemFontOfSize:17];
    }
    return _titleLab;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
        [_rightBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightBtn setImage:[UIImage imageNamed:@"vm_icon_next_"] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"A1A7B2"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(clickClearBtn) forControlEvents:UIControlEventTouchUpInside];
        [VETool changeBtnStyleWithType:LMBtnImageTitleType_ImagRight distance:8 andBtn:_rightBtn];
    }
    return _rightBtn;
}

- (void)clickClearBtn{
    if (self.clickRightBtnBlock) {
        self.clickRightBtnBlock();
    }
}
@end
