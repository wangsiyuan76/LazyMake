//
//  VEVipRecordingModel.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVipRecordingModel.h"

@implementation VEVipRecordingModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"titleStr" : @"payname",
             @"timeStr" : @"paytime",
             @"moneyStr" : @"money",
             @"rightTimeStr" : @"member_desc",
             
             @"pID" : @"id",
             @"goodsid" : @"goodsid",

             };
}

@end
