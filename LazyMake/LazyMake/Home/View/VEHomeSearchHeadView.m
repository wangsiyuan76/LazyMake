//
//  VEHomeSearchHeadView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/30.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeSearchHeadView.h"

@implementation VEHomeSearchHeadView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backBtn];
        [self addSubview:self.searchView];
        [self addSubview:self.searchText];
        [self addSubview:self.searchBtn];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.top.mas_equalTo(Height_StatusBar + 2);
        make.size.mas_equalTo(CGSizeMake(30, 40));
    }];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
        make.left.mas_equalTo(self.backBtn.mas_right).mas_offset(2);
        make.right.mas_equalTo(-54);
        make.height.mas_equalTo(30);
    }];
    
    [self.searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
        make.left.mas_equalTo(self.backBtn.mas_right).mas_offset(7);
        make.right.mas_equalTo(-54);
        make.height.mas_equalTo(30);
    }];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"vm_icon_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setBackgroundColor:[UIColor clearColor]];
    }
    return _backBtn;
}

- (UITextField *)searchText{
    if (!_searchText) {
        _searchText = [UITextField new];
        _searchText.textColor = [UIColor whiteColor];
        _searchText.font= [UIFont systemFontOfSize:14];
        _searchText.clearButtonMode = UITextFieldViewModeWhileEditing;                                     //只有编辑时出现出现那个叉叉
        _searchText.backgroundColor = [UIColor clearColor];
        _searchText.delegate = self;
        _searchText.returnKeyType = UIReturnKeySearch;
        _searchText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入要搜索的内容"attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#A1A7B2"]}];

        UIView *leftV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
        UIImageView *leftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_suosou_ss"]];
        leftImage.frame = CGRectMake(12, 5, 20, 20);
        [leftV addSubview:leftImage];
        _searchText.leftView = leftV;
        _searchText.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchText;
}

- (UIView *)searchView{
    if (!_searchView) {
        _searchView = [UIView new];
        _searchView.backgroundColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _searchView.layer.masksToBounds = YES;
        _searchView.layer.cornerRadius = 15.0f;
        _searchView.alpha = 0.3f;
    }
    return _searchView;
}

- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton new];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor colorWithHexString:@"#1DABFD"] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_searchBtn addTarget:self action:@selector(clickSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}
- (void)clickBackBtn{
    if (self.clickBackBlock) {
        self.clickBackBlock();
    }else{
        [currViewController().navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self clickSearchBtn];
    return YES;
}

- (void)clickSearchBtn{
    if (self.clickSearchBlock) {
        self.clickSearchBlock(self.searchText.text);
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
