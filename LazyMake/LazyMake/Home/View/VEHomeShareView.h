//
//  VEHomeShareView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/9.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEHomeTemplateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEHomeShareView : UIView
@property (copy, nonatomic) void (^cancleBlock)(void);
@property (strong, nonatomic) VEHomeTemplateModel *showModel;           //当前展示的model对象

- (void)show;

@end

NS_ASSUME_NONNULL_END
