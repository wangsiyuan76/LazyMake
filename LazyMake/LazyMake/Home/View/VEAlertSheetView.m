//
//  VEAlertSheetView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/18.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEAlertSheetView.h"
#define BTN_HEIGHT 50

@interface VEAlertSheetView ()

@property (strong, nonatomic) NSArray *titleArr;
@property (strong, nonatomic) NSString *cancelStr;
@property (strong, nonatomic) NSString *titleStr;

@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIButton *shadowBtn;

@end

@implementation VEAlertSheetView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr titleStr:(NSString *)titleStr{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArr = titleArr;
        self.titleStr = titleStr;
        [self addSubview:self.shadowBtn];
        [self addSubview:self.mainView];
        
        [self cerateAllView];
    }
    return self;
}


- (void)cerateAllView{
    for (int x = 0; x < self.titleArr.count; x++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, x*BTN_HEIGHT, self.width, BTN_HEIGHT)];
        btn.userInteractionEnabled = YES;
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [btn setTitleColor:[UIColor colorWithHexString:@"#1A1A1A"] forState:UIControlStateNormal];
        
        [btn setTitle:self.titleArr[x] forState:UIControlStateNormal];
        btn.tag = x;
        [btn addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:btn];
        [self.mainView addSubview:lineV];
        if (x == self.titleArr.count - 1) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#A1A7B2"] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#F0F0F0"]];
        }
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(x*BTN_HEIGHT);
            make.height.mas_equalTo(BTN_HEIGHT);
        }];
        
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo((x+1)*BTN_HEIGHT);
            make.height.mas_equalTo(0.5);
        }];
    }
}

- (void)clickSubBtn:(UIButton *)btn{
    BOOL ifCancel = NO;
    if (btn.tag == self.titleArr.count - 1) {
        ifCancel = YES;
    }else{
        if (self.clickSubBtnBlock) {
            self.clickSubBtnBlock(ifCancel, btn.tag);
        }
        
    }
    [self hiddenAll];
}

- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [[UIView alloc]initWithFrame:CGRectMake(15, kScreenHeight+20, kScreenWidth-30, self.titleArr.count * BTN_HEIGHT)];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.userInteractionEnabled = YES;
        _mainView.layer.masksToBounds = YES;
        _mainView.layer.cornerRadius = 10.0f;
    }
    return _mainView;
}

- (UIButton *)shadowBtn{
    if (!_shadowBtn) {
        _shadowBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _shadowBtn.backgroundColor = [UIColor blackColor];
        _shadowBtn.alpha = 0.f;
        [_shadowBtn addTarget:self action:@selector(clickShadowBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shadowBtn;
}

- (void)show{
    [UIView animateWithDuration:0.2 animations:^{
        self.shadowBtn.alpha = 0.4f;
        self.mainView.frame = CGRectMake(15, kScreenHeight - (self.titleArr.count * BTN_HEIGHT)- 20 - Height_StatusBar, kScreenWidth-30, self.titleArr.count * BTN_HEIGHT);
    }];
    
}

- (void)hiddenAll{
    [UIView animateWithDuration:0.2 animations:^{
        self.shadowBtn.alpha = 0.f;
        self.mainView.frame = CGRectMake(15, kScreenHeight+20, kScreenWidth-30, self.titleArr.count * BTN_HEIGHT);
    }completion:^(BOOL finished) {
        [self removeAll];
    }];
}

- (void)removeAll{
    [self.shadowBtn removeFromSuperview];
    self.shadowBtn = nil;
    [self.mainView removeFromSuperview];
    self.mainView = nil;
    [self removeFromSuperview];
}

- (void)clickShadowBtn{
    [self hiddenAll];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
