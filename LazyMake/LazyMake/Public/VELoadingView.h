//
//  VELoadingView.h
//  DemoProgressView
//
//  Created by xunruiIOS on 2020/6/12.
//  Copyright © 2020 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYRingProgressView.h"

NS_ASSUME_NONNULL_BEGIN

@interface VELoadingView : UIView

@property (strong, nonatomic) UIView *bigView;
@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIView *backgrongdV;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) SYRingProgressView *proView;

- (instancetype)initWithSubSize:(CGSize)subSize;

- (void)setProgress:(CGFloat)prog;

- (void)hiden;


@end

NS_ASSUME_NONNULL_END
