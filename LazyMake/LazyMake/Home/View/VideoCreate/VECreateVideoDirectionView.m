//
//  VECreateVideoDirectionView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/16.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VECreateVideoDirectionView.h"

@implementation VECreateVideoDirectionView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shadowBtn];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.topBtn];
        [self.contentView addSubview:self.leftBtn];
        [self.contentView addSubview:self.pickView];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.sureBtn];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.shadowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(295,240));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(40);
    }];
    
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.titleLab.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.topBtn.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(120);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.pickView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.pickView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _lineView;
}

- (UIPickerView *)pickView{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc]initWithFrame:CGRectZero];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor whiteColor];
    }
    return _pickView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 8.0f;
    }
    return _contentView;
}

- (UIButton *)shadowBtn{
    if (!_shadowBtn) {
        _shadowBtn = [UIButton new];
        _shadowBtn.backgroundColor = [UIColor blackColor];
        _shadowBtn.alpha = 0.7f;
        [_shadowBtn addTarget:self action:@selector(clickShadowBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shadowBtn;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont boldSystemFontOfSize:18];
        _titleLab.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"选择方向";
    }
    return _titleLab;
}

- (UIButton *)topBtn{
    if (!_topBtn) {
        _topBtn = [UIButton new];
        _topBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_topBtn setTitle:@"上下镜像" forState:UIControlStateNormal];
        [_topBtn setTitleColor:[UIColor colorWithHexString:@"#1DABFD"] forState:UIControlStateSelected];
        [_topBtn setTitleColor:[UIColor colorWithHexString:@"#A1A7B2"] forState:UIControlStateNormal];
        _topBtn.tag = 1;
        _topBtn.selected = YES;
        _topBtn.hidden = YES;
        [_topBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBtn;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_leftBtn setTitle:@"左右镜像" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor colorWithHexString:@"#1DABFD"] forState:UIControlStateSelected];
        [_leftBtn setTitleColor:[UIColor colorWithHexString:@"#A1A7B2"] forState:UIControlStateNormal];
        _leftBtn.tag = 2;
        _leftBtn.hidden = YES;
        [_leftBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}


- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        _sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#1DABFD"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(clickSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (void)clickShadowBtn{
    if (self.clickSelectBlock) {
        self.clickSelectBlock(self.selectIndex,NO);
    }
    [self.shadowBtn removeFromSuperview];
    [self removeFromSuperview];
}

- (void)clickSelectBtn:(UIButton *)btn{
    self.leftBtn.selected = NO;
    self.topBtn.selected = NO;
    btn.selected = YES;
    
}

- (void)clickSureBtn:(UIButton *)btn{
//    NSInteger btnTag = self.leftBtn.tag;
//    if (self.topBtn.selected) {
//        btnTag = self.topBtn.tag;
//    }
    if (self.clickSelectBlock) {
        self.clickSelectBlock(self.selectIndex,YES);
    }
    [self.shadowBtn removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - UIPickViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
            singleLine.width = 150;
            singleLine.left = (295 - 150)/2;
        }
    }
    
    /*重新定义row 的UILabel*/
    UILabel *pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        [pickerLabel setTextColor:[UIColor darkGrayColor]];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16.0f]];
       // [pickerLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    }

    if (row == self.selectIndex) {
        pickerLabel.attributedText = [self pickerView:pickerView attributedTitleForRow:self.selectIndex forComponent:component];
    }else{
        pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
    return pickerLabel;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *titleString;
    if (row == 0) {
        titleString =  @"上下镜像";
    }
    else if (row == 1){
       titleString = @"左右镜像";
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:titleString];
    NSRange range = [titleString rangeOfString:titleString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1DABFD"] range:range];
    return attributedString;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row == 0) {
        return @"上下镜像";
    }
    else if (row == 1){
       return @"左右镜像";
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectIndex = row;
//    UILabel *piketLabel =  (UILabel *)[pickerView viewForRow:row forComponent:component];
//    piketLabel.textColor = [UIColor colorWithHexString:@"1DABFD"];
    [pickerView reloadAllComponents];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
