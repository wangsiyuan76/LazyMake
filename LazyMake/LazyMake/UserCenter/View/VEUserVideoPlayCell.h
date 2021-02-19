//
//  VEUserVideoPlayCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/27.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEUserWorksListModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VEUserVideoPlayCellStr = @"VEUserVideoPlayCell";

@interface VEUserVideoPlayCell : UICollectionViewCell

@property (copy, nonatomic) void (^deleteModelBlock)(VEUserWorksListModel *model, NSInteger index);
@property (strong, nonatomic) VEUserWorksListModel *model;
@property (strong, nonatomic) UIImageView *mainImage;
@property (assign, nonatomic) NSInteger index;

+ (CGFloat)cellHieght;

@end

NS_ASSUME_NONNULL_END
