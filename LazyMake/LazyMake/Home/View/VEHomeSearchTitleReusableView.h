//
//  VEHomeSearchTitleReusableView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *VEHomeSearchTitleReusableViewStr = @"VEHomeSearchTitleReusableView";

@interface VEHomeSearchTitleReusableView : UICollectionReusableView

@property (copy, nonatomic) void (^cleanBtnBlock)(void);
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIButton *clearBtn;


@end

NS_ASSUME_NONNULL_END
