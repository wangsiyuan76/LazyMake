//
//  VEHomeApi.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEHomeApi : NSObject

+ (instancetype)sharedApi;

/**
 获取服务端时间
 */
-(void)ve_updateNetTimeCompletionon:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/**
 获取首页分类类别
 */
-(void)ve_loadClassificationDataCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/**
 获取首页分类筛选内容
 */
-(void)ve_loadClassListDataPage:(NSInteger)page classID:(NSString *)classID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/**
 热门搜索
 */
-(void)ve_loadHotSearchListPage:(NSInteger)page Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/**
 搜索数据
 */
-(void)ve_loadSearchListPage:(NSInteger)page searchWord:(NSString *)searchWord Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/**
 标签列表数据
 */
-(void)ve_loadTagListPage:(NSInteger)page tagname:(NSString *)tagname Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/**
 用户作品列表
 */
-(void)ve_loadUserWorksListPage:(NSInteger)page userID:(NSString *)userID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/**
 获取首页热门推荐数据
 */
-(void)ve_loadHomeHomeClassPage:(NSInteger)page Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/**
 详情页访问统计
 */
-(void)ve_detailCountHits:(NSString *)subID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/**
 详情加载更多
 */
-(void)ve_detailLoadListPage:(NSInteger)page pushUrl:(NSString *)pushUrl otherDic:(NSDictionary *)parDic Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/**
 上传作品
*/
- (void)ve_updataVideo:(NSString *)videoUrl coverImage:(UIImage *)coverImage titleStr:(NSString *)titleStr otherPar:(NSDictionary *__nullable)parDic Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/**
 首页中间工具栏数据
*/
- (void)ve_loadHomeToolListCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/**
 首页中间工具栏数据点击统计
*/
- (void)ve_loadHomeToolStatistics:(NSString *)tId Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

//下载模板统计
- (void)ve_addDownLoadTongji:(NSString *)dID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/**
 请求新手教程的数据
*/
- (void)ve_loadTeachDataWithPageSize:(NSString *)pageSize Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/**
 请求新手教程统计
*/
- (void)ve_teachDataStatisticsWithID:(NSString *)tID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

#pragma mark - Other
- (void)ve_addOtherDataLaLalaCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

@end

NS_ASSUME_NONNULL_END
