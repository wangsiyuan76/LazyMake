//
//  VENoneView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/27.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENoneView : UIView

@property (strong, nonatomic) UIImageView *logoImage;
@property (strong, nonatomic) UILabel *titleLab;

+ (CGFloat)cellHeight;

- (void)setLogoImage:(NSString *)imageName andTitle:(NSString *)titleStr;

@end

NS_ASSUME_NONNULL_END
