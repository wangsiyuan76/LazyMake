//
//  VEHomeToolEnumCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *VEHomeToolEnumCellStr = @"VEHomeToolEnumCell";

@interface VEHomeToolEnumCell : UITableViewCell

@property (strong, nonatomic) NSArray *toolList;

+(CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
