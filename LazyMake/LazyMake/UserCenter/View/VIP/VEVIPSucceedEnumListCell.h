//
//  VEVIPSucceedEnumListCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEVipShopSucceedModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VEVIPSucceedEnumListCellStr = @"VEVIPSucceedEnumListCell";

@interface VEVIPSucceedEnumListCell : UITableViewCell

@property (strong, nonatomic) VEVipShopSucceedModel *model;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
