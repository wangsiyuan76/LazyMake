//
//  VEHomeSearchTitleReusableView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeSearchTitleReusableView.h"

@implementation VEHomeSearchTitleReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLab];
        [self addSubview:self.clearBtn];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(0);
        }];
        
        [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(-10);
        }];
    }
    return self;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = [UIColor colorWithHexString:@"1DABFD"];
        _titleLab.font = [UIFont systemFontOfSize:18];
    }
    return _titleLab;
}

- (UIButton *)clearBtn{
    if (!_clearBtn) {
        _clearBtn = [UIButton new];
        [_clearBtn setTitle:@"清空" forState:UIControlStateNormal];
        _clearBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_clearBtn setTitleColor:[UIColor colorWithHexString:@"A1A7B2"] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clickClearBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

- (void)clickClearBtn{
    if (self.cleanBtnBlock) {
        self.cleanBtnBlock();
    }
}

@end
