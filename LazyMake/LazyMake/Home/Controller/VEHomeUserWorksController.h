//
//  VEHomeUserWorksController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/10.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEHomeTemplateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEHomeUserWorksController : UIViewController

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) VEHomeTemplateModel *model;

@end

NS_ASSUME_NONNULL_END
