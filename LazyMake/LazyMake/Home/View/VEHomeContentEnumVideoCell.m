//
//  VEHomeContentEnumVideoCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/1.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeContentEnumVideoCell.h"

@interface VEHomeContentEnumVideoCell ()

@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UIImageView *shadwoImage;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *numLab;
@property (strong, nonatomic) UIView *vipView;
@property (strong, nonatomic) UILabel *vipLab;

@end

@implementation VEHomeContentEnumVideoCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.mainImage];
        [self.contentView addSubview:self.shadwoImage];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.numLab];
        [self.contentView addSubview:self.vipView];
        [self.vipView addSubview:self.vipLab];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.shadwoImage mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
        make.left.mas_equalTo(self.mainImage.mas_left).mas_offset(-3);
        make.right.mas_equalTo(self.mainImage.mas_right).mas_offset(3);
        make.top.mas_equalTo(self.mainImage.mas_top);
        make.bottom.mas_equalTo(self.mainImage.mas_bottom);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(242);
        make.right.mas_equalTo(-10);
    }];
    
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(3);
    }];

    [self.vipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.top.mas_equalTo(2);
    }];
}

- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [UIImageView new];
        _mainImage.backgroundColor = [VETool backgroundRandomColor];
        _mainImage.layer.masksToBounds = YES;
        _mainImage.layer.cornerRadius = 8.0f;
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
    }
    return _mainImage;
}

- (UIImageView *)shadwoImage{
    if (!_shadwoImage) {
        _shadwoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_home1_mask"]];
    }
    return _shadwoImage;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _titleLab;
}

- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [UILabel new];
        _numLab.font = [UIFont systemFontOfSize:11];
        _numLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _numLab.alpha = 0.7f;
    }
    return _numLab;
}

- (UILabel *)vipLab{
    if (!_vipLab) {
        _vipLab = [UILabel new];
        _vipLab.font = [UIFont systemFontOfSize:9];
        _vipLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _vipLab.text = @"VIP";
      }
      return _vipLab;
}

- (UIView *)vipView{
    if (!_vipView) {
        _vipView = [[UIView alloc]initWithFrame:CGRectMake(self.contentView.bounds.size.width - 28, 0, 28, 15)];
        _vipView.contentMode = UIViewContentModeScaleAspectFill;
        _vipView.clipsToBounds = YES;
        _vipView.backgroundColor = [UIColor colorWithHexString:@"1DABFD"];
        
        //设置VIP标志的单边圆角
         UIBezierPath *maskPath;
         maskPath = [UIBezierPath bezierPathWithRoundedRect:_vipView.bounds
                                              byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopRight)
                                                    cornerRadii:CGSizeMake(8, 8)];
         CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
         maskLayer.frame = _vipView.bounds;
         maskLayer.path = maskPath.CGPath;
         _vipView.layer.mask = maskLayer;
    }
    return _vipView;
}

+ (CGFloat)cellHeight{
    return 280;
}

+ (CGFloat)cellHeightSmall{
    return 184;
}

- (void)setModel:(VEHomeTemplateModel *)model{
    _model = model;
    if (model) {
        self.titleLab.text = model.title;
        if (model.views.floatValue > 10000) {
            CGFloat num = model.views.floatValue;
            num = model.views.floatValue/10000;
            self.numLab.text = [NSString stringWithFormat:@"%.1fW人已制作",num];
        }else{
            self.numLab.text = [NSString stringWithFormat:@"%@人已制作",model.views];
        }
        [self.mainImage setImageWithURL:[NSURL URLWithString:model.thumb?:@""] options:YYWebImageOptionProgressiveBlur];
        if (model.isFree.intValue == 1) {
            self.vipView.hidden = YES;
            self.vipLab.hidden = YES;
        }else{
            self.vipView.hidden = NO;
            self.vipLab.hidden = NO;
        }
    }
}

- (void)changeSmallStyle{
    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(140);
    }];
    self.titleLab.hidden = YES;
}
@end
