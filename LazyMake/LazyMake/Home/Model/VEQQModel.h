//
//  VEQQModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/28.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEQQModel : VEBaseModel

@property (strong, nonatomic) NSString *qq_group;
@property (strong, nonatomic) NSString *qq_key;
@property (strong, nonatomic) NSString *lx_qq;
@property (strong, nonatomic) NSString *close_mobile_login; //1开启 0关闭
@property (strong, nonatomic) NSString *access_token;


@end

NS_ASSUME_NONNULL_END
