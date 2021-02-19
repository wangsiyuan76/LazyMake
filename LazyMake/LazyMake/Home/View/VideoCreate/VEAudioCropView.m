//
//  VEAudioCropView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/22.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEAudioCropView.h"

@interface VEAudioCropView ()

@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) UIButton *cancleBtn;
@property (strong, nonatomic) UIImageView *leftImage;
@property (strong, nonatomic) UIImageView *rightImage;

@end

@implementation VEAudioCropView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cancleBtn];
        [self addSubview:self.sureBtn];
        [self addSubview:self.titleLab];
        [self addSubview:self.beginLab];
        [self addSubview:self.endLab];
        [self addSubview:self.bottomLab];
        [self addSubview:self.doubleSliderView];
        [self addSubview:self.leftImage];
        [self addSubview:self.rightImage];
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
    
    [self.beginLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(60);
    }];
    
    [self.endLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(60);
    }];
    
    [self.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.endLab.mas_bottom).mas_offset(16);
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
        _titleLab.text = @"裁剪时间";
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _titleLab;
}

- (UILabel *)bottomLab{
    if (!_bottomLab) {
        _bottomLab = [UILabel new];
        _bottomLab.font = [UIFont systemFontOfSize:14];
        _bottomLab.textAlignment = NSTextAlignmentCenter;
        _bottomLab.text = @"已选择10秒";
        _bottomLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _bottomLab;
}


- (UILabel *)beginLab{
    if (!_beginLab) {
        _beginLab = [UILabel new];
        _beginLab.font = [UIFont boldSystemFontOfSize:12];
        _beginLab.textAlignment = NSTextAlignmentCenter;
        _beginLab.text = @"00:00";
        _beginLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
    }
    return _beginLab;
}

- (UILabel *)endLab{
    if (!_endLab) {
        _endLab = [UILabel new];
        _endLab.font = [UIFont boldSystemFontOfSize:12];
        _endLab.textAlignment = NSTextAlignmentCenter;
        _endLab.text = @"00:00";
        _endLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _endLab.textAlignment = NSTextAlignmentCenter;
    }
    return _endLab;
}

- (UIImageView *)leftImage{
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_detail_tailor_1"]];
        _leftImage.centerX = 68;
        _leftImage.frame = CGRectMake(68-7, 72, 13, 18);
    }
    return _leftImage;
}

- (UIImageView *)rightImage{
    if (!_rightImage) {
        _rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_detail_tailor_2"]];
        _rightImage.frame = CGRectMake(kScreenWidth - (68 + 9), 46, 13, 18);
    }
    return _rightImage;
}
- (DoubleSlider *)doubleSliderView{
    if (!_doubleSliderView) {
        _doubleSliderView = [[DoubleSlider alloc]initWithFrame:CGRectMake(68, 40, kScreenWidth - (68*2), 35 + 20)];
        DoubleSliderConfig *config = [[DoubleSliderConfig alloc]init];
        config.defaultLeftValue = 0;
        config.minValue = 0;
        config.leftLineColor = [UIColor colorWithHexString:@"#A1A7B2"];
        config.rightLineColor = [UIColor colorWithHexString:@"#A1A7B2"];
        config.middleLineColor = [UIColor colorWithHexString:@"#1DABFD"];
        config.sliderSize = CGSizeMake(30, 50);
        config.leftSliderColor = [UIColor clearColor];
        config.rightSliderColor = [UIColor clearColor];
        config.minInterval = 6.0f;
        _doubleSliderView.config = config;
        @weakify(self);
        _doubleSliderView.panResponse = ^(CGFloat leftValue, CGFloat rightValue, CGPoint leftCenter, CGPoint rightCenter, BOOL ifEnd, BOOL ifLeft) {
            @strongify(self);
            LMLog(@"currentValue -- %lf---%lf --%lf--%lf",leftValue,rightValue,leftCenter.x,rightCenter.x);
            self.leftImage.centerX = 68 + leftCenter.x;
            self.rightImage.centerX = 68 + rightCenter.x;
            self.bottomLab.text = [NSString stringWithFormat:@"已选择%zd秒",(NSInteger)rightValue-(NSInteger)leftValue];
            self.beginLab.text = [self changeTimeWithInt:leftValue];
            self.endLab.text = [self changeTimeWithInt:rightValue];
            if (ifEnd) {
                if (self.changeSelectTimeBlock) {
                    self.changeSelectTimeBlock(leftValue,rightValue,rightValue-leftValue,ifLeft);
                }
            }
        };
    }
    return _doubleSliderView;
}


- (void)setAllTime:(NSInteger)allTime{
    _allTime = allTime;
    self.endLab.text = [self changeTimeWithInt:allTime];
    self.bottomLab.text = [NSString stringWithFormat:@"已选择%zd秒",allTime];
    
    self.doubleSliderView.config.maxValue = allTime;
    self.doubleSliderView.config.defaultRightValue = allTime;
    self.doubleSliderView.config = self.doubleSliderView.config;
}

- (NSString *)changeTimeWithInt:(NSInteger)timeInt{
    return [NSString stringWithFormat:@"%.2zd:%.2zd",timeInt/60,timeInt%60];
}

+ (CGFloat)viewHeight{
    return 140 + Height_SafeAreaBottom;
}

- (void)clickCancelBtn{
    if (self.clickDoneBtnBlock) {
        self.clickDoneBtnBlock(NO);
    }
}
- (void)clickSureBtn{
    if (self.clickDoneBtnBlock) {
        self.clickDoneBtnBlock(YES);
    }
}

- (void)hiddenTitleView{
    self.titleLab.hidden = YES;
    self.sureBtn.hidden = YES;
    self.cancleBtn.hidden = YES;
}

@end
