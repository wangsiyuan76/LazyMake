//
//  VEUserApi.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/13.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VEUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VEUserApi : NSObject

/// 登录
+ (void)loginForAppWithModel:(NSDictionary *)model Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/// 手机号登录
+ (void)phoneLoginForAppWithModel:(NSString *)phoneStr password:(NSString *)password Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/// 验证用户token
+ (void)checkUserTokenCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/// 修改用户性别
+ (void)changeUserSex:(NSString *)sexStr Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/// 修改用户昵称
+ (void)changeUserNickName:(NSString *)nickName Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/// 修改用户个性签名
+ (void)changeUserSignature:(NSString *)signatureStr Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;


/// 意见反馈
/// @param content 反馈内容
/// @param qqStr 联系方式
/// @param completion completion description
/// @param failure failure description
+ (void)feedbackWithContent:(NSString *)content qqStr:(NSString *)qqStr Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/// 我的反馈
+ (void)myFeedbackListWithPage:(NSInteger)page Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/// 修改用户头像
+ (void)changeUserIcon:(UIImage *)iconImage Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/// 获取注销验证码
+ (void)loginOutCodeCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

/// 注销账号
+ (void)loginOutWithCode:(NSString *)code Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

///请求购买项列表
+ (void)loadPayListCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

///提交订单
+ (void)pushVipWithID:(NSString *)tariffid paytype:(NSString *)paytype payMouth:(NSString *)payMouth Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

///我的作品列表
+ (void)loadUserWorks:(NSInteger)page Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

///删除作品
+ (void)deleteUserWorksID:(NSString *)wID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

///根据模板id查询模板数据
+ (void)searchAEDataWithID:(NSString *)wID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

///支付回调通知
+ (void)paySucceecBackReceipt:(NSString *)receipt tradeNo:(NSString *)tradeNo Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

///请求客服QQ号
+ (void)loadQQNumberCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

///开通记录
+ (void)loadVIPRecordingPage:(NSInteger)page Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

///通知消息列表
+ (void)loadUserMessageList:(NSInteger)page Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

///个人中心
+ (void)loadUserCenterDataCompletion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

///看视频添加统计
+ (void)videoAddCountHits:(NSString *)pID Completion:(void (^)(id  _Nonnull result))completion failure:(void (^)(NSError * _Nonnull error))failure;

@end

NS_ASSUME_NONNULL_END
