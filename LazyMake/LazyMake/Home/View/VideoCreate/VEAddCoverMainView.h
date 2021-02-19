//
//  VEAddCoverMainView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/23.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEAddCoverMainView : UIView

@property (copy, nonatomic) void (^changeImageBlock)(UIImage *image);
@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIButton *changeBtn;
@property (strong, nonatomic) UILabel *titleLab;
@property (assign, nonatomic) CGSize imageSize;

- (void)changeImage;

@end

NS_ASSUME_NONNULL_END
