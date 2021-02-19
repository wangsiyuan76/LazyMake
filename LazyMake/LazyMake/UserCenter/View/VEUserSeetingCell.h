//
//  VEUserSeetingCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *VEUserSeetingCellStr = @"VEUserSeetingCell";

@interface VEUserSeetingCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *contentLab;
@property (strong, nonatomic) UIImageView *arrowImage;
@property (strong, nonatomic) UIImageView *iconImage;

- (void)setUserIconWithImageUrl:(NSString *)imageUrl;

+ (CGFloat)cellHeight;

- (void)showArrowImage:(BOOL)ifHidden;

@end

NS_ASSUME_NONNULL_END
