//
//  VEHomeHeadEffectCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *VEHomeHeadEffectCellStr = @"VEHomeHeadEffectCell";

@interface VEHomeHeadEffectCell : UITableViewCell

@property (strong, nonatomic) NSMutableArray *dataArr;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
