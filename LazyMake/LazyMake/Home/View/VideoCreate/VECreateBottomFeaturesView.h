//
//  VECreateBottomFeaturesView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/17.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VECreateBottomFeaturesView : UIView

@property (strong, nonatomic) NSArray *titleArr;
@property (strong, nonatomic) NSArray *imageArr;

@property (copy, nonatomic) void (^clickBtnBlock)(NSInteger btnTag);

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr imageArr:(NSArray *)imageArr;

@end

NS_ASSUME_NONNULL_END
