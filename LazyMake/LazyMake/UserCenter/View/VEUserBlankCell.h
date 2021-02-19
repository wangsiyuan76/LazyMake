//
//  VEUserBlankCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *VEUserBlankCellStr = @"VEUserBlankCell";

@interface VEUserBlankCell : UITableViewCell

+ (CGFloat)cellHeight;

- (void)setLogoImage:(NSString *)imageName andTitle:(NSString *)titleStr;

@end

NS_ASSUME_NONNULL_END
