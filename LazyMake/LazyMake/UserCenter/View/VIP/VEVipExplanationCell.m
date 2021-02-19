//
//  VEVipExplanationCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVipExplanationCell.h"
#import "VEWebTermsViewController.h"

@interface VEVipExplanationCell ()

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *contentLab;
@property (strong, nonatomic) YYLabel *contentLab2;

@end

@implementation VEVipExplanationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.contentLab2];
        [self setAllViewLayout];
        
    }
    return self;
}

- (void)setAllViewLayout{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(15);
    }];
    
    @weakify(self);
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(16);
        make.right.mas_equalTo(-14);
    }];
    
    [self.contentLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(16);
        make.right.mas_equalTo(-14);
    }];
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _titleLab.text = @"购买说明";
    }
    return _titleLab;
}

- (YYLabel *)contentLab2{
    if (!_contentLab2) {
        _contentLab2 = [YYLabel new];
        _contentLab2.numberOfLines = 0;
        _contentLab2.preferredMaxLayoutWidth = SCREEN_WIDTH - 30;
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#A1A7B2"]};
        NSString *contentStr = @"本服务订阅费将由苹果商店通过您的iTunes账号绑定的付费渠道收取。订阅成功后，您可以无限使用懒人制作的所有付费功能和内容。根据苹果商店的政策，免费试用期结束后，您的订阅将会被自动续订。如要取消，请在当前订阅结束前至少提前24小时关闭自动续订。点击页面上的按钮表示同意我们的 用户协议 | 隐私政策";
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:contentStr attributes:attributes];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentStr length])];

        //设置高亮色和点击事件
        @weakify(self);
        [text setTextHighlightRange:[[text string] rangeOfString:@"用户协议"] color:[UIColor colorWithHexString:@"#1DABFD"] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                @strongify(self);
                [self pushWebProtocolIfPrivacy:NO];
        }];
                     
        [text setTextHighlightRange:[[text string] rangeOfString:@"隐私政策"] color:[UIColor colorWithHexString:@"#1DABFD"] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                @strongify(self);
                [self pushWebProtocolIfPrivacy:YES];
        }];
        _contentLab2.attributedText = text;
        
    }
    return _contentLab2;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.textColor = [UIColor colorWithHexString:@"A1A7B2"];
        _contentLab.numberOfLines = 0;
        _contentLab.text = @"1、会员VIP服务时长以自然天来计算。\n2、购买VIP服务成功后无法撤销，且不支持退款！\n3、若购买后长时间无反应或异常情况，请联系客服处理（在线时间：周一至周五 8:30-18:00）。\n4、懒人制作享有对本产品及服务的最终解释权。";
        [VETool changeLineSpaceForLabel:_contentLab WithSpace:4];
    }
    return _contentLab;
}

+ (CGFloat)cellHeightIndex:(NSInteger)index{
    if (index == 4) {
        return 210;
    }else{
        NSString *contentStr = @"本服务订阅费将由苹果商店通过您的iTunes账号绑定的付费渠道收取。订阅成功后，您可以无限使用懒人制作的所有付费功能和内容。根据苹果商店的政策，免费试用期结束后，您的订阅将会被自动续订。如要取消，请在当前订阅结束前至少提前24小时关闭自动续订。点击页面上的按钮表示同意我们的 用户协议 | 隐私政策";
       CGFloat h = [VETool getTextHeightWithStr:contentStr withWidth:kScreenWidth - 30 withLineSpacing:6 withFont:14];
        return h + 50;
    }
}

- (void)creatContentWithIndex:(NSInteger)index{
    if (index == 4) {
        self.contentLab.hidden = NO;
        self.contentLab2.hidden = YES;

        self.titleLab.text = @"购买说明";
    }else{
        self.titleLab.text = @"订阅说明";
        self.contentLab.hidden = YES;
        self.contentLab2.hidden = NO;
    }
}

- (void)pushWebProtocolIfPrivacy:(BOOL)IfPrivacy{
    VEWebTermsViewController *webVC = [VEWebTermsViewController new];
    webVC.hidesBottomBarWhenPushed = YES;
    if (IfPrivacy) {
        webVC.loadUrl = WEB_PRIVACY_URL;
        webVC.title = @"隐私政策";
    }else{
        webVC.loadUrl = WEB_PROTOCOL_URL;
        webVC.title = @"用户协议";
    }
    [currViewController().navigationController pushViewController:webVC animated:YES];
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
