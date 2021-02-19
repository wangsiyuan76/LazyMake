//
//  VEQQModel.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/28.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEQQModel.h"

@implementation VEQQModel

- (void)setQq_key:(NSString *)qq_key{
    _qq_key = qq_key;
    if ([qq_key isNotBlank]) {
        if (qq_key.length > 0) {
            [[NSUserDefaults standardUserDefaults]setObject:qq_key forKey:QQGroupNumberKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
}

- (void)setQq_group:(NSString *)qq_group{
    _qq_group = qq_group;
    if ([qq_group isNotBlank]) {
        if (qq_group.length > 0) {
            [[NSUserDefaults standardUserDefaults]setObject:qq_group forKey:QQGroupNumber];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
}

- (void)setLx_qq:(NSString *)lx_qq{
    _lx_qq = lx_qq;
    if ([lx_qq isNotBlank]) {
        if (lx_qq.length > 0) {
            [[NSUserDefaults standardUserDefaults]setObject:lx_qq forKey:QQCustomerService];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
}

- (void)setAccess_token:(NSString *)access_token{
    _access_token = access_token;
    if ([access_token isNotBlank]) {
        if (access_token.length > 0) {
            [[NSUserDefaults standardUserDefaults]setObject:access_token forKey:BaiDuAiKeyToken];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
}

- (void)setClose_mobile_login:(NSString *)close_mobile_login{
    _close_mobile_login = close_mobile_login;
    if ([close_mobile_login isNotBlank]) {
        if (close_mobile_login.length > 0) {
            [[NSUserDefaults standardUserDefaults]setObject:_close_mobile_login forKey:PhoneCloseLogin];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else{
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:PhoneCloseLogin];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:PhoneCloseLogin];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

@end
