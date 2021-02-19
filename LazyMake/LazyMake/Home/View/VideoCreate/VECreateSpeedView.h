//
//  VECreateSpeedView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/17.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VECreateSpeedView : UIView

@property (copy, nonatomic) void (^clickBtnBlock)(BOOL ifSucceed, NSString *selectStr);
@property (copy, nonatomic) void (^changeValueBlock)(CGFloat changeF);

@property (strong, nonatomic) NSString *selectStr;
@property (strong, nonatomic) NSString *speValue;

@end

NS_ASSUME_NONNULL_END
