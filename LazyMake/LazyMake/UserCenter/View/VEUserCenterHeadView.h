//
//  VEUserCenterHeadView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEUserCenterHeadView : UIView

@property (copy, nonatomic) void (^clickVIPBtnBlock)(void);
@property (copy, nonatomic) void (^clickUserDataBtnBlock)(void);

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
