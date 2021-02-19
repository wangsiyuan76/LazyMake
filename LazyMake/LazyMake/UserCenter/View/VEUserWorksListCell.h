//
//  VEUserWorksListCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *VEUserWorksListCellStr = @"VEUserWorksListCell";

@interface VEUserWorksListCell : UITableViewCell

@property (strong, nonatomic) NSArray *worksList;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
