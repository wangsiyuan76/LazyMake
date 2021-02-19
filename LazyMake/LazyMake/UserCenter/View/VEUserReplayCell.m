//
//  VEUserReplayCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserReplayCell.h"

@interface VEUserReplayCell ()

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIImageView *iconImage;

@end

@implementation VEUserReplayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.contentLab];
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
        make.left.mas_equalTo(self.iconImage.mas_right).mas_offset(12);
        make.top.mas_equalTo(15);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(11);
        make.right.mas_equalTo(-15);
    }];
    
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.textColor = [UIColor colorWithHexString:@"#CCCCCC"];
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"管理员  回复了你";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_titleLab.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"A1A7B2"]}];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1DABFD"] range:NSMakeRange(0, 3)];
        _titleLab.attributedText = attrStr;
    }
    return _titleLab;
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_icon_administrator"]];
    }
    return _iconImage;
}

- (void)setModel:(VEUserFeedbackListModel *)model{
    _model = model;
    if ([model.replyContent isNotBlank]) {
        self.contentLab.text = model.replyContent;
        //调整lab的行间距（lab的text必须要有值）
        [VETool changeLineSpaceForLabel:self.contentLab WithSpace:model.lineSep];
    }else{
        
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
