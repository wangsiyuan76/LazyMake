//
//  VEVipRecordingModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEVipRecordingModel : VEBaseModel

//购买记录列表用到的数据
@property (strong, nonatomic) NSString *titleStr;               //支付类型
@property (strong, nonatomic) NSString *timeStr;                //购买时间
@property (strong, nonatomic) NSString *moneyStr;               //金额
@property (strong, nonatomic) NSString *rightTimeStr;           //购买了几个月
@property (strong, nonatomic) NSString *pID;                    //id
@property (strong, nonatomic) NSString *goodsid;                //订单号id


@end

NS_ASSUME_NONNULL_END
