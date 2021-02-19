//
//  VEUserModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/13.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VEUserModel : VEBaseModel <NSCoding>

@property (nonatomic, copy) NSString  *userid;
@property (nonatomic, copy) NSString  *nickname;
@property (nonatomic, copy) NSString  *avatar;              //头像
@property (nonatomic, copy) NSString    *endDay;              //vip结束时间
@property (nonatomic, copy) NSString  *vipState;            //0非会员;1会员;2过期会员

@property (nonatomic, copy) NSString  *feedbackDot;
@property (nonatomic, copy) NSString  *liveMsg;
@property (nonatomic, copy) NSString  *mobile;              //登录类型
@property (nonatomic, copy) NSString  *token;               //token
@property (nonatomic, copy) NSString  *sex;                 //0:其它,1:男,2:女
@property (nonatomic, copy) NSString  *signature;           //个性签名
@property (nonatomic, copy) NSString  *sexStr;                
@property (nonatomic, copy) NSString  *trialPeriod;

@end

@interface LMUserManager : NSObject

@property (strong,nonatomic) VEUserModel *userInfo;
@property (assign,nonatomic) BOOL isLogin;

+ (instancetype)sharedManger;

-(void)archiverUserInfo:(VEUserModel *)userInfo;
-(void)unArchiverUserInfo;
- (void)removeUserData;

@end

NS_ASSUME_NONNULL_END
