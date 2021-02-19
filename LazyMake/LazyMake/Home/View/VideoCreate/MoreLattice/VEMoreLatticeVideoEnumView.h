//
//  VEMoreLatticeVideoEnumView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEMoreLatticeVideoEnumView : UIView

@property (copy, nonatomic) void (^clickBiliBlock)(NSInteger selectIndex);
@property (copy, nonatomic) void (^clickSubBtnBlock)(NSInteger selectIndex);


@property (strong, nonatomic) UIView *biliView;
@property (strong, nonatomic) UIView *btnView;
@property (strong, nonatomic) NSMutableArray *biliArr;
@property (assign, nonatomic) NSInteger videoStyleIndex;

@end

NS_ASSUME_NONNULL_END
