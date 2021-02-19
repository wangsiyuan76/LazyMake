//
//  VEHomeContentEnumVideoCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/1.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEHomeTemplateModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VEHomeContentEnumVideoCellStr = @"VEHomeContentEnumVideoCell";

@interface VEHomeContentEnumVideoCell : UICollectionViewCell

@property (strong, nonatomic) VEHomeTemplateModel *model;

+ (CGFloat)cellHeight;

+ (CGFloat)cellHeightSmall;

- (void)changeSmallStyle;

@end

NS_ASSUME_NONNULL_END
