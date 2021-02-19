//
//  AES128Util.h
//  WechatBusinessSupply
//
//  Created by xuxiangling on 2017/10/25.
//  Copyright © 2017年 xuxiangling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES128Util : NSObject

+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;


+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key iv:(NSString *)iv;

@end
