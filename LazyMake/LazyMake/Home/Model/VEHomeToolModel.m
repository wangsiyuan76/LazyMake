//
//  VEHomeToolModel.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/1.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeToolModel.h"

@implementation VEHomeToolModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"classifyId" : @"classify_id",
             @"classifyName" : @"classify_name",
             @"thumbUrl" : @"thumb",
             };
}

@end

@implementation LMHomeToolListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"spaceid143" : [VEHomeToolModel class]};
}

@end
