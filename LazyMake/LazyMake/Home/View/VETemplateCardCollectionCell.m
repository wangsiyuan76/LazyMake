//
//  VETemplateCardCollectionCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VETemplateCardCollectionCell.h"

@implementation VETemplateCardCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageBottom = [[self class]imageBottom];
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{
    self.imageIV = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.imageIV.contentMode = UIViewContentModeScaleAspectFill;
    self.imageIV.clipsToBounds = YES;
    self.imageIV.layer.masksToBounds = YES;
    self.imageIV.layer.cornerRadius = 12.0f;
    [self.contentView addSubview:self.imageIV];
    [self.contentView addSubview:self.makeExplanationLab];

    [self.imageIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-self.imageBottom);
    }];
    
    @weakify(self);
    [self.makeExplanationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.imageIV.mas_bottom).mas_offset(16);
        make.right.mas_equalTo(0);
    }];
}


- (UILabel *)makeExplanationLab{
    if (!_makeExplanationLab) {
        _makeExplanationLab = [UILabel new];
        _makeExplanationLab.textAlignment = NSTextAlignmentCenter;
        _makeExplanationLab.font = [UIFont systemFontOfSize:15];
        _makeExplanationLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    }
    return _makeExplanationLab;
}

- (void)setModel:(VEHomeTemplateModel *)model{
    _model = model;
    [self.imageIV setImageWithURL:[NSURL URLWithString:model.thumb] options:YYWebImageOptionProgressiveBlur];
    self.makeExplanationLab.text = model.descriptionStr;
}

+ (CGFloat)imageBottom{
    return 26;
}


@end
