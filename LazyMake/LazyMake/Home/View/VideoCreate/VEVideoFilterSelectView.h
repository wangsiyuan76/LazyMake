//
//  VEVideoFilterSelectView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/17.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEFilterSelectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEVideoFilterSelectView : UIView

@property (copy, nonatomic) void (^clickBtnBlock)(BOOL ifSucceed, NSInteger selectIndex,VEFilterSelectModel *model);
@property (copy, nonatomic) void (^clickSubFilBlock)(VEFilterSelectModel *model);

@property (assign, nonatomic) NSInteger selectIndex;
@property (assign, nonatomic) NSInteger oldSelect;

@end

NS_ASSUME_NONNULL_END
