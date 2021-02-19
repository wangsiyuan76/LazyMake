//
//  VEUserMyFeedbackListCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserMyFeedbackListCell.h"

@interface VEUserMyFeedbackListCell ()

@property (strong, nonatomic) UILabel *replayTagLab;            //是否已回复标签lab
@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UIImageView *arrowImage;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation VEUserMyFeedbackListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.replayTagLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.arrowImage];
        [self.contentView addSubview:self.lineView];
        [self setAllViewLayout];

    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.replayTagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(38, 18));
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.replayTagLab.mas_right).mas_offset(8);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-50);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.contentLab.mas_left);
        make.bottom.mas_equalTo(-14);
    }];
    
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);

    }];
}

- (void)setModel:(VEUserFeedbackListModel *)model{
    _model = model;
    self.timeLab.text = model.time;
    
    if (model.isOpen) {
        [self.arrowImage setImage:[UIImage imageNamed:@"vm_icon_bottom"]];
        self.contentLab.text = model.content;

    }else{
        [self.arrowImage setImage:[UIImage imageNamed:@"vm_icon_next"]];
        if (model.content.length > 22) {
            self.contentLab.text = [NSString stringWithFormat:@"%@...",[model.content substringWithRange:NSMakeRange(0, 22)]];
        }else{
            self.contentLab.text = model.content;
        }
    }
    //调整lab的行间距（lab的text必须要有值）
    [VETool changeLineSpaceForLabel:self.contentLab WithSpace:model.lineSep];

    if (model.isReply.boolValue == YES) {
        self.replayTagLab.text = @"已回复";
        self.replayTagLab.backgroundColor = [UIColor colorWithHexString:@"#1DABFD"];
    }else{
        self.replayTagLab.text = @"未回复";
        self.replayTagLab.backgroundColor = [UIColor colorWithHexString:@"#A1A7B2"];
    }
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

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
    }
    return _timeLab;
}

-(UILabel *)replayTagLab{
    if (!_replayTagLab) {
        _replayTagLab = [UILabel new];
        _replayTagLab.font = [UIFont systemFontOfSize:9];
        _replayTagLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _replayTagLab.layer.masksToBounds = YES;
        _replayTagLab.layer.cornerRadius = 9;
        _replayTagLab.textAlignment = NSTextAlignmentCenter;
    }
    return _replayTagLab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = MAIN_NAV_COLOR;
    }
    return _lineView;
}

- (UIImageView *)arrowImage{
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_icon_next"]];
    }
    return _arrowImage;
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
