//
//  VEAlertSheetView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/18.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEAlertSheetView : UIView

@property (copy, nonatomic) void (^clickSubBtnBlock)(BOOL ifCancle, NSInteger btnTag);

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr titleStr:(NSString *)titleStr;
- (void)show;

@end

NS_ASSUME_NONNULL_END
