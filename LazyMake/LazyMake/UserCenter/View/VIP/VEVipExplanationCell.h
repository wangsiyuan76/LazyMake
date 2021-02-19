//
//  VEVipExplanationCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *VEVipExplanationCellStr = @"VEVipExplanationCell";

@interface VEVipExplanationCell : UITableViewCell

+ (CGFloat)cellHeightIndex:(NSInteger)index;

- (void)creatContentWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
