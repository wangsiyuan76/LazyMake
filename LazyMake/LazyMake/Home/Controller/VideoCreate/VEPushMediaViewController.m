//
//  VEPushMediaViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/26.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEPushMediaViewController.h"
#import "VEHomeApi.h"
#import "VEWebTermsViewController.h"
#import "VECreateHUD.h"
#import "AppDelegate.h"
#import <LanSongEditorFramework/LanSongEditor.h>

#define IMAGE_MAX 6
#define BOTTOM_VIEW_H 130

@interface LMPushSelectCoverView : UIView

@property (strong, nonatomic) UIImageView *arrowImage;
@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIView *borderView;

@end

@implementation LMPushSelectCoverView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.arrowImage];
        [self addSubview:self.mainView];
        [self addSubview:self.borderView];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(14, 10));
    }];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.arrowImage.mas_bottom).mas_offset(2);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.arrowImage.mas_bottom).mas_offset(2);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [UIView new];
        _mainView.backgroundColor = [UIColor colorWithHexString:@"#1DABFD"];
        _mainView.alpha = 0.3f;
    }
    return _mainView;
}
- (UIView *)borderView{
    if (!_borderView) {
        _borderView = [UIView new];
        _borderView.backgroundColor = [UIColor clearColor];
        _borderView.layer.borderColor = [UIColor colorWithHexString:@"#1DABFD"].CGColor;
        _borderView.layer.borderWidth = 2.0f;
    }
    return _borderView;
}

- (UIImageView *)arrowImage{
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_choose_cover"]];
    }
    return _arrowImage;
}

@end

@interface VEPushMediaViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textF;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UIView *tagView;
@property (strong, nonatomic) UILabel *tagLab;
@property (strong, nonatomic) YYLabel *bottomLab;
@property (strong, nonatomic) LMPushSelectCoverView *choseView;
@property (strong, nonatomic) NSMutableArray *allImageArr;
@property (assign, nonatomic) NSInteger choseIndex;
@property (nonatomic, strong) VECreateHUD *hud;

@end

@implementation VEPushMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑";
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    [self createHeadView];
    [self initAllView];
    self.hud=[[VECreateHUD alloc] init];

    // Do any additional setup after loading the view.
}

//顶部完成按钮
-(void)createHeadView{
     UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 26)];
     [doneBtn setTitle:@"发布" forState:UIControlStateNormal];
     [doneBtn addTarget:self action:@selector(clickDoneBtn) forControlEvents:UIControlEventTouchUpInside];
     [doneBtn setTitleColor:[UIColor colorWithHexString:@"#1DABFD"] forState:UIControlStateNormal];
     doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
     UIBarButtonItem *searchBtnBar = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
     self.navigationItem.rightBarButtonItem = searchBtnBar;
}

- (void)initAllView{
    [self.view addSubview:self.textF];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.mainImage];
    [self.view addSubview:self.tagView];
    [self.view addSubview:self.tagLab];
    [self.view addSubview:self.bottomLab];
    [self setAllViewLayout];
    [self createAllImageArr];
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.mainImage.mas_left);
        make.top.mas_equalTo(10+Height_NavBar);
        make.right.mas_equalTo(self.mainImage.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.mainImage.mas_left);
        make.top.mas_equalTo(self.textF.mas_bottom);
        make.right.mas_equalTo(self.mainImage.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.top.mas_equalTo(self.mainImage.mas_top).mas_offset(10);
        make.right.mas_equalTo(self.mainImage.mas_right);
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.top.mas_equalTo(self.mainImage.mas_top).mas_offset(10);
        make.right.mas_equalTo(self.mainImage.mas_right);
    }];
    
    [self.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(Height_SafeAreaBottom+8));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textF resignFirstResponder];
}

//提取视频中的图片
- (void)createAllImageArr{
    
    [MBProgressHUD showMessage:@"加载中..."];
    [VETool splitVideo:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",self.vidoeUrl]] fps:6 splitCompleteBlock:^(BOOL success, NSMutableArray * _Nonnull splitimgs) {
        if (success) {
            if (splitimgs.count > IMAGE_MAX) {
                self.allImageArr = [NSMutableArray new];
                CGSize imageSize = CGSizeMake(50, 62);
                CGFloat left = (kScreenWidth - (imageSize.width*IMAGE_MAX))/2;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSInteger otherNum = 1;
                    if (splitimgs.count / IMAGE_MAX > 1) {
                        otherNum = splitimgs.count / IMAGE_MAX;
                    }
                    for (int x = 0; x <= splitimgs.count-otherNum; x+=otherNum) {
                        NSInteger xT = x/otherNum;
                        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(left+xT*imageSize.width, self.mainImage.bottom+30, imageSize.width, imageSize.height)];
                        imageV.contentMode = UIViewContentModeScaleAspectFill;
                        imageV.clipsToBounds = YES;
                        imageV.userInteractionEnabled = YES;
                        imageV.tag = xT;
                        imageV.image = splitimgs[x];
                        [self.allImageArr addObject:splitimgs[x]];
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSubCover:)];
                        [imageV addGestureRecognizer:tap];
                        [self.view addSubview:imageV];
                        if (xT == 0) {
                            self.choseIndex = xT;
                            self.mainImage.image = splitimgs[xT];
                        }
                    }
                    [self.choseView removeFromSuperview];
                    self.choseView = nil;
                    self.choseView = [[LMPushSelectCoverView alloc]initWithFrame:CGRectMake(left, self.mainImage.bottom+15, imageSize.width, imageSize.height+15)];
                    [self.view addSubview:self.choseView];
                    [MBProgressHUD hideHUD];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUD];
                    });
                });
            }
        }
    }];
}

- (void)clickSubCover:(UITapGestureRecognizer *)tap{
    if (self.allImageArr.count > tap.view.tag) {
        self.choseIndex = tap.view.tag;
        UIImage *image = self.allImageArr[tap.view.tag];
        self.mainImage.image = image;
        [UIView animateWithDuration:0.2 animations:^{
            self.choseView.center = CGPointMake(tap.view.center.x, self.choseView.center.y);
        }];
    }
}

- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc]init];
        _textF.backgroundColor = self.view.backgroundColor;
        _textF.font = [UIFont systemFontOfSize:15];
        _textF.textColor = [UIColor colorWithHexString:@"ffffff"];
        _textF.textAlignment = NSTextAlignmentCenter;
        _textF.delegate = self;
//        [_textF addTarget:self action:@selector(textFiledTextChanged) forControlEvents:UIControlEventEditingChanged];
        _textF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入标题(15字以内)"attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#A1A7B2"]}];
        
//        _textF.placeholder = @"请输入标题(15字以内)";
//        [_textF  :[UIColor colorWithHexString:@"#A1A7B2"] forKeyPath:@"_placeholderLabel.textColor"];//颜色
    }
    return _textF;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#A1A7B2"];
    }
    return _lineView;
}

- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [[UIImageView alloc]initWithFrame:[self createVideoSize]];
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
    }
    return _mainImage;
}

- (UILabel *)tagLab{
    if (!_tagLab) {
        _tagLab = [UILabel new];
        _tagLab.text = @"封面";
        _tagLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _tagLab.font = [UIFont systemFontOfSize:15];
        _tagLab.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLab;
}

- (UIView *)tagView{
    if (!_tagView) {
        _tagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 25)];
        _tagView.backgroundColor = [UIColor blackColor];
        _tagView.alpha = 0.5f;
        //设置单边圆角
         UIBezierPath *maskPath;
         maskPath = [UIBezierPath bezierPathWithRoundedRect:_tagView.bounds
                                              byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft)
                                                    cornerRadii:CGSizeMake(12, 12)];
         CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
         maskLayer.frame = _tagView.bounds;
         maskLayer.path = maskPath.CGPath;
         _tagView.layer.mask = maskLayer;
    }
    return _tagView;
}

- (YYLabel *)bottomLab{
    if (!_bottomLab) {
        _bottomLab = [YYLabel new];
        //设置整段字符串的颜色
        UIColor *color = [UIColor colorWithHexString:@"ffffff"];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14], NSForegroundColorAttributeName: color};
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"点击选择一张封面 上传须知《视频审核规则》" attributes:attributes];
        [text setTextHighlightRange:[[text string] rangeOfString:@"《视频审核规则》"] color:[UIColor colorWithHexString:@"#1DABFD"] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            VEWebTermsViewController *webVC = [VEWebTermsViewController new];
            webVC.hidesBottomBarWhenPushed = YES;
            webVC.loadUrl = WEB_PUSHRULE_URL;
            webVC.title = @"视频审核规则";
            [self.navigationController pushViewController:webVC animated:YES];
        }];
        _bottomLab.attributedText = text;
        _bottomLab.textAlignment = NSTextAlignmentCenter;

    }
    return _bottomLab;
}

/// 设置视频的宽高
- (CGRect)createVideoSize{
    CGFloat bili = self.videoSize.width/self.videoSize.height;
    CGFloat maxH = SCREENH_HEIGHT - Height_NavBar - BOTTOM_VIEW_H - Height_SafeAreaBottom - 66;                       //获取当前设置屏幕上视频高度
    CGFloat h = maxH;
    CGFloat w = h * bili;
    if (w > kScreenWidth - 40) {
        w = kScreenWidth - 40;
        h = w / bili;
    }
    //视频左右间距
    CGFloat lR = (kScreenWidth - w) / 2;
    CGFloat top = Height_NavBar + 66;
      if (self.videoSize.width > self.videoSize.height) {
          top = Height_NavBar + 66 + ((maxH - h)/2);
      }
    return CGRectMake(lR, top, w, h);
}

- (void)clickDoneBtn{
    NSString *contentStr = [self.textF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (contentStr.length > 0) {
        [self.textF resignFirstResponder];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:self.customId?:@"" forKey:@"custom_id"];
        self.hud=[[VECreateHUD alloc] init];
        [self.hud showProgress:[NSString stringWithFormat:@"上传中0%%"] par:0];
//        [MBProgressHUD showMessage:@"上传中..."];
        [[VEHomeApi sharedApi]ve_updataVideo:self.vidoeUrl coverImage:self.allImageArr[self.choseIndex] titleStr:self.textF.text otherPar:dic Completion:^(VEBaseModel *  _Nonnull result) {
            if (result.isLoading) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.hud showProgress:[NSString stringWithFormat:@"上传中%.f%%",result.loadingSchedule*100] par:result.loadingSchedule];
                });
            }else{
                dispatch_async(dispatch_queue_create(0, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.hud hide];
                    });
                });
//                [MBProgressHUD hideHUD];
                if (result.state.intValue == 1) {
                    [MBProgressHUD showSuccess:@"上传成功"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:LoadUserWorks object:nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:PushDataSucceed object:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [MBProgressHUD showError:result.errorMsg];
                }
            }

        } failure:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:VENETERROR];
        }];
    }else{
        [MBProgressHUD showError:@"请输入标题"];
    }

}

#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.textF.text.length > 15) {
        self.textF.text = [self.textF.text substringToIndex:15];
        [MBProgressHUD showError:@"最多15个字"];
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
