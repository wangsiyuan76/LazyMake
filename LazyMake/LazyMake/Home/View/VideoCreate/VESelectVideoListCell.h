//
//  VESelectVideoListCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/15.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *VESelectVideoListCellStr = @"VESelectVideoListCell";

@interface VESelectVideoListCell : UICollectionViewCell

@property (copy, nonatomic) void (^clickSelectBtnBlock)(NSInteger index);

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UIImageView *shadowMainImage;

@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UIButton *selectBtn;


@end

NS_ASSUME_NONNULL_END
