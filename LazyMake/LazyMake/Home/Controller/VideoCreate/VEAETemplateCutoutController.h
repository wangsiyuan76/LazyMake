//
//  VEAETemplateCutoutController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEHomeTemplateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEAETemplateCutoutController : UIViewController

@property (copy, nonatomic) void (^selectBlock)(UIImage *selectImage,BOOL hasChange);
@property (strong, nonatomic) UIImage *selectImage;
@property (strong, nonatomic) VEHomeTemplateModel *showModel;

@end

NS_ASSUME_NONNULL_END
