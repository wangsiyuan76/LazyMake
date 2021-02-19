//
//  VEMediaListCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/21.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEMediaListCell.h"

@interface VEMediaListCell ()

@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *contentLab;
@property (strong, nonatomic) UILabel *timeLab;

@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UIButton *userBtn;
@property (strong, nonatomic) UIView *lineView;
@end

@implementation VEMediaListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.playBtn];
        [self.contentView addSubview:self.userBtn];
        [self.contentView addSubview:self.lineView];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(43, 43));
        make.left.mas_equalTo(20);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(18);
        make.right.mas_equalTo(-140);
        make.left.mas_equalTo(self.iconImage.mas_right).mas_offset(13);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(9);
//        make.width.mas_equalTo(kScreenWidth - 240);
        make.left.mas_equalTo(self.titleLab.mas_left);
    
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(-100);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];
    
    [self.userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(-21);
        make.size.mas_equalTo(CGSizeMake(60, 26));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(9);
        make.left.mas_equalTo(self.contentLab.mas_right).mas_offset(0);
        make.width.mas_equalTo(40);
    }];
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_icon_music_empty"]];
        _iconImage.contentMode = UIViewContentModeScaleAspectFill;
        _iconImage.clipsToBounds = YES;
        _iconImage.layer.masksToBounds = YES;
        _iconImage.layer.cornerRadius = 5.0f;
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

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:12];
        _contentLab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
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

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[UIImage imageNamed:@"vm_music_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"vm_music_pause"] forState:UIControlStateSelected];

        [_playBtn addTarget:self action:@selector(clickPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)userBtn{
    if (!_userBtn) {
        _userBtn = [UIButton new];
        [_userBtn setTitle:@"使用" forState:UIControlStateNormal];
        [_userBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _userBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_userBtn addTarget:self action:@selector(clickUserdBtn) forControlEvents:UIControlEventTouchUpInside];  
        UIImage *image = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(60, 26)];
        [_userBtn setBackgroundImage:image forState:UIControlStateNormal];
        _userBtn.layer.masksToBounds = YES;
        _userBtn.layer.cornerRadius = 13.0f;
    }
    return _userBtn;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = MAIN_NAV_COLOR;
    }
    return _lineView;
}

- (void)clickUserdBtn{
    if (self.choseBtnBlock) {
        self.choseBtnBlock(self.index);
    }
}

+ (CGFloat)cellHeight{
    return 70;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clickPlayBtn:(UIButton *)btn{
    if (self.playBtnBlock) {
        self.playBtnBlock(self.index);
    }
}

- (void)setModel:(LMMediaModel *)model{
    _model = model;

    [self.iconImage setImage:model.coverImage?:[UIImage imageNamed:@"vm_icon_music_empty"]];
    self.titleLab.text = [model.nameStr isNotBlank]?model.nameStr:@"无名";
    self.timeLab.text = model.timeStr;
    if (model.isPlay) {
        self.playBtn.selected = YES;
    }else{
        self.playBtn.selected = NO;
    }
    
    self.contentLab.text = [model.artistStr isNotBlank]?model.artistStr:@"无名";
    CGFloat w = [self getWidthWithText:self.contentLab.text height:100 font:15];
    if (w > kScreenWidth - 250) {
        [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth - 250);
        }];
    }else{
        [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
             make.width.mas_equalTo(w);
        }];
    }
}

- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.width;
}
@end

@implementation LMMediaModel


@end
