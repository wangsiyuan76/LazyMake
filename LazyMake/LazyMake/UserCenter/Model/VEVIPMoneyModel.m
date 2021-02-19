//
//  VEVIPMoneyModel.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVIPMoneyModel.h"

@implementation LMVIPMoneyIconModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"isAppleAay" : @"is_apple_pay",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tariff" : [VEVIPMoneyModel class]};
}

@end

@implementation VEVIPMoneyModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"moneyID" : @"id",
             @"dayNum" : @"day_num",
             @"monthNum" : @"month_num",
             @"oldMoneyStr" : @"original_price",
             @"moneyStr" : @"price",
             @"giving" : @"giving",
             @"convertday" : @"convertday",
             @"textDesc" : @"text_desc",
             @"appleTariff" :@"apple_tariff",
             };
}

- (NSString *)timeStr{
    if (!_timeStr) {
        if (self.monthNum.intValue > 0) {
            _timeStr = [NSString stringWithFormat:@"%@个月",self.monthNum];
        }else{
            _timeStr = [NSString stringWithFormat:@"%@天",self.dayNum];
        }
    }
    return _timeStr;
}

- (NSString *)endNum{
    if (!_endNum) {
        int days = self.dayNum.intValue;    // n天后的天数
        NSDate *appointDate;    // 指定日期声明
        NSTimeInterval oneDay = 24 * 60 * 60;  // 一天一共有多少秒
        appointDate = [[NSDate date] initWithTimeIntervalSinceNow: oneDay * days];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString *currentTime = [formatter stringFromDate:appointDate];
        _endNum = currentTime;
    }
    return _endNum;
}

@end

@implementation LMVIPMoneyPushModel


@end
