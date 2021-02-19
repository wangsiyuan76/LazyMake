//
//  VEUserMyFeedbackListCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEUserFeedbackListModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VEUserMyFeedbackListCellStr = @"VEUserMyFeedbackListCell";

@interface VEUserMyFeedbackListCell : UITableViewCell

@property (strong, nonatomic) VEUserFeedbackListModel *model;

@property (strong, nonatomic) UILabel *contentLab;

@end

NS_ASSUME_NONNULL_END
