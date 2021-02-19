//
//  VEVipPackageSubCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEVIPMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VEVipPackageSubCellStr = @"VEVipPackageSubCell";

@interface VEVipPackageSubCell : UICollectionViewCell

@property (strong, nonatomic) VEVIPMoneyModel *model;

+ (CGFloat)celHeight;

@end

NS_ASSUME_NONNULL_END
