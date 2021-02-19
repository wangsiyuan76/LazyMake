//
//  VEVIPRecordingCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVIPRecordingCell.h"

@interface VEVIPRecordingCell ()

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UILabel *moneyLab;
@property (strong, nonatomic) UILabel *rightTimeLab;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation VEVIPRecordingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.moneyLab];
        [self.contentView addSubview:self.rightTimeLab];
        [self.contentView addSubview:self.lineView];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.titleLab.mas_left);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(10);
    }];
    
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
    
    [self.rightTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(self.moneyLab.mas_right);
        make.centerY.mas_equalTo(self.timeLab.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
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

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textColor = [UIColor colorWithHexString:@"A1A7B2"];
    }
    return _timeLab;
}

- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [UILabel new];
        _moneyLab.font = [UIFont systemFontOfSize:15];
        _moneyLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _moneyLab;
}

- (UILabel *)rightTimeLab{
    if (!_rightTimeLab) {
        _rightTimeLab = [UILabel new];
        _rightTimeLab.font = [UIFont systemFontOfSize:12];
        _rightTimeLab.textColor = [UIColor colorWithHexString:@"A1A7B2"];
    }
    return _rightTimeLab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = MAIN_NAV_COLOR;
    }
    return _lineView;
}
+ (CGFloat)cellHeight{
    return 66;
}

- (void)setModel:(VEVipRecordingModel *)model{
    _model = model;
    self.titleLab.text = model.titleStr;
    self.timeLab.text = model.timeStr;
    self.moneyLab.text = model.moneyStr;
    self.rightTimeLab.text = model.rightTimeStr;
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
