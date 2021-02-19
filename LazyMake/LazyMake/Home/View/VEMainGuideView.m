//
//  VEMainGuideView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEMainGuideView.h"

@implementation VEMainGuideView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainShadowBtn];
        [self addSubview:self.subImage];
        [self.mainShadowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

- (UIButton *)mainShadowBtn{
    if (!_mainShadowBtn) {
        _mainShadowBtn = [UIButton new];
        _mainShadowBtn.backgroundColor = [UIColor blackColor];
        _mainShadowBtn.alpha = 0.6f;
        [_mainShadowBtn addTarget:self action:@selector(clickShadowBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mainShadowBtn;
}

- (UIImageView *)subImage{
    if (!_subImage) {
        _subImage = [UIImageView new];
    }
    return _subImage;
}

- (void)clickShadowBtn{
    if (self.clickMainBtnBlock) {
        self.clickMainBtnBlock();
    }else{
        [self hiddenAll];
    }
}

- (void)hiddenAll{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showAll{
    self.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
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
