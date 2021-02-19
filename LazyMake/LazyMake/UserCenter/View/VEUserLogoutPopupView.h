//
//  VEUserLogoutPopupView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/15.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEUserLogoutPopupView : UIView

@property (copy, nonatomic) void (^clickSureBtnBlock)(NSString * codeStr);

@property (strong, nonatomic) UIView *conentView;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UITextField *textF;
@property (strong, nonatomic) UILabel *codeLab;
@property (strong, nonatomic) UIView *line1;
@property (strong, nonatomic) UIView *line2;
@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UIButton *shadowBtn;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

NS_ASSUME_NONNULL_END
