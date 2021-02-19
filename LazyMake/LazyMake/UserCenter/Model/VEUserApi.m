//
//  VEUserApi.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/13.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserApi.h"
#import "VEUserFeedbackListModel.h"
#import "VEVIPMoneyModel.h"
#import "VEUserWorksListModel.h"
#import "VEHomeTemplateModel.h"
#import "VEQQModel.h"
#import "VEVipRecordingModel.h"
#import "VEUserMessageModel.h"
#import "VEUserCenterDataModel.h"

@implementation VEUserApi
+ (void)loginForAppWithModel:(NSDictionary *)model Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"oauth/oauth";
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:model];
           
    entity.params = dic;
    entity.targetClass = [VEUserModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)phoneLoginForAppWithModel:(NSString *)phoneStr password:(NSString *)password Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"user/login";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:phoneStr?:@"" forKey:@"mobile"];
    [dic setObject:password?:@"" forKey:@"password"];

           
    entity.params = dic;
    entity.targetClass = [VEUserModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 验证用户token
+ (void)checkUserTokenCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
        BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
       entity.method = BSDHTTPMethodPOST;
       entity.path = @"user/ckeck_token";
       entity.targetClass = [VEBaseModel class];
       [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
           completion(result);
       } failure:^(NSError * _Nonnull error) {
           failure(error);
       }];
}

/// 修改用户性别
+ (void)changeUserSex:(NSString *)sexStr Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"user/update_personal_data";
    entity.params = @{@"sex":sexStr};
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 修改用户昵称
+ (void)changeUserNickName:(NSString *)nickName Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"user/update_personal_data";
    entity.params = @{@"nickname":nickName};
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 修改用户个性签名
+ (void)changeUserSignature:(NSString *)signatureStr Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"user/update_personal_data";
    entity.params = @{@"signature":signatureStr?:@""};
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 意见反馈
/// @param content 反馈内容
/// @param qqStr 联系方式
/// @param completion completion description
/// @param failure failure description
+ (void)feedbackWithContent:(NSString *)content qqStr:(NSString *)qqStr Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"feedback/index";
    NSMutableDictionary *parDic = [NSMutableDictionary new];
    [parDic setObject:content?:@"" forKey:@"content"];
    [parDic setObject:qqStr?:@"" forKey:@"contact"];
    [parDic setObject:[VETool phoneModel] forKey:@"models"];
    [parDic setObject:[VETool phoneVersion] forKey:@"system"];
    [parDic setObject:[VETool networkingStatesFromStatebar] forKey:@"network"];
    [parDic setObject:[VETool versionNumber] forKey:@"version"];

    entity.params = parDic;
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 我的反馈
+ (void)myFeedbackListWithPage:(NSInteger)page Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"feedback/feedback_list";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"%d",PAGE_SIZE_NUM] forKey:@"pagesize"];
    entity.params = dic;
    entity.subArrClass = [VEUserFeedbackListModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 修改用户头像
+ (void)changeUserIcon:(UIImage *)iconImage Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOSTWithMultiMedia;
    entity.path = @"user/upload_avatar";
    BSDMedia *media = [[BSDMedia alloc]init];
//    media.medias = @[iconImage];
    media.mediaImage = iconImage;
    media.type = BSDMediaTypeImage;
    media.fileName = @"file";
    media.name = @"file";
    entity.medias = @[media];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 获取注销验证码
+ (void)loginOutCodeCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"user/user_get_code";
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
/// 注销账号
+ (void)loginOutWithCode:(NSString *)code Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"user/user_write_off";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:code?:@"" forKey:@"code"];
    entity.params = dic;
    entity.subArrClass = [VEUserFeedbackListModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

///请求购买项列表
+ (void)loadPayListCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"order/open_vip";

    entity.subArrClass = [LMVIPMoneyIconModel class];
    entity.targetClass = [LMVIPMoneyIconModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

///提交订单
+ (void)pushVipWithID:(NSString *)tariffid paytype:(NSString *)paytype payMouth:(NSString *)payMouth Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"order/dopay";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:tariffid?:@"" forKey:@"tariffid"];
    [dic setObject:[VETool phoneUUID]?:@"" forKey:@"spid"];
    [dic setObject:paytype?:@"4" forKey:@"paytype"];
    [dic setObject:[VETool versionNumber]?:@"" forKey:@"version"];
    [dic setObject:payMouth?:@"0" forKey:@"pay_mouth"];
    entity.params = dic;
    entity.subArrClass = [VEBaseModel class];
    entity.targetClass = [LMVIPMoneyPushModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

///我的作品列表
+ (void)loadUserWorks:(NSInteger)page Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"user/homepage_left";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"%d",PAGE_SIZE_NUM] forKey:@"pagesize"];

    entity.params = dic;
    entity.subArrClass = [VEUserWorksListModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

///通知消息列表
+ (void)loadUserMessageList:(NSInteger)page Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"user/msg_notification";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"%d",PAGE_SIZE_NUM] forKey:@"pagesize"];

    entity.params = dic;
    entity.subArrClass = [VEUserMessageModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

///删除作品
+ (void)deleteUserWorksID:(NSString *)wID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"user/del_live_wallpaper";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:wID?:@"" forKey:@"id"];
    
    entity.params = dic;
    entity.subArrClass = [VEBaseModel class];
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

///根据模板id查询模板数据
+ (void)searchAEDataWithID:(NSString *)wID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"custom/select_custom";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:wID?:@"" forKey:@"id"];
    
    entity.params = dic;
    entity.targetClass = [VEHomeTemplateModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

///支付回调通知
+ (void)paySucceecBackReceipt:(NSString *)receipt tradeNo:(NSString *)tradeNo Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
      BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
      entity.method = BSDHTTPMethodPOST;
      entity.path = @"notify/apple_payurl";
      NSMutableDictionary *dic = [NSMutableDictionary new];
      [dic setObject:receipt?:@"" forKey:@"receipt"];
      [dic setObject:tradeNo?:@"" forKey:@"trade_no"];

      entity.params = dic;
      entity.targetClass = [VEHomeTemplateModel class];
      [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
          completion(result);
      } failure:^(NSError * _Nonnull error) {
          failure(error);
      }];
}

///请求客服QQ号
+ (void)loadQQNumberCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"opinion/customer_service";
    entity.targetClass = [VEQQModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

///开通记录
+ (void)loadVIPRecordingPage:(NSInteger)page Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"order/charge_record";
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"%d",PAGE_SIZE_NUM] forKey:@"pagesize"];
    entity.params = dic;
    entity.targetClass = [VEQQModel class];
    entity.subArrClass = [VEVipRecordingModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

///个人中心
+ (void)loadUserCenterDataCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"user/center";
    entity.targetClass = [VEUserCenterDataModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

///看视频添加统计
+ (void)videoAddCountHits:(NSString *)pID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure{
    BSDHTTPEntity *entity = [[BSDHTTPEntity alloc]init];
    entity.method = BSDHTTPMethodPOST;
    entity.path = @"dynamic/count_hits";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:pID?:@"" forKey:@"id"];
    entity.params = dic;
    entity.targetClass = [VEBaseModel class];
    [[VEAPIClient sharedClient] requireWithEntity:entity completion:^(id  _Nonnull result) {
        completion(result);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
