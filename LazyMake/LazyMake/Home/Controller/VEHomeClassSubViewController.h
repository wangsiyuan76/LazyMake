//
//  VEHomeClassSubViewController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEHomeToolModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEHomeClassSubViewController : UIViewController

@property (strong, nonatomic) VEHomeToolModel *toolModel;

- (void)scrollEndScrolld;

- (void)endScroll;

@end

NS_ASSUME_NONNULL_END
