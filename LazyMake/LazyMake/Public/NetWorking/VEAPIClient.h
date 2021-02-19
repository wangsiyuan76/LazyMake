//
//  VEAPIClient.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "VEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

#define REQUEST_TIME_OUT 30

typedef void(^BSDHTTPCompletionBlock)(id result);  //请求成功，返回result为1的结果
typedef void(^BSDHTTPFailureBlock)(NSError * error);  //请求失败，放回error
typedef void(^BSDHTTPWarningBlock)(id result);     //请求成功，返回result为0的结果

typedef NS_ENUM(NSInteger, BSDHTTPMethod)
{
    BSDHTTPMethodGET = 0,
    BSDHTTPMethodPOST,
    BSDHTTPMethodPOSTWithMultiMedia,
};

typedef NS_ENUM(NSInteger, BSDMediaType)
{
    BSDMediaTypeImage = 0,
    BSDMediaTypeAudio,
    BSDMediaTypeVideo,
};

@interface BSDMedia : NSObject

@property (assign, nonatomic) BSDMediaType type;
@property (copy, nonatomic) NSArray * medias;
@property (copy, nonatomic) NSArray * bigMedias;
@property (copy, nonatomic) NSArray * smallMedias;
@property (copy, nonatomic) NSString * name;//单个key对应一张或多张图片
@property (copy, nonatomic) NSArray *names;//多个key个对应一张图片  fileName xxx1的形式
@property (nonatomic, copy) NSString * fileName;

@property (copy, nonatomic) UIImage * mediaImage;
@property (copy, nonatomic) NSURL * mediaUrl;

@property (copy, nonatomic) NSArray * audioMedias;
@property (copy, nonatomic) NSString * audioName;//
@property (copy, nonatomic) NSArray *audioNames;//
@property (nonatomic, copy) NSString * audioFileName;
@end

@interface BSDHTTPEntity : NSObject
@property (assign, nonatomic) BSDHTTPMethod method;
@property (strong, nonatomic) BSDMedia * media;
@property (copy, nonatomic) NSString * path;
@property (copy, nonatomic) NSDictionary * params;
@property (strong, nonatomic) NSString *imgbase64;
@property (strong, nonatomic) Class targetClass;
@property (strong, nonatomic) Class subArrClass;

@property (nonatomic, assign) BOOL cacheEnable;     //是否缓存请求结果, default is NO.
@property (nonatomic, assign) BOOL canNotTime;      //是否不添加时间 （仅用于已启动app时，验证时间的接口）

@property (copy, nonatomic) NSArray * medias;

@end

@interface VEAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (id)requireWithEntity:(BSDHTTPEntity *)entity
             completion:(BSDHTTPCompletionBlock)completion
                failure:(BSDHTTPFailureBlock)failure;

#pragma mark----按照升序排列-----
+ (NSString *)sortSys_key:(NSDictionary *)sys_keyDic;

@end

NS_ASSUME_NONNULL_END
