//
//  VEHomeToolTeachCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VETeachListModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VEHomeToolTeachCellStr = @"VEHomeToolTeachCell";

@interface VEHomeToolTeachCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UILabel *mainLab;
@property (strong, nonatomic) VETeachListModel *model;
- (void)setModel:(VETeachListModel *)model andIndex:(NSInteger)index lineNum:(NSInteger)lineNum;


@end

NS_ASSUME_NONNULL_END
