//
//  VEHomePopupView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/1.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEHomePopupView : UIView

@property (weak, nonatomic) UIViewController *superViewController;

- (void)createShadowBtn;

+ (void)showInViewWithSuperView:(UIViewController *)superView;

@end

NS_ASSUME_NONNULL_END
