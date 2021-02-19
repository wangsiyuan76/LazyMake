//
//  VETeachListModel.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VETeachListModel.h"

@implementation VETeachListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"tID" : @"id",
             @"upStr" : @"up",
             @"downStr" : @"down",
             };
}
@end
