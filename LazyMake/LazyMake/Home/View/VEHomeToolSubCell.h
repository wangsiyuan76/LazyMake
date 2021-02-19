//
//  VEHomeToolSubCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/1.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEHomeToolModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VEHomeToolSubCellStr = @"VEHomeToolSubCell";

@interface VEHomeToolSubCell : UICollectionViewCell

@property (strong, nonatomic) VEHomeToolModel *model;

- (void)hiddenAll;

@end

NS_ASSUME_NONNULL_END
