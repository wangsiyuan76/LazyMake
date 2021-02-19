//
//  VEUserWorksSubCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEUserWorksListModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VEUserWorksSubCellStr = @"VEUserWorksSubCell";

@interface VEUserWorksSubCell : UICollectionViewCell

@property (copy, nonatomic) void (^clickDeleBtnBlock)(NSInteger index);
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) VEUserWorksListModel *model;

+ (CGFloat)cellHeight;

- (void)showViewIfHome:(BOOL)ifHome;
@end

NS_ASSUME_NONNULL_END
