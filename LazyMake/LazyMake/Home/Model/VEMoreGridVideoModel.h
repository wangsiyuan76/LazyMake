//
//  VEMoreGridVideoModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/5.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEMoreGridVideoModel : NSObject
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *selectId;//0上下分屏",1"左右分屏",2"3分屏",3"4分屏"
@property (assign, nonatomic) NSInteger maxNum;
@end

NS_ASSUME_NONNULL_END
