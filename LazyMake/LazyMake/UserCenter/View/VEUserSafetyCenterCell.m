//
//  VEUserSafetyCenterCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/15.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserSafetyCenterCell.h"

@implementation VEUserSafetyCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.numLab];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.contentLab];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.numLab.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.numLab.mas_centerY);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.numLab.mas_right).mas_offset(10);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.numLab.mas_bottom).mas_offset(10);
    }];
}

- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [UILabel new];
        _numLab.font = [UIFont boldSystemFontOfSize:15];
        _numLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _numLab.textAlignment = NSTextAlignmentCenter;
        _numLab.backgroundColor = [UIColor colorWithHexString:@"#1DABFD"];
        _numLab.layer.masksToBounds = YES;
        _numLab.layer.cornerRadius = 10.0f;
    }
    return _numLab;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont boldSystemFontOfSize:15];
        _titleLab.textColor = [UIColor colorWithHexString:@"#1DABFD"];
    }
    return _titleLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}

- (void)setModel:(VEUserSafetyModel *)model{
    _model = model;
    self.numLab.text = model.num;
    self.titleLab.text = model.titleStr;
    self.contentLab.text = model.contentStr;
    [VETool changeLineSpaceForLabel:_contentLab WithSpace:4];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
