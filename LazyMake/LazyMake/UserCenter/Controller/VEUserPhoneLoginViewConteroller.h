//
//  VEUserPhoneLoginViewConteroller.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/18.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEUserPhoneLoginViewConteroller : UIViewController
@property (copy, nonatomic) void (^userLoginSucceedBlock)(void);

@end

NS_ASSUME_NONNULL_END
