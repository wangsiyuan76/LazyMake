
//  NetworkManage.m
//  YQ
//
//  Created by raoyuanjie on 14/11/6.
//  Copyright (c) 2014年 raoyuanjie. All rights reserved.
//
#import<CommonCrypto/CommonDigest.h>
#import "NetworkManage.h"
#import "UIView+Toast.h"
#import "AES128Util.h"
#import <sys/utsname.h>
#import "AES128Util.h"

#define AES_KEY @"CYXFyWk32HlzWYs9"
#define SALT_KEY @"9nhLn3"

//#import "KeychainItemWrapper.h"

@interface NetworkManage()
@property(nonatomic,strong) AFHTTPSessionManager *manager;
@end

@implementation NetworkManage
/*
- (id)init{
    if (self = [super init]){
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应结果序列化类型
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [self.manager.requestSerializer setTimeoutInterval:5];
        [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    }
    return self;
}

+ (NetworkManage *)defaultClient {
    static NetworkManage *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)upload2ImageWithUrl:(NSString *)url uri:(NSString *)uri parameters:(id)parameters images:(NSArray *)images
                   success:(void (^)(NSURLSessionDataTask *, id responseObject))success
                   failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{};

- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
                   view:view
                result:(void (^)(id result))result {
    //请求的URL
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSArray *array = [((NSDictionary *)parameters).allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2]; //升序
    }];
    
    NSMutableString *keystring = [[NSMutableString alloc] init];
    for (int i = 0; i < array.count; i++) {
        NSString *key = array[i];
        [keystring appendString:key];
        [keystring appendFormat:@"%@",parameters[key]];
    }
    //这里是headerparams加密所需4个参数
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本号
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    LMLog(@"手机当前应用软件版本:%@",version);
    //app类型
    NSString* deviceName = @"ios";
    LMLog(@"手机系统类型: %@",deviceName );
    
    //设备标识符
    NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    LMLog(@"手机uuid：%@",deviceUUID);
    
    
    
    
    //手机型号
    NSString* phoneModel = [self iphoneType];
    LMLog(@"手机型号: %@",phoneModel);
    
    
    NSDictionary *header_paramsDic = @{
                                       @"app_type":deviceName,
                                       @"version":version,
                                       @"imei":deviceUUID,
                                       @"model":phoneModel
                                       };
    
    NSString *header_params = [self sortSys_key:header_paramsDic];
    
    
    NSInteger timereduce = [[NSUserDefaults standardUserDefaults] integerForKey:@"servicetimereduce"];
    
    NSDate *nowdate = [NSDate date];
    NSTimeInterval timeinterval = [nowdate timeIntervalSince1970];
    NSInteger timeinterval2 = (NSInteger)timeinterval + timereduce;
    NSLog(@"timereduce:%ld",(long)timeinterval2);
    NSString *timeintersastr = [NSString stringWithFormat:@"%ld",(NSInteger)(timeinterval*1000)];
    NSString *timestring = [NSString stringWithFormat:@"%ld%@",timeinterval2,[timeintersastr substringFromIndex:timeintersastr.length-3]];
    
    NSDictionary *signparamsDic = @{
                                       @"app_type":deviceName,
                                       @"version":version,
                                       @"imei":deviceUUID,
                                       @"model":phoneModel,
                                       @"time":timestring
                                       };
    
    NSString *signparams = [self sortSys_key:signparamsDic];
   
    //[param setObject:[AES128Util AES128Encrypt:signparams key:AES_KEY] forKey:@"sign"];
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setTimeoutInterval:5];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //不设置会报-1016或者会有编码问题
//    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"charset=utf-8", nil];

    [_manager.requestSerializer setValue:[AES128Util AES128Encrypt:header_params key:AES_KEY] forHTTPHeaderField:@"headerparams"];
    [_manager.requestSerializer setValue:[AES128Util AES128Encrypt:signparams key:AES_KEY] forHTTPHeaderField:@"sign"];
    [_manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
   
   // 设置请求的编码类型
    [_manager.requestSerializer setValue:@"Identity" forHTTPHeaderField:@"Content-Encoding"];
    
   
    
    if (view != nil) {
//        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }

    //判断网络状况（有链接：执行请求；无链接：弹出提示）
    if ([self isConnectionAvailable]) {
        //预处理（显示加载信息啥的）
        switch (method) {
            case JDHttpRequestGet:
            {

//                NSLog(@"sign:%@",param);
            
                 
                [self.manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (view != nil) {

//                        [MBProgressHUD hideHUDForView:view animated:YES];
                    }


                    NSNumber *ret = responseObject[@"ret"];

                    LMLog(@"ret:%@",ret);
                    NSString * msg = responseObject[@"msg"];

                    if (ret .integerValue == 400) {
//                        [XHToast showTopWithText:msg];
                    }
                    if (ret .integerValue == 401) {
//                        [XHToast showTopWithText:msg];
                    }
                    if (ret != nil && ret.integerValue == 200) {
                        result(responseObject[@"data"]);

                    } else if (ret != nil) {
                        NSString *msg = responseObject[@"msg"];
                        if (view != nil) {
//                            [view makeToast:msg duration:2 position:nil];
                        }else {
//                            [XHToast showBottomWithText:msg];
                        }

                        result(nil);
                    } else {
                        if (view != nil) {
                            [view makeToast:@"未知异常" duration:2 position:nil];
                        }else {
//                            [XHToast showBottomWithText:@"未知异常"];
                        }

                        result(nil);
                    }

                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

//                    LMLog(@"error:%@",error);

                    result(nil);
                }];
            }
                break;
            case JDHttpRequestPost:
            {
             
                [self.manager POST:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [MBProgressHUD hideHUDForView:view animated:YES];
                    
                    NSNumber *ret = responseObject[@"ret"];
                    
                    if (ret != nil && ret.integerValue == 200) {
                        
                        result(responseObject[@"data"]);
                        
                    } else if (ret != nil) {
                        NSString *msg = responseObject[@"msg"];
//                        [XHToast showBottomWithText:msg];
                        result(nil);
                    } else {
//                        [XHToast showBottomWithText:@"未知异常"];
                        result(nil);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
                  
                }];
            }
                break;
            default:
                break;
        }
    }else{
        result(nil);
//        [MBProgressHUD hideHUDForView:view animated:YES];
        //网络错误咯
        [self showExceptionDialog];
        //发出网络异常通知广播
        [[NSNotificationCenter defaultCenter] postNotificationName:@"k_NOTI_NETWORK_ERROR" object:nil];
    }
    
}

#pragma mark----按照升序排列-----
- (NSString *)sortSys_key:(NSDictionary *)sys_keyDic{
    
    NSArray *allKeys = [sys_keyDic allKeys];
    NSArray *sortAllKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSOrderedAscending];
    }];
    
//    LMLog(@"allKeys:%@",sortAllKeys);
    NSString *sys_keySorted = @"";
    for (int i = 0; i < sortAllKeys.count; i++) {
        NSString *keyPer = sortAllKeys[i];
        NSString *valuePer = [sys_keyDic objectForKey:keyPer];
        //Judge..
        sys_keySorted = [sys_keySorted stringByAppendingFormat:@"%@%@",keyPer, valuePer];
        if (i != (sortAllKeys.count - 1)) {
            sys_keySorted = [sys_keySorted stringByAppendingString:@""];
        }

    }
    return sys_keySorted;
}
- (NSString *)sortSys_withoutkey:(NSDictionary *)sys_keyDic{
    
    NSArray *allKeys = [sys_keyDic allKeys];
    NSArray *sortAllKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSOrderedAscending];
    }];
    
    //    LMLog(@"allKeys:%@",sortAllKeys);
    NSString *sys_keySorted = @"";
    for (int i = 0; i < sortAllKeys.count; i++) {
        NSString *keyPer = sortAllKeys[i];
        NSString *valuePer = [sys_keyDic objectForKey:keyPer];
        //Judge..
        sys_keySorted = [sys_keySorted stringByAppendingFormat:@"%@", valuePer];
        
    }
    return sys_keySorted;
}


-(void)uploadImageWithUrl:(NSString *)url uri:(NSString *)uri parameters:(id)parameters images:(NSArray *)images
                 progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                  success:(void (^)(NSURLSessionDataTask *, id responseObject))success
                  failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
}


//看看网络是不是给力
- (BOOL)isConnectionAvailable{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        LMLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}
//使用AFN框架来检测网络状态的改变
-(void)AFNReachability
{
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听网络状态的改变

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
//                LMLog(@"未知");
//                [XHToast showCenterWithText:@"未知异常"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
//                LMLog(@"没有网络");
//                [XHToast showCenterWithText:@"网络不给力，请检查您的网络设置"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
//                LMLog(@"3G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
//                LMLog(@"WIFI");
                break;
                
            default:
                break;
        }
    }];
    
    //3.开始监听
    [manager startMonitoring];
}

- (void)requestWithPath:(NSString *)url
             parameters:(id)parameters
                 result:(void (^)(id result,BOOL isSuccess))result {
    if ([self isConnectionAvailable]) {
        NSLog(@"isConnection");
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (!param) {
        param = [NSMutableDictionary new];
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本号
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //app系统类型
    NSString* deviceName = @"ios";//[[UIDevice currentDevice] systemName];
    NSString *bundleid = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    
    //设备标识符
//    NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"*******" accessGroup:nil];
//    NSString *UUIDString = [wrapper objectForKey:(__bridge id)kSecValueData];
//    if (UUIDString.length == 0) {
//        UUIDString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//        [wrapper setObject:UUIDString forKey:(__bridge id)kSecValueData];
//    }
//    LMLog(@"手机uuid：%@",UUIDString);
//    NSString *channels;
//    if (!IsEmpty(FHchannel)) {
//        channels =FHchannel;
//    }
    //手机型号
    
    NSDictionary *header_paramsDic = @{
                                       @"app_type":deviceName,
                                       @"version":version,
//                                       @"imei":deviceUUID,
                                       @"bundleid":bundleid,
//                                       @"channel":channels
                                       };
    
    NSString *header_params = [self sortSys_key:header_paramsDic];
    
    
    NSInteger timereduce = [[NSUserDefaults standardUserDefaults] integerForKey:@"servicetimereduce"];
    
    NSDate *nowdate = [NSDate date];
    NSTimeInterval timeinterval = [nowdate timeIntervalSince1970];
    NSInteger timeinterval2 = (NSInteger)timeinterval + timereduce;
    
    NSString *timeintersastr = [NSString stringWithFormat:@"%ld",(NSInteger)(timeinterval*1000)];
    NSString *timestring = [NSString stringWithFormat:@"%ld%@",timeinterval2,[timeintersastr substringFromIndex:timeintersastr.length-3]];
    
    LMLog(@"timestring:%@",timestring);
    param[@"timestamp"] = timestring;
//    param[@"channel"] = channels;
//    param[@"bundleid"] = bundleid;
//    param[@"devicetoken"] = UUIDString;
//    NSDictionary *signparamsDic = @{
////                                    @"app_type":deviceName,
////                                    @"version":version,
//                                    @"service":@"App.V2_Login.GetCode",
//                                    @"mobile":@"15960283398",
//                                    @"timestamp":timestring
//                                    };
    //timestring:1511486995239  timestring:1511487046611
    NSString *signparams = [self sortSys_withoutkey:param];
    
//      _manager.requestSerializer = [AFJSONRequestSerializer serializer];
//      _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"charset=utf-8", nil];

    NSString *str = [signparams stringByAppendingString:@"a17Tg8gGDSTHryvGlusw6bykPdif8C7z"];
    param[@"sign"] = [self MD5ForLower32Bate:str];
    param[@"timestamp"] = timestring;
    [self.manager POST:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * str  =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString * str2 = [AES128Util AES128Decrypt:str key:@"ZVLx7Cbf"];
        LMLog(@"=====%@",str2);

        if (responseObject != nil) {
            NSNumber *ret = responseObject[@"ret"];
        
            NSString * msg = responseObject[@"msg"];
            
            if (ret .integerValue == 400) {
//                [UIView fm_showTextHUD:msg];
            }
            if (ret .integerValue == 401) {
//                [UIView fm_showTextHUD:msg];
            }
#if DEBUG
            if(ret.integerValue != 200) {
//                [UIView fm_showTextHUD:msg];
            }
#endif
            NSDictionary *data = responseObject;
           
            if (data != nil && [data isKindOfClass:[NSDictionary class]]) {
                result(data,YES);
            }else {
                NSString *msg = responseObject[@"msg"];
                result(msg,NO);
            }
        } else {
            result(nil,NO);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
//                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *resultdic;
        if (data == nil) {
            resultdic = @{};
        } else {
            resultdic= [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingMutableContainers
                                                         error:&err];
        }
        
        //失败原因
        if (!err && resultdic!= nil && [resultdic isKindOfClass:[NSDictionary class]]) {
            NSString *msg = resultdic[@"message"];
//            [ShowMessage showCenterMessage:msg];
            if (msg != nil && ![msg isKindOfClass:[NSNull class]] && msg.length>0) {
                result(msg,NO);
                
            }else {
                
                result(nil,NO);
            }
            
        }else {
            result(nil,NO);
        }
    }];
    
}
//上传图片数组
-(void)uploadImageWithPath:(NSString *)url
                parameters:(id)parameters
                     image:(NSArray *)images parameterOfimages:(NSString *)parameter result:(void (^)(id result,BOOL isSuccess))result {

    if ([self isConnectionAvailable]) {
    
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
        
        NSString * key = [self sortSys_key:param];
        
        [param setObject:[AES128Util AES128Encrypt:key key:AES_KEY] forKey:@"body_params"];
        
//        LMLog(@"body_params加密字符串：%@", [AES128Util AES128Encrypt:key key:AES_KEY]);
//        LMLog(@"key:%@",key);
//        LMLog(@"param:%@",param);
        //这里是headerparams加密所需4个参数
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app版本号
        NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        //app系统类型
        NSString* deviceName = @"ios";//[[UIDevice currentDevice] systemName];
        //设备标识符
        NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        //手机型号
        NSString* phoneModel = [self iphoneType];
        
        NSDictionary *header_paramsDic = @{
                                           @"app_type":deviceName,
                                           @"version":version,
                                           @"imei":deviceUUID,
                                           @"model":phoneModel
                                           };
        
        NSString *header_params = [self sortSys_key:header_paramsDic];
        
        
        NSInteger timereduce = [[NSUserDefaults standardUserDefaults] integerForKey:@"servicetimereduce"];
        
        NSDate *nowdate = [NSDate date];
        NSTimeInterval timeinterval = [nowdate timeIntervalSince1970];
        NSInteger timeinterval2 = (NSInteger)timeinterval + timereduce;
        
        NSString *timeintersastr = [NSString stringWithFormat:@"%ld",(NSInteger)(timeinterval*1000)];
        NSString *timestring = [NSString stringWithFormat:@"%ld%@",timeinterval2,[timeintersastr substringFromIndex:timeintersastr.length-3]];
        
        NSDictionary *signparamsDic = @{
                                        @"app_type":deviceName,
                                        @"version":version,
                                        @"imei":deviceUUID,
                                        @"model":phoneModel,
                                        @"time":timestring
                                        };
        
        NSString *signparams = [self sortSys_key:signparamsDic];
        
        [_manager.requestSerializer setValue:[AES128Util AES128Encrypt:header_params key:AES_KEY] forHTTPHeaderField:@"headerparams"];
        [_manager.requestSerializer setValue:[AES128Util AES128Encrypt:signparams key:AES_KEY] forHTTPHeaderField:@"sign"];
        
        
//        LMLog(@"headerparams加密字符串：%@", [AES128Util AES128Encrypt:header_params key:AES_KEY]);
//        LMLog(@"sign加密字符串：%@", [AES128Util AES128Encrypt:signparams key:AES_KEY]);
        if (parameters == nil) {
            param = nil;
        }
        
        [_manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (int i = 0; i < images.count; i ++) {
                UIImage *image = images[i];
              
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy年MM月dd日"];
                NSString *dateString = [formatter stringFromDate:date];
                
                
                    NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
                
//                   NSData *imageData = UIImageJPEGRepresentation(image, 0.7f);
              NSData *imageData =  [self imageData:image];
                    [formData appendPartWithFileData:imageData name:parameter fileName:fileName mimeType:@"image/jpg/png/jpeg"];
                
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject != nil) {
                NSNumber *ret = responseObject[@"ret"];
                
                NSString * msg = responseObject[@"message"];
                
                if (ret .integerValue == 400) {
//                    [XHToast showTopWithText:msg];
                }
                if (ret .integerValue == 401) {
//                    [XHToast showTopWithText:msg];
                }
                NSDictionary *data = responseObject[@"data"];
                if (data != nil && [data isKindOfClass:[NSDictionary class]]) {
                    result(data,YES);
                }else {
                    NSString *msg = responseObject[@"msg"];
                    result(msg,NO);
                }
            } else {
                result(nil,NO);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            //                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *resultdic;
            if (data == nil) {
                resultdic = @{};
            } else {
                resultdic= [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingMutableContainers
                                                             error:&err];
            }
            
            //失败原因
            if (!err && resultdic!= nil && [resultdic isKindOfClass:[NSDictionary class]]) {
                NSString * ststus = resultdic[@"status"];
                NSString *msg = resultdic[@"message"];
//                [XHToast showCenterWithText:msg];
                if (msg != nil && ![msg isKindOfClass:[NSNull class]] && msg.length>0) {
                    result(msg,NO);
                    
                }else {
                    
                    result(nil,NO);
                }
                
            }else {
                result(nil,NO);
            }
        }];
        
    }
    else{

       result(nil,NO);
        //网络错误咯
        [self showExceptionDialog];
        //发出网络异常通知广播
        [[NSNotificationCenter defaultCenter] postNotificationName:@"k_NOTI_NETWORK_ERROR" object:nil];
    }

}
//上传修改图片数组
-(void)uploadImageWithPath:(NSString *)url
                parameters:(id)parameters
                     imagestr:(NSArray *)images parameterOfimages:(NSString *)parameterstr image:(NSArray *)imagesArray parameterOfimages:(NSString *)parameter result:(void (^)(id result,BOOL isSuccess))result {
    
    if ([self isConnectionAvailable]) {
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
        
        NSString * key = [self sortSys_key:param];
        
        [param setObject:[AES128Util AES128Encrypt:key key:AES_KEY] forKey:@"body_params"];
        
        LMLog(@"body_params加密字符串：%@", [AES128Util AES128Encrypt:key key:AES_KEY]);
        LMLog(@"key:%@",key);
        LMLog(@"param:%@",param);
        //这里是headerparams加密所需4个参数
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app版本号
        NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        //app系统类型
        NSString* deviceName = @"ios";//[[UIDevice currentDevice] systemName];
        //设备标识符
        NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        //手机型号
        NSString* phoneModel = [self iphoneType];
        
        NSDictionary *header_paramsDic = @{
                                           @"app_type":deviceName,
                                           @"version":version,
                                           @"imei":deviceUUID,
                                           @"model":phoneModel
                                           };
        
        NSString *header_params = [self sortSys_key:header_paramsDic];
        
        
        NSInteger timereduce = [[NSUserDefaults standardUserDefaults] integerForKey:@"servicetimereduce"];
        
        NSDate *nowdate = [NSDate date];
        NSTimeInterval timeinterval = [nowdate timeIntervalSince1970];
        NSInteger timeinterval2 = (NSInteger)timeinterval + timereduce;
        
        NSString *timeintersastr = [NSString stringWithFormat:@"%ld",(NSInteger)(timeinterval*1000)];
        NSString *timestring = [NSString stringWithFormat:@"%ld%@",timeinterval2,[timeintersastr substringFromIndex:timeintersastr.length-3]];
        
        NSDictionary *signparamsDic = @{
                                        @"app_type":deviceName,
                                        @"version":version,
                                        @"imei":deviceUUID,
                                        @"model":phoneModel,
                                        @"time":timestring
                                        };
        
        NSString *signparams = [self sortSys_key:signparamsDic];
        
        [_manager.requestSerializer setValue:[AES128Util AES128Encrypt:header_params key:AES_KEY] forHTTPHeaderField:@"headerparams"];
        [_manager.requestSerializer setValue:[AES128Util AES128Encrypt:signparams key:AES_KEY] forHTTPHeaderField:@"sign"];
        
        
//        LMLog(@"headerparams加密字符串：%@", [AES128Util AES128Encrypt:header_params key:AES_KEY]);
//        LMLog(@"sign加密字符串：%@", [AES128Util AES128Encrypt:signparams key:AES_KEY]);
        if (parameters == nil) {
            param = nil;
        }
        
        [_manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (int i = 0; i < images.count; i ++) {
                UIImage *image = images[i];
                
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy年MM月dd日"];
                NSString *dateString = [formatter stringFromDate:date];
                
                
                NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
                
                //                   NSData *imageData = UIImageJPEGRepresentation(image, 0.7f);
                NSData *imageData =  [self imageData:image];
                [formData appendPartWithFileData:imageData name:parameterstr fileName:fileName mimeType:@"image/jpg/png/jpeg"];
                
            }
            
            for (int i = 0; i < imagesArray.count; i ++) {
                UIImage *image = imagesArray[i];
                
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy年MM月dd日"];
                NSString *dateString = [formatter stringFromDate:date];
                
                
                NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
                
                //                   NSData *imageData = UIImageJPEGRepresentation(image, 0.7f);
                NSData *imageData =  [self imageData:image];
                [formData appendPartWithFileData:imageData name:parameter fileName:fileName mimeType:@"image/jpg/png/jpeg"];
                
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject != nil) {
                NSNumber *ret = responseObject[@"ret"];
                
                NSString * msg = responseObject[@"message"];
                
                if (ret .integerValue == 400) {
//                    [XHToast showTopWithText:msg];
                }
                if (ret .integerValue == 401) {
//                    [XHToast showTopWithText:msg];
                }
                NSDictionary *data = responseObject[@"data"];
                if (data != nil && [data isKindOfClass:[NSDictionary class]]) {
                    result(data,YES);
                }else {
                    NSString *msg = responseObject[@"msg"];
                    result(msg,NO);
                }
            } else {
                result(nil,NO);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            //                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *resultdic;
            if (data == nil) {
                resultdic = @{};
            } else {
                resultdic= [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingMutableContainers
                                                             error:&err];
            }
            
            //失败原因
            if (!err && resultdic!= nil && [resultdic isKindOfClass:[NSDictionary class]]) {
                NSString * ststus = resultdic[@"status"];
                NSString *msg = resultdic[@"message"];
//                [XHToast showCenterWithText:msg];
                if (msg != nil && ![msg isKindOfClass:[NSNull class]] && msg.length>0) {
                    result(msg,NO);
                    
                }else {
                    
                    result(nil,NO);
                }
                
            }else {
                result(nil,NO);
            }
        }];
        
    }
    else{
        
        result(nil,NO);
        //网络错误咯
        [self showExceptionDialog];
        //发出网络异常通知广播
        [[NSNotificationCenter defaultCenter] postNotificationName:@"k_NOTI_NETWORK_ERROR" object:nil];
    }
    
}
 */
/**
// 压图片质量
//
// @param image image
// @return Data
// */
//- (NSData *)zipImageWithImage:(UIImage *)image
//{
//    if (!image) {
//        return nil;
//    }
//    CGFloat maxFileSize = 32*1024;
//    CGFloat compression = 0.9f;
//    NSData *compressedData = UIImageJPEGRepresentation(image, compression);
//    while ([compressedData length] > maxFileSize) {
//        compression *= 0.9;
//        compressedData = UIImageJPEGRepresentation([[self class] compressImage:image newWidth:image.size.width*compression], compression);
//    }
//    return compressedData;
//}
//
///**
// *  等比缩放本图片大小
// *
// *  @param newImageWidth 缩放后图片宽度，像素为单位
// *
// *  @return self-->(image)
// */
//+ (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth
//{
//    if (!image) return nil;
//    float imageWidth = image.size.width;
//    float imageHeight = image.size.height;
//    float width = newImageWidth;
//    float height = image.size.height/(image.size.width/width);
//
//    float widthScale = imageWidth /width;
//    float heightScale = imageHeight /height;
//
//    // 创建一个bitmap的context
//    // 并把它设置成为当前正在使用的context
//    UIGraphicsBeginImageContext(CGSizeMake(width, height));
//
//    if (widthScale > heightScale) {
//        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
//    }
//    else {
//        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
//    }
//
//    // 从当前context中创建一个改变大小后的图片
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    // 使当前的context出堆栈
//    UIGraphicsEndImageContext();
//
//    return newImage;
//
//}
//
//
//-(NSData *)zipNSDataWithImage:(UIImage *)sourceImage{
//    //进行图像尺寸的压缩
//    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
//    CGFloat width = imageSize.width;    //图片宽度
//    CGFloat height = imageSize.height;  //图片高度
//    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
//    if (width>1280) {
//        if (width>height) {
//            CGFloat scale = width/height;
//            height = 1280;
//            width = height*scale;
//        }else{
//            CGFloat scale = height/width;
//            width = 1280;
//            height = width*scale;
//        }
//        //2.高度大于1280
//    }else if(height>1280){
//        CGFloat scale = height/width;
//        width = 1280;
//        height = width*scale;
//    }else{
//    }
//    UIGraphicsBeginImageContext(CGSizeMake(width, height));
//    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    //进行图像的画面质量压缩
//    NSData *data=UIImageJPEGRepresentation(newImage, 1.0);
//    if (data.length>100*1024) {
//        if (data.length>1024*1024) {//1M以及以上
//            data=UIImageJPEGRepresentation(newImage, 0.7);
//        }else if (data.length>512*1024) {//0.5M-1M
//            data=UIImageJPEGRepresentation(newImage, 0.8);
//        }else if (data.length>200*1024) {
//            //0.25M-0.5M
//            data=UIImageJPEGRepresentation(newImage, 0.9);
//        }
//    }
//    return data;
//}
//
//
//-(NSData *)imageData:(UIImage *)myimage
//{
//    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
//    if (data.length>100*1024) {
//        if (data.length>1024*1024) {//1M以及以上
//            LMLog(@"000");
//            data=UIImageJPEGRepresentation(myimage, 0.1);
//
//        }else if (data.length>512*1024) {//0.5M-1M
//            LMLog(@"111");
//            data=UIImageJPEGRepresentation(myimage, 0.5);
//
//        }else if (data.length>200*1024) {//0.25M-0.5M
//            LMLog(@"222");
//            data=UIImageJPEGRepresentation(myimage, 0.9);
//
//        }
//
//    }
//    return data;
//
//
//}
//
//
//-(void)uploadImageWithPath:(NSString *)url
//                parameters:(id)parameters
//                     image:(UIImage *)image parameterOfimage:(NSString *)parameter result:(void (^)(id result,BOOL isSuccess))result {
//
//    if ([self isConnectionAvailable]) {
//
//        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
//
//        NSString * key = [self sortSys_key:param];
//
//        [param setObject:[AES128Util AES128Encrypt:key key:AES_KEY] forKey:@"body_params"];
//
////        LMLog(@"body_params加密字符串：%@", [AES128Util AES128Encrypt:key key:AES_KEY]);
////        LMLog(@"key:%@",key);
////        LMLog(@"param:%@",param);
//        //这里是headerparams加密所需4个参数
//
//        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//        // app版本号
//        NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//        //app系统类型
//        NSString* deviceName = @"ios";//[[UIDevice currentDevice] systemName];
//        //设备标识符
//        NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//        //手机型号
//        NSString* phoneModel = [self iphoneType];
//
//        NSDictionary *header_paramsDic = @{
//                                           @"app_type":deviceName,
//                                           @"version":version,
//                                           @"imei":deviceUUID,
//                                           @"model":phoneModel
//                                           };
//
//        NSString *header_params = [self sortSys_key:header_paramsDic];
//
//
//        NSInteger timereduce = [[NSUserDefaults standardUserDefaults] integerForKey:@"servicetimereduce"];
//
//        NSDate *nowdate = [NSDate date];
//        NSTimeInterval timeinterval = [nowdate timeIntervalSince1970];
//        NSInteger timeinterval2 = (NSInteger)timeinterval + timereduce;
//
//        NSString *timeintersastr = [NSString stringWithFormat:@"%ld",(NSInteger)(timeinterval*1000)];
//        NSString *timestring = [NSString stringWithFormat:@"%ld%@",timeinterval2,[timeintersastr substringFromIndex:timeintersastr.length-3]];
//
//        NSDictionary *signparamsDic = @{
//                                        @"app_type":deviceName,
//                                        @"version":version,
//                                        @"imei":deviceUUID,
//                                        @"model":phoneModel,
//                                        @"time":timestring
//                                        };
//
//        NSString *signparams = [self sortSys_key:signparamsDic];
//
//        [_manager.requestSerializer setValue:[AES128Util AES128Encrypt:header_params key:AES_KEY] forHTTPHeaderField:@"headerparams"];
//        [_manager.requestSerializer setValue:[AES128Util AES128Encrypt:signparams key:AES_KEY] forHTTPHeaderField:@"sign"];
//
//
////        LMLog(@"headerparams加密字符串：%@", [AES128Util AES128Encrypt:header_params key:AES_KEY]);
////        LMLog(@"sign加密字符串：%@", [AES128Util AES128Encrypt:signparams key:AES_KEY]);
//        if (parameters == nil) {
//            param = nil;
//        }
//
//        [_manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//
//                NSData *imageData = UIImageJPEGRepresentation(image, 0.7f);
//
//                [formData appendPartWithFileData:imageData name:parameter fileName:@"avatar.jpg" mimeType:@"image/jpg"];
//
//
//        } progress:^(NSProgress * _Nonnull uploadProgress) {
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            if (responseObject != nil) {
//                NSNumber *ret = responseObject[@"ret"];
//
//                NSString * msg = responseObject[@"message"];
//
//                if (ret .integerValue == 400) {
////                    [XHToast showTopWithText:msg];
//                }
//                if (ret .integerValue == 401) {
////                    [XHToast showTopWithText:msg];
//                }
//                NSDictionary *data = responseObject[@"data"];
//                if (data != nil && [data isKindOfClass:[NSDictionary class]]) {
//                    result(data,YES);
//                }else {
//                    NSString *msg = responseObject[@"msg"];
//                    result(msg,NO);
//                }
//            } else {
//                result(nil,NO);
//            }
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
//            //                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSError *err;
//            NSDictionary *resultdic;
//            if (data == nil) {
//                resultdic = @{};
//            } else {
//                resultdic= [NSJSONSerialization JSONObjectWithData:data
//                                                           options:NSJSONReadingMutableContainers
//                                                             error:&err];
//            }
//
//            //失败原因
//            if (!err && resultdic!= nil && [resultdic isKindOfClass:[NSDictionary class]]) {
//
//                NSString *msg = resultdic[@"message"];
////                [XHToast showCenterWithText:msg];
//                if (msg != nil && ![msg isKindOfClass:[NSNull class]] && msg.length>0) {
//                    result(msg,NO);
//
//                }else {
//
//                    result(nil,NO);
//                }
//
//            }else {
//                result(nil,NO);
//            }
//        }];
//
//    }
//    else{
//
//        result(nil,NO);
//        //网络错误咯
//        [self showExceptionDialog];
//        //发出网络异常通知广播
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"k_NOTI_NETWORK_ERROR" object:nil];
//    }
//}
//-(NSString *)MD5ForLower32Bate:(NSString *)str{
//
//    //要进行UTF8的转码
//    const char* input = [str UTF8String];
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(input, (CC_LONG)strlen(input), result);
//
//    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
//        [digest appendFormat:@"%02x", result[i]];
//    }
//    return digest;
//}
@end
