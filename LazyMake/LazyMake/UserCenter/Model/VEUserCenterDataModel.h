//
//  VEUserCenterDataModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/6.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEUserCenterDataModel : VEBaseModel

@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *end_day;
@property (strong, nonatomic) NSString *vip_state;
@property (strong, nonatomic) NSString *feedback_dot;       //意见反馈红点标识
@property (strong, nonatomic) NSString *live_msg;           //系统审核通知消息红点标识
@property (strong, nonatomic) NSString *trial_period;       //是否是在试用期

@end

NS_ASSUME_NONNULL_END
