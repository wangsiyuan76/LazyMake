//
//  VELoadDelegate.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UMCommon/UMCommon.h>
//#import <UMPush/UMessage.h>
//#import <UMShare/UMShare.h>
//#import <UMAnalytics/MobClick.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface VELoadDelegate : NSObject

/// 设置rootView
+ (UITabBarController *)createRootViewController;

/// 设置全局导航栏的样式
+ (void)seetingNavBarStyle;

/// 初始化各个第三方平台
+ (void)loadAllThird;
@end

NS_ASSUME_NONNULL_END
