//
//  VETemplateCardCollectionCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEHomeTemplateModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VETemplateCardCollectionCellStr = @"VETemplateCardCollectionCell";

@interface VETemplateCardCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageIV;
@property (nonatomic, strong) UILabel *makeExplanationLab;
@property (nonatomic, strong) VEHomeTemplateModel *model;
@property (nonatomic, assign) CGFloat imageBottom;

+ (CGFloat)imageBottom;
@end

NS_ASSUME_NONNULL_END
