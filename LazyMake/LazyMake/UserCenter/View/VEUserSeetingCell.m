//
//  VEUserSeetingCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserSeetingCell.h"

@interface VEUserSeetingCell ()


@property (strong, nonatomic) UIView *lineView;

@end

@implementation VEUserSeetingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.arrowImage];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.iconImage];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(self.arrowImage.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(kScreenWidth/2 );
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(self.arrowImage.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _titleLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _contentLab.textAlignment = NSTextAlignmentRight;
    }
    return _contentLab;
}

- (UIImageView *)arrowImage{
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_icon_next"]];
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

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_icon_default_avatar"]];
        _iconImage.layer.masksToBounds = YES;
        _iconImage.layer.cornerRadius = 23;
        _iconImage.contentMode = UIViewContentModeScaleAspectFill;
        _iconImage.clipsToBounds = YES;
        _iconImage.hidden = YES;
    }
    return _iconImage;
}

+ (CGFloat)cellHeight{
    return 46;
}
- (void)setUserIconWithImageUrl:(NSString *)imageUrl{
    self.iconImage.hidden = NO;
    if ([imageUrl isNotBlank]) {
        [self.iconImage setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"vm_icon_default_avatar"]];
    }
}

- (void)showArrowImage:(BOOL)ifHidden{
    if (ifHidden) {
        self.arrowImage.hidden = YES;
        @weakify(self)
        [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.mas_equalTo(-5);
        }];
    }else{
        self.arrowImage.hidden = NO;
        @weakify(self)
        [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.mas_equalTo(self.arrowImage.mas_left).mas_offset(-10);
        }];
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
