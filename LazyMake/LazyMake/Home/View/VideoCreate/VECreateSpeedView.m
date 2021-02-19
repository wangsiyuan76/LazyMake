//
//  VECreateSpeedView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/17.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VECreateSpeedView.h"

@interface LMCreateSpeedItemView : UIView

@property (strong, nonatomic) UIView *noView;
@property (strong, nonatomic) UIView *selectView;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *selectLab;
@property (strong, nonatomic) UIButton *mainBtn;
@property (assign, nonatomic) BOOL ifSelect;
@end

@implementation LMCreateSpeedItemView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.noView];
        [self addSubview:self.titleLab];
        [self addSubview:self.selectLab];
        [self addSubview:self.mainBtn];
        [self addSubview:self.selectView];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.noView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self.selectLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.selectView.mas_bottom).mas_offset(4);
        make.right.mas_equalTo(0);
    }];
    
    [self.mainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (UIView *)noView{
    if (!_noView) {
        _noView = [UIView new];
        _noView.backgroundColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _noView.layer.masksToBounds = YES;
        _noView.layer.cornerRadius = 4.0f;
    }
    return _noView;
}

- (UIView *)selectView{
    if (!_selectView) {
        _selectView = [UIView new];
        _selectView.backgroundColor = [UIColor colorWithHexString:@"#1DABFD"];
        _selectView.layer.masksToBounds = YES;
        _selectView.layer.cornerRadius = 7.0f;
        _selectView.hidden = YES;
    }
    return _selectView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UILabel *)selectLab{
    if (!_selectLab) {
        _selectLab = [UILabel new];
        _selectLab.font = [UIFont systemFontOfSize:13];
        _selectLab.textColor = [UIColor colorWithHexString:@"#1DABFD"];
        _selectLab.textAlignment = NSTextAlignmentCenter;
    }
    return _selectLab;
}

- (UIButton *)mainBtn{
    if (!_mainBtn) {
        _mainBtn = [UIButton new];
    }
    return _mainBtn;
}

- (void)setIfSelect:(BOOL)ifSelect{
    _ifSelect = ifSelect;
    if(ifSelect){
        self.selectLab.hidden = NO;
//        self.selectView.hidden = NO;
    }else{
        self.selectLab.hidden = YES;
//        self.selectView.hidden = YES;
    }
}

@end

@interface VECreateSpeedView ()

@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) UIButton *cancleBtn;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSMutableArray *itemArr;
@property (strong, nonatomic) LMCreateSpeedItemView *selectView;
@property (strong, nonatomic) UISlider *slider;

@end

@implementation VECreateSpeedView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cancleBtn];
        [self addSubview:self.sureBtn];
        [self addSubview:self.titleLab];
        [self addSubview:self.lineView];
        [self setAllViewLayout];
        [self createSelectView];
        [self addSubview:self.slider];
    }
    return self;
}

- (void)createSelectView{
    self.itemArr = [NSMutableArray new];
    NSArray *titleArr = @[@"0.5x",@"1x",@"1.5x",@"2x"];
    CGFloat w = (kScreenWidth - 36 * 2)/3;
    CGFloat subW = 40;
    for (int x = 0; x < titleArr.count; x++) {
        LMCreateSpeedItemView *subV = [[LMCreateSpeedItemView alloc]initWithFrame:CGRectMake(36+(x*w)-subW/2, 63, subW, 50)];
        subV.backgroundColor = [UIColor clearColor];
        subV.titleLab.text = titleArr[x];
        subV.selectLab.text = titleArr[x];
        subV.ifSelect = NO;
        if (x == 1) {
            subV.ifSelect = YES;
            self.selectView = subV;
            self.selectStr = [self.selectView.titleLab.text stringByReplacingOccurrencesOfString:@"x" withString:@""];
        }
        subV.mainBtn.tag = x;
//        subV.mainBtn.userInteractionEnabled = NO;
        [subV.mainBtn addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:subV];
        [self.itemArr addObject:subV];
    }
}

- (void)clickSubBtn:(UIButton *)btn{
    for (LMCreateSpeedItemView *subV in self.itemArr) {
        subV.ifSelect = NO;
    }
    if (self.itemArr.count > btn.tag) {
        LMCreateSpeedItemView *subV = self.itemArr[btn.tag];
        subV.ifSelect = YES;
        self.selectView = subV;
    }
    self.selectStr = [self.selectView.titleLab.text stringByReplacingOccurrencesOfString:@"x" withString:@""];
    self.slider.value = self.selectStr.floatValue;
    
    if (self.changeValueBlock) {
        self.changeValueBlock(self.slider.value);
    }
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.cancleBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.sureBtn.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(36);
        make.right.mas_equalTo(-36);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(50);
        make.height.mas_equalTo(4);
    }];
}

- (UISlider *)slider{
    if (!_slider) {
        _slider = [[UISlider alloc]initWithFrame:CGRectMake(32, 85, kScreenWidth - 64, 8)];
        _slider.minimumValue = 0.5;
        _slider.maximumValue = 2;
        _slider.value = 1;
        _slider.minimumTrackTintColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _slider.maximumTrackTintColor = [UIColor colorWithHexString:@"#A1A7B2"];
        [_slider setThumbImage:[UIImage imageNamed:@"vm_detail_editorspeed_control"] forState:UIControlStateNormal];
//        [_slider addTarget:self action:@selector(sliderEndChangeValue:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderEndChangeEnd3) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slider;
}

- (void)sliderEndChangeEnd3{
    NSInteger selectItem = 0;
    if (self.slider.value >= 0.5 && self.slider.value < 1) {
        CGFloat min = 1 - self.slider.value;
        if (min >= 0.25) {
            self.slider.value = 0.5f;
            selectItem = 0;
        }else{
            self.slider.value = 1.0f;
            selectItem = 1;
        }
    }else if(self.slider.value >= 1 && self.slider.value < 1.5) {
        CGFloat min = 1.5 - self.slider.value;
        if (min >= 0.25) {
            self.slider.value = 1.0f;
            selectItem = 1;
        }else{
            self.slider.value = 1.5f;
            selectItem = 2;
        }
    }else if(self.slider.value >= 1.5 && self.slider.value <= 2) {
        CGFloat min = 2 - self.slider.value;
        if (min >= 0.25) {
            self.slider.value = 1.5f;
            selectItem = 2;
        }else{
            self.slider.value = 2.0f;
            selectItem = 3;
        }
    }
    
    if (self.itemArr.count > selectItem) {
        LMCreateSpeedItemView *subView = self.itemArr[selectItem];
        [self clickSubBtn:subView.mainBtn];
    }
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        [_sureBtn setImage:[UIImage imageNamed:@"vm_icon_popover_complete"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton new];
        [_cancleBtn setImage:[UIImage imageNamed:@"vm_icon_popover_close"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont boldSystemFontOfSize:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"变速";
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _titleLab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#A1A7B2"];

    }
    return _lineView;
}

- (void)setSpeValue:(NSString *)speValue{
    _speValue = speValue;
    self.slider.value = speValue.intValue;
    for (int x = 0; x < self.itemArr.count; x++) {
        LMCreateSpeedItemView *subView = self.itemArr[x];
        if ([subView.titleLab.text containsString:speValue]) {
            [self clickSubBtn:subView.mainBtn];
            break;
        }
    }
}

- (void)clickSureBtn{
    self.selectStr = [self.selectView.titleLab.text stringByReplacingOccurrencesOfString:@"x" withString:@""];
    if (self.clickBtnBlock) {
        self.clickBtnBlock(YES, self.selectStr);
    }
    
}

- (void)clickCancelBtn{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(NO, self.selectStr);
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
