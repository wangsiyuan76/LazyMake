//
//  VEUserMessageModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/6.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEUserMessageModel : VEBaseModel
@property (strong, nonatomic) NSString *mId;
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *live_id;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *inputtime;
@property (strong, nonatomic) NSString *type;           //区别类型0:动态壁纸1:3d壁纸2:充值赠送通知3兑换通知4反馈通知5系统通知
@property (strong, nonatomic) NSString *a_type;         //归属APP

@end

NS_ASSUME_NONNULL_END
