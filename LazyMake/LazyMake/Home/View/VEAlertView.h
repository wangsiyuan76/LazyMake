//
//  VEAlertView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/15.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEAlertView : UIView

@property (copy, nonatomic) void (^clickSubBtnBlock)(NSInteger btnTag);
@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIView *line1;
@property (strong, nonatomic) UIView *line2;
@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) UIButton *cancelBtn;

- (void)setContentStr:(NSString *)contentStr;
@end

NS_ASSUME_NONNULL_END
