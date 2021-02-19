//
//  VETemplateNavHeadView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VETemplateNavHeadView.h"

@interface VETemplateNavHeadView ()

@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *undoBtn;
@property (strong, nonatomic) UIButton *shareBtn;

@end

@implementation VETemplateNavHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backBtn];
        [self addSubview:self.shareBtn];
        [self addSubview:self.undoBtn];
        [self addSubview:self.titleLab];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(12 + Height_StatusBar);
        make.width.mas_equalTo(50);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(50);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.undoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
//        make.right.mas_equalTo(self.shareBtn.mas_left).mas_offset(0);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
        make.width.mas_equalTo(40);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"vm_icon_back"] forState:UIControlStateNormal];
        _backBtn.tag = 1;
        [_backBtn addTarget:self action:@selector(clickNavBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(UIButton *)undoBtn{
    if (!_undoBtn) {
        _undoBtn = [UIButton new];
        [_undoBtn setImage:[UIImage imageNamed:@"vm_icon_reset"] forState:UIControlStateNormal];
        _undoBtn.tag = 2;
        [_undoBtn addTarget:self action:@selector(clickNavBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _undoBtn;
}


-(UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton new];
        [_shareBtn setImage:[UIImage imageNamed:@"vm_icon_share"] forState:UIControlStateNormal];
        _shareBtn.tag = 3;
        [_shareBtn addTarget:self action:@selector(clickNavBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _shareBtn.hidden = YES;
    }
    return _shareBtn;
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

- (void)clickNavBtn:(UIButton *)btn{
    if (self.clickNavBtnBlock) {
        self.clickNavBtnBlock(btn.tag);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
