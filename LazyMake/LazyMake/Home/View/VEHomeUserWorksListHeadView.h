//
//  VEHomeUserWorksListHeadView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/10.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEHomeTemplateModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VEHomeUserWorksListHeadViewStr = @"VEHomeUserWorksListHeadView";

@interface VEHomeUserWorksListHeadView : UICollectionReusableView

@property (strong, nonatomic) VEHomeTemplateModel *model;

+ (CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
