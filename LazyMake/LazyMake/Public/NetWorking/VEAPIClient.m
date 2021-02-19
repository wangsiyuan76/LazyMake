//
//  VEAPIClient.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEAPIClient.h"
#import "AES128Util.h"
#import "VEUserModel.h"
#import "VEUserLoginPopupView.h"
#define RESPONSE_RESULT_KEY @"code"
#define RESPONSE_RESULT @"info"
#define RESPONSE_RESULT_MSG @"msg"
#define RESPONSE_RESULT_CODE @"code"


@implementation BSDMedia
@end

@implementation BSDHTTPEntity

-(NSString *)path {
    if (_path) {
        NSLog(@"API_Path:%@",_path);
    }
    return _path;
}

-(NSDictionary *)params {
    if (_params) {
//        NSLog(@"API_Params:%@",[_params jsonStringEncoded]);
    }
    return _params;
}
@end


@implementation VEAPIClient

+ (instancetype)sharedClient
{
    static VEAPIClient * sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [VEAPIClient manager];
        sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", nil];
        NSString *pushUrl = CORRECT_BASEURL;
        sharedClient = [[VEAPIClient alloc] initWithBaseURL:[NSURL URLWithString:pushUrl]];
        sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        sharedClient.requestSerializer.timeoutInterval = REQUEST_TIME_OUT;
        [sharedClient.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
        [sharedClient.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

        NSSet * set = [NSSet setWithObjects:@"text/html",@"application/json", nil];

        sharedClient.responseSerializer.acceptableContentTypes = set;
    });
    return sharedClient;
}

#pragma mark - 统一请求方法

- (id)requireWithEntity:(BSDHTTPEntity *)entity
             completion:(BSDHTTPCompletionBlock)completion
                failure:(BSDHTTPFailureBlock)failure
{
    NSDictionary *parDic = [self createSortOutPar:entity];
    switch (entity.method)
    {
        case BSDHTTPMethodGET:
        {

            return [[VEAPIClient sharedClient]GET:entity.path parameters:parDic?: @{} headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [VEAPIClient handleResponseObject:responseObject uploadProgress:0 entity:entity completion:completion];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [VEAPIClient handleFailureWithEntity:entity completion:completion failure:failure error:error];
            }];
        } break;

        case BSDHTTPMethodPOST:
        {
           return [[VEAPIClient sharedClient] POST:entity.path parameters:parDic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               [VEAPIClient handleResponseObject:responseObject uploadProgress:0 entity:entity completion:completion];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [VEAPIClient handleFailureWithEntity:entity completion:completion failure:failure error:error];
            }];
        } break;
            
        case BSDHTTPMethodPOSTWithMultiMedia:
        {
            [VEAPIClient sharedClient].requestSerializer.timeoutInterval = REQUEST_TIME_OUT * 3;
            return  [[VEAPIClient sharedClient] POST:entity.path parameters:parDic headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                if (entity.medias.count > 0) {
                    for (int x = 0; x < entity.medias.count; x++) {
                         BSDMedia * media = entity.medias[x];
                        if (media.type == BSDMediaTypeImage){
                                UIImage * image = media.mediaImage;
                                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                // 设置时间格式
                                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                                NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
                                [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.6) name:media.name?:@"" fileName:fileName mimeType:@"image/jpeg"];
                        }
                        if (media.type == BSDMediaTypeVideo) {
                                NSURL *videoFileUrl =  media.mediaUrl;
                                NSData*fileData = [NSData dataWithContentsOfURL:videoFileUrl];
                                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                                NSString *fileName = [NSString  stringWithFormat:@"%@.mp4", dateString];
                                [formData appendPartWithFileData:fileData name:media.name?:@"" fileName:fileName mimeType:@"application/octet-stream"];
                        }
                    }
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                LMLog(@"上传。。。。。===%.2f",uploadProgress.fractionCompleted);
                [[self class] handleResponseObject:nil uploadProgress:uploadProgress.fractionCompleted entity:entity completion:completion];

            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [[self class] handleResponseObject:responseObject uploadProgress:0 entity:entity completion:completion];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [[self class] handleFailureWithEntity:entity completion:completion failure:failure error:error];
            }];
        } break;
        default:
            return nil;
            break;
    }
}

/// 处理提交的参数
/// @param entity 加密，排序等处理后的参数数据
- (NSDictionary *)createSortOutPar:(BSDHTTPEntity *)entity{
    NSString *parStr;                                //排序后的数据
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:entity.params];
    if (!dic) {
        dic = [NSMutableDictionary new];
    }
    if (!entity.canNotTime) {                         //添加时间戳
         NSInteger time = [VETool createLoadNetTime];
        [dic setObject:[NSString stringWithFormat:@"%zd",time] forKey:@"timestamp"];
    }
    //添加用户id
    if ([[LMUserManager sharedManger].userInfo.userid isNotBlank]) {
        [dic setObject:[NSString stringWithFormat:@"%@",[LMUserManager sharedManger].userInfo.userid] forKey:@"userid"];
        [dic setObject:[NSString stringWithFormat:@"%@",[LMUserManager sharedManger].userInfo.token] forKey:@"token"];
    }else{
        [LMUserManager sharedManger].isLogin = NO;
    }
   
    parStr = [[self class]sortSys_key:dic];           //对参数进行排序
//    NSString *keyStr = [NSString stringWithFormat:@"%@%@",parStr,PARAMETER_KEY];
    NSString *md5KeyStr = [[NSString stringWithFormat:@"%@%@",parStr,PARAMETER_KEY]md5String];

    NSMutableDictionary *parDic = [NSMutableDictionary new];
    [parDic setObject:md5KeyStr forKey:@"sign"];

    [parDic addEntriesFromDictionary:dic];
    LMLongLog(@"提交的参数为=======%@",[parDic jsonStringEncoded]);
    return parDic;
}

#pragma mark - 统一处理成功和失败回调

+ (void)handleResponseObject:(id) responseObject
              uploadProgress:(double)uploadProgress
                      entity:(BSDHTTPEntity *) entity
                  completion:(BSDHTTPCompletionBlock) completion
{
    if (responseObject)
    {
        NSString * responseContent  =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString * responseData = [AES128Util AES128Decrypt:responseContent key:DES_KEY iv:DES_IV];
        LMLongLog(@"服务端返回的数据为:=====%@",responseData);
        if (![responseData isNotBlank]) {               //判断数据是否解密成功
            VEBaseModel *baseModel = [[VEBaseModel alloc]init];
            baseModel.state = @"-20000";
            baseModel.msg = @"数据解析失败";
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(baseModel);
            });
        }else{                                          //如果解密成功
            NSData *jsonData = [responseData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            NSInteger code = [[dic objectForKey:RESPONSE_RESULT_CODE]integerValue];
            id result = [dic objectForKey:RESPONSE_RESULT];
            if (code == 200) {       //接口返回成功
                VEBaseModel *model;
                if ([result isKindOfClass:[NSString class]]) {
                    model = [[entity.targetClass alloc]init];
                    model.state = @"1";
                    model.msg = result;
                }
                else if ([result isKindOfClass:[NSDictionary class]]) {
                    model = [entity.targetClass modelWithDictionary:result];
                    model.state = @"1";
                }
                else if ([result isKindOfClass:[NSNull class]]) {
                    model = [[entity.targetClass alloc]init];
                    model.state = @"1";
                    model.msg = result;
                }
                else if ([result isKindOfClass:[NSArray class]]) {
                    NSArray *resArr = (NSArray *)result;
                    model = [[entity.targetClass alloc]init];
                    model.state = @"1";
                    model.hasMore = YES;
                    if (resArr.count < PAGE_SIZE_NUM) {
                        model.hasMore = NO;
                    }
                    if (entity.subArrClass) {
                        NSMutableArray *arr = [NSMutableArray new];
                        for (id subModel in resArr) {
                            id subClassModel = [entity.subArrClass modelWithDictionary:subModel];
                            [arr addObject:subClassModel];
                        }
                        model.resultArr = arr;
                    }else{
                        model.resultArr = result;
                    }
                    
                }else{
                    model = [[entity.targetClass alloc]init];
                    model.state = @"1";
                    model.msg = result;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(model);
                });
            }else if (code == 400){
                VEBaseModel *baseModel = [[VEBaseModel alloc]init];
                baseModel.state = @"0";
                baseModel.errorMsg = [dic objectForKey:RESPONSE_RESULT_MSG];;

                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(baseModel);
                });
            }else if (code == 402){
                VEBaseModel *baseModel = [[VEBaseModel alloc]init];
                baseModel.state = @"-10000";
                baseModel.errorMsg = [dic objectForKey:RESPONSE_RESULT_MSG];;
                dispatch_async(dispatch_get_main_queue(), ^{
                        completion(baseModel);
                });
            }else if (code == 401){
                VEBaseModel *baseModel = [[VEBaseModel alloc]init];
                baseModel.state = @"401";
//                baseModel.errorMsg = [dic objectForKey:RESPONSE_RESULT_MSG];;
                baseModel.msg = @"该账号已在其他设备上登录";
                baseModel.errorMsg = @"该账号已在其他设备上登录";
                [[LMUserManager sharedManger]removeUserData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[self class] showLoginView];
                    completion(baseModel);
                });
            }else{
                VEBaseModel *baseModel = [[VEBaseModel alloc]init];
                baseModel.state = @"-10000";
                baseModel.errorMsg = @"接口异常";
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(baseModel);
                });
            }
        }
    }else{
        VEBaseModel *baseModel = [[VEBaseModel alloc]init];
        baseModel.isLoading = YES;
        baseModel.loadingSchedule = uploadProgress;
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(baseModel);
        });
    }
}

+ (void)handleFailureWithEntity:(BSDHTTPEntity *) entity
                     completion:(BSDHTTPCompletionBlock) completion
                        failure:(BSDHTTPFailureBlock) failure
                          error:(NSError *) error
{
    NSLog(@"error = %@", [error localizedDescription]);
    dispatch_async(dispatch_get_main_queue(), ^{
        failure(error);
    });
}

#pragma mark----按照升序排列-----
+ (NSString *)sortSys_key:(NSDictionary *)sys_keyDic{
    
    NSArray *allKeys = [sys_keyDic allKeys];
    NSArray *sortAllKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSOrderedAscending];
    }];
    
//    DLog(@"allKeys:%@",sortAllKeys);
    NSString *sys_keySorted = @"";
    for (int i = 0; i < sortAllKeys.count; i++) {
        NSString *keyPer = sortAllKeys[i];
        NSString *valuePer = [sys_keyDic objectForKey:keyPer];
        //Judge..
        sys_keySorted = [sys_keySorted stringByAppendingFormat:@"%@=%@",keyPer, valuePer];
        if (i != (sortAllKeys.count - 1)) {
            sys_keySorted = [sys_keySorted stringByAppendingString:@"&"];
        }

    }
    return sys_keySorted;
}
/// 弹出登录框
+ (void)showLoginView{
    VEUserLoginPopupView *loginView = [[VEUserLoginPopupView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [win addSubview:loginView];
}


@end
