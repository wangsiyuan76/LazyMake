//
//  VEUserLoginPopupView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEUserLoginPopupView : UIView

@property (copy, nonatomic) void (^userLoginSucceedBlock)(void);

@end

NS_ASSUME_NONNULL_END
