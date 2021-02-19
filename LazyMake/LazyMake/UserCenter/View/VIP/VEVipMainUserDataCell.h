//
//  VEVipMainUserDataCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *VEVipMainUserDataCellStr = @"VEVipMainUserDataCell";

@interface VEVipMainUserDataCell : UITableViewCell

+ (CGFloat)cellHeight;

- (void)changeVipState;

@end

NS_ASSUME_NONNULL_END
