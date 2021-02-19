//
//  VEVipPackageSubCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVipPackageSubCell.h"

@interface VEVipPackageSubCell ()

@property (strong, nonatomic) UIView *colorView;        //后面的蓝色的描边view
@property (strong, nonatomic) UIView *contentV;         //中间的数据view
@property (strong, nonatomic) UILabel *tagView;          //右上角的优惠标志
@property (strong, nonatomic) UILabel *timeLab;         //时间
@property (strong, nonatomic) UILabel *moneyLab;        //金额
@property (strong, nonatomic) UILabel *oldMoneyLab;     //原价
@property (strong, nonatomic) UIView *shadowView;       //选中状态时，淡蓝色遮罩

@end

@implementation VEVipPackageSubCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        [self.contentView addSubview:self.contentV];
        [self.contentView addSubview:self.colorView];

        [self.contentV addSubview:self.shadowView];
        [self.contentV addSubview:self.timeLab];
        [self.contentV addSubview:self.moneyLab];
        [self.contentV addSubview:self.oldMoneyLab];
        [self.contentView addSubview:self.tagView];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(4);
        make.right.mas_equalTo(-6);
        make.bottom.mas_equalTo(-4);
    }];
    
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(4);
        make.right.mas_equalTo(-6);
        make.bottom.mas_equalTo(-4);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.timeLab.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.oldMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.moneyLab.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(1);
        make.right.mas_equalTo(self.colorView.mas_right).mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(58, 18));
    }];
    
    //设置右上角标签的单边圆角
    dispatch_async(dispatch_get_main_queue(), ^{
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.tagView.bounds
                                         byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopRight)
                                               cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.tagView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.tagView.layer.mask = maskLayer;
    });
}

- (UIView *)colorView{
    if (!_colorView) {
        _colorView = [UIView new];
//        _colorView.backgroundColor = [UIColor colorWithHexString:@"1DABFD"];
        _colorView.backgroundColor = [UIColor clearColor];

        _colorView.layer.masksToBounds = YES;
        _colorView.layer.cornerRadius = 7;
        _colorView.layer.borderColor = [UIColor colorWithHexString:@"1DABFD"].CGColor;
        _colorView.layer.borderWidth = 2.f;
    }
    return _colorView;
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.backgroundColor = [UIColor colorWithHexString:@"#203c5c"];
        _shadowView.layer.masksToBounds = YES;
        _shadowView.layer.cornerRadius = 7;
    }
    return _shadowView;
}


- (UIView *)contentV{
    if (!_contentV) {
        _contentV = [UIView new];
        _contentV.backgroundColor = [UIColor colorWithHexString:@"#212438"];
        _contentV.layer.masksToBounds = YES;
        _contentV.layer.cornerRadius = 7;
    }
    return _contentV;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.font = [UIFont systemFontOfSize:16];
        _timeLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _timeLab.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLab;
}

- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [UILabel new];
        _moneyLab.font = [UIFont boldSystemFontOfSize:20];
        _moneyLab.textColor = [UIColor colorWithHexString:@"1DABFD"];
        _moneyLab.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLab;
}

- (UILabel *)oldMoneyLab{
    if (!_oldMoneyLab) {
        _oldMoneyLab = [UILabel new];
        _oldMoneyLab.font = [UIFont boldSystemFontOfSize:12];
        _oldMoneyLab.textColor = [UIColor colorWithHexString:@"A1A7B2"];
        _oldMoneyLab.textAlignment = NSTextAlignmentCenter;
    }
    return _oldMoneyLab;
}

- (UILabel *)tagView{
    if (!_tagView) {
        _tagView = [UILabel new];
        _tagView.backgroundColor = [UIColor colorWithHexString:@"1DABFD"];
        _tagView.textColor = [UIColor colorWithHexString:@"ffffff"];
        _tagView.text = @"限时特惠";
        _tagView.font = [UIFont systemFontOfSize:10];
        _tagView.textAlignment = NSTextAlignmentCenter;
    }
    return _tagView;
}

+ (CGFloat)celHeight{
    return 110;;
}

- (void)setModel:(VEVIPMoneyModel *)model{
    _model = model;
    self.timeLab.text = model.timeStr;
    
    //设置现价
    NSString *moneyStr = [NSString stringWithFormat:@"￥%@",model.moneyStr];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    UIFont *font = [UIFont systemFontOfSize:12];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,1)];
    self.moneyLab.attributedText = attrString;
    
    //设置原价
    if (model.oldMoneyStr.length > 0) {
        self.oldMoneyLab.hidden = NO;
        NSString *oldMoneyStr = [NSString stringWithFormat:@"原价￥%@",model.oldMoneyStr];
        NSMutableAttributedString *oldAttributeMarket = [[NSMutableAttributedString alloc] initWithString:oldMoneyStr];
        [oldAttributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,oldMoneyStr.length)];
        self.oldMoneyLab.attributedText = oldAttributeMarket;
    }else{
        self.oldMoneyLab.hidden = YES;
    }
    
    if (model.textDesc.length > 0) {
        self.tagView.hidden = NO;
        self.tagView.text = @"限时特惠";
    }else{
        self.tagView.hidden = YES;
    }
    //设置选中状态
    if (model.ifSelect) {
        self.shadowView.hidden = NO;
        self.colorView.hidden = NO;
    }else{
        self.shadowView.hidden = YES;
        self.colorView.hidden = YES;
//        self.tagView.hidden = YES;
    }
    
    if ([model.timeStr isEqualToString:@"一个月"] || model.dayNum.intValue == 30) {
        if ([LMUserManager sharedManger].userInfo.vipState.intValue == 0) {
            self.tagView.hidden = NO;
            self.tagView.text = @"免费用3天";
        }
    }
}
@end
