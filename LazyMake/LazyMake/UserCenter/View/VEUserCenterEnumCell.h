//
//  VEUserCenterEnumCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEUserCenterEnumModel.h"

static NSString *VEUserCenterEnumCellStr = @"VEUserCenterEnumCell";

NS_ASSUME_NONNULL_BEGIN

@interface VEUserCenterEnumCell : UITableViewCell

@property (strong, nonatomic) UIView *redView;
@property (strong, nonatomic) VEUserCenterEnumModel *model;

@end

NS_ASSUME_NONNULL_END
