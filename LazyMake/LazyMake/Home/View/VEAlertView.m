//
//  VEAlertView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/15.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEAlertView.h"

#define BTN_HEIGHT 52
#define MAIN_SIZE CGSizeMake(294, 120)

@implementation VEAlertView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainView];
        [self.mainView addSubview:self.titleLab];
        [self.mainView addSubview:self.sureBtn];
        [self.mainView addSubview:self.cancelBtn];
        [self.mainView addSubview:self.line1];
        [self.mainView addSubview:self.line2];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
        make.size.mas_equalTo(MAIN_SIZE);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo((self.mainView.height - BTN_HEIGHT)/2);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.height.mas_equalTo(BTN_HEIGHT);
         make.left.mas_equalTo(0);
         make.width.mas_equalTo(147);
         make.bottom.mas_equalTo(0);
     }];
     
     [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
         make.height.mas_equalTo(self.cancelBtn.mas_height);
         make.left.mas_equalTo(self.cancelBtn.mas_right);
         make.width.mas_equalTo(self.cancelBtn.mas_width);
         make.bottom.mas_equalTo(self.cancelBtn.mas_bottom);
     }];
     
     [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
         make.height.mas_equalTo(1);
         make.left.mas_equalTo(0);
         make.right.mas_equalTo(0);
         make.bottom.mas_equalTo(-BTN_HEIGHT);
     }];
     
     [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
         make.bottom.mas_equalTo(0);
         make.left.mas_equalTo(self.cancelBtn.mas_right);
         make.width.mas_equalTo(1);
         make.height.mas_equalTo(BTN_HEIGHT);
      }];
}

- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [UIView new];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.layer.masksToBounds = YES;
        _mainView.layer.cornerRadius = 10.f;
    }
    return _mainView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:17];
        _titleLab.numberOfLines = 2;
    }
    return _titleLab;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#1DABFD"] forState:UIControlStateNormal];
        _sureBtn.backgroundColor = [UIColor clearColor];
        [_sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#1DABFD"] forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn addTarget:self action:@selector(clickCancleBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIView *)line1{
    if (!_line1) {
        _line1 = [UIView new];
        _line1.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _line1;
}

- (UIView *)line2{
    if (!_line2) {
        _line2 = [UIView new];
        _line2.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _line2;
}

- (void)clickSureBtn{
    if (self.clickSubBtnBlock) {
        self.clickSubBtnBlock(1);
    }
    [self removeAllView];
}

- (void)clickCancleBtn{
    if (self.clickSubBtnBlock) {
        self.clickSubBtnBlock(0);
    }
    [self removeAllView];
}

- (void)removeAllView{
    [self.mainView removeFromSuperview];
    self.mainView = nil;
    [self removeFromSuperview];
}

- (void)setContentStr:(NSString *)contentStr{
    self.titleLab.text = contentStr;
    if (contentStr.length > 15) {
        [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(140);
        }];
    }
}

@end
