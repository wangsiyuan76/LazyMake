//
//  VEVipShopSucceedModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEVipShopSucceedModel : VEBaseModel

@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *contentStr;
@property (assign, nonatomic) BOOL isBlue;              //是否蓝色

@end

NS_ASSUME_NONNULL_END
