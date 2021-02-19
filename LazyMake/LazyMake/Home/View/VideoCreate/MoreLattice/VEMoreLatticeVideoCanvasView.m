//
//  VEMoreLatticeVideoCanvasView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEMoreLatticeVideoCanvasView.h"

@implementation LMMoreLatticeVideoSubCanvasView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainView];
        [self addSubview:self.borderView];
        [self addSubview:self.titleLab];
        [self addSubview:self.mainBtn];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.mainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

- (UIView *)borderView{
    if (!_borderView) {
        _borderView = [UIView new];
        _borderView.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
        _borderView.layer.borderWidth = 1;
    }
    return _borderView;
}

- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [UIView new];
        _mainView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _mainView.alpha = 0.2f;
    }
    return _mainView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _titleLab;
}

- (UIButton *)mainBtn{
    if (!_mainBtn) {
        _mainBtn = [UIButton new];
        [_mainBtn addTarget:self action:@selector(clickMainBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mainBtn;
}

- (void)setSelect:(BOOL)ifSelect{
    if (ifSelect) {
        self.borderView.layer.borderColor = [UIColor colorWithHexString:@"#20A0F4"].CGColor;
        self.mainView.backgroundColor = [UIColor colorWithHexString:@"#20A0F4"];
    }else{
        self.borderView.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
        self.mainView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
}

- (void)clickMainBtn{
    if (self.clickMainBtnBlock) {
        self.clickMainBtnBlock(self.tag);
    }
}

@end

@implementation VEMoreLatticeVideoCanvasView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.sureBtn];
        [self addSubview:self.cancleBtn];
        [self addSubview:self.titleLab];
        [self addSubview:self.scroolView];
        [self setAllViewLayout];
    }
    return self;
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
        _titleLab.text = @"画布";
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _titleLab;
}

- (UIScrollView *)scroolView{
    if (!_scroolView) {
        _scroolView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, self.width, 100)];
        _scroolView.showsVerticalScrollIndicator = NO;
        _scroolView.showsHorizontalScrollIndicator = NO;
        self.subArr = [NSMutableArray new];
        
        NSArray *wArr = @[@"45",@"80",@"80",@"60",@"80"];
        NSArray *hArr = @[@"80",@"45",@"80",@"80",@"60"];
        NSArray *titleArr = @[@"9:16",@"16:9",@"1:1",@"3:4",@"4:3"];
        CGFloat interval = 10;
        CGFloat maxLeft = 0;
        for (int x = 0; x < wArr.count; x++) {
            NSString * w = wArr[x];
            NSString * h = hArr[x];
            CGFloat top = (80 - h.intValue)/2 + 10;

            LMMoreLatticeVideoSubCanvasView *subV = [[LMMoreLatticeVideoSubCanvasView alloc]initWithFrame:CGRectMake((interval*(x+1)) + maxLeft, top, w.intValue, h.intValue)];
            subV.tag = x;
            subV.titleLab.text = titleArr[x];
            if (x == 0) {
                [subV setSelect:YES];
            }else{
                [subV setSelect:NO];
            }
            @weakify(self);
            subV.clickMainBtnBlock = ^(NSInteger tag) {
                @strongify(self);
                [self changeSelectWithIndex:tag];
            };
            
            maxLeft += w.intValue;
            [self.subArr addObject:subV];
            [_scroolView addSubview:subV];
        }
        _scroolView.contentSize = CGSizeMake(maxLeft+(interval*(wArr.count+1)), 100);
    }
    return _scroolView;
}

- (void)changeSelectWithIndex:(NSInteger)index{
    self.selectIndex = index;
    for (LMMoreLatticeVideoSubCanvasView *subV in self.subArr) {
        if (subV.tag == index) {
            [subV setSelect:YES];
        }else{
            [subV setSelect:NO];
        }
    }
}

- (void)clickSureBtn{
    if (self.clickSubChangeBlock) {
        self.clickSubChangeBlock(YES, self.selectIndex, [self showSize]);
    }
}

- (void)clickCancelBtn{
    if (self.clickSubChangeBlock) {
        self.clickSubChangeBlock(NO, self.selectIndex, [self showSize]);
    }
}

- (CGSize)showSize{
    if (self.selectIndex == 0) {
        return CGSizeMake(9, 16);
    }
    if (self.selectIndex == 1) {
        return CGSizeMake(16, 9);
    }
    if (self.selectIndex == 2) {
        return CGSizeMake(1, 1);
    }
    if (self.selectIndex == 3) {
        return CGSizeMake(3, 4);
    }
    return CGSizeMake(4, 3);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
