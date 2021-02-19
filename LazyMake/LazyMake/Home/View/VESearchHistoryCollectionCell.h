//
//  VESearchHistoryCollectionCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYLabelsSelect.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VESearchHistoryCollectionCellStr = @"VESearchHistoryCollectionCell";

@interface VESearchHistoryCollectionCell : UICollectionViewCell

@property (copy, nonatomic) void (^clickTagBlock)(NSString *content, NSInteger index);
@property (assign, nonatomic) CGFloat cellHeight;
@property (strong, nonatomic) JYLabelsSelect * labelSelect;

- (CGFloat)createCellHeightWithTagArr:(NSArray *)tagArr;

@end

NS_ASSUME_NONNULL_END

