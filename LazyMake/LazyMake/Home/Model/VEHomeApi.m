//
//  VEHomeApi.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeApi.h"
#import "VEHomeToolModel.h"
#import "VEHomeTemplateModel.h"
#import "VEQQModel.h"
#import "VETeachListModel.h"

@implementation VEHomeApi

+ (instancetype)sharedApi
{
    static VEHomeApi *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/**
 获取服务端时间
 */
-(void)ve_updateNetTimeCompletionon:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"opinion/public_timestamp";
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 获取首页分类类别
 */
-(void)ve_loadClassificationDataCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"custom/classify_info";
    entity.subArrClass = [VEHomeToolModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 获取首页分类筛选内容
 */
-(void)ve_loadClassListDataPage:(NSInteger)page classID:(NSString *)classID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"custom/classify_list_info";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"%d",PAGE_SIZE_NUM] forKey:@"pagesize"];
    [dic setObject:[NSString stringWithFormat:@"%@",classID?:@""] forKey:@"classify_id"];
    
    entity.params = dic;
    entity.subArrClass = [VEHomeTemplateModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 获取首页热门推荐数据
 */
-(void)ve_loadHomeHomeClassPage:(NSInteger)page Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"custom/recommend_custom";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"%d",PAGE_SIZE_NUM] forKey:@"pagesize"];
    
    entity.params = dic;
    entity.subArrClass = [VEHomeTemplateModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 热门搜索
 */
-(void)ve_loadHotSearchListPage:(NSInteger)page Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"search/hot_custom";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"%d",PAGE_SIZE_NUM] forKey:@"pagesize"];
    
    entity.params = dic;
    entity.subArrClass = [VEHomeTemplateModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 搜索数据
 */
-(void)ve_loadSearchListPage:(NSInteger)page searchWord:(NSString *)searchWord Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"search/index";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"%d",PAGE_SIZE_NUM] forKey:@"pagesize"];
    [dic setObject:[NSString stringWithFormat:@"%@",searchWord] forKey:@"word"];

    entity.params = dic;
    entity.subArrClass = [VEHomeTemplateModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 标签列表数据
 */
-(void)ve_loadTagListPage:(NSInteger)page tagname:(NSString *)tagname Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"tags/custom_tag_list";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"%d",PAGE_SIZE_NUM] forKey:@"pagesize"];
    [dic setObject:[NSString stringWithFormat:@"%@",tagname] forKey:@"tagname"];

    entity.params = dic;
    entity.subArrClass = [VEHomeTemplateModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 用户作品列表
 */
-(void)ve_loadUserWorksListPage:(NSInteger)page userID:(NSString *)userID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"user/homepage_list";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"%d",PAGE_SIZE_NUM] forKey:@"pagesize"];
    [dic setObject:[NSString stringWithFormat:@"%@",userID] forKey:@"friend_id"];

    entity.params = dic;
    entity.subArrClass = [VEHomeTemplateModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}


/**
 详情页访问统计
 */
-(void)ve_detailCountHits:(NSString *)subID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"custom/count_hits";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%@",subID] forKey:@"id"];

    entity.params = dic;
    entity.subArrClass = [VEHomeTemplateModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 详情加载更多
 */
-(void)ve_detailLoadListPage:(NSInteger)page pushUrl:(NSString *)pushUrl otherDic:(NSDictionary *)parDic Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = pushUrl;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parDic];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];

    entity.params = dic;
    entity.subArrClass = [VEHomeTemplateModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 上传作品
*/
- (void)ve_updataVideo:(NSString *)videoUrl coverImage:(UIImage *)coverImage titleStr:(NSString *)titleStr otherPar:(NSDictionary *__nullable)parDic Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOSTWithMultiMedia;
    entity.path = @"dynamicupload/video_upload";
    
    BSDMedia *media = [[BSDMedia alloc]init];
    media.mediaImage = coverImage;
    media.type = BSDMediaTypeImage;
    media.fileName = @"thumb";
    media.name = @"thumb";
    
    BSDMedia *videoMedia = [[BSDMedia alloc]init];
    videoMedia.mediaUrl = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",videoUrl]];
    videoMedia.type = BSDMediaTypeVideo;
    videoMedia.fileName = @"vedio";
    videoMedia.name = @"vedio";

    NSMutableDictionary *par = [NSMutableDictionary dictionaryWithDictionary:parDic];
    
    [par setObject:[VETool getFileMD5StrFromPath:videoUrl]?:@"" forKey:@"md5"];
    [par setObject:titleStr?:@"" forKey:@"title"];

    entity.params = par;
    entity.medias = @[media,videoMedia];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

//下载模板统计
- (void)ve_addDownLoadTongji:(NSString *)dID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"custom/download_hits";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%@",dID] forKey:@"id"];
    entity.params = dic;
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 首页中间工具栏数据
*/
- (void)ve_loadHomeToolListCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"opinion/self_advertising";
    entity.targetClass = [LMHomeToolListModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 首页中间工具栏数据点击统计
*/
- (void)ve_loadHomeToolStatistics:(NSString *)tId Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"poster/click_count";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%@",tId] forKey:@"hitsid"];
    entity.params = dic;
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 请求新手教程的数据
*/
- (void)ve_loadTeachDataWithPageSize:(NSString *)pageSize Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"tutorial/index";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%@",pageSize] forKey:@"pagesize"];
    [dic setObject:[NSString stringWithFormat:@"1"] forKey:@"page"];
    entity.params = dic;
    entity.subArrClass = [VETeachListModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 请求新手教程统计
*/
- (void)ve_teachDataStatisticsWithID:(NSString *)tID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"tutorial/count_hits";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%@",tID] forKey:@"id"];
    entity.params = dic;
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

#pragma mark - Other
- (void)ve_addOtherDataLaLalaCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"看看看" forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [btn2 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

@end
