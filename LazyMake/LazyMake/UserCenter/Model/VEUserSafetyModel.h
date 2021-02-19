//
//  VEUserSafetyModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/15.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEUserSafetyModel : NSObject

@property (strong, nonatomic) NSString *num;
@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *contentStr;
@property (assign, nonatomic) CGFloat cellH;


@end

NS_ASSUME_NONNULL_END
