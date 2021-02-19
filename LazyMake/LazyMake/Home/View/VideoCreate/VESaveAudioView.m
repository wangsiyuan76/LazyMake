//
//  VESaveAudioView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/26.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VESaveAudioView.h"

@interface VESaveAudioView ()

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *contentLab;
@property (strong, nonatomic) UILabel *mp3Lab;
@property (strong, nonatomic) UIButton *cacleBtn;
@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) UIView *line1;
@property (strong, nonatomic) UIView *line2;


@end

@implementation VESaveAudioView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLab];
        [self addSubview:self.contentLab];
        [self addSubview:self.contentText];
        [self addSubview:self.mp3Lab];
        [self addSubview:self.cacleBtn];
        [self addSubview:self.sureBtn];
        [self addSubview:self.line1];
        [self addSubview:self.line2];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(18);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(14);
    }];
    
    [self.contentText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.contentLab.mas_bottom).mas_offset(14);
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-54);
        make.height.mas_equalTo(35);
    }];
    
    [self.mp3Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(self.contentText.mas_bottom);
        make.left.mas_equalTo(self.contentText.mas_right).mas_offset(4);
    }];
    
//    [self.cacleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.bottom.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(self.contentText.mas_bottom).mas_offset(20);
//        make.right.mas_equalTo(self.mas_centerX);
//    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.contentText.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(0);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.contentText.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.contentText.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(1);
    }];
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:17];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"保存成功（可更改歌名）"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1A1A1A"] range:NSMakeRange(0,4)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#A1A7B2"] range:NSMakeRange(4,str.length-4)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(4,str.length-4)];
        _titleLab.attributedText = str;
    }
    return _titleLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:13];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _contentLab.text = @"本地路径：/Application/Documents/Music/";
    }
    return _contentLab;
}

- (UITextField *)contentText{
    if (!_contentText) {
        _contentText = [[UITextField alloc]init];
        _contentText.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
        _contentText.layer.masksToBounds = YES;
        _contentText.layer.cornerRadius = 7.0f;
        _contentText.textColor = [UIColor blackColor];
        
        UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];
        leftV.backgroundColor = _contentText.backgroundColor;
        _contentText.leftView = leftV;
        _contentText.leftViewMode = UITextFieldViewModeAlways;
    }
    return _contentText;
}

- (UILabel *)mp3Lab{
    if (!_mp3Lab) {
        _mp3Lab = [UILabel new];
        _mp3Lab.font = [UIFont systemFontOfSize:13];
        _mp3Lab.textAlignment = NSTextAlignmentLeft;
        _mp3Lab.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
        _mp3Lab.text = @".w4a";
    }
    return _mp3Lab;
}

- (UIButton *)cacleBtn{
    if (!_cacleBtn) {
        _cacleBtn = [UIButton new];
        [_cacleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cacleBtn setTitleColor:[UIColor colorWithHexString:@"#1DABFD"] forState:UIControlStateNormal];
        _cacleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _cacleBtn.tag = 1;
        _cacleBtn.hidden = YES;
        [_cacleBtn addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cacleBtn;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#1DABFD"] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _sureBtn.tag = 2;
        [_sureBtn addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
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
        _line2.hidden = YES;
    }
    return _line2;
}

- (void)clickSubBtn:(UIButton *)btn{
    if (self.contentText.text.length > 0) {
        if (self.clickSubBtnBlock) {
            self.clickSubBtnBlock(btn.tag, self.contentText.text);
        }
    }else{
        [MBProgressHUD showError:@"文件名不能为空"];
    }
}

- (void)setAudioName:(NSString *)audioName{
    _audioName = audioName;
    self.contentText.text = audioName;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
