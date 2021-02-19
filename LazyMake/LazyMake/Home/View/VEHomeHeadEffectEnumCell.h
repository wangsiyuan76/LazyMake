//
//  VEHomeHeadEffectEnumCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEHomeHeadEffectModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VEHomeHeadEffectEnumCellStr = @"VEHomeHeadEffectEnumCell";

@interface VEHomeHeadEffectEnumCell : UICollectionViewCell

@property (strong, nonatomic) VEHomeHeadEffectModel *model;

@end

NS_ASSUME_NONNULL_END
