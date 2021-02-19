//
//  VEVipFeaturesListSubCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEVIPMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VEVipFeaturesListSubCellStr = @"VEVipFeaturesListSubCell";

@interface VEVipFeaturesListSubCell : UICollectionViewCell

@property (strong, nonatomic) VEVIPMoneyModel *model;

+(CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
