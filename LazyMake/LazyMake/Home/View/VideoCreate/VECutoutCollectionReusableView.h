//
//  VECutoutCollectionReusableView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VECutoutImageSelectView.h"

NS_ASSUME_NONNULL_BEGIN

@interface VECutoutCollectionReusableView : UICollectionReusableView

@property (copy, nonatomic) void (^clickMakeBtnBlock)(void);
@property (strong, nonatomic) VECutoutImageSelectView *selectView;
@property (strong, nonatomic) YYLabel *explanationLab;
@property (strong, nonatomic) UIButton *makeBtn;
@property (strong, nonatomic) UILabel *bottomLab;

@property (assign, nonatomic) CGRect mainSlectSize;

+ (CGFloat)mainHeight;

@end

NS_ASSUME_NONNULL_END
