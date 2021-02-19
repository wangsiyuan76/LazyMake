//
//  VEUserCenterEnumModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEUserCenterEnumModel : NSObject

@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *imageStr;
@property (assign, nonatomic) BOOL isRed;               //是否显示小红点
@property (strong, nonatomic) NSString *rightTitle;     //右边的文字
@property (strong, nonatomic) NSString *rightColor;     //右边文字的色值

@end

NS_ASSUME_NONNULL_END
