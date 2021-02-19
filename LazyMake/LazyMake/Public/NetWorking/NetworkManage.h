//
//  NetworkManage.h
//  YQ
//
//  Created by raoyuanjie on 14/11/6.
//  Copyright (c) 2014年 raoyuanjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

typedef void(^HttpUploadSuccessBlock)(id Json);
typedef void(^HttpUploadFailureBlock)(void);

@interface NetworkManage : NSObject
//HTTP REQUEST METHOD TYPE
typedef NS_ENUM(NSInteger, JDHttpRequestType) {
    JDHttpRequestGet,
    JDHttpRequestPost,
    JDHttpRequestDelete,
    JDHttpRequestPut,
};

/**
 *  请求开始前预处理Block
 */
typedef void(^PrepareExecuteBlock)(void);

//typedef void(^Result)(id object);

/****************      ****************/

+ (NetworkManage *)defaultClient;

- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
                   view:view
                result:(void (^)(id result))success;

/**
 *  HTTP请求（GET、POST、DELETE、PUT）
 *
 *  @param path
 *  @param method     RESTFul请求类型
 *  @param parameters 请求参数
 *  @param prepare    请求前预处理块
 *  @param success    请求成功处理块
 *  @param failure    请求失败处理块
 */
- (void)requestWithPath:(NSString *)url uri:(NSString *)uri
                 method:(NSInteger)method
             parameters:(id)parameters
         prepareExecute:(PrepareExecuteBlock) prepare
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
//上传单张图片//parameterOfimage:(NSString *)parameter
-(void)uploadImageWithPath:(NSString *)url
                parameters:(id)parameters
                     image:(UIImage *)image parameterOfimage:(NSString *)parameter result:(void (^)(id result,BOOL isSuccess))result;
//上传多张图片
-(void)uploadImageWithPath:(NSString *)url
                parameters:(id)parameters
                     image:(NSArray *)images parameterOfimages:(NSString *)parameter result:(void (^)(id result,BOOL isSuccess))result;

//上传修改图片数组
-(void)uploadImageWithPath:(NSString *)url
                parameters:(id)parameters
                  imagestr:(NSArray *)images parameterOfimages:(NSString *)parameterstr image:(NSArray *)imagesArray parameterOfimages:(NSString *)parameter result:(void (^)(id result,BOOL isSuccess))result;
//判断当前网络状态
- (BOOL)isConnectionAvailable;

- (void)requestWithPath:(NSString *)url
             parameters:(id)parameters
                 result:(void (^)(id result,BOOL isSuccess))result;
- (NSString *)sortSys_withoutkey:(NSDictionary *)sys_keyDic;

@end
