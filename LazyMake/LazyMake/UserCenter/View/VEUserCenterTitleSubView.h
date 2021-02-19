//
//  VEUserCenterTitleSubView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *VEUserCenterTitleSubViewStr = @"VEUserCenterTitleSubView";

@interface VEUserCenterTitleSubView : UITableViewHeaderFooterView

@property (copy, nonatomic) void (^clickRightBtnBlock)(void);
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIButton *rightBtn;


@end

NS_ASSUME_NONNULL_END
