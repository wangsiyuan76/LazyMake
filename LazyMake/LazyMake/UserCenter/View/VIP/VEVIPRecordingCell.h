//
//  VEVIPRecordingCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEVipRecordingModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VEVIPRecordingCellStr = @"VEVIPRecordingCell";

@interface VEVIPRecordingCell : UITableViewCell

@property (strong, nonatomic) VEVipRecordingModel *model;
+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
