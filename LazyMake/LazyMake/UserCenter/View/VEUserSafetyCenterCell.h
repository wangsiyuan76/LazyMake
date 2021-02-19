//
//  VEUserSafetyCenterCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/15.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEUserSafetyModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VEUserSafetyCenterCellStr = @"VEUserSafetyCenterCell";

@interface VEUserSafetyCenterCell : UITableViewCell

@property (strong, nonatomic) UILabel *numLab;
@property (strong, nonatomic) UILabel *contentLab;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) VEUserSafetyModel *model;

@end

NS_ASSUME_NONNULL_END
