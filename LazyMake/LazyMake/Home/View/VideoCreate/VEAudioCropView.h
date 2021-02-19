//
//  VEAudioCropView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/22.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubleSlider.h"
#import "UIView+HJViewFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEAudioCropView : UIView

@property (nonatomic, strong) DoubleSlider *doubleSliderView;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *beginLab;
@property (strong, nonatomic) UILabel *endLab;
@property (strong, nonatomic) UILabel *bottomLab;
@property (assign, nonatomic) NSInteger allTime;          //音乐总时长

@property (copy, nonatomic) void (^clickDoneBtnBlock)(BOOL ifSucceed);
@property (copy, nonatomic) void (^changeSelectTimeBlock)(NSInteger beginTime, NSInteger endTime, NSInteger continuedTime, BOOL ifLeft);

+ (CGFloat)viewHeight;

- (void)hiddenTitleView;

@end

NS_ASSUME_NONNULL_END
