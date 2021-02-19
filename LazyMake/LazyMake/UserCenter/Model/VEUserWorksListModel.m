//
//  VEUserWorksListModel.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/27.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserWorksListModel.h"

@implementation VEUserWorksListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"wID" : @"id",
             };
}
@end
