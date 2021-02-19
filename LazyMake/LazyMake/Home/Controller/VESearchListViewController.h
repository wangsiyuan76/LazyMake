//
//  VESearchListViewController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VESearchListViewController : UIViewController

@property (copy, nonatomic) void (^willBackBlock)(NSMutableArray *hisArr);

@property (strong, nonatomic) NSString *searchContent;
@property (strong, nonatomic) NSMutableArray *historyArr;

@end

NS_ASSUME_NONNULL_END
