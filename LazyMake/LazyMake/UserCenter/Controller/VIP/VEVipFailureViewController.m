//
//  VEVipFailureViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVipFailureViewController.h"

@interface VEVipFailureViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *contentLab;
@property (strong, nonatomic) UIButton *serviceBtn;
@property (strong, nonatomic) UILabel *bottomLab;

@end

@implementation VEVipFailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    //self.navigationController.navigationBar.topItem.title = @"";
    self.title = @"充值结果";
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.contentLab];
    [self.view addSubview:self.bottomLab];
    [self.view addSubview:self.serviceBtn];
    [self setAllViewLayout];
    // Do any additional setup after loading the view.
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(60 + Height_NavBar);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(16);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-60);
    }];
    
    [self.serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(self.bottomLab.mas_top).mas_offset(-10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        [_imageView setImage:[UIImage imageNamed:@"vm_check_fail"]];
    }
    return _imageView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:23];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"支付失败";
    }
    return _titleLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.text = @"请检查网络连接是否正常";
    }
    return _contentLab;
}

- (UILabel *)bottomLab{
    if (!_bottomLab) {
        _bottomLab = [UILabel new];
        _bottomLab.font = [UIFont systemFontOfSize:14];
        _bottomLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _bottomLab.textAlignment = NSTextAlignmentCenter;
        _bottomLab.text = @"在线时间: 周一到周五 8:30-18:00";
    }
    return _bottomLab;
}

- (UIButton *)serviceBtn{
    if (!_serviceBtn) {
        _serviceBtn = [UIButton new];
        [_serviceBtn setTitle:@"点击联系客服" forState:UIControlStateNormal];
        [_serviceBtn setTitleColor:[UIColor colorWithHexString:@"#1DABFD"] forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_serviceBtn setImage:[UIImage imageNamed:@"vm_member_qq"] forState:UIControlStateNormal];
        [_serviceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_serviceBtn addTarget:self action:@selector(clickServiceBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _serviceBtn;
}

- (void)clickServiceBtn{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
