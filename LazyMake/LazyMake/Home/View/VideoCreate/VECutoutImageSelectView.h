//
//  VECutoutImageSelectView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VECutoutImageSelectView : UIView

@property (copy, nonatomic) void (^changeSelectImageBlock)(UIImage *selectImage);

@property (strong, nonatomic) UIButton *mainBtn;
@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UIImageView *addImage;
@property (strong, nonatomic) UIImageView *backgroundImage;

@property (strong, nonatomic) UILabel *subLab;

@end

NS_ASSUME_NONNULL_END
