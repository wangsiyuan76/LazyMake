//
//  VEMainGuideView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEMainGuideView : UIView

@property (copy, nonatomic) void (^clickMainBtnBlock)(void);
@property (strong, nonatomic) UIButton *mainShadowBtn;
@property (strong, nonatomic) UIImageView *subImage;

- (void)showAll;

- (void)hiddenAll;

@end

NS_ASSUME_NONNULL_END
