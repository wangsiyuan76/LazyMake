//
//  VEUserCenterEnumCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserCenterEnumCell.h"

@interface VEUserCenterEnumCell ()

@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *rightLab;
@property (strong, nonatomic) UIImageView *arrowImage;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation VEUserCenterEnumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.arrowImage];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.rightLab];
        [self.contentView addSubview:self.redView];
        [self.contentView addSubview:self.lineView];
        [self setAllViewLayout];
    }
    return self;
}
- (void)setAllViewLayout{
    @weakify(self);
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(14);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.iconImage.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-14);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.titleLab.mas_right).mas_offset(8);
        make.top.mas_equalTo(self.titleLab.mas_top).mas_offset(2);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    [self.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.arrowImage.mas_left).mas_offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [UIImageView new];
    }
    return _iconImage;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _titleLab;
}

- (UILabel *)rightLab{
    if (!_rightLab) {
        _rightLab = [UILabel new];
        _rightLab.font = [UIFont systemFontOfSize:14];
        _rightLab.textAlignment = NSTextAlignmentRight;
    }
    return _rightLab;
}

- (UIView *)redView{
    if (!_redView) {
        _redView = [UIView new];
        _redView.backgroundColor = [UIColor colorWithHexString:@"F20000"];
        _redView.layer.masksToBounds = YES;
        _redView.layer.cornerRadius = 4.0f;
    }
    return _redView;
}

- (UIImageView *)arrowImage{
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_icon_next_"]];
    }
    return _arrowImage;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = MAIN_NAV_COLOR;
    }
    return _lineView;
}

- (void)setModel:(VEUserCenterEnumModel *)model{
    _model = model;
    [self.iconImage setImage:[UIImage imageNamed:model.imageStr]];
    self.titleLab.text = model.titleStr;
    if (model.isRed) {
        self.redView.hidden = NO;
    }else{
        self.redView.hidden = YES;
    }
    if ([model.rightTitle isNotBlank]) {
        self.rightLab.hidden = NO;
        self.rightLab.text = model.rightTitle;
        self.rightLab.textColor = [UIColor colorWithHexString:model.rightColor];
    }else{
        self.rightLab.hidden = YES;
    }
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
