//
//  VEUserNameViewController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEUserNameViewController : UIViewController
@property (copy, nonatomic) void (^changeSucceedBlock)(NSString *content);

@end

NS_ASSUME_NONNULL_END
