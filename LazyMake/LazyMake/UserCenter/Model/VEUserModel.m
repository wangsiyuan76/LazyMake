//
//  VEUserModel.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/13.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserModel.h"

@implementation VEUserModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"endDay" : @"end_day",
             @"vipState" : @"vip_state",
             @"feedbackDot" : @"feedback_dot",
             @"liveMsg" : @"live_msg",
             @"trialPeriod":@"trial_period",
             };
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_userid forKey:@"userid"];
    [aCoder encodeObject:_nickname forKey:@"nickname"];
    [aCoder encodeObject:_avatar forKey:@"avatar"];
    [aCoder encodeObject:_endDay forKey:@"endDay"];
    [aCoder encodeObject:_vipState forKey:@"vipState"];
    [aCoder encodeObject:_feedbackDot forKey:@"feedbackDot"];
    [aCoder encodeObject:_liveMsg forKey:@"liveMsg"];
    [aCoder encodeObject:_mobile forKey:@"mobile"];
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeObject:_sex forKey:@"sex"];
    [aCoder encodeObject:_signature forKey:@"signature"];
    [aCoder encodeObject:_trialPeriod forKey:@"trialPeriod"];

}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        
        self.userid = [aDecoder decodeObjectForKey:@"userid"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.endDay = [aDecoder decodeObjectForKey:@"endDay"];
        self.vipState = [aDecoder decodeObjectForKey:@"vipState"];
        self.feedbackDot = [aDecoder decodeObjectForKey:@"feedbackDot"];
        self.liveMsg = [aDecoder decodeObjectForKey:@"liveMsg"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.signature = [aDecoder decodeObjectForKey:@"signature"];
        self.trialPeriod = [aDecoder decodeObjectForKey:@"trialPeriod"];
    }
    return self;
}

- (NSString *)sexStr{
    NSString *str = @"未设置";
    if (self.sex.intValue == 1) {
        str = @"男";
    }else if(self.sex.intValue == 2){
        str = @"女";
    }
    return str;
}
@end


@implementation LMUserManager

+(instancetype)sharedManger {
    static dispatch_once_t onceToken;
    static LMUserManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LMUserManager alloc] init];
        [instance unArchiverUserInfo];
    });
    return instance;
}

-(void)archiverUserInfo:(VEUserModel *)userInfo {

    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"UserManagerUserData"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
-(void)unArchiverUserInfo {
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserManagerUserData"];
    if ([userData isKindOfClass:[NSData class]]) {
        VEUserModel *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        if (userInfo) {
            self.userInfo = userInfo;
            self.isLogin = YES;
        }
    }
}

- (void)removeUserData{
    self.isLogin = NO;
    self.userInfo = [VEUserModel new];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"UserManagerUserData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
