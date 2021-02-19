//
//  VEFindApi.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/19.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEFindApi.h"
#import "VEFindHomeListModel.h"

@implementation VEFindApi
+ (void)ve_loadFindListDataWithPage:(NSInteger)page Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"dynamic/user_works";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"%d",PAGE_SIZE_NUM] forKey:@"pagesize"];
    entity.params = dic;
    entity.subArrClass = [VEFindHomeListModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//发现页获取单视频内容
+ (void)ve_loadVideoDataWithID:(NSString *)vID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"dynamic/select_live";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%@",vID] forKey:@"id"];
    entity.params = dic;
    entity.subArrClass = [VEFindHomeListModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//发现页单视频统计
+ (void)ve_findVideoStatisticsWithID:(NSString *)vID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"dynamic/count_hits";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%@",vID] forKey:@"id"];
    entity.params = dic;
    entity.subArrClass = [VEBaseModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
@end
