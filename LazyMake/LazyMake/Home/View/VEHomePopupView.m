//
//  VEHomePopupView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/1.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomePopupView.h"
#import "VEWebTermsViewController.h"

#define BTNSIZE CGSizeMake(170, 38)
#define AGREEPROTOCOL @"AGREEPROTOCOL"

@interface VEHomePopupView () <UITextViewDelegate>

@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UILabel *headLab;
@property (strong, nonatomic) UITextView *contentText;
@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) UIButton *noBtn;
@property (strong, nonatomic) UIButton *shadowBtn;

@end

@implementation VEHomePopupView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 12.0f;
        [self addSubview:self.headImage];
        [self addSubview:self.headLab];
        [self addSubview:self.contentText];
        [self addSubview:self.sureBtn];
        [self addSubview:self.noBtn];
        [self setAllViewLayout];
        
    }
    return self;
}

- (void)setAllViewLayout{
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(87);
    }];
    
    [self.headLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(32);
    }];
    
    [self.contentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(94);
    }];
    
    @weakify(self);
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.contentText.mas_bottom).mas_offset(12);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(BTNSIZE);
    }];
    
    [self.noBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.sureBtn.mas_bottom).mas_offset(8);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(BTNSIZE);
    }];
}

- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_bg_policy"]];
    }
    return _headImage;
}

- (UILabel *)headLab{
    if (!_headLab) {
        _headLab = [UILabel new];
        _headLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _headLab.font = [UIFont systemFontOfSize:21];
        _headLab.textAlignment = NSTextAlignmentCenter;
        _headLab.text = @"用户协议和隐私政策";
    }
    return _headLab;
}

- (UITextView *)contentText{
    if (!_contentText) {
        _contentText = [UITextView new];
        _contentText.attributedText = [self getContentLabelAttributed];
        _contentText.textAlignment = NSTextAlignmentLeft;
        _contentText.delegate = self;
        _contentText.backgroundColor = [UIColor clearColor];
        _contentText.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
        _contentText.scrollEnabled = NO;
    }
    return _contentText;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        [_sureBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = BTNSIZE.height/2;
        _sureBtn.tag = 1;
        [_sureBtn addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];

        //设置button背景色渐变
        UIImage *bgImage = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"6156FC"] endColor:[UIColor colorWithHexString:@"1DABFD"] ifVertical:NO imageSize:BTNSIZE];
        [_sureBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    }
    return _sureBtn;
}

- (UIButton *)noBtn{
    if (!_noBtn) {
        _noBtn = [UIButton new];
        [_noBtn setTitle:@"不同意(退出软件)" forState:UIControlStateNormal];
        _noBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_noBtn setTitleColor:[UIColor colorWithHexString:@"A1A7B2"] forState:UIControlStateNormal];
        _noBtn.tag = 2;
        [_noBtn addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noBtn;
}

- (UIButton *)shadowBtn{
    if (!_shadowBtn) {
        _shadowBtn = [UIButton new];
        _shadowBtn.backgroundColor = [UIColor blackColor];
        _shadowBtn.alpha = 0.3f;
    }
    return _shadowBtn;
}

//按钮的点击事件
- (void)clickSubBtn:(UIButton *)btn{
    if (btn.tag == 1) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:AGREEPROTOCOL];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ClickPopoutViewSureBtn" object:nil];
    }else if(btn.tag == 2){
        //退出软件
        [self exitApplication];
        
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.shadowBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self.shadowBtn removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)exitApplication {
//    UIWindow *window =  [UIApplication sharedApplication].keyWindow;
//    [UIView animateWithDuration:1.0f animations:^{
//        window.alpha = 0;
//        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
//    } completion:^(BOOL finished) {
//    }];
    
    exit(0);
}

- (void)hiddenView{
    self.hidden = YES;
    self.shadowBtn.hidden = YES;
}

//设置中间的文字协议的点击效果
- (NSAttributedString *)getContentLabelAttributed{
    NSString *content = @"欢迎来到懒人制作，您的信任对我们至关重要，我们深知您对个人信息和隐私保护的重视，您可以通过阅读《用户协议》和《隐私政策》了解详细信息，未成年人应在监护人陪同下阅读。\n我们将按照法律法规要求，竭诚保护您的个人信息安全可控。如你同意，请点击“同意”开始接受我们的服务。";
    NSRange range1 = [content rangeOfString:@"《用户协议》"];
    NSRange range2 = [content rangeOfString:@"《隐私政策》"];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"1A1A1A"]}];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#528DF0"] range:NSMakeRange(range1.location, range1.length)];
    [attrStr addAttribute:NSLinkAttributeName value:@"healthservice://" range:NSMakeRange(range1.location, range1.length)];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#528DF0"] range:NSMakeRange(range2.location, range2.length)];
    [attrStr addAttribute:NSLinkAttributeName value:@"digitalcer://" range:NSMakeRange(range2.location, range2.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    return attrStr;
}

//创建背景的半透明阴影图
- (void)createShadowBtn{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.shadowBtn];
    [self.shadowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if ([[URL scheme] isEqualToString:@"healthservice"] || [[URL scheme] isEqualToString:@"digitalcer"]) {
        VEWebTermsViewController *webVC = [VEWebTermsViewController new];
        webVC.hidesBottomBarWhenPushed = YES;
        if([[URL scheme] isEqualToString:@"healthservice"]){
            webVC.loadUrl = WEB_PROTOCOL_URL;
            webVC.title = @"用户协议";
        }else{
            webVC.loadUrl = WEB_PRIVACY_URL;
            webVC.title = @"隐私政策";
        }
        [self.superViewController.navigationController pushViewController:webVC animated:YES];
        [self hiddenView];

        webVC.backBlock = ^{
            self.hidden = NO;
            self.shadowBtn.hidden = NO;
        };
        return NO;
    }
    return YES;
}

//创建方法
+ (void)showInViewWithSuperView:(UIViewController *)superView{
    NSNumber *num = [[NSUserDefaults standardUserDefaults]objectForKey:AGREEPROTOCOL];
    if (num.boolValue == NO) {
         if (superView) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            VEHomePopupView *popView = [[VEHomePopupView alloc]initWithFrame:CGRectMake(0, 0, 310, 420)];
            popView.center = CGPointMake(superView.view.bounds.size.width/2, superView.view.bounds.size.height/2);
            [popView createShadowBtn];
            popView.superViewController = superView;
            [window addSubview:popView];
           }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
