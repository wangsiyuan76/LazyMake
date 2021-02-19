//
//  VECreateBottomFeaturesView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/17.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VECreateBottomFeaturesView.h"

@interface LMCreateBottomFeaturesItemView : UIView

@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *titlLab;
@property (strong, nonatomic) UIButton *btn;

@end

@implementation LMCreateBottomFeaturesItemView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImage];
        [self addSubview:self.titlLab];
        [self addSubview:self.btn];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-20);
    }];
    [self.titlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.iconImage.mas_bottom).mas_offset(6);
    }];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [UIImageView new];
    }
    return _iconImage;
}

- (UILabel *)titlLab{
    if (!_titlLab) {
        _titlLab = [UILabel new];
        _titlLab.textAlignment = NSTextAlignmentCenter;
        _titlLab.font = [UIFont systemFontOfSize:15];
        _titlLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _titlLab;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton new];
    }
    return _btn;
}

@end
@implementation VECreateBottomFeaturesView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr imageArr:(NSArray *)imageArr{
    self = [super initWithFrame:frame];
    if (self) {
        _titleArr = titleArr;
        _imageArr = imageArr;
        [self createAllView];
    }
    return self;
}

- (void)createAllView{
    CGFloat btnW = kScreenWidth/_titleArr.count;
    for (int x = 0; x < _titleArr.count; x++) {
        LMCreateBottomFeaturesItemView *btn = [[LMCreateBottomFeaturesItemView alloc]initWithFrame:CGRectMake(x*btnW, 0, btnW, self.bounds.size.height)];
        [btn.iconImage setImage:[UIImage imageNamed:_imageArr[x]]];
        btn.titlLab.text = _titleArr[x];
        btn.btn.tag = x;
        [btn.btn addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)clickSubBtn:(UIButton *)btn{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(btn.tag);
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
