//
//  VEFindApi.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/19.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEFindApi : NSObject
//发现页列表数据
+ (void)ve_loadFindListDataWithPage:(NSInteger)page Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

//发现页获取单视频内容
+ (void)ve_loadVideoDataWithID:(NSString *)vID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

//发现页单视频统计
+ (void)ve_findVideoStatisticsWithID:(NSString *)vID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;
@end

NS_ASSUME_NONNULL_END
