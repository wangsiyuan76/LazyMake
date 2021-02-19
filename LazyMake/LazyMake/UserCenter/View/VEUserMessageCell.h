//
//  VEUserMessageCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/6.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *VEUserMessageCellStr = @"VEUserMessageCell";

@interface VEUserMessageCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *noticeLab;
@property (strong, nonatomic) UILabel *contentLab;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) NSString *contentStr;

+ (CGFloat)cellHeightWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
