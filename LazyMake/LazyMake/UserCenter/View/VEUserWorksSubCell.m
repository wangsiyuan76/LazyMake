//
//  VEUserWorksSubCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserWorksSubCell.h"
#import "VEAlertView.h"

@interface VEUserWorksSubCell ()

@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UILabel *numLab;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIButton *delBtn;
@property (strong, nonatomic) UIImageView *shadwoImage;

@end

@implementation VEUserWorksSubCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.mainImage];
        [self.contentView addSubview:self.shadwoImage];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.numLab];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.delBtn];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.shadwoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, -1, 0, -1));
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(-8);
    }];
    
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.bottom.mas_equalTo(-7);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(6);
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [UIImageView new];
        _mainImage.backgroundColor = [VETool backgroundRandomColor];
        _mainImage.layer.masksToBounds = YES;
        _mainImage.layer.cornerRadius = 7.0f;
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
    }
    return _mainImage;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIImageView *)shadwoImage{
    if (!_shadwoImage) {
        _shadwoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_mengban_h"]];
    }
    return _shadwoImage;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.font = [UIFont systemFontOfSize:10];
        _timeLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _timeLab;
}

- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [UILabel new];
        _numLab.font = [UIFont systemFontOfSize:11];
        _numLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _numLab;
}

- (UIButton *)delBtn{
    if (!_delBtn) {
        _delBtn = [UIButton new];
        [_delBtn setImage:[UIImage imageNamed:@"vm_production_detail"] forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(clickDeleBtn) forControlEvents:UIControlEventTouchUpInside];
//        [_delBtn setBackgroundColor:[UIColor redColor]];
    }
    return _delBtn;
}

- (void)setModel:(VEUserWorksListModel *)model{
    _model = model;
    [self.mainImage setImageWithURL:[NSURL URLWithString:model.thumb?:@""] options:YYWebImageOptionProgressiveBlur];
    self.timeLab.text = model.duration;
    self.numLab.text = [NSString stringWithFormat:@"%@人浏览",model.click_num];
    
    if (model.status.intValue == 0) {
        self.titleLab.text = @"已退稿";
    }else if(model.status.intValue == 1){
        self.titleLab.text = @"审核中";
    }else{
        self.titleLab.text = @"";
    }
}

- (void)showViewIfHome:(BOOL)ifHome{
    if (ifHome) {
        self.delBtn.hidden = YES;
        self.numLab.hidden = YES;
        self.titleLab.hidden = YES;
        self.timeLab.hidden = NO;
    }else{
        self.delBtn.hidden = NO;
        self.numLab.hidden = NO;
        self.titleLab.hidden = NO;
        self.timeLab.hidden = YES;
    }
}

- (void)clickDeleBtn{
    VEAlertView *ale = [[VEAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [ale setContentStr:@"删除后视频将无法恢复，确定删除？"];
    [win addSubview:ale];
    @weakify(self);
    ale.clickSubBtnBlock = ^(NSInteger btnTag) {
        @strongify(self);
        if (btnTag == 1) {
            if (self.clickDeleBtnBlock) {
                self.clickDeleBtnBlock(self.index);
            }
        }
    };
}

+ (CGFloat)cellHeight{
    return 186;
}


@end
