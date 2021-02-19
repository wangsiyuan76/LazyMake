//
//  VEAudioChangeSizeView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/22.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEAudioChangeSizeView.h"

@implementation VEAudioChangeSizeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cancleBtn];
        [self addSubview:self.sureBtn];
        [self addSubview:self.titleLab];
        [self addSubview:self.audioLogo];
        [self addSubview:self.audioTitle];
        [self addSubview:self.audioDelete];
        [self addSubview:self.lab1];
        [self addSubview:self.lab2];
        [self addSubview:self.slider1];
        [self addSubview:self.slider2];
        [self addSubview:self.selectAudioBtn];
        [self addSubview:self.selectAudioBtn2];
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
    
    [self.audioLogo mas_makeConstraints:^(MASConstraintMaker *make) {       //
        @strongify(self);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.bottom.mas_equalTo(self.sureBtn.mas_bottom).mas_offset(18);
    }];
    
    [self.audioTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.audioLogo.mas_right).mas_offset(6);
        make.centerY.mas_equalTo(self.audioLogo.mas_centerY);
    }];
    
    [self.audioDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.audioTitle.mas_right).mas_offset(6);
        make.centerY.mas_equalTo(self.audioLogo.mas_centerY);
    }];
    
    [self.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(32);
        make.top.mas_equalTo(self.audioTitle.mas_bottom).mas_offset(18);
    }];
    
    [self.lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(32);
        make.top.mas_equalTo(self.lab1.mas_bottom).mas_offset(18);
    }];
    
    [self.slider1 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.lab1.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.lab1.mas_centerY);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(10);
    }];
    
    [self.slider2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.lab2.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.lab2.mas_centerY);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(10);
    }];
    
    [self.selectAudioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo((kScreenWidth-145-145-25)/2);
        make.size.mas_equalTo(CGSizeMake(145, 36));
        make.top.mas_equalTo(self.slider2.mas_bottom).mas_offset(26);
    }];
    
    [self.selectAudioBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.selectAudioBtn.mas_right).mas_offset(25);
        make.size.mas_equalTo(CGSizeMake(145, 36));
        make.top.mas_equalTo(self.slider2.mas_bottom).mas_offset(26);
    }];
}

- (UIButton *)selectAudioBtn{
    if (!_selectAudioBtn) {
        _selectAudioBtn = [UIButton new];
        [_selectAudioBtn setTitle:@"本地音乐" forState:UIControlStateNormal];
        [_selectAudioBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _selectAudioBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _selectAudioBtn.layer.masksToBounds = YES;
        _selectAudioBtn.layer.cornerRadius = 18;
        _selectAudioBtn.tag = 1;
        [_selectAudioBtn setBackgroundImage:[VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(145, 36)] forState:UIControlStateNormal];
        [_selectAudioBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectAudioBtn;
}

- (UIButton *)selectAudioBtn2{
    if (!_selectAudioBtn2) {
        _selectAudioBtn2 = [UIButton new];
        [_selectAudioBtn2 setTitle:@"从视频提取音频" forState:UIControlStateNormal];
        [_selectAudioBtn2 setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _selectAudioBtn2.titleLabel.font = [UIFont systemFontOfSize:17];
        _selectAudioBtn2.layer.masksToBounds = YES;
        _selectAudioBtn2.layer.cornerRadius = 18;
        _selectAudioBtn2.tag = 2;
        [_selectAudioBtn2 setBackgroundImage:[VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(145, 36)] forState:UIControlStateNormal];
        [_selectAudioBtn2 addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectAudioBtn2;
}

- (UIImageView *)audioLogo{
    if (!_audioLogo) {
        _audioLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_icon_popover_music_"]];
    }
    return _audioLogo;
}

- (UILabel *)audioTitle{
    if (!_audioTitle) {
        _audioTitle = [UILabel new];
        _audioTitle.font = [UIFont systemFontOfSize:15];
        _audioTitle.textColor = [UIColor colorWithHexString:@"#1DABFD"];
        _audioTitle.text = @"音乐名称";
    }
    return _audioTitle;
}

- (UILabel *)lab1{
    if (!_lab1) {
        _lab1 = [UILabel new];
        _lab1.font = [UIFont systemFontOfSize:15];
        _lab1.textColor = [UIColor colorWithHexString:@"ffffff"];
        _lab1.text = @"配乐";
    }
    return _lab1;
}

- (UILabel *)lab2{
    if (!_lab2) {
        _lab2 = [UILabel new];
        _lab2.font = [UIFont systemFontOfSize:15];
        _lab2.textColor = [UIColor colorWithHexString:@"ffffff"];
        _lab2.text = @"原声";
    }
    return _lab2;
}

-(UISlider *)slider1{
    if (!_slider1) {
        _slider1 = [[UISlider alloc] initWithFrame:CGRectZero];
        _slider1.minimumValue = 0;
        _slider1.maximumValue = 1;
        _slider1.value = 1;
        _slider1.minimumTrackTintColor = [UIColor colorWithHexString:@"#1DABFD"];
        _slider1.maximumTrackTintColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _slider1.thumbTintColor = [UIColor yellowColor];
        [_slider1 setThumbImage:[UIImage imageNamed:@"vm_detail_editorspeed_control"] forState:UIControlStateNormal];
        [_slider1 setThumbImage:[UIImage imageNamed:@"vm_detail_editorspeed_control"] forState:UIControlStateHighlighted];
        [_slider1 addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    }
    return _slider1;
}

-(UISlider *)slider2{
    if (!_slider2) {
        _slider2 = [[UISlider alloc] initWithFrame:CGRectZero];
        _slider2.minimumValue = 0;
        _slider2.maximumValue = 1;
        _slider2.value = 1;
        _slider2.minimumTrackTintColor = [UIColor colorWithHexString:@"#1DABFD"];
        _slider2.maximumTrackTintColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _slider2.thumbTintColor = [UIColor yellowColor];
        [_slider2 setThumbImage:[UIImage imageNamed:@"vm_detail_editorspeed_control"] forState:UIControlStateNormal];
        [_slider2 setThumbImage:[UIImage imageNamed:@"vm_detail_editorspeed_control"] forState:UIControlStateHighlighted];
        [_slider2 addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    }
    return _slider2;
}

- (UIButton *)audioDelete{
    if (!_audioDelete) {
        _audioDelete = [UIButton new];
        [_audioDelete setImage:[UIImage imageNamed:@"vm_icon_popover_delete_"] forState:UIControlStateNormal];
        [_audioDelete addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioDelete;
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
        _titleLab.text = @"配乐";
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _titleLab;
}



- (void)clickCancelBtn{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(NO,self.slider2.value,self.slider1.value);
    }
}

- (void)clickSureBtn{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(YES,self.slider2.value,self.slider1.value);
    }
}

- (void)clickSelectBtn:(UIButton *)btn{
    if (self.clickSelectBtnBlock) {
        self.clickSelectBtnBlock(btn.tag);
    }
}

- (void)setOldSize:(CGFloat)oldSize newSize:(CGFloat)newSize{
    self.slider2.value = oldSize;
    self.slider1.value = newSize;
}

//是否显示顶部配乐音量
- (void)changeHeadIfShow:(BOOL)ifShow{
    if (ifShow) {
        self.audioLogo.hidden = NO;
        self.audioTitle.hidden = NO;
        self.audioDelete.hidden = NO;
        self.lab1.hidden = NO;
        self.slider1.hidden = NO;
        @weakify(self);
        [self.lab2 mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.lab1.mas_bottom).mas_offset(18);
        }];
    }else{
        self.audioLogo.hidden = YES;
        self.audioTitle.hidden = YES;
        self.audioDelete.hidden = YES;
        self.lab1.hidden = YES;
        self.slider1.hidden = YES;
        @weakify(self);
        [self.lab2 mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.lab1.mas_bottom).mas_offset(-30);

        }];
    }
}

+ (CGFloat)viewHeightIfAll:(BOOL)ifAll{
    if (ifAll) {
        return 200;
    }
    return 150;
}

- (void)clickDeleteBtn{
    [self changeHeadIfShow:NO];
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+50, self.frame.size.width, [[self class]viewHeightIfAll:NO]);
    }];
    self.audioTitle.text = @"";
    if (self.clickDeleteAudioBlock) {
        self.clickDeleteAudioBlock();
    }
}


- (void)sliderValueChanged:(UISlider *)slider{

    NSLog(@"slider value%f",slider.value);
}
@end
