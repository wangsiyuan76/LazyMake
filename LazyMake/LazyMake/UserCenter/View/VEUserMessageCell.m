//
//  VEUserMessageCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/6.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserMessageCell.h"

@implementation VEUserMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.noticeLab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.lineView];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(self.iconImage.mas_right).mas_equalTo(12);
    }];
    
    [self.noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(self.titleLab.mas_right).mas_equalTo(8);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.right.mas_equalTo(-16);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5f);
    }];
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_icon_administrator"]];

    }
    return _iconImage;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor colorWithHexString:@"#1DABFD"];
        _titleLab.text = @"管理员";
    }
    return _titleLab;
}

- (UILabel *)noticeLab{
    if (!_noticeLab) {
        _noticeLab = [UILabel new];
        _noticeLab.font = [UIFont systemFontOfSize:14];
        _noticeLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _noticeLab.text = @"通知";
    }
    return _noticeLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = MAIN_NAV_COLOR;
    }
    return _lineView;
}

- (void)setContentStr:(NSString *)contentStr{
    _contentStr = contentStr;
    self.contentLab.text = contentStr;
    [VETool changeLineSpaceForLabel:self.contentLab WithSpace:6];
}

+ (CGFloat)cellHeightWithContent:(NSString *)content{
    CGFloat h = [VETool getTextHeightWithStr:content withWidth:kScreenWidth - 77 withLineSpacing:6 withFont:15]-20;
    return h + 60;
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
