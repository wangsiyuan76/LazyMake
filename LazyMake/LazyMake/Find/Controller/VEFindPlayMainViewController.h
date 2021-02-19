//
//  VEFindPlayMainViewController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/20.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEFindPlayMainViewController : UIViewController

@property (assign, nonatomic) NSInteger selectIndex;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL hasMore;

@end

NS_ASSUME_NONNULL_END
