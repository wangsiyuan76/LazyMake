//
//  VEPushMediaViewController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/26.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEPushMediaViewController : UIViewController
@property (assign, nonatomic) CGSize videoSize;
@property (strong, nonatomic) NSString *vidoeUrl;
@property (strong, nonatomic) NSString *customId;           //模板id

@end

NS_ASSUME_NONNULL_END
