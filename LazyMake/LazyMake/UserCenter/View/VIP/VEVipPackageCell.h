//
//  VEVipPackageCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEVIPMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VEVipPackageCellStr = @"VEVipPackageCell";

@interface VEVipPackageCell : UITableViewCell

@property (copy, nonatomic) void (^clickSureBtnBlock) (VEVIPMoneyModel *selectModel);

@property (strong, nonatomic) NSArray *moneyArr;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
