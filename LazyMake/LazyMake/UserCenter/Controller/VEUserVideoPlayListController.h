//
//  VEUserVideoPlayListController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/27.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEUserVideoPlayListController : UIViewController

@property (assign, nonatomic) NSInteger selectIndex;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL hasMore;


@end

NS_ASSUME_NONNULL_END
